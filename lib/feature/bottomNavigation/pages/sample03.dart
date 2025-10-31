// // lib/location_picker_page.dart
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_google_places_hoc081098/google_maps_webservice_places.dart'
//     as g_places show GoogleMapsPlaces, Component, Location;
// import 'package:flutter_google_places_hoc081098/google_maps_webservice_places.dart';
// import 'package:flutter_google_places_hoc081098/google_maps_webservice_places.dart'
//     as g_places;
// import 'package:flutter_polyline_points/flutter_polyline_points.dart' as g_dir;
// import 'package:geocoding/geocoding.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';

// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:location/location.dart' show Location;
// // import 'package:google_maps_webservice/directions.dart' as g_dir;
// import 'package:uuid/uuid.dart';

// const String kGoogleApiKey =
//     "AIzaSyDwD1BJXVxky_Cy6xzyQh_5A2PW9cTOO0I"; // <-- put your key

// class LocationPickerPage extends StatefulWidget {
//   const LocationPickerPage({super.key});

//   @override
//   State<LocationPickerPage> createState() => _LocationPickerPageState();
// }

// class _LocationPickerPageState extends State<LocationPickerPage> {
//   final Completer<GoogleMapController> _mapController = Completer();
//   final TextEditingController _pickupCtrl = TextEditingController();
//   final TextEditingController _dropCtrl = TextEditingController();

//   // Places & Directions clients
//   final g_places.GoogleMapsPlaces _places =
//       g_places.GoogleMapsPlaces(apiKey: kGoogleApiKey);
//   final g_dir.PolylinePoints _directions = g_dir.PolylinePoints();

//   // State
//   LatLng? _pickupLatLng;
//   LatLng? _dropLatLng;
//   final Set<Marker> _markers = {};
//   final Set<Polyline> _polylines = {};

//   // Initial camera (India center-ish)
//   static const CameraPosition _kInitialCamera = CameraPosition(
//     target: LatLng(22.3511148, 78.6677428),
//     zoom: 4.8,
//   );

//   @override
//   void dispose() {
//     _pickupCtrl.dispose();
//     _dropCtrl.dispose();
//     super.dispose();
//   }

//   // ====== ON TAP HANDLERS ======

//   Future<void> _onTapPickup() async {
//     final sessionToken = const Uuid().v4(); // cheaper billing with token
//     final p = await PlacesAutocomplete.show(
//       context: context,
//       apiKey: kGoogleApiKey,
//       mode: Mode.overlay,
//       sessionToken: sessionToken,
//       components: [
//         g_places.Component(g_places.Component.country, "in")
//       ], // limit if you want
//       hint: "Search pickup location",
//       radius: 30000,
//     );

//     if (p == null) return;

//     // Fetch place details
//     final details = await _places.getDetailsByPlaceId(p.placeId!,
//         sessionToken: sessionToken);
//     final loc = details.result.geometry?.location;
//     if (loc == null) return;

//     final latLng = LatLng(loc.lat, loc.lng);
//     setState(() {
//       _pickupLatLng = latLng;
//       _pickupCtrl.text = details.result.name;
//       _addOrUpdateMarker("pickup", latLng, "Pickup");
//       _polylines.clear(); // clean any previous route if editing
//     });

//     _moveCamera(latLng, zoom: 15);

//     // If drop already chosen, draw route
//     if (_dropLatLng != null) {
//       await _drawRoute(_pickupLatLng!, _dropLatLng!);
//     }
//   }

//   Future<void> _onTapDrop() async {
//     final sessionToken = const Uuid().v4();
//     final p = await PlacesAutocomplete.show(
//       context: context,
//       apiKey: kGoogleApiKey,
//       mode: Mode.overlay,
//       sessionToken: sessionToken,
//       components: [Component(Component.country, "in")],
//       hint: "Search drop location",
//       radius: 30000,
//     );

//     if (p == null) return;

//     final details = await _places.getDetailsByPlaceId(p.placeId!,
//         sessionToken: sessionToken);
//     final loc = details.result.geometry?.location;
//     if (loc == null) return;

//     final latLng = LatLng(loc.lat, loc.lng);
//     setState(() {
//       _dropLatLng = latLng;
//       _dropCtrl.text = details.result.name;
//       _addOrUpdateMarker("drop", latLng, "Drop");
//     });

//     _moveCamera(latLng, zoom: 15);

//     // If pickup already chosen, draw route
//     if (_pickupLatLng != null) {
//       await _drawRoute(_pickupLatLng!, _dropLatLng!);
//     }
//   }

//   // ====== HELPERS ======

//   void _addOrUpdateMarker(String id, LatLng pos, String title) {
//     _markers.removeWhere((m) => m.markerId.value == id);
//     _markers.add(
//       Marker(
//         markerId: MarkerId(id),
//         position: pos,
//         infoWindow: InfoWindow(title: title),
//       ),
//     );
//   }

//   Future<void> _moveCamera(LatLng target, {double zoom = 14}) async {
//     final c = await _mapController.future;
//     await c.animateCamera(CameraUpdate.newCameraPosition(
//       CameraPosition(target: target, zoom: zoom),
//     ));
//   }

//   Future<void> _drawRoute(LatLng origin, LatLng dest) async {
//     // Clear previous polyline
//     setState(() {
//       _polylines.clear();
//     });

//     // Get directions
//     // final resp = await _directions.directionsWithLocation(
//     //   g_dir.Location(origin.latitude, origin.longitude),
//     //   g_dir.Location(dest.latitude, dest.longitude),
//     //   travelMode: g_dir.TravelMode.driving,
//     //   alternatives: false,
//     // );

//     // if (resp.isOkay && resp.routes.isNotEmpty) {
//     //   final encoded = resp.routes.first.overviewPolyline.points;
//     //   final points = PolylinePoints().decodePolyline(encoded);
//     //   final polyPoints = points
//     //       .map((p) => LatLng(p.latitude, p.longitude))
//     //       .toList(growable: false);

//     //   setState(() {
//     //     _polylines.add(
//     //       Polyline(
//     //         polylineId: const PolylineId("route"),
//     //         points: polyPoints,
//     //         width: 5,
//     //       ),
//     //     );
//     //   });

//     //   // Fit bounds
//     //   await _fitBoundsTo(origin, dest);
//     // }
//   }

//   Future<void> _fitBoundsTo(LatLng a, LatLng b) async {
//     final sw = LatLng(
//       (a.latitude <= b.latitude) ? a.latitude : b.latitude,
//       (a.longitude <= b.longitude) ? a.longitude : b.longitude,
//     );
//     final ne = LatLng(
//       (a.latitude >= b.latitude) ? a.latitude : b.latitude,
//       (a.longitude >= b.longitude) ? a.longitude : b.longitude,
//     );
//     final c = await _mapController.future;
//     await c.animateCamera(CameraUpdate.newLatLngBounds(
//       LatLngBounds(southwest: sw, northeast: ne),
//       60,
//     ));
//   }

//   Future<void> _useCurrentLocationAsPickup() async {
//     final hasPermission = await _ensureLocationPermission();
//     if (!hasPermission) return;

//     final pos = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.best,
//     );

//     final latLng = LatLng(pos.latitude, pos.longitude);
//     setState(() {
//       _pickupLatLng = latLng;
//       _pickupCtrl.text = "Current location";
//       _addOrUpdateMarker("pickup", latLng, "Pickup");
//       _polylines.clear();
//     });
//     _moveCamera(latLng, zoom: 16);

//     if (_dropLatLng != null) {
//       await _drawRoute(_pickupLatLng!, _dropLatLng!);
//     }
//   }

//   Future<bool> _ensureLocationPermission() async {
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       await Geolocator.openLocationSettings();
//       return false;
//     }
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//     }
//     if (permission == LocationPermission.deniedForever ||
//         permission == LocationPermission.denied) {
//       return false;
//     }
//     return true;
//   }

//   // ====== UI ======

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar:
//           AppBar(title: const Text("Pick Pickup & Drop (Drive + Delivery)")),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _pickupCtrl,
//                     readOnly: true,
//                     decoration: const InputDecoration(
//                       labelText: "Pickup",
//                       hintText: "Tap to select pickup",
//                       prefixIcon: Icon(Icons.location_on),
//                       border: OutlineInputBorder(),
//                     ),
//                     onTap: _onTapPickup, // <-- your onTap function
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 ElevatedButton(
//                   onPressed: _useCurrentLocationAsPickup,
//                   child: const Text("Use current"),
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.fromLTRB(12, 6, 12, 12),
//             child: TextField(
//               controller: _dropCtrl,
//               readOnly: true,
//               decoration: const InputDecoration(
//                 labelText: "Drop",
//                 hintText: "Tap to select drop",
//                 prefixIcon: Icon(Icons.flag),
//                 border: OutlineInputBorder(),
//               ),
//               onTap: _onTapDrop, // <-- your onTap function
//             ),
//           ),
//           Expanded(
//             child: GoogleMap(
//               initialCameraPosition: _kInitialCamera,
//               myLocationEnabled: true,
//               myLocationButtonEnabled: true,
//               markers: _markers,
//               polylines: _polylines,
//               onMapCreated: (c) => _mapController.complete(c),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
