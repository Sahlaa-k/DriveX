// import 'dart:math' show sin, cos, sqrt, atan2;
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// class D2dEstimatepage extends StatefulWidget {
//   const D2dEstimatepage({super.key});

//   @override
//   State<D2dEstimatepage> createState() => _D2dEstimatepageState();
// }

// class _D2dEstimatepageState extends State<D2dEstimatepage> {
//   late Map<String, dynamic> pickup; // {address, lat, lng}
//   late Map<String, dynamic> dropoff; // {address, lat, lng}
//   late List<Map<String, dynamic>> stops; // [{address, lat, lng}, ...]

//   double _totalKm = 0.0;

//   @override
//   void initState() {
//     super.initState();
//     // Load from arguments or use demo
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final args = ModalRoute.of(context)?.settings.arguments;
//       if (args is Map<String, dynamic>) {
//         pickup = (args["pickup"] as Map).cast<String, dynamic>();
//         dropoff = (args["dropoff"] as Map).cast<String, dynamic>();
//         stops = (args["stops"] as List?)
//                 ?.map((e) => (e as Map).cast<String, dynamic>())
//                 .toList() ??
//             [];
//       } else {
//         // Demo data (Perinthalmanna → Kozhikode with 2 stops)
//         pickup = {
//           "address": "Pickup • Perinthalmanna",
//           "lat": 10.9770,
//           "lng": 76.2254,
//         };
//         stops = [
//           {"address": "Stop 1 • Kuttippuram", "lat": 10.8333, "lng": 76.0333},
//           {"address": "Stop 2 • Ramanattukara", "lat": 11.1860, "lng": 75.9990},
//         ];
//         dropoff = {
//           "address": "Drop • Kozhikode",
//           "lat": 11.2588,
//           "lng": 75.7804,
//         };
//       }
//       setState(() {
//         _totalKm = _computeTotalKm();
//       });
//     });
//   }

//   double _deg2rad(double d) => d * (3.1415926535897932 / 180.0);

//   double _haversineKm(double lat1, double lon1, double lat2, double lon2) {
//     const R = 6371.0; // km
//     final dLat = _deg2rad(lat2 - lat1);
//     final dLon = _deg2rad(lon2 - lon1);
//     final a = sin(dLat / 2) * sin(dLat / 2) +
//         cos(_deg2rad(lat1)) *
//             cos(_deg2rad(lat2)) *
//             sin(dLon / 2) *
//             sin(dLon / 2);
//     final c = 2 * atan2(sqrt(a), sqrt(1 - a));
//     return R * c;
//   }

//   double _computeTotalKm() {
//     final chain = <Map<String, dynamic>>[pickup, ...stops, dropoff];
//     double total = 0.0;
//     for (int i = 0; i < chain.length - 1; i++) {
//       final a = chain[i];
//       final b = chain[i + 1];
//       total += _haversineKm(
//         (a["lat"] as num).toDouble(),
//         (a["lng"] as num).toDouble(),
//         (b["lat"] as num).toDouble(),
//         (b["lng"] as num).toDouble(),
//       );
//     }
//     return total;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;

//     return Scaffold(
//       backgroundColor: const Color(0xFFF6F6F7),
//       appBar: AppBar(
//         title: const Text("Estimate"),
//         centerTitle: true,
//       ),
//       body: pickup == null
//           ? const SizedBox() // filled in after first frame
//           : Column(
//               children: [
//                 // Header: counts
//                 Container(
//                   width: double.infinity,
//                   padding:
//                       EdgeInsets.fromLTRB(width * 0.05, 14, width * 0.05, 8),
//                   child: Row(
//                     children: [
//                       const Icon(CupertinoIcons.map_pin_ellipse, size: 22),
//                       const SizedBox(width: 8),
//                       Text(
//                         "${stops.length} stop${stops.length == 1 ? "" : "s"} added",
//                         style: const TextStyle(
//                             fontSize: 16, fontWeight: FontWeight.w700),
//                       ),
//                     ],
//                   ),
//                 ),

//                 // List of Pickup -> Stops -> Dropoff
//                 Expanded(
//                   child: ListView(
//                     padding:
//                         EdgeInsets.fromLTRB(width * 0.05, 6, width * 0.05, 120),
//                     children: [
//                       // Pickup
//                       Container(
//                         margin: const EdgeInsets.only(bottom: 10),
//                         padding: const EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(14),
//                           border: Border.all(color: const Color(0xFFE9ECF2)),
//                           boxShadow: const [
//                             BoxShadow(
//                                 blurRadius: 10,
//                                 color: Color(0x14000000),
//                                 offset: Offset(0, 4))
//                           ],
//                         ),
//                         child: Row(
//                           children: [
//                             Container(
//                               width: 38,
//                               height: 38,
//                               decoration: BoxDecoration(
//                                 color: const Color(0xFFE7F6EA),
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               child: const Icon(Icons.trip_origin,
//                                   color: Colors.green),
//                             ),
//                             const SizedBox(width: 10),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   const Text("Pickup",
//                                       style: TextStyle(
//                                           fontWeight: FontWeight.w700)),
//                                   const SizedBox(height: 2),
//                                   Text(
//                                     pickup["address"]?.toString() ??
//                                         "${pickup["lat"]}, ${pickup["lng"]}",
//                                     style:
//                                         const TextStyle(color: Colors.black54),
//                                     maxLines: 2,
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),

//                       // Stops
//                       for (int i = 0; i < stops.length; i++)
//                         Container(
//                           margin: const EdgeInsets.only(bottom: 10),
//                           padding: const EdgeInsets.all(12),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(14),
//                             border: Border.all(color: const Color(0xFFE9ECF2)),
//                             boxShadow: const [
//                               BoxShadow(
//                                   blurRadius: 10,
//                                   color: Color(0x14000000),
//                                   offset: Offset(0, 4))
//                             ],
//                           ),
//                           child: Row(
//                             children: [
//                               Container(
//                                 width: 38,
//                                 height: 38,
//                                 decoration: BoxDecoration(
//                                   color: const Color(0xFFEAF2FF),
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                                 child: Center(
//                                   child: Text(
//                                     "${i + 1}",
//                                     style: const TextStyle(
//                                         fontWeight: FontWeight.w800),
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(width: 10),
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text("Stop ${i + 1}",
//                                         style: const TextStyle(
//                                             fontWeight: FontWeight.w700)),
//                                     const SizedBox(height: 2),
//                                     Text(
//                                       stops[i]["address"]?.toString() ??
//                                           "${stops[i]["lat"]}, ${stops[i]["lng"]}",
//                                       style: const TextStyle(
//                                           color: Colors.black54),
//                                       maxLines: 2,
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),

//                       // Dropoff
//                       Container(
//                         margin: const EdgeInsets.only(bottom: 10),
//                         padding: const EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(14),
//                           border: Border.all(color: const Color(0xFFE9ECF2)),
//                           boxShadow: const [
//                             BoxShadow(
//                                 blurRadius: 10,
//                                 color: Color(0x14000000),
//                                 offset: Offset(0, 4))
//                           ],
//                         ),
//                         child: Row(
//                           children: [
//                             Container(
//                               width: 38,
//                               height: 38,
//                               decoration: BoxDecoration(
//                                 color: const Color(0xFFFFEAEA),
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               child: const Icon(Icons.location_on,
//                                   color: Colors.red),
//                             ),
//                             const SizedBox(width: 10),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   const Text("Dropoff",
//                                       style: TextStyle(
//                                           fontWeight: FontWeight.w700)),
//                                   const SizedBox(height: 2),
//                                   Text(
//                                     dropoff["address"]?.toString() ??
//                                         "${dropoff["lat"]}, ${dropoff["lng"]}",
//                                     style:
//                                         const TextStyle(color: Colors.black54),
//                                     maxLines: 2,
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 // Bottom summary card (sticky)
//                 Container(
//                   padding: EdgeInsets.fromLTRB(width * 0.05, 14, width * 0.05,
//                       14 + MediaQuery.of(context).padding.bottom),
//                   decoration: const BoxDecoration(
//                     color: Colors.white,
//                     borderRadius:
//                         BorderRadius.vertical(top: Radius.circular(18)),
//                     boxShadow: [
//                       BoxShadow(
//                           blurRadius: 18,
//                           color: Colors.black12,
//                           offset: Offset(0, -6))
//                     ],
//                   ),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 14, vertical: 14),
//                           decoration: BoxDecoration(
//                             color: const Color(0xFFF3F5F9),
//                             borderRadius: BorderRadius.circular(14),
//                             border: Border.all(color: const Color(0xFFE9ECF2)),
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               const Text("Route distance",
//                                   style:
//                                       TextStyle(fontWeight: FontWeight.w700)),
//                               Text("${_totalKm.toStringAsFixed(1)} km",
//                                   style: const TextStyle(
//                                       fontWeight: FontWeight.w800)),
//                             ],
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       FilledButton.icon(
//                         onPressed: () {
//                           // TODO: proceed to fare estimation/confirmation
//                           Navigator.pop(context, true);
//                         },
//                         icon: const Icon(Icons.arrow_forward),
//                         label: const Text("Continue"),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }
// }

// import 'dart:math' show sin, cos, sqrt, atan2;
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart'; // for LatLng (polyline optional)

// class D2dEstimatepage extends StatefulWidget {
//   const D2dEstimatepage({super.key});

//   @override
//   State<D2dEstimatepage> createState() => _D2dEstimatepageState();
// }

// class _D2dEstimatepageState extends State<D2dEstimatepage> {
//   late Map<String, dynamic> pickup; // {address, lat, lng}
//   late Map<String, dynamic> dropoff; // {address, lat, lng}
//   late List<Map<String, dynamic>> stops; // [{address, lat, lng}, ...]

//   double _totalKm = 0.0;
//   int? _etaMins; // optional (if provided)
//   List<LatLng> _overviewPath = []; // optional (if provided)
//   bool _ready = false; // avoid touching late vars before init

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final args = ModalRoute.of(context)?.settings.arguments;

//       if (args is Map<String, dynamic>) {
//         pickup = (args["pickup"] as Map).cast<String, dynamic>();
//         dropoff = (args["dropoff"] as Map).cast<String, dynamic>();
//         stops = (args["stops"] as List?)
//                 ?.map((e) => (e as Map).cast<String, dynamic>())
//                 .toList() ??
//             [];

//         // 1) compute fallback (haversine) first
//         _totalKm = _computeTotalKm();

//         // 2) prefer road distance if provided
//         final roadKm = (args["roadKm"] as num?)?.toDouble();
//         if (roadKm != null && roadKm > 0) {
//           _totalKm = roadKm;
//         }

//         // 3) optional ETA + polyline
//         _etaMins = (args["etaMins"] as num?)?.toInt();
//         final polyArg =
//             (args["polyline"] as List?)?.cast<Map<String, dynamic>>();
//         if (polyArg != null) {
//           _overviewPath = polyArg
//               .map((m) => LatLng(
//                     (m["lat"] as num).toDouble(),
//                     (m["lng"] as num).toDouble(),
//                   ))
//               .toList();
//         }
//       } else {
//         // Demo data (Perinthalmanna → Kozhikode with 2 stops)
//         pickup = {
//           "address": "Pickup • Perinthalmanna",
//           "lat": 10.9770,
//           "lng": 76.2254,
//         };
//         stops = [
//           {"address": "Stop 1 • Kuttippuram", "lat": 10.8333, "lng": 76.0333},
//           {"address": "Stop 2 • Ramanattukara", "lat": 11.1860, "lng": 75.9990},
//         ];
//         dropoff = {
//           "address": "Drop • Kozhikode",
//           "lat": 11.2588,
//           "lng": 75.7804,
//         };
//         _totalKm = _computeTotalKm();
//       }

//       setState(() {
//         _ready = true;
//       });
//     });
//   }

//   double _deg2rad(double d) => d * (3.1415926535897932 / 180.0);

//   double _haversineKm(double lat1, double lon1, double lat2, double lon2) {
//     const R = 6371.0; // km
//     final dLat = _deg2rad(lat2 - lat1);
//     final dLon = _deg2rad(lon2 - lon1);
//     final a = sin(dLat / 2) * sin(dLat / 2) +
//         cos(_deg2rad(lat1)) *
//             cos(_deg2rad(lat2)) *
//             sin(dLon / 2) *
//             sin(dLon / 2);
//     final c = 2 * atan2(sqrt(a), sqrt(1 - a));
//     return R * c;
//   }

//   double _computeTotalKm() {
//     final chain = <Map<String, dynamic>>[pickup, ...stops, dropoff];
//     double total = 0.0;
//     for (int i = 0; i < chain.length - 1; i++) {
//       final a = chain[i];
//       final b = chain[i + 1];
//       total += _haversineKm(
//         (a["lat"] as num).toDouble(),
//         (a["lng"] as num).toDouble(),
//         (b["lat"] as num).toDouble(),
//         (b["lng"] as num).toDouble(),
//       );
//     }
//     return total;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;

//     final double padSm = width * 0.03; // small padding
//     final double padMd = width * 0.04; // medium padding
//     final double br = width * 0.035; // border radius
//     final double icoSm = width * 0.055; // small icon ~22 on 400px
//     final double icoLg = width * 0.065; // larger icon
//     final double chip = width * 0.095; // square 38 on 400px
//     final double blur = width * 0.025; // shadow blur

//     return Scaffold(
//       backgroundColor: const Color(0xFFF6F6F7),
//       appBar: AppBar(
//         title: Text("Estimate", style: TextStyle(fontSize: width * 0.048)),
//         centerTitle: true,
//       ),
//       body: !_ready
//           ? const SizedBox()
//           : Column(
//               children: [
//                 // Header: counts
//                 Container(
//                   width: double.infinity,
//                   padding: EdgeInsets.fromLTRB(
//                       width * 0.05, padSm, width * 0.05, width * 0.02),
//                   child: Row(
//                     children: [
//                       Icon(CupertinoIcons.map_pin_ellipse, size: icoSm),
//                       SizedBox(width: width * 0.02),
//                       Text(
//                         "${stops.length} stop${stops.length == 1 ? "" : "s"} added",
//                         style: TextStyle(
//                             fontSize: width * 0.04,
//                             fontWeight: FontWeight.w700),
//                       ),
//                     ],
//                   ),
//                 ),

//                 // List of Pickup -> Stops -> Dropoff
//                 Expanded(
//                   child: ListView(
//                     padding: EdgeInsets.fromLTRB(
//                         width * 0.05, width * 0.015, width * 0.05, width * 0.3),
//                     children: [
//                       // Pickup
//                       Container(
//                         margin: EdgeInsets.only(bottom: width * 0.025),
//                         padding: EdgeInsets.all(padSm),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(br),
//                           border: Border.all(color: const Color(0xFFE9ECF2)),
//                           boxShadow: [
//                             BoxShadow(
//                                 blurRadius: blur,
//                                 color: const Color(0x14000000),
//                                 offset: Offset(0, width * 0.01))
//                           ],
//                         ),
//                         child: Row(
//                           children: [
//                             Container(
//                               width: chip,
//                               height: chip,
//                               decoration: BoxDecoration(
//                                 color: const Color(0xFFE7F6EA),
//                                 borderRadius:
//                                     BorderRadius.circular(width * 0.025),
//                               ),
//                               child: Icon(Icons.trip_origin,
//                                   color: Colors.green, size: icoLg),
//                             ),
//                             SizedBox(width: width * 0.025),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text("Pickup",
//                                       style: TextStyle(
//                                           fontWeight: FontWeight.w700,
//                                           fontSize: width * 0.038)),
//                                   SizedBox(height: width * 0.005),
//                                   Text(
//                                     pickup["address"]?.toString() ??
//                                         "${pickup["lat"]}, ${pickup["lng"]}",
//                                     style: TextStyle(
//                                         color: Colors.black54,
//                                         fontSize: width * 0.034),
//                                     maxLines: 2,
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),

//                       // Stops
//                       for (int i = 0; i < stops.length; i++)
//                         Container(
//                           margin: EdgeInsets.only(bottom: width * 0.025),
//                           padding: EdgeInsets.all(padSm),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(br),
//                             border: Border.all(color: const Color(0xFFE9ECF2)),
//                             boxShadow: [
//                               BoxShadow(
//                                   blurRadius: blur,
//                                   color: const Color(0x14000000),
//                                   offset: Offset(0, width * 0.01))
//                             ],
//                           ),
//                           child: Row(
//                             children: [
//                               Container(
//                                 width: chip,
//                                 height: chip,
//                                 decoration: BoxDecoration(
//                                   color: const Color(0xFFEAF2FF),
//                                   borderRadius:
//                                       BorderRadius.circular(width * 0.025),
//                                 ),
//                                 child: Center(
//                                   child: Text(
//                                     "${i + 1}",
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.w800,
//                                         fontSize: width * 0.042),
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(width: width * 0.025),
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text("Stop ${i + 1}",
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.w700,
//                                             fontSize: width * 0.038)),
//                                     SizedBox(height: width * 0.005),
//                                     Text(
//                                       stops[i]["address"]?.toString() ??
//                                           "${stops[i]["lat"]}, ${stops[i]["lng"]}",
//                                       style: TextStyle(
//                                           color: Colors.black54,
//                                           fontSize: width * 0.034),
//                                       maxLines: 2,
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),

//                       // Dropoff
//                       Container(
//                         margin: EdgeInsets.only(bottom: width * 0.025),
//                         padding: EdgeInsets.all(padSm),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(br),
//                           border: Border.all(color: const Color(0xFFE9ECF2)),
//                           boxShadow: [
//                             BoxShadow(
//                                 blurRadius: blur,
//                                 color: const Color(0x14000000),
//                                 offset: Offset(0, width * 0.01))
//                           ],
//                         ),
//                         child: Row(
//                           children: [
//                             Container(
//                               width: chip,
//                               height: chip,
//                               decoration: BoxDecoration(
//                                 color: const Color(0xFFFFEAEA),
//                                 borderRadius:
//                                     BorderRadius.circular(width * 0.025),
//                               ),
//                               child: Icon(Icons.location_on,
//                                   color: Colors.red, size: icoLg),
//                             ),
//                             SizedBox(width: width * 0.025),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text("Dropoff",
//                                       style: TextStyle(
//                                           fontWeight: FontWeight.w700,
//                                           fontSize: width * 0.038)),
//                                   SizedBox(height: width * 0.005),
//                                   Text(
//                                     dropoff["address"]?.toString() ??
//                                         "${dropoff["lat"]}, ${dropoff["lng"]}",
//                                     style: TextStyle(
//                                         color: Colors.black54,
//                                         fontSize: width * 0.034),
//                                     maxLines: 2,
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 // Bottom summary card (sticky)
//                 Container(
//                   padding: EdgeInsets.fromLTRB(
//                     width * 0.05,
//                     padSm,
//                     width * 0.05,
//                     padSm + MediaQuery.of(context).padding.bottom,
//                   ),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.vertical(
//                         top: Radius.circular(width * 0.045)),
//                     boxShadow: [
//                       BoxShadow(
//                           blurRadius: width * 0.045,
//                           color: Colors.black12,
//                           offset: Offset(0, -width * 0.015))
//                     ],
//                   ),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: Container(
//                           padding: EdgeInsets.symmetric(
//                               horizontal: padMd, vertical: padSm),
//                           decoration: BoxDecoration(
//                             color: const Color(0xFFF3F5F9),
//                             borderRadius: BorderRadius.circular(width * 0.035),
//                             border: Border.all(color: const Color(0xFFE9ECF2)),
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text("Route distance",
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.w700,
//                                       fontSize: width * 0.038)),
//                               Text("${_totalKm.toStringAsFixed(1)} km",
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.w800,
//                                       fontSize: width * 0.042)),
//                             ],
//                           ),
//                         ),
//                       ),
//                       SizedBox(width: width * 0.03),
//                       FilledButton.icon(
//                         onPressed: () => Navigator.pop(context, true),
//                         icon: Icon(Icons.arrow_forward, size: icoSm),
//                         label: Text("Continue",
//                             style: TextStyle(fontSize: width * 0.038)),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }
// }

// ------------

import 'dart:convert';
import 'package:drivex/feature/bottomNavigation/pages/D2D/D2D_paymentPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// Single page — OSRM only (no Google APIs)
/// Pricing:
///  - ₹10 / km
///  - +₹5 for each intermediate stop (excluding pickup & final drop)
class D2dEstimateOsrmPage extends StatefulWidget {
  const D2dEstimateOsrmPage({super.key});

  @override
  State<D2dEstimateOsrmPage> createState() => _D2dEstimateOsrmPageState();
}

class _D2dEstimateOsrmPageState extends State<D2dEstimateOsrmPage> {
  // Inputs
  late Map<String, dynamic> pickup; // {address, lat, lng}
  late Map<String, dynamic> dropoff; // {address, lat, lng}
  late List<Map<String, dynamic>> stops; // [{address, lat, lng, kind?}, ...]

  // OSRM outputs
  double? _roadKm;
  int? _etaMins;
  bool _ready = false;
  bool _loading = false;
  String? _error;

  // Pricing
  static const double perKmRate = 10.0; // ₹10/km
  static const int perStopCharge = 5; // ₹5 per intermediate stop
  double? _fare; // computed when OSRM distance available

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final args = ModalRoute.of(context)?.settings.arguments;

      if (args is Map<String, dynamic>) {
        pickup = (args["pickup"] as Map).cast<String, dynamic>();
        dropoff = (args["dropoff"] as Map).cast<String, dynamic>();
        stops = (args["stops"] as List?)
                ?.map((e) => (e as Map).cast<String, dynamic>())
                .toList() ??
            [];
      } else {
        // Demo chain — Perinthalmanna → Kozhikode (2 stops)
        pickup = {
          "address": "Pickup • Perinthalmanna",
          "lat": 10.9770,
          "lng": 76.2254,
        };
        stops = [
          {
            "address": "Kuttippuram",
            "lat": 10.8333,
            "lng": 76.0333,
            "kind": "pick"
          },
          {
            "address": "Ramanattukara",
            "lat": 11.1860,
            "lng": 75.9990,
            "kind": "drop"
          },
        ];
        dropoff = {
          "address": "Drop • Kozhikode",
          "lat": 11.2588,
          "lng": 75.7804,
        };
      }

      setState(() => _ready = true);
      await _fetchOsrmRoadDistance();
    });
  }

  Future<void> _fetchOsrmRoadDistance() async {
    if (!_ready) return;
    setState(() {
      _loading = true;
      _error = null;
    });

    // Build "lon,lat;lon,lat;..." for OSRM
    final chain = <Map<String, dynamic>>[pickup, ...stops, dropoff];
    final coords = chain.map((m) {
      final lat = (m["lat"] as num).toDouble();
      final lng = (m["lng"] as num).toDouble();
      return "$lng,$lat"; // OSRM expects LON,LAT
    }).join(';');

    final url =
        "https://router.project-osrm.org/route/v1/driving/$coords?overview=false";

    try {
      final res = await http.get(Uri.parse(url));
      if (res.statusCode != 200) {
        setState(() {
          _loading = false;
          _error = "OSRM error: HTTP ${res.statusCode}";
        });
        return;
      }

      final data = json.decode(res.body) as Map<String, dynamic>;
      final routes = data["routes"] as List?;
      if (routes == null || routes.isEmpty) {
        setState(() {
          _loading = false;
          _error = "No route found";
        });
        return;
      }

      final route = routes.first as Map<String, dynamic>;
      final km = ((route["distance"] as num).toDouble()) / 1000.0;
      final mins = ((route["duration"] as num).toDouble()) / 60.0;

      // Compute fare now that we have road km
      final stopsCost =
          (stops.length) * perStopCharge; // exclude pickup & final drop
      final distanceCost = km * perKmRate;
      final totalFare = distanceCost + stopsCost;

      setState(() {
        _roadKm = km;
        _etaMins = mins.round();
        _fare = totalFare;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _error = "Failed to fetch OSRM route";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    // sizing (stops a bit smaller than pickup/drop)
    final double padSm = width * 0.03;
    final double padMd = width * 0.04;
    final double br = width * 0.035;
    final double icoSm = width * 0.055;
    final double icoLg = width * 0.065;
    final double chip = width * 0.095;
    final double chipSmall = width * 0.082; // smaller chip for stops
    final double blur = width * 0.025;

    if (!_ready) return const Scaffold(body: SizedBox());

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F7),
      appBar: AppBar(
        title: Text("Trip Estimate", style: TextStyle(fontSize: width * 0.04)),
        centerTitle: true,
        // actions: [
        //   IconButton(
        //     tooltip: "Refresh",
        //     onPressed: _loading ? null : _fetchOsrmRoadDistance,
        //     icon: const Icon(CupertinoIcons.refresh),
        //   )
        // ],
      ),
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(
                width * 0.05, padSm, width * 0.05, width * 0.02),
            child: Row(
              children: [
                Icon(CupertinoIcons.map_pin_ellipse, size: icoSm),
                SizedBox(width: width * 0.02),
                Text(
                  "${stops.length} stop${stops.length == 1 ? "" : "s"}",
                  style: TextStyle(
                      fontSize: width * 0.04, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),

          // List: Pickup → Stops → Dropoff
          Expanded(
            child: ListView(
              padding: EdgeInsets.fromLTRB(
                  width * 0.05, width * 0.015, width * 0.05, width * 0.3),
              children: [
                // Pickup (big tile)
                _placeCard(
                  width: width,
                  padSm: padSm,
                  br: br,
                  blur: blur,
                  chip: chip,
                  badgeText: "Pick",
                  icon:
                      Icon(Icons.trip_origin, color: Colors.green, size: icoLg),
                  bgColor: const Color(0xFFE7F6EA),
                  title: pickup["address"]?.toString() ?? "Pickup",
                  subtitle: _coordLine(pickup),
                ),

                // Stops (smaller tile + Pick/Drop/Stop badge)
                for (int i = 0; i < stops.length; i++)
                  _placeCard(
                    width: width,
                    padSm: padSm * 0.9, // slightly tighter
                    br: br,
                    blur: blur,
                    chip: chipSmall,
                    badgeText: _stopKindLabel(stops[i]["kind"]),
                    icon: Center(
                      child: Text("${i + 1}",
                          style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: width * 0.042)),
                    ),
                    bgColor: const Color(0xFFEAF2FF),
                    title: stops[i]["address"]?.toString() ?? "Stop ${i + 1}",
                    subtitle: _coordLine(stops[i]),
                  ),

                // Drop (big tile)
                _placeCard(
                  width: width,
                  padSm: padSm,
                  br: br,
                  blur: blur,
                  chip: chip,
                  badgeText: "Drop",
                  icon: Icon(Icons.location_on, color: Colors.red, size: icoLg),
                  bgColor: const Color(0xFFFFEAEA),
                  title: dropoff["address"]?.toString() ?? "Dropoff",
                  subtitle: _coordLine(dropoff),
                ),
              ],
            ),
          ),

          // Bottom summary
          Container(
            padding: EdgeInsets.fromLTRB(
              width * 0.05,
              padSm,
              width * 0.05,
              padSm + MediaQuery.of(context).padding.bottom,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.vertical(top: Radius.circular(width * 0.045)),
              boxShadow: [
                BoxShadow(
                    blurRadius: width * 0.045,
                    color: Colors.black12,
                    offset: Offset(0, -width * 0.015))
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: padMd, vertical: padSm),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F5F9),
                          borderRadius: BorderRadius.circular(width * 0.035),
                          border: Border.all(color: const Color(0xFFE9ECF2)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // status line
                            if (_loading)
                              Text("OSRM road distance: calculating…",
                                  style: TextStyle(
                                      fontSize: width * 0.032,
                                      color: Colors.black54))
                            else if (_error != null)
                              Text("OSRM road distance: ${_error!}",
                                  style: TextStyle(
                                      fontSize: width * 0.032,
                                      color: Colors.redAccent))
                            else if (_roadKm != null)
                              Text(
                                "OSRM road distance: ${_roadKm!.toStringAsFixed(1)} km"
                                "${_etaMins != null ? " • ~$_etaMins min" : ""}",
                                style: TextStyle(
                                    fontSize: width * 0.032,
                                    color: Colors.black54),
                              )
                            else
                              Text("OSRM road distance: unavailable",
                                  style: TextStyle(
                                      fontSize: width * 0.032,
                                      color: Colors.black54)),

                            SizedBox(height: width * 0.03),

                            // ── Fare breakdown lines ────────────────────────────────────────────────
                            // 1) Per-km line
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Per km: ₹${perKmRate.toStringAsFixed(0)} × "
                                  "${_roadKm != null ? _roadKm!.toStringAsFixed(1) : '--'} km",
                                  style: TextStyle(
                                      fontSize: width * 0.034,
                                      color: Colors.black87),
                                ),
                                Text(
                                  _roadKm != null
                                      ? "₹${(_roadKm! * perKmRate).toStringAsFixed(0)}"
                                      : "—",
                                  style: TextStyle(
                                    fontSize: width * 0.036,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: width * 0.018),

                            // 2) Stops line
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Stops: ${stops.length} × ₹$perStopCharge",
                                  style: TextStyle(
                                      fontSize: width * 0.034,
                                      color: Colors.black87),
                                ),
                                Text(
                                  "₹${(stops.length * perStopCharge).toStringAsFixed(0)}",
                                  style: TextStyle(
                                    fontSize: width * 0.036,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),

                            // Divider
                            Padding(
                              padding:
                                  EdgeInsets.symmetric(vertical: width * 0.028),
                              child: const Divider(
                                  height: 1,
                                  thickness: 1,
                                  color: Color(0xFFE1E6EF)),
                            ),

                            // 3) Total fare line
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Total Fare",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: width * 0.04,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  _fare != null
                                      ? "₹${_fare!.toStringAsFixed(0)}"
                                      : "—",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: width * 0.048,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    // SizedBox(width: width * 0.03),
                  ],
                ),
                SizedBox(height: width * 0.03),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                      // onTap: () {
                      //   Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (_) => const D2dPaymentpage(),
                      //       settings: RouteSettings(arguments: {
                      //         "fare":
                      //             275.0, // required base fare (after OSRM + stops)
                      //         "distance_km": 23.8, // optional
                      //         "eta_mins": 28, // optional
                      //         "stops_count": 2, // optional
                      //         "per_km_rate": 10.0, // optional
                      //         "per_stop_charge": 5, // optional
                      //       }),
                      //     ),
                      //   );
                      // },
                      onTap: (_loading || _fare == null || _roadKm == null)
                          ? null
                          : () {
                              final args = {
                                // original, computed here
                                "fare": _fare, // double
                                "distance_km": _roadKm, // double
                                "eta_mins": _etaMins, // int?
                                "stops_count": stops.length, // int
                                "per_km_rate": perKmRate, // double
                                "per_stop_charge": perStopCharge, // int

                                // pass full locations too (optional but useful)
                                "pickup": pickup, // {address, lat, lng}
                                "dropoff": dropoff, // {address, lat, lng}
                                "stops":
                                    stops, // list of {address, lat, lng, kind?}
                              };

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const D2dPaymentpage(),
                                  settings: RouteSettings(arguments: args),
                                ),
                              );
                            },
                      child: Container(
                        width: width * .4,
                        decoration: BoxDecoration(
                            // border: Border.all(),

                            color:
                                (_loading || _fare == null || _roadKm == null)
                                    ? Colors.blueAccent.withOpacity(0.4)
                                    : Colors.blueAccent,
                            borderRadius: BorderRadius.all(
                                Radius.circular(width * .025))),
                        child: Center(
                          child: Padding(
                            padding:
                                EdgeInsets.symmetric(vertical: width * .02),
                            child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Proceed",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  SizedBox(
                                    width: width * .005,
                                  ),
                                  Icon(
                                    Icons.arrow_circle_right_outlined,
                                    color: Colors.white,
                                  )
                                ]),
                          ),
                        ),
                      )),
                )
                // Align(
                //   alignment: Alignment.centerRight,
                //   child: FilledButton.icon(
                //     onPressed: (_fare == null || _loading)
                //         ? null
                //         : () => Navigator.pop(context, {
                //               "distance_km": _roadKm,
                //               "eta_mins": _etaMins,
                //               "fare": _fare,
                //             }),
                //     icon: const Icon(Icons.arrow_forward),
                //     label: Text("Proceed",
                //         style: TextStyle(fontSize: width * 0.038)),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---- helpers ----

  String _coordLine(Map<String, dynamic> m) {
    final lat = (m["lat"] as num).toStringAsFixed(6);
    final lng = (m["lng"] as num).toStringAsFixed(6);
    return "$lat, $lng";
  }

  String _stopKindLabel(dynamic kind) {
    final s = (kind ?? "").toString().toLowerCase();
    if (s == "pick" || s == "pickup") return "Pick";
    if (s == "drop" || s == "dropoff") return "Drop";
    return "Stop";
  }

  Widget _placeCard({
    required double width,
    required double padSm,
    required double br,
    required double blur,
    required double chip,
    required String badgeText,
    required Widget icon,
    required Color bgColor,
    required String title,
    required String subtitle,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: width * 0.025),
      padding: EdgeInsets.all(padSm),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(br),
        border: Border.all(color: const Color(0xFFE9ECF2)),
        boxShadow: [
          BoxShadow(
              blurRadius: blur,
              color: const Color(0x14000000),
              offset: Offset(0, width * 0.01))
        ],
      ),
      child: Row(
        children: [
          Container(
            width: chip,
            height: chip,
            decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(width * 0.025)),
            child: icon,
          ),
          SizedBox(width: width * 0.025),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // small badge showing Pick / Drop / Stop
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.02, vertical: width * 0.007),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF2F7),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: const Color(0xFFDDE3ED)),
                  ),
                  child: Text(badgeText,
                      style: TextStyle(
                          fontSize: width * 0.028,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87)),
                ),
                SizedBox(height: width * 0.012),
                // Place name
                Text(title,
                    style: TextStyle(
                        fontWeight: FontWeight.w700, fontSize: width * 0.038)),
                SizedBox(height: width * 0.005),
                // Coordinates line directly below name
                Text(subtitle,
                    style: TextStyle(
                        color: Colors.black54, fontSize: width * 0.034)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
