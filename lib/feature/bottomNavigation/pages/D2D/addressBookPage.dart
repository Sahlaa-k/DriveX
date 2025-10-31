import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drivex/feature/bottomNavigation/pages/D2D/selectFromMap.dart';
import 'package:drivex/main.dart'; // AppFire.gServiceDb / AppFire.mainDb
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // LatLng

class Addressbookpage extends StatefulWidget {
  const Addressbookpage({super.key});
  @override
  State<Addressbookpage> createState() => _AddressbookpageState();
}


class _AddressbookpageState extends State<Addressbookpage> {
  User? get _user => FirebaseAuth.instance.currentUser;

  // Read from the SAME DB you wrote to (main project)
  CollectionReference<Map<String, dynamic>> get _col => AppFire.mainDb
      .collection('users')
      .doc(_user!.uid)
      .collection('saved_addresses');

  // Secondary (g-service) – if you need it later
  FirebaseFirestore get _gsvc => AppFire.gServiceDb;

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      final width = MediaQuery.of(context).size.width;
      return Scaffold(
        appBar: AppBar(title: const Text('Saved Addresses')),
        body: Center(
          child: Text(
            'Please sign in to view saved addresses',
            style: TextStyle(fontSize: width * .04),
          ),
        ),
      );
    }

    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: const Text('Saved Addresses')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addViaMap(context),
        tooltip: 'Add via map',
        elevation: 3,
        child: const Icon(Icons.add_location_alt_outlined),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _col.orderBy('updatedAt', descending: true).snapshots(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}'));
          }
          final docs = snap.data?.docs ?? [];
          if (docs.isEmpty) {
            return _EmptyState(onAdd: () => _addViaMap(context), w: width);
          }

          return ListView.separated(
            padding: EdgeInsets.fromLTRB(
                width * .04, width * .04, width * .04, width * .25),
            itemCount: docs.length,
            separatorBuilder: (_, __) => SizedBox(height: width * .03),
            itemBuilder: (context, i) {
              final d = docs[i].data();
              final id = docs[i].id;
              final type = (d['type'] ?? 'other') as String;
              final label = (d['label'] as String?)?.trim().isNotEmpty == true
                  ? (d['label'] as String)
                  : _prettyType(type);
              final address = _displayAddress(d);

              return _AddressCard(
                w: width,
                type: type,
                label: label,
                address: address,
                onTap: () {},
                onEdit: () => _editOnMap(context, docId: id, data: d),
                onDelete: () => _confirmDelete(context, id),
              );
            },
          );
        },
      ),
    );
  }

  // ========== ADD VIA MAP (simple) ==========
  Future<void> _addViaMap(BuildContext context) async {
    final res = await Navigator.push<Map<String, dynamic>?>(
      context,
      MaterialPageRoute(builder: (_) => const Selectfrommap()),
    );
    if (res != null) {
      await _saveMapPick(res);
    }
  }

  // ========== EDIT ON MAP ==========
  Future<void> _editOnMap(BuildContext context,
      {required String docId, required Map<String, dynamic> data}) async {
    final current = await _resolveLatLngForDoc(data);
    final readable = _displayAddress(data);

    final res = await Navigator.push<Map<String, dynamic>?>(
      context,
      MaterialPageRoute(
        builder: (_) => Selectfrommap(
          existingDocId: docId,
          initialTarget: current,
          initialAddress: readable.isNotEmpty ? readable : null,
          initialType: (data['type'] as String?),
          initialLabel: (data['label'] as String?),
          initialName: (data['name'] as String?),
          initialHouse: (data['house'] as String?),
          initialLandmark: (data['landmark'] as String?),
          initialIsDefault: (data['isDefault'] as bool?),
          initialAddressMap: (data['addressMap'] is Map<String, dynamic>)
              ? Map<String, dynamic>.from(data['addressMap'])
              : null,
        ),
      ),
    );

    if (res != null) {
      final payload = _normalizeMapPick(res);
      if (payload != null) {
        await _col.doc(docId).set(payload, SetOptions(merge: true));
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location updated')),
          );
        }
      }
    }
  }

  /// Extract LatLng for centering the map, trying multiple schema variants.
  Future<LatLng?> _resolveLatLngForDoc(Map<String, dynamic> d) async {
    final gp = d['location'];
    if (gp is GeoPoint) return LatLng(gp.latitude, gp.longitude);

    if (gp is Map) {
      final lat = (gp['lat'] as num?)?.toDouble();
      final lng = (gp['lng'] as num?)?.toDouble();
      if (lat != null && lng != null) return LatLng(lat, lng);
    }

    final tlat = (d['lat'] as num?)?.toDouble();
    final tlng = (d['lng'] as num?)?.toDouble();
    if (tlat != null && tlng != null) return LatLng(tlat, tlng);

    final am = d['addressMap'];
    if (am is Map) {
      final lat = (am['lat'] as num?)?.toDouble();
      final lng = (am['lng'] as num?)?.toDouble();
      if (lat != null && lng != null) return LatLng(lat, lng);
    }

    final readable = _displayAddress(d);
    if (readable.isNotEmpty && readable != '—') {
      try {
        final ll = await locationFromAddress(readable);
        if (ll.isNotEmpty) {
          return LatLng(ll.first.latitude, ll.first.longitude);
        }
      } catch (_) {}
    }
    return null;
  }

  /// Normalize whatever came back from Selectfrommap into fields we store.
  Map<String, dynamic>? _normalizeMapPick(Map<String, dynamic> raw) {
    String? addressString;
    Map<String, dynamic>? addressMap;
    double? lat, lng;

    final s = raw['addressString'] ?? raw['formatted'] ?? raw['display'];
    if (s is String && s.trim().isNotEmpty) addressString = s.trim();

    final am = raw['addressMap'] ?? raw['address'];
    if (am is Map<String, dynamic>) addressMap = Map<String, dynamic>.from(am);

    final ll = raw['latLng'];
    if (ll is LatLng) {
      lat = ll.latitude;
      lng = ll.longitude;
    } else if (ll is Map) {
      final la = (ll['lat'] as num?)?.toDouble();
      final ln = (ll['lng'] as num?)?.toDouble();
      if (la != null && ln != null) {
        lat = la;
        lng = ln;
      }
    } else if (raw['location'] is GeoPoint) {
      final gp = raw['location'] as GeoPoint;
      lat = gp.latitude;
      lng = gp.longitude;
    } else {
      final la = (raw['lat'] as num?)?.toDouble();
      final ln = (raw['lng'] as num?)?.toDouble();
      if (la != null && ln != null) {
        lat = la;
        lng = ln;
      }
    }

    if (addressString == null &&
        addressMap == null &&
        (lat == null || lng == null)) {
      return null;
    }

    final now = FieldValue.serverTimestamp();
    return <String, dynamic>{
      if (addressString != null) 'addressString': addressString,
      if (addressMap != null) 'addressMap': addressMap,
      if (lat != null && lng != null) 'location': GeoPoint(lat!, lng!),
      'updatedAt': now,
    };
  }

  Future<void> _saveMapPick(Map<String, dynamic> res) async {
    final payload = _normalizeMapPick(res);
    if (payload == null) return;

    payload.putIfAbsent('type', () => 'other');
    payload.putIfAbsent('label', () => _prettyType('other'));

    final s = payload['addressString'] as String?;
    if (s != null && s.isNotEmpty) payload['address'] = s;

    await _col.add(payload);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Address saved from map')),
      );
    }
  }

  Future<void> _confirmDelete(BuildContext context, String docId) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete address?'),
        content:
            const Text('This address will be removed from your saved list.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Delete')),
        ],
      ),
    );
    if (ok == true) {
      await _col.doc(docId).delete();
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Address deleted')));
    }
  }

  // ---------- Display address resolver ----------
  String _displayAddress(Map<String, dynamic> d) {
    final s1 = (d['addressString'] as String?)?.trim();
    if (s1 != null && s1.isNotEmpty) return s1;

    final s2 = (d['address'] as String?)?.trim();
    if (s2 != null && s2.isNotEmpty) return s2;

    final addrMap = d['addressMap'];
    if (addrMap is Map<String, dynamic>) {
      final parts = <String>[
        (addrMap['formatted'] as String?)?.trim() ?? '',
        (addrMap['locality'] as String?)?.trim() ?? '',
        (addrMap['subDistrict'] as String?)?.trim() ?? '',
        (addrMap['district'] as String?)?.trim() ?? '',
        (addrMap['state'] as String?)?.trim() ?? '',
        (addrMap['postalCode'] as String?)?.trim() ?? '',
      ].where((e) => e.isNotEmpty).toList();
      if (parts.isNotEmpty) return parts.join(', ');
    }

    final parts = <String>[
      (d['area'] as String?)?.trim() ?? '',
      (d['district'] as String?)?.trim() ?? '',
      (d['state'] as String?)?.trim() ?? '',
      (d['postalCode'] as String?)?.trim() ?? '',
    ].where((e) => e.isNotEmpty).toList();

    return parts.isNotEmpty ? parts.join(', ') : '—';
  }

  String _prettyType(String t) {
    switch (t) {
      case 'home':
        return 'Home';
      case 'work':
        return 'Work';
      default:
        return 'Other';
    }
  }
}

/// Empty state
class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onAdd, required this.w});
  final VoidCallback onAdd;
  final double w;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: w * .08),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.location_off_outlined,
                size: w * .18, color: Colors.black38),
            SizedBox(height: w * .03),
            Text('No saved addresses',
                style:
                    TextStyle(fontSize: w * .045, fontWeight: FontWeight.w700)),
            SizedBox(height: w * .015),
            Text(
              'Add your frequently used locations to pick them quickly while booking.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: w * .035, color: Colors.black54),
            ),
            SizedBox(height: w * .04),
            SizedBox(
              height: w * .12,
              child: OutlinedButton.icon(
                onPressed: onAdd,
                icon: Icon(Icons.add_location_alt_outlined, size: w * .06),
                label: Text('Add via map', style: TextStyle(fontSize: w * .04)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Address tile – uses emojis instead of Material icons
class _AddressCard extends StatelessWidget {
  const _AddressCard({
    required this.w,
    required this.type,
    required this.label,
    required this.address,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  final double w;
  final String type;
  final String label;
  final String address;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  String get _emoji {
    switch (type) {
      case 'home':
        return '🏠';
      case 'work':
        return '🏢';
      default:
        return '📍';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      shadowColor: Colors.black12,
      borderRadius: BorderRadius.circular(w * .04),
      color: Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(w * .04),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.fromLTRB(w * .035, w * .03, w * .02, w * .03),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: w * .06,
                backgroundColor: Colors.grey.shade100,
                child: Text(_emoji, style: TextStyle(fontSize: w * .045)),
              ),
              SizedBox(width: w * .03),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label,
                        style: TextStyle(
                            fontSize: w * .042, fontWeight: FontWeight.w700)),
                    SizedBox(height: w * .01),
                    Text(
                      address,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.grey.shade700, fontSize: w * .035),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (v) {
                  if (v == 'edit') onEdit?.call();
                  if (v == 'delete') onDelete?.call();
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'edit', child: Text('Edit')),
                  PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
                icon: Icon(Icons.more_vert, size: w * .06),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
