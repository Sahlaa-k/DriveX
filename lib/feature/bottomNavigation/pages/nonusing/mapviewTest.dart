// // lib/mapview_test.dart
// import 'dart:convert';
// import 'dart:math' show sin, cos, sqrt, atan2, pi;

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// // Places autocomplete (no UI from Google SDK; this package shows a nice overlay)
// import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart'
//     as places;
// import 'package:flutter_google_places_hoc081098/google_maps_webservice_places.dart'
//     as gmws;
// import 'package:google_api_headers/google_api_headers.dart';

// // Simple HTTP for OSRM route
// import 'package:http/http.dart' as http;

// const String googleApiKey =
//     "YOUR_GOOGLE_PLACES_API_KEY"; // <-- replace with your key (you already have one in your project)

// class Mapviewtest extends StatefulWidget {
//   const Mapviewtest({super.key});

//   @override
//   State<Mapviewtest> createState() => _MapviewtestState();
// }

// class _MapviewtestState extends State<Mapviewtest> {
//   final TextEditingController _fromC = TextEditingController();
//   final TextEditingController _toC = TextEditingController();

//   GoogleMapController? _map;
//   final Set<Marker> _markers = {};
//   final Set<Polyline> _polylines = {};

//   LatLng? _from;
//   LatLng? _to;

//   // Toggle: use OSRM (online, no key) for real driving route. If false, draws a straight line.
//   bool useOsrmRouting = true;

//   // Initial camera (Kerala region as a neutral default)
//   static const CameraPosition _initialCam = CameraPosition(
//     target: LatLng(10.9770, 76.2250),
//     zoom: 10.5,
//   );

//   @override
//   void dispose() {
//     _fromC.dispose();
//     _toC.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.sizeOf(context).width;

//     return Scaffold(
//       body: Stack(
//         children: [
//           GoogleMap(
//             initialCameraPosition: _initialCam,
//             myLocationButtonEnabled: true,
//             myLocationEnabled: true,
//             zoomControlsEnabled: false,
//             markers: _markers,
//             polylines: _polylines,
//             onMapCreated: (c) => _map = c,
//           ),

//           // Top search fields
//           SafeArea(
//             child: Container(
//               margin:
//                   EdgeInsets.fromLTRB(width * .04, width * .04, width * .04, 0),
//               padding: EdgeInsets.all(width * .03),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(16),
//                 boxShadow: const [
//                   BoxShadow(
//                       blurRadius: 12,
//                       color: Colors.black12,
//                       offset: Offset(0, 6))
//                 ],
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   _buildSearchField(
//                     context: context,
//                     controller: _fromC,
//                     hint: "Pickup",
//                     icon: Icons.my_location,
//                     isPickup: true,
//                   ),
//                   const SizedBox(height: 8),
//                   _buildSearchField(
//                     context: context,
//                     controller: _toC,
//                     hint: "Drop",
//                     icon: Icons.location_on_outlined,
//                     isPickup: false,
//                   ),

//                   // Small options row
//                   Row(
//                     children: [
//                       const SizedBox(width: 4),
//                       CupertinoSwitch(
//                         value: useOsrmRouting,
//                         onChanged: (v) => setState(() => useOsrmRouting = v),
//                         activeColor: Colors.green,
//                       ),
//                       const SizedBox(width: 8),
//                       Text(
//                         "Use OSRM route (no key). Fallback = straight line",
//                         style: TextStyle(fontSize: 12, color: Colors.black87),
//                       ),
//                       const Spacer(),
//                       IconButton(
//                         tooltip: "Swap",
//                         onPressed: _swapPoints,
//                         icon: const Icon(Icons.swap_vert),
//                       ),
//                       IconButton(
//                         tooltip: "Clear",
//                         onPressed: _clearAll,
//                         icon: const Icon(Icons.clear),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSearchField({
//     required BuildContext context,
//     required TextEditingController controller,
//     required String hint,
//     required IconData icon,
//     required bool isPickup,
//   }) {
//     return GestureDetector(
//       onTap: () async {
//         FocusScope.of(context).unfocus();

//         final Prediction? p = await places.PlacesAutocomplete.show(
//           context: context,
//           apiKey: googleApiKey,
//           mode: places.Mode.overlay,
//           language: 'en',
//           components: [], // add country filters if you want: [Component(Component.country, "in")]
//           hint: hint,
//         );

//         if (p == null) return;

//         final placeId = p.placeId;
//         if (placeId == null) return;

//         // Fetch place details to get lat/lng
//         final headers = await const GoogleApiHeaders().getHeaders();
//         final gmws.GoogleMapsPlaces _places =
//             gmws.GoogleMapsPlaces(apiKey: googleApiKey, apiHeaders: headers);

//         final details = await _places.getDetailsByPlaceId(placeId);
//         if (details.status != 'OK' || details.result.geometry == null) return;

//         final loc = details.result.geometry!.location;
//         final latLng = LatLng(loc.lat, loc.lng);

//         setState(() {
//           controller.text = details.result.name ?? hint;
//           if (isPickup) {
//             _from = latLng;
//           } else {
//             _to = latLng;
//           }
//           _refreshMarkers();
//         });

//         // If both selected, draw the route
//         if (_from != null && _to != null) {
//           await _drawRoute(_from!, _to!);
//           await _fitToBounds(_from!, _to!);
//         }
//       },
//       child: Container(
//         height: 48,
//         padding: const EdgeInsets.symmetric(horizontal: 12),
//         decoration: BoxDecoration(
//           color: const Color(0xfff4f5f6),
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: Colors.black12),
//         ),
//         alignment: Alignment.centerLeft,
//         child: Row(
//           children: [
//             Icon(icon,
//                 size: 20, color: isPickup ? Colors.green : Colors.redAccent),
//             const SizedBox(width: 10),
//             Expanded(
//               child: Text(
//                 controller.text.isEmpty ? hint : controller.text,
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//                 style: TextStyle(
//                   color:
//                       controller.text.isEmpty ? Colors.black45 : Colors.black87,
//                   fontSize: 14,
//                 ),
//               ),
//             ),
//             const Icon(Icons.search, size: 18, color: Colors.black45),
//           ],
//         ),
//       ),
//     );
//   }

//   void _refreshMarkers() {
//     _markers.clear();
//     if (_from != null) {
//       _markers.add(
//         Marker(
//           markerId: const MarkerId('from'),
//           position: _from!,
//           icon:
//               BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
//           infoWindow: const InfoWindow(title: "Pickup"),
//         ),
//       );
//     }
//     if (_to != null) {
//       _markers.add(
//         Marker(
//           markerId: const MarkerId('to'),
//           position: _to!,
//           icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
//           infoWindow: const InfoWindow(title: "Drop"),
//         ),
//       );
//     }
//     setState(() {});
//   }

//   Future<void> _fitToBounds(LatLng a, LatLng b) async {
//     if (_map == null) return;
//     final sw = LatLng(
//       (a.latitude <= b.latitude) ? a.latitude : b.latitude,
//       (a.longitude <= b.longitude) ? a.longitude : b.longitude,
//     );
//     final ne = LatLng(
//       (a.latitude >= b.latitude) ? a.latitude : b.latitude,
//       (a.longitude >= b.longitude) ? a.longitude : b.longitude,
//     );
//     final bounds = LatLngBounds(southwest: sw, northeast: ne);

//     await _map!.animateCamera(
//       CameraUpdate.newLatLngBounds(bounds, 60),
//     );
//   }

//   Future<void> _drawRoute(LatLng from, LatLng to) async {
//     _polylines.clear();

//     // Try OSRM (real driving path, no API key)
//     if (useOsrmRouting) {
//       try {
//         final line = await _fetchOsrmPolyline(from, to);
//         if (line.isNotEmpty) {
//           _polylines.add(
//             Polyline(
//               polylineId: const PolylineId('route'),
//               width: 6,
//               points: line,
//             ),
//           );
//           setState(() {});
//           return; // success
//         }
//       } catch (_) {
//         // fall through to straight line
//       }
//     }

//     // Fallback: straight line (works offline)
//     _polylines.add(
//       Polyline(
//         polylineId: const PolylineId('straight'),
//         width: 5,
//         points: [from, to],
//         patterns: [PatternItem.dash(20), PatternItem.gap(10)],
//       ),
//     );
//     setState(() {});
//   }

//   Future<List<LatLng>> _fetchOsrmPolyline(LatLng from, LatLng to) async {
//     final url =
//         'https://router.project-osrm.org/route/v1/driving/${from.longitude},${from.latitude};${to.longitude},${to.latitude}?overview=full&geometries=geojson';
//     final res = await http.get(Uri.parse(url));
//     if (res.statusCode != 200) return [];

//     final data = json.decode(res.body) as Map<String, dynamic>;
//     if (data['routes'] == null || (data['routes'] as List).isEmpty) return [];

//     final coords = (data['routes'][0]['geometry']['coordinates'] as List)
//         .cast<List>()
//         .map<LatLng>(
//             (c) => LatLng((c[1] as num).toDouble(), (c[0] as num).toDouble()))
//         .toList();

//     return coords;
//   }

//   void _swapPoints() async {
//     if (_from == null && _to == null) return;
//     final tmp = _from;
//     _from = _to;
//     _to = tmp;
//     final tmpText = _fromC.text;
//     _fromC.text = _toC.text;
//     _toC.text = tmpText;
//     _refreshMarkers();
//     if (_from != null && _to != null) {
//       await _drawRoute(_from!, _to!);
//       await _fitToBounds(_from!, _to!);
//     }
//   }

//   void _clearAll() {
//     _from = null;
//     _to = null;
//     _fromC.clear();
//     _toC.clear();
//     _markers.clear();
//     _polylines.clear();
//     setState(() {});
//   }

//   // (Optional) You can use this if you need straight-line distance somewhere.
//   double _haversineKm(LatLng a, LatLng b) {
//     const R = 6371.0;
//     final dLat = _deg2rad(b.latitude - a.latitude);
//     final dLon = _deg2rad(b.longitude - a.longitude);
//     final aa = sin(dLat / 2) * sin(dLat / 2) +
//         cos(_deg2rad(a.latitude)) *
//             cos(_deg2rad(b.latitude)) *
//             sin(dLon / 2) *
//             sin(dLon / 2);
//     final c = 2 * atan2(sqrt(aa), sqrt(1 - aa));
//     return R * c;
//   }

//   double _deg2rad(double d) => d * (pi / 180.0);
// }

// typedef Prediction = gmws.Prediction;

///////////////////////////////////////////////////////////////

// import 'dart:convert';
// import 'dart:math' show sin, cos, sqrt, atan2, pi;

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:http/http.dart' as http;

// class Mapviewtest extends StatefulWidget {
//   const Mapviewtest({super.key});

//   @override
//   State<Mapviewtest> createState() => _MapviewtestState();
// }

// class _MapviewtestState extends State<Mapviewtest> {
//   GoogleMapController? _map;
//   final Set<Marker> _markers = {};
//   final Set<Polyline> _polylines = {};

//   // Your two fixed points
//   static const LatLng _pointA = LatLng(10.97592, 76.22568);
//   static const LatLng _pointB = LatLng(11.05105, 76.07109);

//   // Toggle: use OSRM (online, free) for real driving route
//   bool useOsrmRouting = true;

//   // Start near midpoint so the first frame isn't empty
//   static const CameraPosition _initialCam = CameraPosition(
//     target: LatLng(11.0135, 76.1484), // midpoint approx
//     zoom: 10.5,
//   );

//   @override
//   void initState() {
//     super.initState();
//     // After first frame, set markers, draw route, and fit bounds.
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       _setFixedMarkers();
//       await _drawRoute(_pointA, _pointB);
//       await _fitToBounds(_pointA, _pointB);
//       setState(() {}); // refresh once done
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.sizeOf(context).width;

//     return Scaffold(
//       body: Stack(
//         children: [
//           GoogleMap(
//             initialCameraPosition: _initialCam,
//             myLocationButtonEnabled: true,
//             myLocationEnabled: false,
//             zoomControlsEnabled: false,
//             markers: _markers,
//             polylines: _polylines,
//             onMapCreated: (c) => _map = c,
//           ),

//           // Small header showing the two points + switches
//           SafeArea(
//             child: Container(
//               margin:
//                   EdgeInsets.fromLTRB(width * .04, width * .04, width * .04, 0),
//               padding: EdgeInsets.all(width * .03),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(16),
//                 boxShadow: const [
//                   BoxShadow(
//                       blurRadius: 12,
//                       color: Colors.black12,
//                       offset: Offset(0, 6))
//                 ],
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   _pill("A: 10.97592, 76.22568",
//                       leading: Icons.my_location, color: Colors.green),
//                   const SizedBox(height: 8),
//                   _pill("B: 11.05105, 76.07109",
//                       leading: Icons.location_on_outlined,
//                       color: Colors.redAccent),
//                   const SizedBox(height: 8),
//                   Row(
//                     children: [
//                       CupertinoSwitch(
//                         value: useOsrmRouting,
//                         onChanged: (v) async {
//                           setState(() => useOsrmRouting = v);
//                           await _drawRoute(_pointA, _pointB);
//                           await _fitToBounds(_pointA, _pointB);
//                         },
//                         activeColor: Colors.green,
//                       ),
//                       const SizedBox(width: 8),
//                       const Expanded(
//                         child: Text(
//                           "Use OSRM (real road route). Fallback = straight line",
//                           style: TextStyle(fontSize: 12),
//                         ),
//                       ),
//                       IconButton(
//                         tooltip: "Recenter",
//                         onPressed: () => _fitToBounds(_pointA, _pointB),
//                         icon: const Icon(Icons.center_focus_strong),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _pill(String text, {required IconData leading, required Color color}) {
//     return Container(
//       height: 44,
//       padding: const EdgeInsets.symmetric(horizontal: 12),
//       decoration: BoxDecoration(
//         color: const Color(0xfff4f5f6),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.black12),
//       ),
//       child: Row(
//         children: [
//           Icon(leading, size: 18, color: color),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Text(
//               text,
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//               style: const TextStyle(fontSize: 14),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _setFixedMarkers() {
//     _markers
//       ..clear()
//       ..add(
//         const Marker(
//           markerId: MarkerId('A'),
//           position: _pointA,
//           infoWindow: InfoWindow(title: "Point A"),
//           // icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
//         ),
//       )
//       ..add(
//         const Marker(
//           markerId: MarkerId('B'),
//           position: _pointB,
//           infoWindow: InfoWindow(title: "Point B"),
//           // icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
//         ),
//       );
//   }

//   Future<void> _drawRoute(LatLng from, LatLng to) async {
//     _polylines.clear();

//     // Try OSRM for driving route
//     if (useOsrmRouting) {
//       try {
//         final points = await _fetchOsrmPolyline(from, to);
//         if (points.isNotEmpty) {
//           _polylines.add(
//             Polyline(
//               polylineId: const PolylineId('route'),
//               width: 6,
//               points: points,
//             ),
//           );
//           setState(() {});
//           return;
//         }
//       } catch (_) {/* ignore and fallback */}
//     }

//     // Fallback: straight line
//     _polylines.add(
//       Polyline(
//         polylineId: const PolylineId('straight'),
//         width: 5,
//         points: [from, to],
//         patterns: [PatternItem.dash(20), PatternItem.gap(10)],
//       ),
//     );
//     setState(() {});
//   }

//   Future<List<LatLng>> _fetchOsrmPolyline(LatLng from, LatLng to) async {
//     final url =
//         'https://router.project-osrm.org/route/v1/driving/${from.longitude},${from.latitude};'
//         '${to.longitude},${to.latitude}?overview=full&geometries=geojson';
//     final res = await http.get(Uri.parse(url));
//     if (res.statusCode != 200) return [];

//     final data = json.decode(res.body) as Map<String, dynamic>;
//     final routes = data['routes'] as List?;
//     if (routes == null || routes.isEmpty) return [];

//     final coords = (routes[0]['geometry']['coordinates'] as List)
//         .cast<List>()
//         .map<LatLng>(
//             (c) => LatLng((c[1] as num).toDouble(), (c[0] as num).toDouble()))
//         .toList();
//     return coords;
//   }

//   Future<void> _fitToBounds(LatLng a, LatLng b) async {
//     if (_map == null) return;
//     final sw = LatLng(
//       (a.latitude <= b.latitude) ? a.latitude : b.latitude,
//       (a.longitude <= b.longitude) ? a.longitude : b.longitude,
//     );
//     final ne = LatLng(
//       (a.latitude >= b.latitude) ? a.latitude : b.latitude,
//       (a.longitude >= b.longitude) ? a.longitude : b.longitude,
//     );
//     final bounds = LatLngBounds(southwest: sw, northeast: ne);
//     await _map!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 60));
//   }

//   // Optional: straight-line distance if you want to display it somewhere
//   double _haversineKm(LatLng a, LatLng b) {
//     const R = 6371.0;
//     final dLat = _deg2rad(b.latitude - a.latitude);
//     final dLon = _deg2rad(b.longitude - a.longitude);
//     final aa = sin(dLat / 2) * sin(dLat / 2) +
//         cos(_deg2rad(a.latitude)) *
//             cos(_deg2rad(b.latitude)) *
//             sin(dLon / 2) *
//             sin(dLon / 2);
//     final c = 2 * atan2(sqrt(aa), sqrt(1 - aa));
//     return R * c;
//   }

//   double _deg2rad(double d) => d * (pi / 180.0);
// }

/////////////////////////////////////////

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:http/http.dart' as http;

// class Mapviewtest extends StatefulWidget {
//   const Mapviewtest({super.key});

//   @override
//   State<Mapviewtest> createState() => _MapviewtestState();
// }

// class _MapviewtestState extends State<Mapviewtest> {
//   GoogleMapController? _map;
//   final Set<Marker> _markers = {};
//   final Set<Polyline> _polylines = {};

//   // Fixed points
//   static const LatLng _pointA = LatLng(10.97592, 76.22568);
//   static const LatLng _pointB = LatLng(11.05105, 76.07109);

//   // Start near midpoint so the first frame has something sensible
//   static const CameraPosition _initialCam = CameraPosition(
//     target: LatLng(11.0135, 76.1484), // midpoint approx
//     zoom: 10.5,
//   );

//   // Route info (from OSRM)
//   double? _distanceKm; // e.g., 24.3
//   int? _etaMin; // e.g., 42

//   @override
//   void initState() {
//     super.initState();
//     _setMarkers();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final w = MediaQuery.sizeOf(context).width;

//     return Scaffold(
//       body: Stack(
//         children: [
//           GoogleMap(
//             initialCameraPosition: _initialCam,
//             myLocationEnabled: false,
//             myLocationButtonEnabled: true,
//             zoomControlsEnabled: false,
//             markers: _markers,
//             polylines: _polylines,
//             onMapCreated: (c) async {
//               _map = c;
//               // Draw the real route and fit bounds as soon as the map is ready.
//               await Future.delayed(const Duration(milliseconds: 180));
//               await _drawRealRoute(_pointA, _pointB);
//             },
//           ),

//           // Header with two points + distance/ETA
//           SafeArea(
//             child: Container(
//               margin: EdgeInsets.fromLTRB(w * .04, w * .04, w * .04, 0),
//               padding: EdgeInsets.all(w * .03),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(16),
//                 boxShadow: const [
//                   BoxShadow(
//                       blurRadius: 12,
//                       color: Colors.black12,
//                       offset: Offset(0, 6))
//                 ],
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   _pill("A: 10.97592, 76.22568",
//                       icon: Icons.my_location, color: Colors.green),
//                   const SizedBox(height: 8),
//                   _pill("B: 11.05105, 76.07109",
//                       icon: Icons.location_on_outlined,
//                       color: Colors.redAccent),
//                   const SizedBox(height: 8),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Container(
//                           height: 38,
//                           alignment: Alignment.center,
//                           decoration: BoxDecoration(
//                             color: const Color(0xfff4f5f6),
//                             borderRadius: BorderRadius.circular(10),
//                             border: Border.all(color: Colors.black12),
//                           ),
//                           child: Text(
//                             _distanceKm == null
//                                 ? "Fetching route…"
//                                 : "Distance: ${_distanceKm!.toStringAsFixed(2)} km • ETA: ${_etaMin} min",
//                             style: const TextStyle(fontSize: 13),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       IconButton(
//                         tooltip: "Recenter",
//                         onPressed: () => _fitToBounds(_pointA, _pointB),
//                         icon: const Icon(Icons.center_focus_strong),
//                       ),
//                       IconButton(
//                         tooltip: "Redraw",
//                         onPressed: () => _drawRealRoute(_pointA, _pointB),
//                         icon: const Icon(Icons.refresh),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _pill(String text, {required IconData icon, required Color color}) {
//     return Container(
//       height: 44,
//       padding: const EdgeInsets.symmetric(horizontal: 12),
//       decoration: BoxDecoration(
//         color: const Color(0xfff4f5f6),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.black12),
//       ),
//       child: Row(
//         children: [
//           Icon(icon, size: 18, color: color),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Text(text,
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//                 style: const TextStyle(fontSize: 14)),
//           ),
//         ],
//       ),
//     );
//   }

//   void _setMarkers() {
//     _markers
//       ..clear()
//       ..add(const Marker(
//         markerId: MarkerId('A'),
//         position: _pointA,
//         infoWindow: InfoWindow(title: "Point A"),
//       ))
//       ..add(const Marker(
//         markerId: MarkerId('B'),
//         position: _pointB,
//         infoWindow: InfoWindow(title: "Point B"),
//       ));
//     setState(() {});
//   }

//   Future<void> _drawRealRoute(LatLng from, LatLng to) async {
//     // Hit OSRM and render only if a real route is returned
//     final route = await _fetchOsrmRoute(from, to);
//     if (route == null || route.points.isEmpty) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//               content: Text("Couldn’t fetch a driving route right now.")),
//         );
//       }
//       return;
//     }

//     _polylines
//       ..clear()
//       ..add(Polyline(
//         polylineId: const PolylineId('osrm_route'),
//         width: 6,
//         points: route.points,
//       ));

//     setState(() {
//       _distanceKm = route.distanceKm;
//       _etaMin = route.durationMin;
//     });

//     await _fitToBounds(from, to);
//   }

//   Future<void> _fitToBounds(LatLng a, LatLng b) async {
//     if (_map == null) return;

//     final sw = LatLng(
//       (a.latitude <= b.latitude) ? a.latitude : b.latitude,
//       (a.longitude <= b.longitude) ? a.longitude : b.longitude,
//     );
//     final ne = LatLng(
//       (a.latitude >= b.latitude) ? a.latitude : b.latitude,
//       (a.longitude >= b.longitude) ? a.longitude : b.longitude,
//     );
//     final bounds = LatLngBounds(southwest: sw, northeast: ne);

//     // A short delay helps avoid “map size is zero” on some devices.
//     await Future.delayed(const Duration(milliseconds: 60));
//     try {
//       await _map!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 60));
//     } catch (_) {
//       // Retry once
//       await Future.delayed(const Duration(milliseconds: 120));
//       if (mounted) {
//         try {
//           await _map!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 60));
//         } catch (_) {}
//       }
//     }
//   }

//   Future<_RouteData?> _fetchOsrmRoute(LatLng from, LatLng to) async {
//     final url =
//         'https://router.project-osrm.org/route/v1/driving/${from.longitude},${from.latitude};'
//         '${to.longitude},${to.latitude}?overview=full&geometries=geojson';
//     try {
//       final res = await http.get(Uri.parse(url));
//       if (res.statusCode != 200) return null;

//       final map = json.decode(res.body) as Map<String, dynamic>;
//       final routes = map['routes'] as List?;
//       if (routes == null || routes.isEmpty) return null;

//       final r0 = routes[0] as Map<String, dynamic>;
//       final distanceMeters =
//           (r0['distance'] as num?)?.toDouble() ?? 0.0; // meters
//       final durationSeconds =
//           (r0['duration'] as num?)?.toDouble() ?? 0.0; // seconds
//       final coords = (r0['geometry']['coordinates'] as List)
//           .cast<List>()
//           .map<LatLng>(
//               (c) => LatLng((c[1] as num).toDouble(), (c[0] as num).toDouble()))
//           .toList();

//       return _RouteData(
//         points: coords,
//         distanceKm: distanceMeters / 1000.0,
//         durationMin: (durationSeconds / 60.0).round(),
//       );
//     } catch (_) {
//       return null;
//     }
//   }
// }

// class _RouteData {
//   final List<LatLng> points;
//   final double distanceKm;
//   final int durationMin;
//   _RouteData({
//     required this.points,
//     required this.distanceKm,
//     required this.durationMin,
//   });
// }

// -------------------------------------------------------------

import 'dart:convert';
import 'dart:math' show sin, cos, sqrt, atan2, pi;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

class OsmRouteDemo extends StatefulWidget {
  const OsmRouteDemo({super.key});

  @override
  State<OsmRouteDemo> createState() => _OsmRouteDemoState();
}

class _OsmRouteDemoState extends State<OsmRouteDemo> {
  final MapController _map = MapController();

  // Two fixed points (Kerala area, like your example)
  static const LatLng _pointA = LatLng(10.97592, 76.22568);
  static const LatLng _pointB = LatLng(11.05105, 76.07109);

  bool useOsrmRouting = true;

  // Route geometry
  List<LatLng> _route = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _drawRoute(_pointA, _pointB);
      _fitToBounds(_pointA, _pointB);
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _map,
            options: MapOptions(
              initialCenter: LatLng(11.0135, 76.1484), // midpoint-ish
              initialZoom: 10.5,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.pinchZoom |
                    InteractiveFlag.drag |
                    InteractiveFlag.doubleTapZoom,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: ['a', 'b', 'c'],
                userAgentPackageName: 'com.example.app',
              ),
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: _route,
                    strokeWidth: 5,
                    // (no explicit color per your preference; default theming)
                  ),
                ],
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _pointA,
                    width: 36,
                    height: 36,
                    child: const _Dot(color: Colors.green, label: 'A'),
                  ),
                  Marker(
                    point: _pointB,
                    width: 36,
                    height: 36,
                    child: const _Dot(color: Colors.redAccent, label: 'B'),
                  ),
                ],
              ),
            ],
          ),

          // Header card
          SafeArea(
            child: Container(
              margin:
                  EdgeInsets.fromLTRB(width * .04, width * .04, width * .04, 0),
              padding: EdgeInsets.all(width * .03),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 12,
                    color: Colors.black12,
                    offset: Offset(0, 6),
                  )
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _pill("A: 10.97592, 76.22568",
                      leading: Icons.my_location, color: Colors.green),
                  const SizedBox(height: 8),
                  _pill("B: 11.05105, 76.07109",
                      leading: Icons.location_on_outlined,
                      color: Colors.redAccent),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      CupertinoSwitch(
                        value: useOsrmRouting,
                        onChanged: (v) async {
                          setState(() => useOsrmRouting = v);
                          await _drawRoute(_pointA, _pointB);
                          _fitToBounds(_pointA, _pointB);
                        },
                        activeColor: Colors.green,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _loading
                              ? "Loading route…"
                              : useOsrmRouting
                                  ? "OSRM driving route"
                                  : "Straight line (fallback)",
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      IconButton(
                        tooltip: "Recenter",
                        onPressed: () => _fitToBounds(_pointA, _pointB),
                        icon: const Icon(Icons.center_focus_strong),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Straight-line distance: ${_haversineKm(_pointA, _pointB).toStringAsFixed(2)} km",
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pill(String text, {required IconData leading, required Color color}) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xfff4f5f6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        children: [
          Icon(leading, size: 18, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _drawRoute(LatLng from, LatLng to) async {
    setState(() => _loading = true);

    // Try OSRM for road route
    if (useOsrmRouting) {
      try {
        final points = await _fetchOsrmPolyline(from, to);
        if (points.isNotEmpty) {
          setState(() {
            _route = points;
            _loading = false;
          });
          return;
        }
      } catch (_) {
        // ignore and fall through
      }
    }

    // Fallback to straight line
    setState(() {
      _route = [from, to];
      _loading = false;
    });
  }

  Future<List<LatLng>> _fetchOsrmPolyline(LatLng from, LatLng to) async {
    final url =
        'https://router.project-osrm.org/route/v1/driving/${from.longitude},${from.latitude};'
        '${to.longitude},${to.latitude}?overview=full&geometries=geojson';
    final res = await http.get(Uri.parse(url));
    if (res.statusCode != 200) return [];

    final data = json.decode(res.body) as Map<String, dynamic>;
    final routes = data['routes'] as List?;
    if (routes == null || routes.isEmpty) return [];

    final coords = (routes[0]['geometry']['coordinates'] as List)
        .cast<List>()
        .map<LatLng>(
          (c) => LatLng(
            (c[1] as num).toDouble(),
            (c[0] as num).toDouble(),
          ),
        )
        .toList();
    return coords;
  }

  void _fitToBounds(LatLng a, LatLng b) {
    final sw = LatLng(
      (a.latitude <= b.latitude) ? a.latitude : b.latitude,
      (a.longitude <= b.longitude) ? a.longitude : b.longitude,
    );
    final ne = LatLng(
      (a.latitude >= b.latitude) ? a.latitude : b.latitude,
      (a.longitude >= b.longitude) ? a.longitude : b.longitude,
    );
    final bounds = LatLngBounds(sw, ne);

    _map.fitCamera(
      CameraFit.bounds(
        bounds: bounds,
        padding: const EdgeInsets.all(60),
      ),
    );
  }

  // Haversine straight-line distance (km)
  double _haversineKm(LatLng a, LatLng b) {
    const R = 6371.0;
    final dLat = _deg2rad(b.latitude - a.latitude);
    final dLon = _deg2rad(b.longitude - a.longitude);
    final aa = sin(dLat / 2) * sin(dLat / 2) +
        cos(_deg2rad(a.latitude)) *
            cos(_deg2rad(b.latitude)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final c = 2 * atan2(sqrt(aa), sqrt(1 - aa));
    return R * c;
  }

  double _deg2rad(double d) => d * (pi / 180.0);
}

class _Dot extends StatelessWidget {
  const _Dot({required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Icon(Icons.place, color: color, size: 34),
        Positioned(
          top: 6,
          child: Text(label,
              style:
                  const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
