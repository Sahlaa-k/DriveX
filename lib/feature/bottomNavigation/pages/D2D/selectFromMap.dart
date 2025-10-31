import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drivex/main.dart'; // AppFire.mainDb / AppFire.gServiceDb
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// Google Places (legacy SDK in your project)
import 'package:flutter_google_places_hoc081098/google_maps_webservice_places.dart'
    as gmws;
import 'package:google_api_headers/google_api_headers.dart';
import 'package:uuid/uuid.dart';

class Selectfrommap extends StatefulWidget {
  const Selectfrommap({
    super.key,
    this.initialTarget,
    this.initialAddress,

    // >>> edit mode (optional)
    this.existingDocId, // if provided -> update instead of add
    this.initialType, // 'home' | 'work' | 'other'
    this.initialLabel, // free text label
    this.initialName,
    this.initialHouse,
    this.initialLandmark,
    this.initialIsDefault,
    this.initialAddressMap, // structured address map if you have it
  });

  /// Optional: center the map and pre-drop a marker when editing an existing address
  final LatLng? initialTarget;
  final String? initialAddress;

  // --- edit mode fields ---
  final String? existingDocId;
  final String? initialType;
  final String? initialLabel;
  final String? initialName;
  final String? initialHouse;
  final String? initialLandmark;
  final bool? initialIsDefault;
  final Map<String, dynamic>? initialAddressMap;

  @override
  State<Selectfrommap> createState() => _SelectfrommapState();
}

/// Row used when showing Firebase cache (g-service) results
class _LocalPlace {
  final String id;
  final String title;
  final String subtitle; // display string (address.formatted or parts)
  final LatLng? latLng;
  final DocumentReference<Map<String, dynamic>> docRef;

  _LocalPlace({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.latLng,
    required this.docRef,
  });
}

/// Row used when showing API Text Search results (last-resort)
class _ApiPlace {
  final String placeId;
  final String title;
  final String subtitle;
  final LatLng? latLng;

  _ApiPlace({
    required this.placeId,
    required this.title,
    required this.subtitle,
    required this.latLng,
  });
}

enum _ResultSource { local, googlePredictions, apiSearch }

class _SelectfrommapState extends State<Selectfrommap> {
  User? get _user => FirebaseAuth.instance.currentUser;
  // ⚠️ Use a restricted key or proxy via your server.
  static const String _googleApiKey = 'AIzaSyDwD1BJXVxky_Cy6xzyQh_5A2PW9cTOO0I';

  // ===== Cost-control knobs =====
  static const int _minSearchChars = 3; // don't query until >=3 chars
  static const int _localLimit = 5; // keep reads low but suggestions useful

  // Firestore DBs
  FirebaseFirestore get _main => AppFire.mainDb; // save targets
  FirebaseFirestore get _gsvc => AppFire.gServiceDb; // places_cache home

  // Map
  GoogleMapController? _map;
  final Set<Marker> _markers = {};
  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(10.8505, 76.2711), // Kerala fallback
    zoom: 14.0,
  );

  // Search
  final TextEditingController _searchCtrl = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  Timer? _debounce;
  String _lastIssuedQuery = "";
  String _sessionToken = const Uuid().v4();

  // Drag debounce (for marker)
  Timer? _dragDelay;

  // “short-circuit on first cache hit”
  bool _suppressFurtherNetwork = false; // true = keep filtering local only

  // Avoid duplicate Place Details calls per placeId in a session
  final Set<String> _fetchedDetails = {};

  // Results
  List<_LocalPlace> _localResults = [];
  List<gmws.Prediction> _googleResults = [];
  List<_ApiPlace> _apiResults = [];

  _ResultSource _source = _ResultSource.local;
  bool _loading = false;
  String? _error;

  // Location bias (for nearby feel / ranking / API bounds)
  LatLng _biasCenter = const LatLng(10.8505, 76.2711);
  LatLng? _pendingCameraTarget;

  // Selection state (enables bottom confirm button)
  LatLng? _selectedLatLng;
  String? _selectedTitle;
  String? _selectedAddress;
  Map<String, dynamic>? _selectedAddressMap;
  String? _selectedPlaceId; // if from Google details
  bool _isGeocoding = false;

  @override
  void initState() {
    super.initState();

    // If the caller provided an initial target (edit flow), seed the UI with it
    if (widget.initialTarget != null) {
      _biasCenter = widget.initialTarget!;
      _pendingCameraTarget = widget.initialTarget!;
      _placePickedMarker(
        widget.initialTarget!,
        title: widget.initialAddress?.trim().isNotEmpty == true
            ? widget.initialAddress!.trim()
            : 'Selected place',
        snippet: widget.initialAddress,
      );
      _selectedAddress = widget.initialAddress;
    } else {
      _initLocationAndBias();
    }

    // Seed selectedAddressMap if provided in edit mode
    if (widget.initialAddressMap != null) {
      _selectedAddressMap =
          Map<String, dynamic>.from(widget.initialAddressMap!);
    }

    _searchFocus.addListener(() {
      final q = _searchCtrl.text.trim();
      if (_searchFocus.hasFocus && q.length >= _minSearchChars) {
        _lastIssuedQuery = q;
        _searchCascade(q);
      }
      if (!_searchFocus.hasFocus) {
        setState(() {
          _localResults = [];
          _googleResults = [];
          _apiResults = [];
          _error = null;
          _loading = false;
          _source = _ResultSource.local;
        });
      }
    });
  }

  @override
  void dispose() {
    _map = null;
    _debounce?.cancel();
    _dragDelay?.cancel();
    _searchCtrl.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  // ---------------- Location init ----------------
  Future<void> _initLocationAndBias() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) return;

      var perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.denied ||
          perm == LocationPermission.deniedForever) {
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final center = LatLng(pos.latitude, pos.longitude);

      if (!mounted) return;
      setState(() {
        _biasCenter = center;
        _pendingCameraTarget = center;
      });

      if (_map != null) {
        await _map!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: center, zoom: 15),
          ),
        );
        _pendingCameraTarget = null;
      }
    } catch (_) {/* ignore */}
  }

  // ----------------- Cache upsert (g-service) -----------------
  Future<void> _upsertPlaceCache({
    required String placeId,
    required String name,
    required Map<String, dynamic> addressMap,
    required LatLng latLng,
    String? stateName,
  }) async {
    final data = {
      'placeId': placeId,
      'name': name,
      'name_lc': name.toLowerCase(),
      'address': addressMap, // structured map
      'lat': latLng.latitude,
      'lng': latLng.longitude,
      'state': stateName,
      'state_lc': (stateName ?? '').toLowerCase(),
      'hits': FieldValue.increment(1),
      'updatedAt': FieldValue.serverTimestamp(),
      'createdAt': FieldValue.serverTimestamp(),
    };

    final existing = await _gsvc
        .collection('places_cache')
        .where('placeId', isEqualTo: placeId)
        .limit(1)
        .get();

    if (existing.docs.isNotEmpty) {
      await existing.docs.first.reference.set(data, SetOptions(merge: true));
    } else {
      await _gsvc.collection('places_cache').add(data);
    }
  }

  // ----------------- Search cascade -----------------
  Future<void> _onChanged(String text) async {
    _debounce?.cancel();
    final issued = text.trim();

    _debounce = Timer(const Duration(milliseconds: 260), () {
      // Reset when user clears or goes below min chars
      if (issued.length < _minSearchChars) {
        setState(() {
          _lastIssuedQuery = issued;
          _localResults = [];
          _googleResults = [];
          _apiResults = [];
          _error =
              issued.isEmpty ? null : 'Type at least $_minSearchChars letters';
          _loading = false;
          _source = _ResultSource.local;
          _suppressFurtherNetwork = false; // allow network again later
        });
        return;
      }

      _lastIssuedQuery = issued;
      _searchCascade(issued);
    });
  }

  Future<void> _searchCascade(String input) async {
    final q = input.trim();
    if (q.length < _minSearchChars) return;

    // 1) Always try local first (free)
    final foundLocal = await _searchLocal(q);

    // If we have local results, keep filtering locally and avoid network spam
    if (foundLocal) {
      _suppressFurtherNetwork = true;
      return;
    } else {
      // No local match — allow network fallbacks
      _suppressFurtherNetwork = false;
    }

    // 2) Google Autocomplete predictions — only if not suppressed
    if (!_suppressFurtherNetwork) {
      final foundPred = await _searchGooglePredictions(q);
      if (foundPred) return;
    }

    // 3) Places Text Search (API search) — last resort
    if (!_suppressFurtherNetwork) {
      await _searchGoogleText(q);
    }
  }

  Future<bool> _searchLocal(String input) async {
    final q = input.trim().toLowerCase();

    setState(() {
      _loading = true;
      _error = null;
      _localResults = [];
      if (!_suppressFurtherNetwork) {
        _googleResults = [];
        _apiResults = [];
      }
      _source = _ResultSource.local;
    });

    try {
      final snap = await _gsvc
          .collection('places_cache')
          .orderBy('name_lc')
          .startAt([q])
          .endAt([q + '\uf8ff'])
          .limit(_localLimit)
          .get();

      final items = <_LocalPlace>[];
      for (final d in snap.docs) {
        final data = d.data();
        final title = (data['name'] ?? '') as String? ?? '';

        // address can be String or Map
        String subtitle = '';
        final rawAddr = data['address'];
        if (rawAddr is Map) {
          final m = Map<String, dynamic>.from(rawAddr as Map);
          subtitle = (m['formatted'] ?? '') as String? ?? '';
          if (subtitle.isEmpty) {
            final parts = [
              m['premise'],
              m['route'],
              m['streetNumber'],
              m['sublocality'],
              m['neighborhood'],
              m['locality'],
              m['subDistrict'],
              m['district'],
              m['state'],
              m['postalCode'],
            ].whereType<String>().where((s) => s.trim().isNotEmpty).toList();
            subtitle = parts.join(', ');
          }
        } else {
          subtitle = (rawAddr ?? '') as String? ?? '';
        }

        final lat = (data['lat'] as num?)?.toDouble();
        final lng = (data['lng'] as num?)?.toDouble();

        items.add(
          _LocalPlace(
            id: d.id,
            title: title,
            subtitle: subtitle,
            latLng: (lat != null && lng != null) ? LatLng(lat, lng) : null,
            docRef: d.reference,
          ),
        );
      }

      if (!mounted || _lastIssuedQuery != input.trim()) return false;

      setState(() {
        _localResults = items;
        _loading = false;
        _error = items.isEmpty ? null : null;
        _source = _ResultSource.local;
      });

      return items.isNotEmpty;
    } catch (e) {
      if (!mounted) return false;
      setState(() {
        _localResults = [];
        _error = e.toString();
        _loading = false;
        _source = _ResultSource.local;
      });
      return false;
    }
  }

  Future<bool> _searchGooglePredictions(String input) async {
    // Only run if search panel is open and we aren't suppressing network
    if (!_searchFocus.hasFocus || _suppressFurtherNetwork) return false;
    if (input.trim().length < _minSearchChars) return false;

    setState(() {
      _loading = true;
      _error = null;
      _googleResults = [];
      _apiResults = [];
      _source = _ResultSource.googlePredictions;
    });

    try {
      final places = gmws.GoogleMapsPlaces(
        apiKey: _googleApiKey,
        apiHeaders: await const GoogleApiHeaders().getHeaders(),
      );

      final resp = await places.autocomplete(
        input,
        sessionToken: _sessionToken,
        language: 'en',
        components: [gmws.Component(gmws.Component.country, 'in')],
        location: gmws.Location(
            lat: _biasCenter.latitude, lng: _biasCenter.longitude),
        radius: 60000,
        strictbounds: false,
      );

      if (!mounted || _lastIssuedQuery != input.trim()) return false;

      setState(() {
        if (resp.isOkay) {
          _googleResults = (resp.predictions).toList();
          _error = _googleResults.isEmpty ? 'No Google suggestions' : null;
        } else {
          _googleResults = [];
          _error = resp.errorMessage ?? 'No results';
        }
        _loading = false;
        _source = _ResultSource.googlePredictions;
      });

      return _googleResults.isNotEmpty;
    } catch (e) {
      if (!mounted) return false;
      setState(() {
        _googleResults = [];
        _error = e.toString();
        _loading = false;
        _source = _ResultSource.googlePredictions;
      });
      return false;
    }
  }

  Future<bool> _searchGoogleText(String input) async {
    setState(() {
      _loading = true;
      _error = null;
      _apiResults = [];
      _source = _ResultSource.apiSearch;
    });

    try {
      final places = gmws.GoogleMapsPlaces(
        apiKey: _googleApiKey,
        apiHeaders: await const GoogleApiHeaders().getHeaders(),
      );

      // NOTE: google_maps_webservice_places v0 (legacy) uses `searchByText`, newer uses `textSearch`.
      final resp = await places.searchByText(
        input,
        language: 'en',
        location: gmws.Location(
            lat: _biasCenter.latitude, lng: _biasCenter.longitude),
        radius: 60000,
      );

      if (!mounted || _lastIssuedQuery != input.trim()) return false;

      if (resp.isOkay) {
        final items = resp.results.map((r) {
          return _ApiPlace(
            placeId: r.placeId ?? 'unknown',
            title: r.name ?? (r.formattedAddress ?? 'Unknown'),
            subtitle: r.formattedAddress ?? '',
            latLng: (r.geometry?.location == null)
                ? null
                : LatLng(r.geometry!.location.lat, r.geometry!.location.lng),
          );
        }).toList();

        setState(() {
          _apiResults = items;
          _loading = false;
          _error = items.isEmpty ? 'No places found' : null;
          _source = _ResultSource.apiSearch;
        });
        return items.isNotEmpty;
      } else {
        setState(() {
          _apiResults = [];
          _loading = false;
          _error = resp.errorMessage ?? 'No results';
          _source = _ResultSource.apiSearch;
        });
        return false;
      }
    } catch (e) {
      if (!mounted) return false;
      setState(() {
        _apiResults = [];
        _error = e.toString();
        _loading = false;
        _source = _ResultSource.apiSearch;
      });
      return false;
    }
  }

  // ----------------- Selection handlers -----------------
  Future<void> _selectLocal(_LocalPlace item) async {
    final target = item.latLng;
    if (target == null) return;

    // 1) Marker
    _placePickedMarker(target, title: item.title, snippet: item.subtitle);

    // 2) Camera
    await _map?.animateCamera(CameraUpdate.newLatLngZoom(target, 17.0));

    // 3) Fill field & close panel
    _debounce?.cancel();
    _searchCtrl.text = _selectedAddress ?? item.subtitle;
    _searchFocus.unfocus();
    setState(() {
      _localResults = [];
      _googleResults = [];
      _apiResults = [];
      _error = null;
      _loading = false;
    });

    // 4) bump hits
    await item.docRef.set({
      'hits': FieldValue.increment(1),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> _selectPrediction(gmws.Prediction p) async {
    if (p.placeId == null) return;

    // Avoid calling details more than once per placeId within this screen session
    if (_fetchedDetails.contains(p.placeId)) {
      final snap = await _gsvc
          .collection('places_cache')
          .where('placeId', isEqualTo: p.placeId)
          .limit(1)
          .get();
      if (snap.docs.isNotEmpty) {
        final d = snap.docs.first.data();
        final lat = (d['lat'] as num?)?.toDouble();
        final lng = (d['lng'] as num?)?.toDouble();
        if (lat != null && lng != null) {
          final target = LatLng(lat, lng);
          final title = (d['name'] ?? '') as String? ?? (p.description ?? '');
          final subtitle = (d['address'] is Map)
              ? ((d['address']['formatted'] ?? '') as String? ?? '')
              : ((d['address'] ?? '') as String? ?? '');
          _applySelection(
            target,
            title,
            subtitle.isNotEmpty ? subtitle : title,
            placeId: p.placeId!,
            addressMap: d['address'] is Map
                ? Map<String, dynamic>.from(d['address'])
                : null,
          );
          return;
        }
      }
    }

    _sessionToken = const Uuid().v4();

    final places = gmws.GoogleMapsPlaces(
      apiKey: _googleApiKey,
      apiHeaders: await const GoogleApiHeaders().getHeaders(),
    );

    final detail = await places.getDetailsByPlaceId(p.placeId!);
    _fetchedDetails.add(p.placeId!);

    final geometry = detail.result.geometry;
    if (geometry == null) return;

    final target = LatLng(geometry.location.lat, geometry.location.lng);
    final title = detail.result.name;
    final fullAddress =
        detail.result.formattedAddress ?? (p.description ?? title);

    // Upsert into g-service cache (so next time it's free)
    final addrMap =
        _toAddressMap(detail.result.addressComponents, formatted: fullAddress);
    final String? stateName = addrMap['state'] as String?;

    await _upsertPlaceCache(
      placeId: p.placeId!,
      name: title,
      addressMap: addrMap,
      latLng: target,
      stateName: stateName,
    );

    _applySelection(target, title, fullAddress,
        placeId: p.placeId!, addressMap: addrMap);
  }

  Future<void> _selectApiPlace(_ApiPlace a) async {
    if (_fetchedDetails.contains(a.placeId)) {
      final snap = await _gsvc
          .collection('places_cache')
          .where('placeId', isEqualTo: a.placeId)
          .limit(1)
          .get();
      if (snap.docs.isNotEmpty) {
        final d = snap.docs.first.data();
        final lat = (d['lat'] as num?)?.toDouble();
        final lng = (d['lng'] as num?)?.toDouble();
        final target = (lat != null && lng != null)
            ? LatLng(lat, lng)
            : (a.latLng ?? _biasCenter);
        final title = (d['name'] ?? '') as String? ?? a.title;
        final subtitle = (d['address'] is Map)
            ? ((d['address']['formatted'] ?? '') as String? ?? '')
            : ((d['address'] ?? '') as String? ?? '');
        _applySelection(target, title, subtitle.isNotEmpty ? subtitle : title,
            placeId: a.placeId,
            addressMap: d['address'] is Map
                ? Map<String, dynamic>.from(d['address'])
                : null);
        return;
      }
    }

    try {
      final places = gmws.GoogleMapsPlaces(
        apiKey: _googleApiKey,
        apiHeaders: await const GoogleApiHeaders().getHeaders(),
      );

      final detail = await places.getDetailsByPlaceId(a.placeId);
      _fetchedDetails.add(a.placeId);

      final g = detail.result.geometry;
      LatLng target = a.latLng ??
          ((g != null) ? LatLng(g.location.lat, g.location.lng) : _biasCenter);

      final title =
          detail.result.name.isNotEmpty ? detail.result.name : a.title;
      final fullAddress = detail.result.formattedAddress?.isNotEmpty == true
          ? detail.result.formattedAddress!
          : a.subtitle;

      final addrMap = _toAddressMap(detail.result.addressComponents,
          formatted: fullAddress);
      final String? stateName = addrMap['state'] as String?;

      await _upsertPlaceCache(
        placeId: a.placeId,
        name: title,
        addressMap: addrMap,
        latLng: target,
        stateName: stateName,
      );

      _applySelection(
          target, title, fullAddress.isNotEmpty ? fullAddress : title,
          placeId: a.placeId, addressMap: addrMap);
    } catch (e) {
      final target = a.latLng ?? _biasCenter;
      _applySelection(
          target, a.title, a.subtitle.isNotEmpty ? a.subtitle : a.title);
    }
  }

  Future<void> _applySelection(
    LatLng target,
    String title,
    String fullAddress, {
    String? placeId,
    Map<String, dynamic>? addressMap,
  }) async {
    _selectedPlaceId = placeId;
    _selectedAddressMap = addressMap;

    _placePickedMarker(target, title: title, snippet: fullAddress);

    await _map?.animateCamera(CameraUpdate.newLatLngZoom(target, 17.0));

    _debounce?.cancel();
    _searchCtrl.text = fullAddress;
    _searchFocus.unfocus();
    setState(() {
      _localResults = [];
      _googleResults = [];
      _apiResults = [];
      _error = null;
      _loading = false;
    });
  }

  void _placePickedMarker(LatLng target,
      {required String title, String? snippet}) {
    setState(() {
      _markers
        ..clear()
        ..add(Marker(
          markerId: const MarkerId('picked'),
          position: target,
          infoWindow: InfoWindow(title: title, snippet: snippet ?? ''),
          draggable: true,
          onDragEnd: _onMarkerDragEnd,
        ));
      _selectedLatLng = target;
      _selectedTitle = title;
      _selectedAddress = snippet ?? title;
    });
  }

  void _onMarkerDragEnd(LatLng pos) {
    // Move marker to new position and debounce reverse-geocoding by 3 seconds
    setState(() {
      _selectedLatLng = pos;
      _isGeocoding = true;
      // address becomes tentative until geocode finishes
    });

    // Update marker immediately so it stays where user dropped it
    _markers.removeWhere((m) => m.markerId.value == 'picked');
    _markers.add(Marker(
      markerId: const MarkerId('picked'),
      position: pos,
      infoWindow: InfoWindow(title: _selectedTitle ?? 'Dropped pin'),
      draggable: true,
      onDragEnd: _onMarkerDragEnd,
    ));
    setState(() {});

    _dragDelay?.cancel();
    _dragDelay = Timer(const Duration(seconds: 3), () {
      _reverseGeocodeAndFill(pos,
          fallbackTitle: _selectedTitle ?? 'Dropped pin');
    });
  }

  // ----------------- Helpers for addresses -----------------
  String? _safeString(String? v) {
    if (v == null) return null;
    final t = v.trim();
    return t.isEmpty ? null : t;
  }

  Map<String, dynamic> _toAddressMap(List<gmws.AddressComponent> comps,
      {String? formatted}) {
    gmws.AddressComponent? _first(String type) {
      try {
        return comps.firstWhere((c) => c.types.contains(type));
      } catch (_) {
        return null;
      }
    }

    String? longOf(String type) => _safeString(_first(type)?.longName);
    String? shortOf(String type) => _safeString(_first(type)?.shortName);

    String? sublocality() {
      const levels = [
        'sublocality',
        'sublocality_level_1',
        'sublocality_level_2',
        'sublocality_level_3',
        'sublocality_level_4',
        'sublocality_level_5',
      ];
      for (final t in levels) {
        final v = longOf(t);
        if (v != null) return v;
      }
      return null;
    }

    final map = <String, dynamic>{
      'formatted': _safeString(formatted),
      'country': longOf('country'),
      'countryCode': shortOf('country'),
      'state': longOf('administrative_area_level_1'),
      'stateCode': shortOf('administrative_area_level_1'),
      'district': longOf('administrative_area_level_2'),
      'subDistrict': longOf('administrative_area_level_3'),
      'locality': longOf('locality'),
      'sublocality': sublocality(),
      'neighborhood': longOf('neighborhood'),
      'route': longOf('route'),
      'streetNumber': longOf('street_number'),
      'postalCode': longOf('postal_code'),
      'premise': longOf('premise'),
      'subpremise': longOf('subpremise'),
      'plusCode': longOf('plus_code'),
    };

    final out = <String, dynamic>{};
    map.forEach((k, v) {
      if (v == null) return;
      if (v is String && v.trim().isEmpty) return;
      out[k] = v;
    });
    return out;
  }

  Map<String, dynamic> _placemarkToAddressMap(Placemark p,
      {String? formatted}) {
    String? _nz(String? s) => (s == null || s.trim().isEmpty) ? null : s.trim();
    final map = <String, dynamic>{
      'formatted': _nz(formatted),
      'country': _nz(p.country),
      'countryCode': _nz(p.isoCountryCode),
      'state': _nz(p.administrativeArea),
      'district': _nz(p.subAdministrativeArea),
      'locality': _nz(p.locality),
      'sublocality': _nz(p.subLocality),
      'route': _nz(p.street),
      'postalCode': _nz(p.postalCode),
      'premise': _nz(p.name),
    };
    final out = <String, dynamic>{};
    map.forEach((k, v) {
      if (v == null) return;
      if (v is String && v.trim().isEmpty) return;
      out[k] = v;
    });
    return out;
  }

  // ----------------- Map extras: FAB, long press, reverse geocode -----------------
  Future<void> _goToMyLocation() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location services are disabled')),
        );
        return;
      }
      var perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.denied ||
          perm == LocationPermission.deniedForever) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permission denied')),
        );
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      final here = LatLng(pos.latitude, pos.longitude);

      await _map?.animateCamera(CameraUpdate.newLatLngZoom(here, 16.5));

      _placePickedMarker(here, title: 'Your location');

      _isGeocoding = true;
      await _reverseGeocodeAndFill(here, fallbackTitle: 'Your location');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to get location: $e')),
      );
    }
  }

  Future<void> _onMapLongPress(LatLng pos) async {
    _placePickedMarker(pos, title: 'Dropped pin');
    await _map?.animateCamera(CameraUpdate.newLatLngZoom(pos, 17.0));
    await _reverseGeocodeAndFill(pos, fallbackTitle: 'Dropped pin');
  }

  Future<void> _reverseGeocodeAndFill(LatLng pos,
      {required String fallbackTitle}) async {
    try {
      final placemarks =
          await placemarkFromCoordinates(pos.latitude, pos.longitude);
      String display = '';
      Map<String, dynamic>? addrMap;

      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        final parts = <String>[
          if ((p.name ?? '').trim().isNotEmpty) p.name!,
          if ((p.subLocality ?? '').trim().isNotEmpty) p.subLocality!,
          if ((p.locality ?? '').trim().isNotEmpty) p.locality!,
          if ((p.subAdministrativeArea ?? '').trim().isNotEmpty)
            p.subAdministrativeArea!,
          if ((p.administrativeArea ?? '').trim().isNotEmpty)
            p.administrativeArea!,
          if ((p.postalCode ?? '').trim().isNotEmpty) p.postalCode!,
        ];
        display = parts.join(', ');
        addrMap = _placemarkToAddressMap(p, formatted: display);
      }

      setState(() {
        _selectedAddress = display.isNotEmpty ? display : fallbackTitle;
        _selectedAddressMap = addrMap;
        _searchCtrl.text = _selectedAddress!;
        _isGeocoding = false;
        _error = null;
        _localResults = [];
        _googleResults = [];
        _apiResults = [];
      });

      // Not caching manual pins into places_cache.
    } catch (_) {
      setState(() {
        _isGeocoding = false;
      });
    }
  }

  // ----------------- Save location (sheet) -----------------
  Future<void> _openSaveBottomSheet() async {
    if (_selectedLatLng == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pick a location first')),
      );
      return;
    }

    final width = MediaQuery.of(context).size.width;

    // --- Controllers (prefill for EDIT) ---
    final TextEditingController nameCtrl = TextEditingController(
        text: (widget.initialName?.trim().isNotEmpty ?? false)
            ? widget.initialName!.trim()
            : (_selectedTitle ?? ''));

    final TextEditingController houseCtrl =
        TextEditingController(text: widget.initialHouse ?? '');

    final TextEditingController landmarkCtrl =
        TextEditingController(text: widget.initialLandmark ?? '');

    // Type selector + Label field
    String selectedTypeKey = (widget.initialType == 'home' ||
            widget.initialType == 'work' ||
            widget.initialType == 'other')
        ? widget.initialType!
        : 'home';

    String _cap(String k) =>
        k.isEmpty ? k : (k[0].toUpperCase() + k.substring(1));

    final TextEditingController labelCtrl = TextEditingController(
      text: (widget.initialLabel?.trim().isNotEmpty ?? false)
          ? widget.initialLabel!.trim()
          : _cap(selectedTypeKey),
    );

    bool makeDefault = widget.initialIsDefault ?? false;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final bottom = MediaQuery.of(ctx).viewInsets.bottom;

        // --- size + style constants (uniform across fields) ---
        final double kFieldH = width * .095;
        final double kFont = width * .035;
        final double kLabel = width * .034;

        InputDecoration _dec(String label, String hint, {Widget? prefixIcon}) =>
            InputDecoration(
              isDense: true,
              labelText: label,
              labelStyle: TextStyle(fontSize: kLabel),
              hintText: hint,
              hintStyle:
                  TextStyle(fontSize: kFont * .94, color: Colors.black45),
              contentPadding: EdgeInsets.symmetric(
                horizontal: width * .03,
                vertical: width * .022,
              ),
              prefixIcon: prefixIcon,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(width * .03),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(width * .03),
                borderSide: BorderSide(
                    color: const Color(0xFFDFE3EA), width: width * .003),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(width * .03),
                borderSide: BorderSide(
                    color: const Color(0xFF2F6BFF), width: width * .004),
              ),
            );

        return AnimatedPadding(
          duration: const Duration(milliseconds: 150),
          padding: EdgeInsets.only(bottom: bottom),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(width * .045),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.15),
                  blurRadius: width * .06,
                  offset: Offset(0, width * .02),
                )
              ],
            ),
            child: StatefulBuilder(
              builder: (ctx, setM) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                        width * .05, width * .04, width * .05, width * .04),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // drag handle
                        Center(
                          child: Container(
                            width: width * .18,
                            height: width * .012,
                            decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(width * .01),
                            ),
                          ),
                        ),
                        SizedBox(height: width * .04),

                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.existingDocId == null
                                    ? "Save location"
                                    : "Update location",
                                style: TextStyle(
                                  fontSize: width * .05,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () => Navigator.of(ctx).pop(),
                              icon:
                                  Icon(Icons.close_rounded, size: width * .06),
                            ),
                          ],
                        ),
                        SizedBox(height: width * .02),

                        // --- TYPE SELECTOR (Home / Work / Other) ---
                        TypeSelector(
                          width: width,
                          value: selectedTypeKey,
                          onChanged: (v) {
                            setM(() {
                              selectedTypeKey = v; // true type
                              // don't auto-change label
                            });
                          },
                        ),

                        SizedBox(height: width * .02),

                        // --- LABEL (editable, saved as `label`) ---
                        SizedBox(
                          height: kFieldH,
                          child: TextField(
                            controller: labelCtrl,
                            style: TextStyle(fontSize: kFont),
                            textCapitalization: TextCapitalization.words,
                            decoration: _dec(
                              'Label',
                              'e.g., Home, Work, Gym',
                              prefixIcon:
                                  const Icon(Icons.label_important_outline),
                            ),
                          ),
                        ),

                        SizedBox(height: width * .02),

                        // Name
                        SizedBox(
                          height: kFieldH,
                          child: TextField(
                            controller: nameCtrl,
                            style: TextStyle(fontSize: kFont),
                            textCapitalization: TextCapitalization.words,
                            decoration: _dec('Name', 'e.g., “John’s Home”',
                                prefixIcon: const Icon(Icons.badge_outlined)),
                          ),
                        ),

                        SizedBox(height: width * .02),

                        // House/flat and Landmark
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: kFieldH,
                                child: TextField(
                                  controller: houseCtrl,
                                  style: TextStyle(fontSize: kFont),
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  decoration: _dec(
                                    'House / Flat / Building',
                                    'Optional',
                                    prefixIcon:
                                        const Icon(Icons.apartment_outlined),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: width * .02),
                            Expanded(
                              child: SizedBox(
                                height: kFieldH,
                                child: TextField(
                                  controller: landmarkCtrl,
                                  style: TextStyle(fontSize: kFont),
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  decoration: _dec(
                                    'Landmark / Notes',
                                    'Optional',
                                    prefixIcon: const Icon(
                                        Icons.location_city_outlined),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: width * .03),

                        // Address preview
                        Container(
                          padding: EdgeInsets.all(width * .03),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF6F7FA),
                            borderRadius: BorderRadius.circular(width * .03),
                            border: Border.all(color: const Color(0xFFE6EAF1)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.place_rounded,
                                  color: Colors.redAccent, size: width * .06),
                              SizedBox(width: width * .02),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _selectedAddress ?? '—',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: kFont,
                                      ),
                                    ),
                                    SizedBox(height: width * .01),
                                    Text(
                                      '(${_selectedLatLng!.latitude.toStringAsFixed(6)}, '
                                      '${_selectedLatLng!.longitude.toStringAsFixed(6)})',
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: kFont * .9,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: width * .02),

                        // Default toggle
                        InkWell(
                          onTap: () => setM(() => makeDefault = !makeDefault),
                          child: Row(
                            children: [
                              Checkbox(
                                value: makeDefault,
                                onChanged: (v) =>
                                    setM(() => makeDefault = v ?? false),
                              ),
                              Text(
                                'Make this my default address',
                                style: TextStyle(fontSize: kFont),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: width * .03),

                        // Actions
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => Navigator.of(ctx).pop(),
                                style: OutlinedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                      vertical: width * .03),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(width * .03),
                                  ),
                                ),
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(fontSize: width * .038),
                                ),
                              ),
                            ),
                            SizedBox(width: width * .03),
                            Expanded(
                              child: FilledButton.icon(
                                icon: const Icon(Icons.bookmark_added),
                                label: Text(
                                  widget.existingDocId == null
                                      ? 'Save location'
                                      : 'Update location',
                                  style: TextStyle(fontSize: width * .038),
                                ),
                                style: FilledButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                      vertical: width * .03),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(width * .03),
                                  ),
                                ),
                                onPressed: () async {
                                  final finalType =
                                      selectedTypeKey; // <- TRUE type
                                  final labelText = labelCtrl.text.trim();

                                  await _saveSelectedPlace(
                                    type: finalType,
                                    label: labelText.isEmpty
                                        ? _cap(finalType)
                                        : labelText, // saved as `label`
                                    name: nameCtrl.text.trim().isEmpty
                                        ? (_selectedTitle ?? 'Saved place')
                                        : nameCtrl.text.trim(),
                                    house: houseCtrl.text.trim(),
                                    landmark: landmarkCtrl.text.trim(),
                                    isDefault: makeDefault,
                                    existingDocId: widget.existingDocId,
                                  );

                                  if (mounted) {
                                    Navigator.of(ctx).pop();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          widget.existingDocId == null
                                              ? 'Location saved'
                                              : 'Location updated',
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> _saveSelectedPlace({
    required String type, // 'home' | 'work' | 'other'
    required String label, // free-text label
    required String name,
    String? house,
    String? landmark,
    bool isDefault = false,
    String? existingDocId, // if provided -> update instead of add
  }) async {
    if (_selectedLatLng == null) return;

    final now = FieldValue.serverTimestamp();

    final base = <String, dynamic>{
      'type': type, // <-- TRUE TYPE
      'label': label, // <-- SAVED LABEL
      'name': name, // user title
      'title': _selectedTitle, // picked title (optional)
      'addressString': _selectedAddress, // display address
      'addressMap': _selectedAddressMap, // structured parts if available
      'placeId': _selectedPlaceId,
      'house': (house?.isEmpty ?? true) ? null : house,
      'landmark': (landmark?.isEmpty ?? true) ? null : landmark,
      'lat': _selectedLatLng!.latitude,
      'lng': _selectedLatLng!.longitude,
      'source': _selectedPlaceId != null ? 'google_detail' : 'reverse_geocode',
      'isDefault': isDefault,
      'updatedAt': now,
    }..removeWhere((k, v) => v == null);

    final col =
        _main.collection('users').doc(_user!.uid).collection('saved_addresses');

    String currentId;

    if ((existingDocId ?? '').isNotEmpty) {
      // UPDATE existing (don't overwrite createdAt)
      await col.doc(existingDocId).set(base, SetOptions(merge: true));
      currentId = existingDocId!;
    } else {
      // ADD new (set createdAt)
      final data = {
        ...base,
        'createdAt': now,
      };
      final ref = await col.add(data);
      currentId = ref.id;
    }

    // If flagged as default, mark others not default (optional tidy-up)
    if (isDefault) {
      final others =
          await col.where(FieldPath.documentId, isNotEqualTo: currentId).get();
      for (final d in others.docs) {
        await d.reference.set(
            {'isDefault': false, 'updatedAt': now}, SetOptions(merge: true));
      }
    }
  }

  // ----------------- UI -----------------
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final double spacerTop = width * .05;
    final double fieldHeight = width * .105;
    final double panelPad = width * .0125;
    final double cardRadius = width * .03;
    final double borderWidth = width * .005;
    final double iconSize = width * .034;
    final double gap = width * .01;

    String _panelTitle() {
      switch (_source) {
        case _ResultSource.local:
          return "from places cache";
        case _ResultSource.googlePredictions:
          return "Google predictions";
        case _ResultSource.apiSearch:
          return "API search results";
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select from map'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
          tooltip: 'Back',
        ),
        actions: [
          IconButton(
            tooltip: 'My location',
            icon: const Icon(Icons.my_location),
            onPressed: _goToMyLocation,
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: _initialCameraPosition,
              onMapCreated: (c) async {
                _map = c;
                if (_pendingCameraTarget != null) {
                  await _map!.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(target: _pendingCameraTarget!, zoom: 15),
                    ),
                  );
                  _pendingCameraTarget = null;
                }
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: false, // we use AppBar button
              zoomControlsEnabled: false,
              markers: _markers,
              onCameraMove: (pos) => _biasCenter = pos.target,
              onLongPress: _onMapLongPress, // drop a pin
            ),

            // Search + panel
            SafeArea(
              child: SizedBox(
                width: width,
                child: Column(
                  children: [
                    SizedBox(height: spacerTop),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // colored leading dot
                        SizedBox(
                          height: fieldHeight,
                          child: Center(
                            child: Container(
                              width: width * 0.04,
                              height: width * 0.04,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: width * .005,
                                  color: Colors.black.withOpacity(.25),
                                ),
                                color: const Color(0xFF2F6BFF),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Container(
                                  width: width * 0.02,
                                  height: width * 0.02,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // search field + results
                        Container(
                          width: width * .82,
                          decoration:
                              const BoxDecoration(color: Colors.transparent),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // search field
                              Container(
                                height: fieldHeight,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.circular(width * .035),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.12),
                                      blurRadius: width * .02,
                                      offset: Offset(0, width * .0075),
                                    ),
                                  ],
                                ),
                                child: TextField(
                                  controller: _searchCtrl,
                                  focusNode: _searchFocus,
                                  onChanged: _onChanged,
                                  textInputAction: TextInputAction.search,
                                  decoration: InputDecoration(
                                    hintText:
                                        'Search places (cache → Google → API)',
                                    hintStyle:
                                        TextStyle(fontSize: width * .032),
                                    prefixIcon: Icon(
                                      Icons.search,
                                      size: iconSize,
                                      color: const Color(0xFF2F6BFF),
                                    ),
                                    suffixIcon: _searchCtrl.text.isEmpty
                                        ? null
                                        : IconButton(
                                            icon: Icon(Icons.close,
                                                size: iconSize),
                                            onPressed: () {
                                              setState(() {
                                                _searchCtrl.clear();
                                                _lastIssuedQuery = "";
                                                _localResults = [];
                                                _googleResults = [];
                                                _apiResults = [];
                                                _error = null;
                                                _source = _ResultSource.local;
                                                _suppressFurtherNetwork = false;
                                              });
                                            },
                                          ),
                                    border: InputBorder.none,
                                    contentPadding:
                                        EdgeInsets.only(top: width * .0125),
                                  ),
                                  style: TextStyle(fontSize: width * .035),
                                ),
                              ),
                              SizedBox(height: gap),

                              // panel
                              if (_searchFocus.hasFocus &&
                                  (_loading ||
                                      _localResults.isNotEmpty ||
                                      _googleResults.isNotEmpty ||
                                      _apiResults.isNotEmpty ||
                                      (_error != null &&
                                          _searchCtrl.text.isNotEmpty)))
                                Container(
                                  padding: EdgeInsets.all(panelPad),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEDEDED),
                                    borderRadius:
                                        BorderRadius.circular(width * .04),
                                    border: Border.all(
                                        color: Colors.black26,
                                        width: borderWidth),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(.18),
                                        blurRadius: width * .03,
                                        offset: Offset(0, width * .01),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: gap * .5,
                                            horizontal: gap * .5,
                                          ),
                                          child: Text(
                                            _panelTitle(),
                                            style: TextStyle(
                                              fontSize: width * .028,
                                              color: Colors.black54,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                      if (_loading)
                                        SizedBox(
                                          height: width * .08,
                                          child: const Center(
                                            child: CupertinoActivityIndicator(),
                                          ),
                                        )
                                      else if (_error != null)
                                        Padding(
                                          padding: EdgeInsets.all(width * .01),
                                          child: Text(
                                            _error!,
                                            style: TextStyle(
                                              color: Colors.redAccent,
                                              fontSize: width * .032,
                                            ),
                                          ),
                                        )
                                      else if (_source == _ResultSource.local &&
                                          _localResults.isNotEmpty)
                                        ListView.separated(
                                          padding: EdgeInsets.zero,
                                          shrinkWrap: true,
                                          itemCount: _localResults.length,
                                          separatorBuilder: (_, __) =>
                                              SizedBox(height: gap * .6),
                                          itemBuilder: (context, i) {
                                            final item = _localResults[i];
                                            return InkWell(
                                              onTap: () => _selectLocal(item),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      cardRadius),
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: width * .022,
                                                  vertical: width * .018,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          cardRadius),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(.06),
                                                      blurRadius: width * .02,
                                                      offset: Offset(
                                                          0, width * .005),
                                                    ),
                                                  ],
                                                ),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width: width * .06,
                                                      height: width * .06,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.green
                                                            .withOpacity(.12),
                                                      ),
                                                      child: Icon(
                                                        Icons
                                                            .cloud_done_outlined,
                                                        size: iconSize,
                                                        color: Colors.green,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                        width: width * .02),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            item.title,
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                              fontSize:
                                                                  width * .034,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                          if (item.subtitle
                                                              .isNotEmpty) ...[
                                                            SizedBox(
                                                                height: width *
                                                                    .005),
                                                            Text(
                                                              item.subtitle,
                                                              maxLines: 2,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                fontSize:
                                                                    width *
                                                                        .028,
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        .6),
                                                              ),
                                                            ),
                                                          ],
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                        width: width * .01),
                                                    Icon(Icons.north_east,
                                                        size: iconSize,
                                                        color: Colors.black45),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        )
                                      else if (_source ==
                                              _ResultSource.googlePredictions &&
                                          _googleResults.isNotEmpty)
                                        ListView.separated(
                                          padding: EdgeInsets.zero,
                                          shrinkWrap: true,
                                          itemCount: _googleResults.length,
                                          separatorBuilder: (_, __) =>
                                              SizedBox(height: gap * .6),
                                          itemBuilder: (context, i) {
                                            final p = _googleResults[i];
                                            final main = p.structuredFormatting
                                                    ?.mainText ??
                                                (p.description ?? '');
                                            final secondary = p
                                                    .structuredFormatting
                                                    ?.secondaryText ??
                                                '';
                                            return InkWell(
                                              onTap: () => _selectPrediction(p),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      cardRadius),
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: width * .022,
                                                  vertical: width * .018,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          cardRadius),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(.06),
                                                      blurRadius: width * .02,
                                                      offset: Offset(
                                                          0, width * .005),
                                                    ),
                                                  ],
                                                ),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width: width * .06,
                                                      height: width * .06,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: const Color(
                                                                0xFF2F6BFF)
                                                            .withOpacity(.12),
                                                      ),
                                                      child: Icon(
                                                        Icons.place_outlined,
                                                        size: iconSize,
                                                        color: const Color(
                                                            0xFF2F6BFF),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                        width: width * .02),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            main,
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                              fontSize:
                                                                  width * .034,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                          if (secondary
                                                              .isNotEmpty) ...[
                                                            SizedBox(
                                                                height: width *
                                                                    .005),
                                                            Text(
                                                              secondary,
                                                              maxLines: 2,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                fontSize:
                                                                    width *
                                                                        .028,
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        .6),
                                                              ),
                                                            ),
                                                          ],
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                        width: width * .01),
                                                    Icon(Icons.north_east,
                                                        size: iconSize,
                                                        color: Colors.black45),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        )
                                      else if (_source ==
                                              _ResultSource.apiSearch &&
                                          _apiResults.isNotEmpty)
                                        ListView.separated(
                                          padding: EdgeInsets.zero,
                                          shrinkWrap: true,
                                          itemCount: _apiResults.length,
                                          separatorBuilder: (_, __) =>
                                              SizedBox(height: gap * .6),
                                          itemBuilder: (context, i) {
                                            final a = _apiResults[i];
                                            return InkWell(
                                              onTap: () => _selectApiPlace(a),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      cardRadius),
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: width * .022,
                                                    vertical: width * .018),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          cardRadius),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(.06),
                                                      blurRadius: width * .02,
                                                      offset: Offset(
                                                          0, width * .005),
                                                    ),
                                                  ],
                                                ),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width: width * .06,
                                                      height: width * .06,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.orange
                                                            .withOpacity(.12),
                                                      ),
                                                      child: Icon(
                                                        Icons.travel_explore,
                                                        size: iconSize,
                                                        color: Colors.orange,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                        width: width * .02),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            a.title,
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                              fontSize:
                                                                  width * .034,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                          if (a.subtitle
                                                              .isNotEmpty) ...[
                                                            SizedBox(
                                                                height: width *
                                                                    .005),
                                                            Text(
                                                              a.subtitle,
                                                              maxLines: 2,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                fontSize:
                                                                    width *
                                                                        .028,
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        .6),
                                                              ),
                                                            ),
                                                          ],
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                        width: width * .01),
                                                    Icon(Icons.north_east,
                                                        size: iconSize,
                                                        color: Colors.black45),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        )
                                      else
                                        Column(
                                          children: List.generate(4, (i) {
                                            return Container(
                                              margin: EdgeInsets.symmetric(
                                                  vertical: gap * .6),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        cardRadius),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(.06),
                                                    blurRadius: width * .02,
                                                    offset:
                                                        Offset(0, width * .005),
                                                  ),
                                                ],
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: width * .022,
                                                  vertical: width * .018),
                                              child:
                                                  SizedBox(height: width * .03),
                                            );
                                          }),
                                        ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // --- Bottom buttons ---
            Positioned(
              left: 16,
              right: 16,
              bottom: 24,
              child: Column(
                children: [
                  // Primary: Use this location
                  ElevatedButton.icon(
                    icon: _isGeocoding
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.check_circle_outline),
                    label: Text(
                      _selectedAddress == null
                          ? 'Use this location'
                          : 'Use this location • ${_selectedAddress!.length > 40 ? _selectedAddress!.substring(0, 40) + '…' : _selectedAddress!}',
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: const Color(0xFF2F6BFF),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: (!_isGeocoding && _selectedLatLng != null)
                        ? () {
                            Navigator.pop(context, {
                              // Return both modern and legacy keys for safety
                              'addressString':
                                  _selectedAddress ?? _searchCtrl.text.trim(),
                              'address': _selectedAddress ??
                                  _searchCtrl.text.trim(), // legacy
                              'latLng': _selectedLatLng,
                              'addressMap': _selectedAddressMap,
                              'placeId': _selectedPlaceId,
                            });
                          }
                        : null,
                  ),
                  const SizedBox(height: 8),

                  // Secondary row: Cancel + Save location (improved)
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.arrow_back),
                          label: const Text('Cancel'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton.icon(
                          icon: const Icon(Icons.bookmark_added_outlined),
                          label: Text(
                            widget.existingDocId == null
                                ? 'Save location'
                                : 'Update location',
                          ),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: (_selectedLatLng != null)
                              ? _openSaveBottomSheet
                              : null,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Segmented Type Selector — same style as the other page (Home/Work/Other)
class TypeSelector extends StatelessWidget {
  const TypeSelector({
    super.key,
    required this.width,
    required this.value,
    required this.onChanged,
  });

  final double width;
  final String value; // 'home' | 'work' | 'other'
  final ValueChanged<String> onChanged;

  static const _items = [
    ('home', '🏠', 'Home'),
    ('work', '🏢', 'Work'),
    ('other', '📍', 'Other'),
  ];

  static const Color kChipGreen = Color(0xFF22A45D);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(width * .01),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(width * .04),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
          children: _items.map((e) {
        final sel = value == e.$1;
        return Expanded(
          child: InkWell(
            onTap: () => onChanged(e.$1),
            borderRadius: BorderRadius.circular(width * .03),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              padding: EdgeInsets.symmetric(
                  vertical: width * .02, horizontal: width * .02),
              decoration: BoxDecoration(
                color: sel ? kChipGreen.withOpacity(.10) : null,
                borderRadius: BorderRadius.circular(width * .03),
                border: Border.all(
                  color: sel ? kChipGreen : Colors.transparent,
                  width: sel ? width * .005 : width * .003,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(e.$2, style: TextStyle(fontSize: width * .038)),
                  SizedBox(width: width * .012),
                  Text(
                    e.$3,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: sel ? kChipGreen : Colors.black87,
                      fontSize: width * .034,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList()),
    );
  }
}

/* ──────────────────────────────────────────────────────────────
   OPTIONAL: Model + fetch helper for "getting from Firebase"
   This matches the structure saved above (type + label separated)
   ────────────────────────────────────────────────────────────── */

class SavedAddress {
  final String id;
  final String type; // 'home' | 'work' | 'other'
  final String label; // free text label (e.g., "Home", "Parents", "Gym")
  final String name;
  final String? addressString;
  final Map<String, dynamic>? addressMap;
  final String? placeId;
  final double lat;
  final double lng;
  final bool isDefault;

  SavedAddress({
    required this.id,
    required this.type,
    required this.label,
    required this.name,
    required this.addressString,
    required this.addressMap,
    required this.placeId,
    required this.lat,
    required this.lng,
    required this.isDefault,
  });

  factory SavedAddress.fromDoc(DocumentSnapshot<Map<String, dynamic>> d) {
    final m = d.data() ?? {};
    return SavedAddress(
      id: d.id,
      type: (m['type'] ?? 'other') as String,
      label: (m['label'] ?? '') as String,
      name: (m['name'] ?? '') as String,
      addressString: m['addressString'] as String?,
      addressMap: (m['addressMap'] as Map?)?.cast<String, dynamic>(),
      placeId: m['placeId'] as String?,
      lat: (m['lat'] as num).toDouble(),
      lng: (m['lng'] as num).toDouble(),
      isDefault: (m['isDefault'] as bool?) ?? false,
    );
  }
}

/// Example read helper:
Future<List<SavedAddress>> fetchSavedAddresses(
    FirebaseFirestore db, String uid) async {
  final q = await db
      .collection('users')
      .doc(uid)
      .collection('saved_addresses')
      .orderBy('isDefault', descending: true)
      .orderBy('updatedAt', descending: true)
      .get();
  return q.docs.map(SavedAddress.fromDoc).toList();
}
