// import 'package:drivex/core/constants/localVariables.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class D2dPlaceSearchPage extends StatefulWidget {
//   const D2dPlaceSearchPage({super.key});

//   @override
//   State<D2dPlaceSearchPage> createState() => _D2dPlaceSearchPageState();
// }

// class _D2dPlaceSearchPageState extends State<D2dPlaceSearchPage> {
//   final String googleApiKey = "AIzaSyD1fU_UDudvvy1HEPEoJ4Ify_YOYDlhdEY";
//   late GoogleMapController? mapController;

//   final CameraPosition _initialPosition = CameraPosition(
//     target: LatLng(10.8505, 76.2711), // Example: Kerala
//     zoom: 14.0,
//   );
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           GoogleMap(
//             initialCameraPosition: _initialPosition,
//             onMapCreated: (controller) {
//               mapController = controller;
//             },
//             myLocationEnabled: true,
//             myLocationButtonEnabled: true,
//             zoomControlsEnabled: false,
//           ),
//           Container(
//               height: height * 1,
//               width: width * 1,
//               child: Center(
//                   child: Column(
//                 children: [
//                   SizedBox(
//                     height: height * .075,
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       Container(
//                         width: width * 0.04,
//                         height: width * 0.04,
//                         decoration: BoxDecoration(
//                           border: Border.all(
//                               width: width * .005,
//                               color: Colors.black.withOpacity(.25)),
//                           color: Colors.green, // Change for "To" field
//                           shape: BoxShape.circle,
//                         ),
//                         child: Center(
//                           child: Container(
//                               width: width * 0.04 / 2,
//                               height: width * 0.04 / 2,
//                               decoration: BoxDecoration(
//                                 color: Colors.black
//                                     .withOpacity(0.5), // Change for "To" field
//                                 shape: BoxShape.circle,
//                               )),
//                         ),
//                       ),
//                       Container(
//                         height: width * .125,
//                         width: width * .8,
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(8),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.1),
//                               blurRadius: 4,
//                               offset: Offset(0, 2),
//                             ),
//                           ],
//                         ),
//                         child: TextField(
//                           decoration: InputDecoration(
//                             hintText: 'Search for a place',
//                             // prefixIcon: Icon(Icons.search),
//                             border: InputBorder.none,
//                             contentPadding:
//                                 EdgeInsets.symmetric(horizontal: width * .05),
//                           ),
//                         ),
//                       ),
//                     ],
//                   )
//                 ],
//               )))
//         ],
//       ),
//     );
//   }
// }

//////////////////

// import 'package:drivex/core/constants/localVariables.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// // Places autocomplete + details
// import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
// import 'package:flutter_google_places_hoc081098/google_maps_webservice_places.dart'
//     as gmws;
// import 'package:google_api_headers/google_api_headers.dart';
// import 'package:uuid/uuid.dart';

// class D2dPlaceSearchPage extends StatefulWidget {
//   const D2dPlaceSearchPage({super.key});

//   @override
//   State<D2dPlaceSearchPage> createState() => _D2dPlaceSearchPageState();
// }

// class _D2dPlaceSearchPageState extends State<D2dPlaceSearchPage> {
//   final String googleApiKey = "AIzaSyD1fU_UDudvvy1HEPEoJ4Ify_YOYDlhdEY";

//   GoogleMapController? mapController;
//   final TextEditingController _searchCtrl = TextEditingController();
//   final Set<Marker> _markers = {};

//   final CameraPosition _initialPosition = const CameraPosition(
//     target: LatLng(10.8505, 76.2711), // Kerala
//     zoom: 14.0,
//   );

//   // 👉 Bias center for nearby suggestions (kept in sync with camera)
//   LatLng _biasCenter = const LatLng(10.8505, 76.2711);

//   @override
//   void dispose() {
//     _searchCtrl.dispose();
//     super.dispose();
//   }

//   Future<void> _openPlacesOverlay() async {
//     final sessionToken = const Uuid().v4(); // improves billing/accuracy

//     final prediction = await PlacesAutocomplete.show(
//       context: context,
//       apiKey: googleApiKey,
//       mode: Mode.overlay,
//       language: 'en',
//       hint: 'Search for a place',
//       sessionToken: sessionToken,

//       // Optional: limit to India
//       components: [gmws.Component(gmws.Component.country, 'in')],

//       // ✅ Nearby bias using current map center (named args)
//       location: gmws.Location(
//         lat: _biasCenter.latitude,
//         lng: _biasCenter.longitude,
//       ),
//       radius: 25000, // meters; adjust as you like
//       // strictbounds: true, // uncomment to hard-restrict to the radius
//     );

//     if (prediction == null) return;

//     final places = gmws.GoogleMapsPlaces(
//       apiKey: googleApiKey,
//       apiHeaders: await const GoogleApiHeaders().getHeaders(),
//     );

//     final detail = await places.getDetailsByPlaceId(prediction.placeId!);
//     final geometry = detail.result.geometry;
//     if (geometry == null) return;

//     final target = LatLng(geometry.location.lat, geometry.location.lng);

//     setState(() {
//       _searchCtrl.text = prediction.description ?? detail.result.name;
//       _biasCenter = target; // keep bias updated
//       _markers
//         ..clear()
//         ..add(
//           Marker(
//             markerId: const MarkerId('picked'),
//             position: target,
//             infoWindow: InfoWindow(
//               title: detail.result.name,
//               snippet: detail.result.formattedAddress,
//             ),
//           ),
//         );
//     });

//     await mapController?.animateCamera(
//       CameraUpdate.newCameraPosition(
//         CameraPosition(target: target, zoom: 16.0),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           GoogleMap(
//             initialCameraPosition: _initialPosition,
//             onMapCreated: (controller) => mapController = controller,
//             myLocationEnabled: true,
//             myLocationButtonEnabled: true,
//             zoomControlsEnabled: false,
//             markers: _markers,

//             // 💡 Keep bias center synced to camera
//             onCameraMove: (pos) => _biasCenter = pos.target,
//           ),
//           // Top search row overlay
//           SizedBox(
//             height: height * 1,
//             width: width * 1,
//             child: Center(
//               child: Column(
//                 children: [
//                   SizedBox(height: height * .075),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       // Leading dot
//                       Container(
//                         width: width * 0.04,
//                         height: width * 0.04,
//                         decoration: BoxDecoration(
//                           border: Border.all(
//                             width: width * .005,
//                             color: Colors.black.withOpacity(.25),
//                           ),
//                           color: Colors.green,
//                           shape: BoxShape.circle,
//                         ),
//                         child: Center(
//                           child: Container(
//                             width: width * 0.02,
//                             height: width * 0.02,
//                             decoration: BoxDecoration(
//                               color: Colors.black.withOpacity(0.5),
//                               shape: BoxShape.circle,
//                             ),
//                           ),
//                         ),
//                       ),
//                       // Search box (readOnly -> opens Places overlay)
//                       Container(
//                         height: width * .125,
//                         width: width * .8,
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(8),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.1),
//                               blurRadius: 4,
//                               offset: const Offset(0, 2),
//                             ),
//                           ],
//                         ),
//                         child: TextField(
//                           controller: _searchCtrl,
//                           readOnly: true, // avoid keyboard flicker
//                           onTap: _openPlacesOverlay,
//                           decoration: InputDecoration(
//                             hintText: 'Search for a place',
//                             prefixIcon: const Icon(Icons.search),
//                             suffixIcon: _searchCtrl.text.isEmpty
//                                 ? null
//                                 : IconButton(
//                                     icon: const Icon(Icons.clear),
//                                     onPressed: () {
//                                       setState(() {
//                                         _searchCtrl.clear();
//                                         _markers.clear();
//                                       });
//                                     },
//                                   ),
//                             border: InputBorder.none,
//                           ),
//                         ),
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// /////////////////////

// import 'dart:async';

// import 'package:drivex/core/constants/localVariables.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// // Google Places (http ^1.x friendly)
// import 'package:flutter_google_places_hoc081098/google_maps_webservice_places.dart'
//     as gmws;
// import 'package:google_api_headers/google_api_headers.dart';

// // Current location + reverse geocoding
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';

// import 'package:uuid/uuid.dart';

// class D2dPlaceSearchPage extends StatefulWidget {
//   const D2dPlaceSearchPage({super.key});

//   @override
//   State<D2dPlaceSearchPage> createState() => _D2dPlaceSearchPageState();
// }

// class _D2dPlaceSearchPageState extends State<D2dPlaceSearchPage> {
//   final String googleApiKey = "AIzaSyD1fU_UDudvvy1HEPEoJ4Ify_YOYDlhdEY";

//   GoogleMapController? mapController;

//   // Search state
//   final TextEditingController _searchCtrl = TextEditingController();
//   final FocusNode _searchFocus = FocusNode();
//   Timer? _debounce;
//   String _sessionToken = const Uuid().v4();

//   List<gmws.Prediction> _results = [];
//   bool _loading = false;
//   String? _error;

//   // Location/state
//   LatLng _biasCenter = const LatLng(10.8505, 76.2711); // fallback: Kerala
//   String? _currentStateName; // e.g., "Kerala", "Tamil Nadu"
//   LatLng? _pendingCameraTarget; // in case map isn't ready yet

//   // Map/markers
//   final Set<Marker> _markers = {};
//   final CameraPosition _initialPosition = const CameraPosition(
//     target: LatLng(10.8505, 76.2711),
//     zoom: 14.0,
//   );

//   @override
//   void initState() {
//     super.initState();
//     _initLocationAndBias();

//     _searchFocus.addListener(() {
//       if (_searchFocus.hasFocus && _searchCtrl.text.trim().length >= 2) {
//         _search(_searchCtrl.text.trim()); // show list again on refocus
//       }
//       if (!_searchFocus.hasFocus) {
//         setState(() {
//           _results = [];
//           _error = null;
//           _loading = false;
//         });
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _searchCtrl.dispose();
//     _searchFocus.dispose();
//     _debounce?.cancel();
//     super.dispose();
//   }

//   // ---------- Init location & state ----------
//   Future<void> _initLocationAndBias() async {
//     try {
//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         // keep fallback center; don't block UX
//         return;
//       }

//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//       }
//       if (permission == LocationPermission.deniedForever ||
//           permission == LocationPermission.denied) {
//         return; // user denied; stick with fallback
//       }

//       final pos = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );

//       final newCenter = LatLng(pos.latitude, pos.longitude);
//       List<Placemark> places =
//           await placemarkFromCoordinates(pos.latitude, pos.longitude);

//       setState(() {
//         _biasCenter = newCenter;
//         _currentStateName =
//             places.isNotEmpty ? places.first.administrativeArea : null;
//         _pendingCameraTarget = newCenter; // move camera once map is ready
//       });

//       // If map is already ready, move now
//       if (mapController != null) {
//         await mapController!.animateCamera(
//           CameraUpdate.newCameraPosition(
//             CameraPosition(target: newCenter, zoom: 15.0),
//           ),
//         );
//         _pendingCameraTarget = null;
//       }
//     } catch (_) {
//       // ignore errors; keep fallback bias center
//     }
//   }

//   // ---------- Places search ----------
//   Future<void> _onChanged(String text) async {
//     _debounce?.cancel();
//     _debounce = Timer(const Duration(milliseconds: 260), () {
//       _search(text.trim());
//     });
//   }

//   Future<void> _search(String input) async {
//     if (!_searchFocus.hasFocus) return; // only search while focused
//     if (input.length < 2) {
//       setState(() {
//         _results = [];
//         _error = null;
//         _loading = false;
//       });
//       return;
//     }

//     setState(() {
//       _loading = true;
//       _error = null;
//     });

//     try {
//       final places = gmws.GoogleMapsPlaces(
//         apiKey: googleApiKey,
//         apiHeaders: await const GoogleApiHeaders().getHeaders(),
//       );

//       final resp = await places.autocomplete(
//         input,
//         sessionToken: _sessionToken,
//         language: 'en',
//         // Country = India; bias to current location so your state shows first.
//         components: [gmws.Component(gmws.Component.country, 'in')],
//         location: gmws.Location(
//           lat: _biasCenter.latitude,
//           lng: _biasCenter.longitude,
//         ),
//         radius: 60000, // 60km radius bias; tweak if you want broader state bias
//         strictbounds: false,
//       );

//       if (!mounted) return;

//       setState(() {
//         if (resp.isOkay) {
//           _results = resp.predictions;
//           _error = null;
//         } else {
//           _results = [];
//           _error = resp.errorMessage ?? 'No results';
//         }
//         _loading = false;
//       });
//     } catch (e) {
//       if (!mounted) return;
//       setState(() {
//         _results = [];
//         _error = e.toString();
//         _loading = false;
//       });
//     }
//   }

//   Future<void> _selectPrediction(gmws.Prediction p) async {
//     // rotate session for billing best practice
//     _sessionToken = const Uuid().v4();

//     setState(() {
//       _searchCtrl.text = p.description ?? '';
//       _results = [];
//       _error = null;
//       _loading = false;
//     });
//     _searchFocus.unfocus();

//     final places = gmws.GoogleMapsPlaces(
//       apiKey: googleApiKey,
//       apiHeaders: await const GoogleApiHeaders().getHeaders(),
//     );

//     final detail = await places.getDetailsByPlaceId(p.placeId!);
//     final geometry = detail.result.geometry;
//     if (geometry == null) return;

//     final target = LatLng(geometry.location.lat, geometry.location.lng);

//     setState(() {
//       _biasCenter = target;
//       _currentStateName = detail.result.addressComponents
//           .firstWhere(
//             (c) => c.types.contains('administrative_area_level_1'),
//             orElse: () =>
//                 gmws.AddressComponent(longName: '', shortName: '', types: []),
//           )
//           .longName;
//       _markers
//         ..clear()
//         ..add(
//           Marker(
//             markerId: const MarkerId('picked'),
//             position: target,
//             infoWindow: InfoWindow(
//               title: detail.result.name,
//               snippet: detail.result.formattedAddress,
//             ),
//           ),
//         );
//     });

//     await mapController?.animateCamera(
//       CameraUpdate.newCameraPosition(
//         CameraPosition(target: target, zoom: 16.0),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     // all sizing with width*
//     final double spacerTop = width * .05; // top spacing
//     final double fieldHeight = width * .105; // textfield height
//     final double panelPad = width * .0125;
//     final double cardRadius = width * .03;
//     final double borderWidth = width * .005;
//     final double iconSize = width * .034;
//     final double gap = width * .01;
//     final double maxPanelH = width * .6; // cap list height using width*

//     return Scaffold(
//       body: GestureDetector(
//         onTap: () => FocusScope.of(context).unfocus(),
//         behavior: HitTestBehavior.translucent,
//         child: Stack(
//           children: [
//             GoogleMap(
//               initialCameraPosition: _initialPosition,
//               onMapCreated: (controller) async {
//                 mapController = controller;
//                 if (_pendingCameraTarget != null) {
//                   await mapController!.animateCamera(
//                     CameraUpdate.newCameraPosition(
//                       CameraPosition(target: _pendingCameraTarget!, zoom: 15.0),
//                     ),
//                   );
//                   _pendingCameraTarget = null;
//                 }
//               },
//               myLocationEnabled: true,
//               myLocationButtonEnabled: true,
//               zoomControlsEnabled: false,
//               markers: _markers,
//               onCameraMove: (pos) => _biasCenter = pos.target,
//             ),

//             // Search + inline suggestions (all inside Scaffold)
//             SafeArea(
//               child: SizedBox(
//                 width: width * 1,
//                 child: Column(
//                   children: [
//                     SizedBox(height: spacerTop),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // leading dot
//                         SizedBox(
//                           height: width * .105,
//                           child: Center(
//                             child: Container(
//                               width: width * 0.04,
//                               height: width * 0.04,
//                               decoration: BoxDecoration(
//                                 border: Border.all(
//                                   width: width * .005,
//                                   color: Colors.black.withOpacity(.25),
//                                 ),
//                                 color: Colors.green,
//                                 shape: BoxShape.circle,
//                               ),
//                               child: Center(
//                                 child: Container(
//                                   width: width * 0.02,
//                                   height: width * 0.02,
//                                   decoration: BoxDecoration(
//                                     color: Colors.black.withOpacity(0.5),
//                                     shape: BoxShape.circle,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),

//                         // Search field + the suggestion list bundled
//                         Container(
//                           width: width * .82,
//                           decoration:
//                               const BoxDecoration(color: Colors.transparent),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.stretch,
//                             children: [
//                               // search field
//                               Container(
//                                 height: fieldHeight,
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius:
//                                       BorderRadius.circular(width * .035),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.black.withOpacity(0.12),
//                                       blurRadius: width * .02,
//                                       offset: Offset(0, width * .0075),
//                                     ),
//                                   ],
//                                 ),
//                                 child: TextField(
//                                   controller: _searchCtrl,
//                                   focusNode: _searchFocus,
//                                   onChanged: _onChanged,
//                                   textInputAction: TextInputAction.search,
//                                   decoration: InputDecoration(
//                                     // hintText: _currentStateName == null
//                                     //     ? 'Search for a place'
//                                     //     : 'Search near $_currentStateName',
//                                     hintText: 'Search your pickup location',
//                                     prefixIcon:
//                                         Icon(Icons.search, size: iconSize),
//                                     suffixIcon: _searchCtrl.text.isEmpty
//                                         ? null
//                                         : IconButton(
//                                             icon: Icon(Icons.close,
//                                                 size: iconSize),
//                                             onPressed: () {
//                                               setState(() {
//                                                 _searchCtrl.clear();
//                                                 _results = [];
//                                                 _error = null;
//                                               });
//                                             },
//                                           ),
//                                     border: InputBorder.none,
//                                     contentPadding:
//                                         EdgeInsets.only(top: width * .0125
//                                             // horizontal: width * .03,
//                                             // vertical: 0,
//                                             ),
//                                   ),
//                                   style: TextStyle(fontSize: width * .035),
//                                 ),
//                               ),

//                               SizedBox(height: gap),

//                               // suggestion panel (INLINE)
//                               if (_searchFocus.hasFocus &&
//                                   (_loading ||
//                                       _results.isNotEmpty ||
//                                       (_error != null &&
//                                           _searchCtrl.text.isNotEmpty)))
//                                 Container(
//                                   padding: EdgeInsets.all(panelPad),
//                                   constraints:
//                                       BoxConstraints(maxHeight: maxPanelH),
//                                   decoration: BoxDecoration(
//                                     color: const Color(0xFFEDEDED),
//                                     borderRadius:
//                                         BorderRadius.circular(width * .04),
//                                     border: Border.all(
//                                       color: Colors.black26,
//                                       width: borderWidth,
//                                     ),
//                                     boxShadow: [
//                                       BoxShadow(
//                                         color: Colors.black.withOpacity(.18),
//                                         blurRadius: width * .03,
//                                         offset: Offset(0, width * .01),
//                                       ),
//                                     ],
//                                   ),
//                                   child: Builder(builder: (context) {
//                                     if (_loading) {
//                                       return SizedBox(
//                                         height: width * .08,
//                                         child: const Center(
//                                           child: CupertinoActivityIndicator(),
//                                         ),
//                                       );
//                                     }

//                                     if (_error != null) {
//                                       return Padding(
//                                         padding: EdgeInsets.all(width * .01),
//                                         child: Text(
//                                           _error!,
//                                           style: TextStyle(
//                                             color: Colors.redAccent,
//                                             fontSize: width * .032,
//                                           ),
//                                         ),
//                                       );
//                                     }

//                                     if (_results.isEmpty) {
//                                       // skeletons
//                                       return Column(
//                                         children: List.generate(4, (i) {
//                                           return Container(
//                                             margin: EdgeInsets.symmetric(
//                                               vertical: gap * .6,
//                                             ),
//                                             decoration: BoxDecoration(
//                                               color: Colors.white,
//                                               borderRadius:
//                                                   BorderRadius.circular(
//                                                       cardRadius),
//                                               boxShadow: [
//                                                 BoxShadow(
//                                                   color: Colors.black
//                                                       .withOpacity(.06),
//                                                   blurRadius: width * .02,
//                                                   offset:
//                                                       Offset(0, width * .005),
//                                                 ),
//                                               ],
//                                             ),
//                                             padding: EdgeInsets.symmetric(
//                                               horizontal: width * .022,
//                                               vertical: width * .018,
//                                             ),
//                                             child:
//                                                 SizedBox(height: width * .03),
//                                           );
//                                         }),
//                                       );
//                                     }

//                                     // results
//                                     return ListView.separated(
//                                       padding: EdgeInsets.zero,
//                                       shrinkWrap: true,
//                                       itemCount: _results.length,
//                                       separatorBuilder: (_, __) =>
//                                           SizedBox(height: gap * .6),
//                                       itemBuilder: (context, i) {
//                                         final p = _results[i];
//                                         final main =
//                                             p.structuredFormatting?.mainText ??
//                                                 (p.description ?? '');
//                                         final secondary = p.structuredFormatting
//                                                 ?.secondaryText ??
//                                             '';

//                                         return InkWell(
//                                           onTap: () => _selectPrediction(p),
//                                           borderRadius:
//                                               BorderRadius.circular(cardRadius),
//                                           child: Container(
//                                             padding: EdgeInsets.symmetric(
//                                               horizontal: width * .022,
//                                               vertical: width *
//                                                   .018, // dynamic height
//                                             ),
//                                             decoration: BoxDecoration(
//                                               color: Colors.white,
//                                               borderRadius:
//                                                   BorderRadius.circular(
//                                                       cardRadius),
//                                               boxShadow: [
//                                                 BoxShadow(
//                                                   color: Colors.black
//                                                       .withOpacity(.06),
//                                                   blurRadius: width * .02,
//                                                   offset:
//                                                       Offset(0, width * .005),
//                                                 ),
//                                               ],
//                                             ),
//                                             child: Row(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 Container(
//                                                   width: width * .06,
//                                                   height: width * .06,
//                                                   decoration:
//                                                       const BoxDecoration(
//                                                     shape: BoxShape.circle,
//                                                     color: Color(0xFFEFF3FF),
//                                                   ),
//                                                   child: Icon(
//                                                       Icons.place_outlined,
//                                                       size: iconSize),
//                                                 ),
//                                                 SizedBox(width: width * .02),
//                                                 Expanded(
//                                                   child: Column(
//                                                     crossAxisAlignment:
//                                                         CrossAxisAlignment
//                                                             .start,
//                                                     children: [
//                                                       Text(
//                                                         main,
//                                                         maxLines: 2,
//                                                         overflow: TextOverflow
//                                                             .ellipsis,
//                                                         style: TextStyle(
//                                                           fontSize:
//                                                               width * .034,
//                                                           fontWeight:
//                                                               FontWeight.w600,
//                                                         ),
//                                                       ),
//                                                       if (secondary
//                                                           .isNotEmpty) ...[
//                                                         SizedBox(
//                                                             height:
//                                                                 width * .005),
//                                                         Text(
//                                                           secondary,
//                                                           maxLines: 2,
//                                                           overflow: TextOverflow
//                                                               .ellipsis,
//                                                           style: TextStyle(
//                                                             fontSize:
//                                                                 width * .028,
//                                                             color: Colors.black
//                                                                 .withOpacity(
//                                                                     .6),
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ],
//                                                   ),
//                                                 ),
//                                                 SizedBox(width: width * .01),
//                                                 Icon(Icons.north_east,
//                                                     size: iconSize,
//                                                     color: Colors.black45),
//                                               ],
//                                             ),
//                                           ),
//                                         );
//                                       },
//                                     );
//                                   }),
//                                 ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

/////////////////
///
///
///
///

import 'dart:async';

import 'package:drivex/core/constants/localVariables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// Google Places (http ^1.x friendly)
import 'package:flutter_google_places_hoc081098/google_maps_webservice_places.dart'
    as gmws;
import 'package:google_api_headers/google_api_headers.dart';

// Current location + reverse geocoding
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import 'package:uuid/uuid.dart';

class D2dPlaceSearchPage extends StatefulWidget {
  const D2dPlaceSearchPage({
    super.key,
    required this.controller, // <-- FROM/TO controller (parent)
    required this.accentColor, // <-- green/red
    required this.label, // <-- "Pickup" or "Destination"
    this.defaultSenderName,
    this.defaultSenderMobile,
  });

  final TextEditingController controller;
  final Color accentColor;
  final String label;

  /// Optional defaults for the confirm sheet
  final String? defaultSenderName;
  final String? defaultSenderMobile;

  @override
  State<D2dPlaceSearchPage> createState() => _D2dPlaceSearchPageState();
}

class _D2dPlaceSearchPageState extends State<D2dPlaceSearchPage> {
  final String googleApiKey = "AIzaSyD1fU_UDudvvy1HEPEoJ4Ify_YOYDlhdEY";

  GoogleMapController? mapController;

  // Search state
  late TextEditingController _searchCtrl; // bound to parent
  final FocusNode _searchFocus = FocusNode();
  Timer? _debounce;
  String _sessionToken = const Uuid().v4();

  List<gmws.Prediction> _results = [];
  bool _loading = false;
  String? _error;

  // Location/state
  LatLng _biasCenter = const LatLng(10.8505, 76.2711); // fallback: Kerala
  String? _currentStateName;
  LatLng? _pendingCameraTarget;

  // Map/markers
  final Set<Marker> _markers = {};
  final CameraPosition _initialPosition = const CameraPosition(
    target: LatLng(10.8505, 76.2711),
    zoom: 14.0,
  );

  // --- Confirm sheet temp values (set on selection) ---
  String? _pendingAddressTitle;
  String? _pendingFullAddress;
  LatLng? _pendingLatLng;

  // Confirm sheet controllers
  final TextEditingController _houseCtrl = TextEditingController();
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _phoneCtrl = TextEditingController();
  final TextEditingController _instructionCtrl = TextEditingController();
  final TextEditingController _pkgOtherCtrl = TextEditingController();

  bool _useMyMobile = false;

  // Package type selection (confirm sheet)
  String? _pkgSelectedKey; // e.g., 'document', 'other'
  bool get _showPkgOtherField => _pkgSelectedKey == 'other';

  // Track whether user confirmed (so we know whether to keep/clear text on pop)
  bool _confirmed = false;

  // Package type map
  final Map<String, Map<String, dynamic>> _packageTypeMap = const {
    'document': {'label': 'Document', 'icon': Icons.description},
    'box': {'label': 'Box', 'icon': Icons.inbox},
    'food': {'label': 'Food', 'icon': Icons.fastfood},
    'gift': {'label': 'Gift', 'icon': Icons.card_giftcard},
    'electronics': {'label': 'Electronics', 'icon': Icons.devices_other},
    'clothes': {'label': 'Clothes', 'icon': Icons.checkroom},
    'fragile': {'label': 'Fragile', 'icon': Icons.emoji_objects},
    'other': {'label': 'Other', 'icon': Icons.more_horiz},
  };

  @override
  void initState() {
    super.initState();
    _searchCtrl = widget.controller; // <-- bind
    _initLocationAndBias();

    // seed defaults for sheet
    _nameCtrl.text = widget.defaultSenderName ?? "";
    _phoneCtrl.text = widget.defaultSenderMobile ?? "";

    _searchFocus.addListener(() {
      if (_searchFocus.hasFocus && _searchCtrl.text.trim().length >= 2) {
        _search(_searchCtrl.text.trim()); // show list again on refocus
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
    if (!_confirmed) {
      _searchCtrl.clear();
    }
    _searchFocus.dispose();
    _debounce?.cancel();
    _houseCtrl.dispose();
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _instructionCtrl.dispose();
    _pkgOtherCtrl.dispose();
    super.dispose();
  }

  // ---------- Init location & state ----------
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
      final places =
          await placemarkFromCoordinates(pos.latitude, pos.longitude);

      setState(() {
        _biasCenter = newCenter;
        _currentStateName =
            places.isNotEmpty ? places.first.administrativeArea : null;
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
    } catch (_) {/* ignore and keep fallback */}
  }

  // ---------- Places search ----------
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
      _currentStateName = detail.result.addressComponents
          .firstWhere(
            (c) => c.types.contains('administrative_area_level_1'),
            orElse: () =>
                gmws.AddressComponent(longName: '', shortName: '', types: []),
          )
          .longName;
      _markers
        ..clear()
        ..add(
          Marker(
            markerId: const MarkerId('picked'),
            position: target,
            infoWindow: InfoWindow(title: title, snippet: fullAddress),
          ),
        );

      _pendingAddressTitle = title;
      _pendingFullAddress = fullAddress;
      _pendingLatLng = target;
    });

    await mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: target, zoom: 16.0),
      ),
    );

    _showConfirmSheet();
  }

  Future<void> _showConfirmSheet() async {
    final String userMobile =
        widget.defaultSenderMobile ?? _phoneCtrl.text; // optional default

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      // ⬇️ No max-height constraints; let it expand to full content height.
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(MediaQuery.of(context).size.width * .05),
        ),
      ),
      builder: (ctx) {
        final width = MediaQuery.of(ctx).size.width;
        final bottomInset = MediaQuery.of(ctx).viewInsets.bottom;
        final inputH = width * .105; // uniform height for all fields
        final packageTypeKeys =
            _packageTypeMap.keys.toList(growable: false); // grid items

        Widget buildLinedField({
          required TextEditingController controller,
          required String hint,
          TextInputType? keyboardType,
          Widget? suffixIcon,
          bool enabled = true,
        }) {
          return SizedBox(
            height: inputH,
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              enabled: enabled,
              maxLines: 1,
              textAlignVertical: TextAlignVertical.center,
              style: TextStyle(fontSize: width * .034),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(fontSize: width * .032),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: width * .035,
                ),
                suffixIcon: suffixIcon,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(width * .03),
                  borderSide: const BorderSide(color: Color(0xFFDFE3EA)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(width * .03),
                  borderSide: const BorderSide(color: Color(0xFFDFE3EA)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(width * .03),
                  borderSide: const BorderSide(color: Color(0xFF2F6BFF)),
                ),
              ),
            ),
          );
        }

        Widget buildPackageTile(
            String key, void Function(VoidCallback) setSheet) {
          final item = _packageTypeMap[key]!;
          final bool isSelected = _pkgSelectedKey == key;

          return GestureDetector(
            onTap: () {
              setSheet(() {
                _pkgSelectedKey = key;
                if (!_showPkgOtherField) _pkgOtherCtrl.clear();
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue.withOpacity(0.05) : null,
                border: Border.all(
                  color:
                      isSelected ? Colors.blue : Colors.black.withOpacity(0.25),
                  width: isSelected ? width * 0.005 : width * 0.003,
                ),
                borderRadius: BorderRadius.circular(width * 0.025),
              ),
              padding: EdgeInsets.symmetric(vertical: width * 0.02),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    item['icon'] as IconData,
                    color: isSelected ? Colors.blue : Colors.black,
                    size: width * 0.07,
                  ),
                  SizedBox(height: width * 0.015),
                  Text(
                    item['label'] as String,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: width * 0.025,
                      color: isSelected ? Colors.blue : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return StatefulBuilder(
          builder: (ctx, setSheet) {
            bool canConfirm() =>
                _nameCtrl.text.trim().isNotEmpty &&
                _phoneCtrl.text.trim().isNotEmpty &&
                _pkgSelectedKey != null; // must select one item in grid

            String? pkgLabel() {
              if (_pkgSelectedKey == null) return null;
              if (_pkgSelectedKey == 'other') {
                final custom = _pkgOtherCtrl.text.trim();
                return custom.isNotEmpty ? custom : 'Other';
              }
              return _packageTypeMap[_pkgSelectedKey!]!['label'] as String;
            }

            return Padding(
              padding: EdgeInsets.only(bottom: bottomInset),
              child: SafeArea(
                top: false,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // ⬅️ Wrap to full content
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // drag handle
                      Center(
                        child: Container(
                          width: width * .18,
                          height: width * .013,
                          margin: EdgeInsets.only(
                              bottom: width * .03, top: width * .02),
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(width * .01),
                          ),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: width * .05,
                          vertical: width * .02,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Location row
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.place,
                                    color: Colors.green, size: width * .05),
                                SizedBox(width: width * .02),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _pendingAddressTitle ?? widget.label,
                                        style: TextStyle(
                                          fontSize: width * .04,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      SizedBox(height: width * .01),
                                      Text(
                                        _pendingFullAddress ?? '',
                                        style: TextStyle(
                                          color: Colors.black87,
                                          height: 1.2,
                                          fontSize: width * .032,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx),
                                  child: Text("Change",
                                      style: TextStyle(fontSize: width * .032)),
                                ),
                              ],
                            ),
                            SizedBox(height: width * .03),

                            // House/Shop
                            buildLinedField(
                              controller: _houseCtrl,
                              hint: "House / Apartment / Shop (optional)",
                            ),
                            SizedBox(height: width * .02),

                            // Sender name
                            Text("Sender's Name",
                                style: TextStyle(
                                    fontSize: width * .032,
                                    fontWeight: FontWeight.w500)),
                            SizedBox(height: width * .01),
                            SizedBox(
                              height: inputH,
                              child: TextField(
                                controller: _nameCtrl,
                                onChanged: (_) => setSheet(() {}),
                                maxLines: 1,
                                textAlignVertical: TextAlignVertical.center,
                                style: TextStyle(fontSize: width * .034),
                                decoration: InputDecoration(
                                  hintText: "Enter sender name",
                                  hintStyle: TextStyle(fontSize: width * .032),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: width * .035),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(width * .03),
                                    borderSide: const BorderSide(
                                        color: Color(0xFFDFE3EA)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(width * .03),
                                    borderSide: const BorderSide(
                                        color: Color(0xFFDFE3EA)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(width * .03),
                                    borderSide: const BorderSide(
                                        color: Color(0xFF2F6BFF)),
                                  ),
                                  suffixIcon: Icon(Icons.recent_actors_outlined,
                                      size: width * .05),
                                ),
                              ),
                            ),
                            SizedBox(height: width * .02),

                            // Sender phone
                            Text("Sender's Mobile number",
                                style: TextStyle(
                                    fontSize: width * .032,
                                    fontWeight: FontWeight.w500)),
                            SizedBox(height: width * .01),
                            SizedBox(
                              height: inputH,
                              child: TextField(
                                controller: _phoneCtrl,
                                keyboardType: TextInputType.phone,
                                onChanged: (_) => setSheet(() {}),
                                maxLines: 1,
                                textAlignVertical: TextAlignVertical.center,
                                style: TextStyle(fontSize: width * .034),
                                decoration: InputDecoration(
                                  hintText: "Enter mobile number",
                                  hintStyle: TextStyle(fontSize: width * .032),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: width * .035),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(width * .03),
                                    borderSide: const BorderSide(
                                        color: Color(0xFFDFE3EA)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(width * .03),
                                    borderSide: const BorderSide(
                                        color: Color(0xFFDFE3EA)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(width * .03),
                                    borderSide: const BorderSide(
                                        color: Color(0xFF2F6BFF)),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: width * .01),

                            // Use my mobile checkbox
                            Row(
                              children: [
                                SizedBox(
                                  width: width * .06,
                                  height: width * .06,
                                  child: Checkbox(
                                    value: _useMyMobile,
                                    onChanged: (v) {
                                      setSheet(() {
                                        _useMyMobile = v ?? false;
                                        if (_useMyMobile &&
                                            userMobile.isNotEmpty) {
                                          _phoneCtrl.text = userMobile;
                                        }
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(width: width * .02),
                                Expanded(
                                  child: Text(
                                    "Use my mobile number${userMobile.isNotEmpty ? " : $userMobile" : ""}",
                                    style: TextStyle(fontSize: width * .032),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: width * .03),

                            // Package Type
                            Text(
                              "Package Type (required)",
                              style: TextStyle(
                                  fontSize: width * .034,
                                  fontWeight: FontWeight.w700),
                            ),
                            SizedBox(height: width * .02),

                            GridView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: packageTypeKeys.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                mainAxisSpacing: width * 0.02,
                                crossAxisSpacing: width * 0.02,
                                childAspectRatio: 1,
                              ),
                              itemBuilder: (context, index) {
                                final key = packageTypeKeys[index];
                                return buildPackageTile(key, setSheet);
                              },
                            ),

                            if (_showPkgOtherField) ...[
                              SizedBox(height: width * .02),
                              SizedBox(
                                height: inputH,
                                child: TextField(
                                  controller: _pkgOtherCtrl,
                                  maxLines: 1,
                                  textAlignVertical: TextAlignVertical.center,
                                  style: TextStyle(fontSize: width * .034),
                                  decoration: const InputDecoration(
                                    labelText: "Enter package type",
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                            ],

                            SizedBox(height: width * .03),

                            // Instruction (single-line, same height)
                            Text(
                              "Courier instruction (optional)",
                              style: TextStyle(
                                  fontSize: width * .032,
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(height: width * .01),
                            SizedBox(
                              height: inputH,
                              child: TextField(
                                controller: _instructionCtrl,
                                maxLines: 1,
                                textAlignVertical: TextAlignVertical.center,
                                style: TextStyle(fontSize: width * .034),
                                decoration: InputDecoration(
                                  hintText:
                                      "E.g. call on arrival, leave with security, fragile, etc.",
                                  hintStyle: TextStyle(fontSize: width * .032),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: width * .035),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(width * .03),
                                    borderSide: const BorderSide(
                                        color: Color(0xFFDFE3EA)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(width * .03),
                                    borderSide: const BorderSide(
                                        color: Color(0xFFDFE3EA)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(width * .03),
                                    borderSide: const BorderSide(
                                        color: Color(0xFF2F6BFF)),
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: width * .04),

                            // Confirm button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: canConfirm()
                                      ? const Color(0xFF2F6BFF)
                                      : const Color(0xFFBFC7DB),
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                    vertical: width * .04,
                                    horizontal: width * .035,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(width * .035),
                                  ),
                                ),
                                onPressed: canConfirm()
                                    ? () {
                                        _confirmed = true;

                                        // write address back to parent textfield
                                        if (_pendingFullAddress != null) {
                                          _searchCtrl.text =
                                              _pendingFullAddress!;
                                        }

                                        final String? pkgKey = _pkgSelectedKey;
                                        final String? pkgText = pkgLabel();
                                        final String? pkgCustom =
                                            _showPkgOtherField &&
                                                    _pkgOtherCtrl.text
                                                        .trim()
                                                        .isNotEmpty
                                                ? _pkgOtherCtrl.text.trim()
                                                : null;

                                        Navigator.pop(ctx);
                                        Navigator.of(context).pop({
                                          'address': _pendingFullAddress ??
                                              _searchCtrl.text,
                                          'latLng': _pendingLatLng,
                                          'label': widget.label,
                                          'house': _houseCtrl.text.trim(),
                                          'senderName': _nameCtrl.text.trim(),
                                          'senderPhone': _phoneCtrl.text.trim(),
                                          'instruction':
                                              _instructionCtrl.text.trim(),
                                          'packageTypeKey':
                                              pkgKey, // e.g., 'food', 'other'
                                          'packageTypeLabel':
                                              pkgText, // user-friendly label
                                          'packageTypeCustom':
                                              pkgCustom // text if "Other"
                                        });
                                      }
                                    : null,
                                child: Text(
                                  "Confirm and Proceed",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: width * .036,
                                  ),
                                ),
                              ),
                            ),
                            if (!canConfirm())
                              Padding(
                                padding: EdgeInsets.only(top: width * .02),
                                child: Text(
                                  "Select a package type, and enter sender name & mobile number to continue.",
                                  style: TextStyle(
                                    color: Colors.red.shade600,
                                    fontSize: width * .03,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width; // <-- width*
    final double spacerTop = width * .05;
    final double fieldHeight = width * .105;
    final double panelPad = width * .0125;
    final double cardRadius = width * .03;
    final double borderWidth = width * .005;
    final double iconSize = width * .034;
    final double gap = width * .01;
    final double maxPanelH = width * .6;

    final String hintText = 'Search ${widget.label.toLowerCase()} location';

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

            // Search + suggestions
            SafeArea(
              child: SizedBox(
                width: width * 1,
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
                                color: widget.accentColor,
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

                        // Search field + suggestion panel
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
                                    hintText: hintText,
                                    hintStyle:
                                        TextStyle(fontSize: width * .032),
                                    prefixIcon: Icon(
                                      Icons.search,
                                      size: iconSize,
                                      color: widget.accentColor,
                                    ),
                                    suffixIcon: _searchCtrl.text.isEmpty
                                        ? null
                                        : IconButton(
                                            icon: Icon(Icons.close,
                                                size: iconSize),
                                            onPressed: () {
                                              setState(() {
                                                _searchCtrl.clear();
                                                _results = [];
                                                _error = null;
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

                              // suggestion panel (INLINE)
                              if (_searchFocus.hasFocus &&
                                  (_loading ||
                                      _results.isNotEmpty ||
                                      (_error != null &&
                                          _searchCtrl.text.isNotEmpty)))
                                Container(
                                  padding: EdgeInsets.all(panelPad),
                                  constraints:
                                      BoxConstraints(maxHeight: maxPanelH),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEDEDED),
                                    borderRadius:
                                        BorderRadius.circular(width * .04),
                                    border: Border.all(
                                      color: Colors.black26,
                                      width: borderWidth,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(.18),
                                        blurRadius: width * .03,
                                        offset: Offset(0, width * .01),
                                      ),
                                    ],
                                  ),
                                  child: Builder(builder: (context) {
                                    if (_loading) {
                                      return SizedBox(
                                        height: width * .08,
                                        child: const Center(
                                          child: CupertinoActivityIndicator(),
                                        ),
                                      );
                                    }

                                    if (_error != null) {
                                      return Padding(
                                        padding: EdgeInsets.all(width * .01),
                                        child: Text(
                                          _error!,
                                          style: TextStyle(
                                            color: Colors.redAccent,
                                            fontSize: width * .032,
                                          ),
                                        ),
                                      );
                                    }

                                    if (_results.isEmpty) {
                                      return Column(
                                        children: List.generate(4, (i) {
                                          return Container(
                                            margin: EdgeInsets.symmetric(
                                              vertical: gap * .6,
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
                                                  offset:
                                                      Offset(0, width * .005),
                                                ),
                                              ],
                                            ),
                                            padding: EdgeInsets.symmetric(
                                              horizontal: width * .022,
                                              vertical: width * .018,
                                            ),
                                            child:
                                                SizedBox(height: width * .03),
                                          );
                                        }),
                                      );
                                    }

                                    // results
                                    return ListView.separated(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      itemCount: _results.length,
                                      separatorBuilder: (_, __) =>
                                          SizedBox(height: gap * .6),
                                      itemBuilder: (context, i) {
                                        final p = _results[i];
                                        final main =
                                            p.structuredFormatting?.mainText ??
                                                (p.description ?? '');
                                        final secondary = p.structuredFormatting
                                                ?.secondaryText ??
                                            '';

                                        return InkWell(
                                          onTap: () => _selectPrediction(p),
                                          borderRadius:
                                              BorderRadius.circular(cardRadius),
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
                                                  offset:
                                                      Offset(0, width * .005),
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
                                                    color: widget.accentColor
                                                        .withOpacity(.12),
                                                  ),
                                                  child: Icon(
                                                    Icons.place_outlined,
                                                    size: iconSize,
                                                    color: widget.accentColor,
                                                  ),
                                                ),
                                                SizedBox(width: width * .02),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        main,
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          fontSize:
                                                              width * .034,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      if (secondary
                                                          .isNotEmpty) ...[
                                                        SizedBox(
                                                            height:
                                                                width * .005),
                                                        Text(
                                                          secondary,
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                            fontSize:
                                                                width * .028,
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    .6),
                                                          ),
                                                        ),
                                                      ],
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(width: width * .01),
                                                Icon(Icons.north_east,
                                                    size: iconSize,
                                                    color: Colors.black45),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }),
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
          ],
        ),
      ),
    );
  }
}
