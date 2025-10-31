import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_google_places_hoc081098/google_maps_webservice_places.dart'
    as gmws;
import 'package:google_api_headers/google_api_headers.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:uuid/uuid.dart';

class DriverLocationSetting extends StatefulWidget {
  const DriverLocationSetting({super.key});

  @override
  State<DriverLocationSetting> createState() => _DriverLocationSettingState();
}

class _DriverLocationSettingState extends State<DriverLocationSetting> {
  final String googleApiKey = "AIzaSyDwD1BJXVxky_Cy6xzyQh_5A2PW9cTOO0I";

  GoogleMapController? mapController;
  late TextEditingController _searchCtrl;
  final FocusNode _searchFocus = FocusNode();
  Timer? _debounce;
  String _sessionToken = const Uuid().v4();

  List<gmws.Prediction> _results = [];
  bool _loading = false;
  String? _error;

  LatLng _biasCenter = const LatLng(10.8505, 76.2711);
  LatLng? _pendingCameraTarget;

  final Set<Marker> _markers = {};
  final CameraPosition _initialPosition = const CameraPosition(
    target: LatLng(10.8505, 76.2711),
    zoom: 14.0,
  );

  @override
  void initState() {
    super.initState();
    _searchCtrl = TextEditingController();
    _initLocationAndBias();

    _searchFocus.addListener(() {
      if (_searchFocus.hasFocus && _searchCtrl.text.trim().length >= 2) {
        _search(_searchCtrl.text.trim());
      }
      if (!_searchFocus.hasFocus) {
        setState(() {
          _results = [];
          _error = null;
          _loading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _searchFocus.dispose();
    _debounce?.cancel();
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _initLocationAndBias() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final newCenter = LatLng(pos.latitude, pos.longitude);
      setState(() {
        _biasCenter = newCenter;
        _pendingCameraTarget = newCenter;
      });

      if (mapController != null) {
        await mapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: newCenter, zoom: 15.0),
          ),
        );
        _pendingCameraTarget = null;
      }
    } catch (_) {}
  }

  Future<void> _onChanged(String text) async {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 260), () {
      _search(text.trim());
    });
  }

  Future<void> _search(String input) async {
    if (!_searchFocus.hasFocus) return;
    if (input.length < 2) {
      setState(() {
        _results = [];
        _error = null;
        _loading = false;
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final places = gmws.GoogleMapsPlaces(
        apiKey: googleApiKey,
        apiHeaders: await const GoogleApiHeaders().getHeaders(),
      );

      final resp = await places.autocomplete(
        input,
        sessionToken: _sessionToken,
        language: 'en',
        components: [gmws.Component(gmws.Component.country, 'in')],
        location: gmws.Location(
          lat: _biasCenter.latitude,
          lng: _biasCenter.longitude,
        ),
        radius: 60000,
        strictbounds: false,
      );

      if (!mounted) return;

      setState(() {
        if (resp.isOkay) {
          _results = resp.predictions;
          _error = null;
        } else {
          _results = [];
          _error = resp.errorMessage ?? 'No results';
        }
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _results = [];
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _selectPrediction(gmws.Prediction p) async {
    _sessionToken = const Uuid().v4();

    final places = gmws.GoogleMapsPlaces(
      apiKey: googleApiKey,
      apiHeaders: await const GoogleApiHeaders().getHeaders(),
    );

    final detail = await places.getDetailsByPlaceId(p.placeId!);
    final geometry = detail.result.geometry;
    if (geometry == null) return;

    final target = LatLng(geometry.location.lat, geometry.location.lng);
    final title = detail.result.name;
    final fullAddress =
        detail.result.formattedAddress ?? (p.description ?? title);

    setState(() {
      _biasCenter = target;
      _markers
        ..clear()
        ..add(
          Marker(
            markerId: const MarkerId('picked'),
            position: target,
            infoWindow: InfoWindow(title: title, snippet: fullAddress),
          ),
        );
    });

    await mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: target, zoom: 16.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final double fieldHeight = width * .105;
    final double iconSize = width * .034;
    final double gap = width * .01;

    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: _initialPosition,
              onMapCreated: (controller) async {
                mapController = controller;
                if (_pendingCameraTarget != null) {
                  await mapController!.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(target: _pendingCameraTarget!, zoom: 15.0),
                    ),
                  );
                  _pendingCameraTarget = null;
                }
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: false,
              markers: _markers,
              onCameraMove: (pos) => _biasCenter = pos.target,
            ),

            // Search field and results
            SafeArea(
              child: Padding(
                padding: EdgeInsets.all(width * 0.04),
                child: Column(
                  children: [
                    Container(
                      height: fieldHeight,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(width * .035),
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
                        decoration: InputDecoration(
                          hintText: 'Search driver location',
                          prefixIcon: Icon(Icons.search,
                              size: iconSize, color: Colors.blue),
                          suffixIcon: _searchCtrl.text.isEmpty
                              ? null
                              : IconButton(
                                  icon: Icon(Icons.close, size: iconSize),
                                  onPressed: () {
                                    setState(() {
                                      _searchCtrl.clear();
                                      _results = [];
                                      _error = null;
                                    });
                                  },
                                ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(height: gap),

                    // Results
                    if (_results.isNotEmpty)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(width * 0.03),
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _results.length,
                          itemBuilder: (context, i) {
                            final p = _results[i];
                            return ListTile(
                              leading: const Icon(Icons.place_outlined),
                              title: Text(p.description ?? ""),
                              onTap: () => _selectPrediction(p),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
