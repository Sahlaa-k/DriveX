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
//   final String googleApiKey = "AIzaSyDwD1BJXVxky_Cy6xzyQh_5A2PW9cTOO0I";
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
//   final String googleApiKey = "AIzaSyDwD1BJXVxky_Cy6xzyQh_5A2PW9cTOO0I";

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
//   final String googleApiKey = "AIzaSyDwD1BJXVxky_Cy6xzyQh_5A2PW9cTOO0I";

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
//   const D2dPlaceSearchPage({
//     super.key,
//     required this.controller, // <-- FROM/TO controller (parent)
//     required this.accentColor, // <-- green/red
//     required this.label, // <-- "Pickup" or "Destination"
//     this.defaultSenderName,
//     this.defaultSenderMobile,
//   });

//   final TextEditingController controller;
//   final Color accentColor;
//   final String label;

//   /// Optional defaults for the confirm sheet
//   final String? defaultSenderName;
//   final String? defaultSenderMobile;

//   @override
//   State<D2dPlaceSearchPage> createState() => _D2dPlaceSearchPageState();
// }

// class _D2dPlaceSearchPageState extends State<D2dPlaceSearchPage> {
//   final String googleApiKey = "AIzaSyDwD1BJXVxky_Cy6xzyQh_5A2PW9cTOO0I";

//   GoogleMapController? mapController;

//   // Search state
//   late TextEditingController _searchCtrl; // bound to parent
//   final FocusNode _searchFocus = FocusNode();
//   Timer? _debounce;
//   String _sessionToken = const Uuid().v4();

//   List<gmws.Prediction> _results = [];
//   bool _loading = false;
//   String? _error;

//   // Location/state
//   LatLng _biasCenter = const LatLng(10.8505, 76.2711); // fallback: Kerala
//   String? _currentStateName;
//   LatLng? _pendingCameraTarget;

//   // Map/markers
//   final Set<Marker> _markers = {};
//   final CameraPosition _initialPosition = const CameraPosition(
//     target: LatLng(10.8505, 76.2711),
//     zoom: 14.0,
//   );

//   // --- Confirm sheet temp values (set on selection) ---
//   String? _pendingAddressTitle;
//   String? _pendingFullAddress;
//   LatLng? _pendingLatLng;

//   // Confirm sheet controllers
//   final TextEditingController _houseCtrl = TextEditingController();
//   final TextEditingController _nameCtrl = TextEditingController();
//   final TextEditingController _phoneCtrl = TextEditingController();
//   final TextEditingController _instructionCtrl = TextEditingController();
//   final TextEditingController _pkgOtherCtrl = TextEditingController();

//   bool _useMyMobile = false;

//   // Package type selection (confirm sheet)
//   String? _pkgSelectedKey; // e.g., 'document', 'other'
//   bool get _showPkgOtherField => _pkgSelectedKey == 'other';

//   // Track whether user confirmed (so we know whether to keep/clear text on pop)
//   bool _confirmed = false;

//   // Package type map
//   final Map<String, Map<String, dynamic>> _packageTypeMap = const {
//     'document': {'label': 'Document', 'icon': Icons.description},
//     'box': {'label': 'Box', 'icon': Icons.inbox},
//     'food': {'label': 'Food', 'icon': Icons.fastfood},
//     'gift': {'label': 'Gift', 'icon': Icons.card_giftcard},
//     'electronics': {'label': 'Electronics', 'icon': Icons.devices_other},
//     'clothes': {'label': 'Clothes', 'icon': Icons.checkroom},
//     'fragile': {'label': 'Fragile', 'icon': Icons.emoji_objects},
//     'other': {'label': 'Other', 'icon': Icons.more_horiz},
//   };

//   @override
//   void initState() {
//     super.initState();
//     _searchCtrl = widget.controller; // <-- bind
//     _initLocationAndBias();

//     // seed defaults for sheet
//     _nameCtrl.text = widget.defaultSenderName ?? "";
//     _phoneCtrl.text = widget.defaultSenderMobile ?? "";

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
//     if (!_confirmed) {
//       _searchCtrl.clear();
//     }
//     _searchFocus.dispose();
//     _debounce?.cancel();
//     _houseCtrl.dispose();
//     _nameCtrl.dispose();
//     _phoneCtrl.dispose();
//     _instructionCtrl.dispose();
//     _pkgOtherCtrl.dispose();
//     super.dispose();
//   }

//   // ---------- Init location & state ----------
//   Future<void> _initLocationAndBias() async {
//     try {
//       if (!await Geolocator.isLocationServiceEnabled()) return;

//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//       }
//       if (permission == LocationPermission.deniedForever ||
//           permission == LocationPermission.denied) {
//         return;
//       }

//       final pos = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );

//       final newCenter = LatLng(pos.latitude, pos.longitude);
//       final places =
//           await placemarkFromCoordinates(pos.latitude, pos.longitude);

//       setState(() {
//         _biasCenter = newCenter;
//         _currentStateName =
//             places.isNotEmpty ? places.first.administrativeArea : null;
//         _pendingCameraTarget = newCenter;
//       });

//       if (mapController != null) {
//         await mapController!.animateCamera(
//           CameraUpdate.newCameraPosition(
//             CameraPosition(target: newCenter, zoom: 15.0),
//           ),
//         );
//         _pendingCameraTarget = null;
//       }
//     } catch (_) {/* ignore and keep fallback */}
//   }

//   // ---------- Places search ----------
//   Future<void> _onChanged(String text) async {
//     _debounce?.cancel();
//     _debounce = Timer(const Duration(milliseconds: 260), () {
//       _search(text.trim());
//     });
//   }

//   Future<void> _search(String input) async {
//     if (!_searchFocus.hasFocus) return;
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
//         components: [gmws.Component(gmws.Component.country, 'in')],
//         location: gmws.Location(
//           lat: _biasCenter.latitude,
//           lng: _biasCenter.longitude,
//         ),
//         radius: 60000,
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
//     _sessionToken = const Uuid().v4();

//     final places = gmws.GoogleMapsPlaces(
//       apiKey: googleApiKey,
//       apiHeaders: await const GoogleApiHeaders().getHeaders(),
//     );

//     final detail = await places.getDetailsByPlaceId(p.placeId!);
//     final geometry = detail.result.geometry;
//     if (geometry == null) return;

//     final target = LatLng(geometry.location.lat, geometry.location.lng);
//     final title = detail.result.name;
//     final fullAddress =
//         detail.result.formattedAddress ?? (p.description ?? title);

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
//             infoWindow: InfoWindow(title: title, snippet: fullAddress),
//           ),
//         );

//       _pendingAddressTitle = title;
//       _pendingFullAddress = fullAddress;
//       _pendingLatLng = target;
//     });

//     await mapController?.animateCamera(
//       CameraUpdate.newCameraPosition(
//         CameraPosition(target: target, zoom: 16.0),
//       ),
//     );

//     _showConfirmSheet();
//   }

//   Future<void> _showConfirmSheet() async {
//     final String userMobile =
//         widget.defaultSenderMobile ?? _phoneCtrl.text; // optional default

//     await showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.white,
//       // ⬇️ No max-height constraints; let it expand to full content height.
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(
//           top: Radius.circular(MediaQuery.of(context).size.width * .05),
//         ),
//       ),
//       builder: (ctx) {
//         final width = MediaQuery.of(ctx).size.width;
//         final bottomInset = MediaQuery.of(ctx).viewInsets.bottom;
//         final inputH = width * .105; // uniform height for all fields
//         final packageTypeKeys =
//             _packageTypeMap.keys.toList(growable: false); // grid items

//         Widget buildLinedField({
//           required TextEditingController controller,
//           required String hint,
//           TextInputType? keyboardType,
//           Widget? suffixIcon,
//           bool enabled = true,
//         }) {
//           return SizedBox(
//             height: inputH,
//             child: TextField(
//               controller: controller,
//               keyboardType: keyboardType,
//               enabled: enabled,
//               maxLines: 1,
//               textAlignVertical: TextAlignVertical.center,
//               style: TextStyle(fontSize: width * .034),
//               decoration: InputDecoration(
//                 hintText: hint,
//                 hintStyle: TextStyle(fontSize: width * .032),
//                 contentPadding: EdgeInsets.symmetric(
//                   horizontal: width * .035,
//                 ),
//                 suffixIcon: suffixIcon,
//                 filled: true,
//                 fillColor: Colors.white,
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(width * .03),
//                   borderSide: const BorderSide(color: Color(0xFFDFE3EA)),
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(width * .03),
//                   borderSide: const BorderSide(color: Color(0xFFDFE3EA)),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(width * .03),
//                   borderSide: const BorderSide(color: Color(0xFF2F6BFF)),
//                 ),
//               ),
//             ),
//           );
//         }

//         Widget buildPackageTile(
//             String key, void Function(VoidCallback) setSheet) {
//           final item = _packageTypeMap[key]!;
//           final bool isSelected = _pkgSelectedKey == key;

//           return GestureDetector(
//             onTap: () {
//               setSheet(() {
//                 _pkgSelectedKey = key;
//                 if (!_showPkgOtherField) _pkgOtherCtrl.clear();
//               });
//             },
//             child: Container(
//               decoration: BoxDecoration(
//                 color: isSelected ? Colors.blue.withOpacity(0.05) : null,
//                 border: Border.all(
//                   color:
//                       isSelected ? Colors.blue : Colors.black.withOpacity(0.25),
//                   width: isSelected ? width * 0.005 : width * 0.003,
//                 ),
//                 borderRadius: BorderRadius.circular(width * 0.025),
//               ),
//               padding: EdgeInsets.symmetric(vertical: width * 0.02),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     item['icon'] as IconData,
//                     color: isSelected ? Colors.blue : Colors.black,
//                     size: width * 0.07,
//                   ),
//                   SizedBox(height: width * 0.015),
//                   Text(
//                     item['label'] as String,
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontSize: width * 0.025,
//                       color: isSelected ? Colors.blue : Colors.black,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }

//         return StatefulBuilder(
//           builder: (ctx, setSheet) {
//             bool canConfirm() =>
//                 _nameCtrl.text.trim().isNotEmpty &&
//                 _phoneCtrl.text.trim().isNotEmpty &&
//                 _pkgSelectedKey != null; // must select one item in grid

//             String? pkgLabel() {
//               if (_pkgSelectedKey == null) return null;
//               if (_pkgSelectedKey == 'other') {
//                 final custom = _pkgOtherCtrl.text.trim();
//                 return custom.isNotEmpty ? custom : 'Other';
//               }
//               return _packageTypeMap[_pkgSelectedKey!]!['label'] as String;
//             }

//             return Padding(
//               padding: EdgeInsets.only(bottom: bottomInset),
//               child: SafeArea(
//                 top: false,
//                 child: SingleChildScrollView(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min, // ⬅️ Wrap to full content
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // drag handle
//                       Center(
//                         child: Container(
//                           width: width * .18,
//                           height: width * .013,
//                           margin: EdgeInsets.only(
//                               bottom: width * .03, top: width * .02),
//                           decoration: BoxDecoration(
//                             color: Colors.black12,
//                             borderRadius: BorderRadius.circular(width * .01),
//                           ),
//                         ),
//                       ),

//                       Padding(
//                         padding: EdgeInsets.symmetric(
//                           horizontal: width * .05,
//                           vertical: width * .02,
//                         ),
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             // Location row
//                             Row(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Icon(Icons.place,
//                                     color: Colors.green, size: width * .05),
//                                 SizedBox(width: width * .02),
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         _pendingAddressTitle ?? widget.label,
//                                         style: TextStyle(
//                                           fontSize: width * .04,
//                                           fontWeight: FontWeight.w700,
//                                         ),
//                                       ),
//                                       SizedBox(height: width * .01),
//                                       Text(
//                                         _pendingFullAddress ?? '',
//                                         style: TextStyle(
//                                           color: Colors.black87,
//                                           height: 1.2,
//                                           fontSize: width * .032,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 TextButton(
//                                   onPressed: () => Navigator.pop(ctx),
//                                   child: Text("Change",
//                                       style: TextStyle(fontSize: width * .032)),
//                                 ),
//                               ],
//                             ),
//                             SizedBox(height: width * .03),

//                             // House/Shop
//                             buildLinedField(
//                               controller: _houseCtrl,
//                               hint: "House / Apartment / Shop (optional)",
//                             ),
//                             SizedBox(height: width * .02),

//                             // Sender name
//                             Text("Sender's Name",
//                                 style: TextStyle(
//                                     fontSize: width * .032,
//                                     fontWeight: FontWeight.w500)),
//                             SizedBox(height: width * .01),
//                             SizedBox(
//                               height: inputH,
//                               child: TextField(
//                                 controller: _nameCtrl,
//                                 onChanged: (_) => setSheet(() {}),
//                                 maxLines: 1,
//                                 textAlignVertical: TextAlignVertical.center,
//                                 style: TextStyle(fontSize: width * .034),
//                                 decoration: InputDecoration(
//                                   hintText: "Enter sender name",
//                                   hintStyle: TextStyle(fontSize: width * .032),
//                                   contentPadding: EdgeInsets.symmetric(
//                                       horizontal: width * .035),
//                                   filled: true,
//                                   fillColor: Colors.white,
//                                   border: OutlineInputBorder(
//                                     borderRadius:
//                                         BorderRadius.circular(width * .03),
//                                     borderSide: const BorderSide(
//                                         color: Color(0xFFDFE3EA)),
//                                   ),
//                                   enabledBorder: OutlineInputBorder(
//                                     borderRadius:
//                                         BorderRadius.circular(width * .03),
//                                     borderSide: const BorderSide(
//                                         color: Color(0xFFDFE3EA)),
//                                   ),
//                                   focusedBorder: OutlineInputBorder(
//                                     borderRadius:
//                                         BorderRadius.circular(width * .03),
//                                     borderSide: const BorderSide(
//                                         color: Color(0xFF2F6BFF)),
//                                   ),
//                                   suffixIcon: Icon(Icons.recent_actors_outlined,
//                                       size: width * .05),
//                                 ),
//                               ),
//                             ),
//                             SizedBox(height: width * .02),

//                             // Sender phone
//                             Text("Sender's Mobile number",
//                                 style: TextStyle(
//                                     fontSize: width * .032,
//                                     fontWeight: FontWeight.w500)),
//                             SizedBox(height: width * .01),
//                             SizedBox(
//                               height: inputH,
//                               child: TextField(
//                                 controller: _phoneCtrl,
//                                 keyboardType: TextInputType.phone,
//                                 onChanged: (_) => setSheet(() {}),
//                                 maxLines: 1,
//                                 textAlignVertical: TextAlignVertical.center,
//                                 style: TextStyle(fontSize: width * .034),
//                                 decoration: InputDecoration(
//                                   hintText: "Enter mobile number",
//                                   hintStyle: TextStyle(fontSize: width * .032),
//                                   contentPadding: EdgeInsets.symmetric(
//                                       horizontal: width * .035),
//                                   filled: true,
//                                   fillColor: Colors.white,
//                                   border: OutlineInputBorder(
//                                     borderRadius:
//                                         BorderRadius.circular(width * .03),
//                                     borderSide: const BorderSide(
//                                         color: Color(0xFFDFE3EA)),
//                                   ),
//                                   enabledBorder: OutlineInputBorder(
//                                     borderRadius:
//                                         BorderRadius.circular(width * .03),
//                                     borderSide: const BorderSide(
//                                         color: Color(0xFFDFE3EA)),
//                                   ),
//                                   focusedBorder: OutlineInputBorder(
//                                     borderRadius:
//                                         BorderRadius.circular(width * .03),
//                                     borderSide: const BorderSide(
//                                         color: Color(0xFF2F6BFF)),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             SizedBox(height: width * .01),

//                             // Use my mobile checkbox
//                             Row(
//                               children: [
//                                 SizedBox(
//                                   width: width * .06,
//                                   height: width * .06,
//                                   child: Checkbox(
//                                     value: _useMyMobile,
//                                     onChanged: (v) {
//                                       setSheet(() {
//                                         _useMyMobile = v ?? false;
//                                         if (_useMyMobile &&
//                                             userMobile.isNotEmpty) {
//                                           _phoneCtrl.text = userMobile;
//                                         }
//                                       });
//                                     },
//                                   ),
//                                 ),
//                                 SizedBox(width: width * .02),
//                                 Expanded(
//                                   child: Text(
//                                     "Use my mobile number${userMobile.isNotEmpty ? " : $userMobile" : ""}",
//                                     style: TextStyle(fontSize: width * .032),
//                                   ),
//                                 ),
//                               ],
//                             ),

//                             SizedBox(height: width * .03),

//                             // Package Type
//                             Text(
//                               "Package Type (required)",
//                               style: TextStyle(
//                                   fontSize: width * .034,
//                                   fontWeight: FontWeight.w700),
//                             ),
//                             SizedBox(height: width * .02),

//                             GridView.builder(
//                               padding: EdgeInsets.zero,
//                               shrinkWrap: true,
//                               physics: const NeverScrollableScrollPhysics(),
//                               itemCount: packageTypeKeys.length,
//                               gridDelegate:
//                                   SliverGridDelegateWithFixedCrossAxisCount(
//                                 crossAxisCount: 4,
//                                 mainAxisSpacing: width * 0.02,
//                                 crossAxisSpacing: width * 0.02,
//                                 childAspectRatio: 1,
//                               ),
//                               itemBuilder: (context, index) {
//                                 final key = packageTypeKeys[index];
//                                 return buildPackageTile(key, setSheet);
//                               },
//                             ),

//                             if (_showPkgOtherField) ...[
//                               SizedBox(height: width * .02),
//                               SizedBox(
//                                 height: inputH,
//                                 child: TextField(
//                                   controller: _pkgOtherCtrl,
//                                   maxLines: 1,
//                                   textAlignVertical: TextAlignVertical.center,
//                                   style: TextStyle(fontSize: width * .034),
//                                   decoration: const InputDecoration(
//                                     labelText: "Enter package type",
//                                     border: OutlineInputBorder(),
//                                   ),
//                                 ),
//                               ),
//                             ],

//                             SizedBox(height: width * .03),

//                             // Instruction (single-line, same height)
//                             Text(
//                               "Courier instruction (optional)",
//                               style: TextStyle(
//                                   fontSize: width * .032,
//                                   fontWeight: FontWeight.w500),
//                             ),
//                             SizedBox(height: width * .01),
//                             SizedBox(
//                               height: inputH,
//                               child: TextField(
//                                 controller: _instructionCtrl,
//                                 maxLines: 1,
//                                 textAlignVertical: TextAlignVertical.center,
//                                 style: TextStyle(fontSize: width * .034),
//                                 decoration: InputDecoration(
//                                   hintText:
//                                       "E.g. call on arrival, leave with security, fragile, etc.",
//                                   hintStyle: TextStyle(fontSize: width * .032),
//                                   contentPadding: EdgeInsets.symmetric(
//                                       horizontal: width * .035),
//                                   filled: true,
//                                   fillColor: Colors.white,
//                                   border: OutlineInputBorder(
//                                     borderRadius:
//                                         BorderRadius.circular(width * .03),
//                                     borderSide: const BorderSide(
//                                         color: Color(0xFFDFE3EA)),
//                                   ),
//                                   enabledBorder: OutlineInputBorder(
//                                     borderRadius:
//                                         BorderRadius.circular(width * .03),
//                                     borderSide: const BorderSide(
//                                         color: Color(0xFFDFE3EA)),
//                                   ),
//                                   focusedBorder: OutlineInputBorder(
//                                     borderRadius:
//                                         BorderRadius.circular(width * .03),
//                                     borderSide: const BorderSide(
//                                         color: Color(0xFF2F6BFF)),
//                                   ),
//                                 ),
//                               ),
//                             ),

//                             SizedBox(height: width * .04),

//                             // Confirm button
//                             SizedBox(
//                               width: double.infinity,
//                               child: ElevatedButton(
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: canConfirm()
//                                       ? const Color(0xFF2F6BFF)
//                                       : const Color(0xFFBFC7DB),
//                                   foregroundColor: Colors.white,
//                                   padding: EdgeInsets.symmetric(
//                                     vertical: width * .04,
//                                     horizontal: width * .035,
//                                   ),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius:
//                                         BorderRadius.circular(width * .035),
//                                   ),
//                                 ),
//                                 onPressed: canConfirm()
//                                     ? () {
//                                         _confirmed = true;

//                                         // write address back to parent textfield
//                                         if (_pendingFullAddress != null) {
//                                           _searchCtrl.text =
//                                               _pendingFullAddress!;
//                                         }

//                                         final String? pkgKey = _pkgSelectedKey;
//                                         final String? pkgText = pkgLabel();
//                                         final String? pkgCustom =
//                                             _showPkgOtherField &&
//                                                     _pkgOtherCtrl.text
//                                                         .trim()
//                                                         .isNotEmpty
//                                                 ? _pkgOtherCtrl.text.trim()
//                                                 : null;

//                                         Navigator.pop(ctx);
//                                         Navigator.of(context).pop({
//                                           'address': _pendingFullAddress ??
//                                               _searchCtrl.text,
//                                           'latLng': _pendingLatLng,
//                                           'label': widget.label,
//                                           'house': _houseCtrl.text.trim(),
//                                           'senderName': _nameCtrl.text.trim(),
//                                           'senderPhone': _phoneCtrl.text.trim(),
//                                           'instruction':
//                                               _instructionCtrl.text.trim(),
//                                           'packageTypeKey':
//                                               pkgKey, // e.g., 'food', 'other'
//                                           'packageTypeLabel':
//                                               pkgText, // user-friendly label
//                                           'packageTypeCustom':
//                                               pkgCustom // text if "Other"
//                                         });
//                                       }
//                                     : null,
//                                 child: Text(
//                                   "Confirm and Proceed",
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.w700,
//                                     fontSize: width * .036,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             if (!canConfirm())
//                               Padding(
//                                 padding: EdgeInsets.only(top: width * .02),
//                                 child: Text(
//                                   "Select a package type, and enter sender name & mobile number to continue.",
//                                   style: TextStyle(
//                                     color: Colors.red.shade600,
//                                     fontSize: width * .03,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                               ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width; // <-- width*
//     final double spacerTop = width * .05;
//     final double fieldHeight = width * .105;
//     final double panelPad = width * .0125;
//     final double cardRadius = width * .03;
//     final double borderWidth = width * .005;
//     final double iconSize = width * .034;
//     final double gap = width * .01;
//     final double maxPanelH = width * .6;

//     final String hintText = 'Search ${widget.label.toLowerCase()} location';

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

//             // Search + suggestions
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
//                         // colored leading dot
//                         SizedBox(
//                           height: fieldHeight,
//                           child: Center(
//                             child: Container(
//                               width: width * 0.04,
//                               height: width * 0.04,
//                               decoration: BoxDecoration(
//                                 border: Border.all(
//                                   width: width * .005,
//                                   color: Colors.black.withOpacity(.25),
//                                 ),
//                                 color: widget.accentColor,
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

//                         // Search field + suggestion panel
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
//                                     hintText: hintText,
//                                     hintStyle:
//                                         TextStyle(fontSize: width * .032),
//                                     prefixIcon: Icon(
//                                       Icons.search,
//                                       size: iconSize,
//                                       color: widget.accentColor,
//                                     ),
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
//                                         EdgeInsets.only(top: width * .0125),
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
//                                               vertical: width * .018,
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
//                                                   decoration: BoxDecoration(
//                                                     shape: BoxShape.circle,
//                                                     color: widget.accentColor
//                                                         .withOpacity(.12),
//                                                   ),
//                                                   child: Icon(
//                                                     Icons.place_outlined,
//                                                     size: iconSize,
//                                                     color: widget.accentColor,
//                                                   ),
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

// ----------------------

// import 'dart:async';
// import 'package:cloud_firestore/cloud_firestore.dart';
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
//   const D2dPlaceSearchPage({
//     super.key,
//     required this.controller, // <-- FROM/TO controller (parent)
//     required this.accentColor, // <-- green/red
//     required this.label, // <-- "Pickup" / "Drop" / "Stop ..."
//     required this.gServiceDb, // <-- SECONDARY FIREBASE (g-service-d45fd)
//     this.defaultSenderName,
//     this.defaultSenderMobile,
//   });

//   final TextEditingController controller;
//   final Color accentColor;
//   final String label;

//   final FirebaseFirestore gServiceDb; // <- pass secondary Firestore here

//   /// Optional defaults for the confirm sheet
//   final String? defaultSenderName;
//   final String? defaultSenderMobile;

//   @override
//   State<D2dPlaceSearchPage> createState() => _D2dPlaceSearchPageState();
// }

// /// Unified item used in the suggestions list (local or Google)
// class PlaceItem {
//   final String id; // doc id (local) or placeId (google) or generated
//   final String title; // main display
//   final String subtitle; // secondary line (address)
//   final LatLng?
//       latLng; // if known (local will have it; google prediction: null)
//   final String source; // 'local' or 'google'
//   final DocumentReference<Map<String, dynamic>>? docRef; // for local documents
//   final gmws.Prediction? prediction; // for google items

//   PlaceItem({
//     required this.id,
//     required this.title,
//     required this.subtitle,
//     required this.source,
//     this.latLng,
//     this.docRef,
//     this.prediction,
//   });
// }

// class _D2dPlaceSearchPageState extends State<D2dPlaceSearchPage> {
//   // Set your Places API key (use the g-service key if you keep keys per project)
//   final String googleApiKey = "AIzaSyBn8rqTzw0fku-HIgCZnnkFQheufH9ZXDw";

//   // ---- Map ----
//   GoogleMapController? mapController;
//   final Set<Marker> _markers = {};
//   final CameraPosition _initialPosition = const CameraPosition(
//     target: LatLng(10.8505, 76.2711), // Kerala fallback
//     zoom: 14.0,
//   );

//   // ---- Search state ----
//   late TextEditingController _searchCtrl; // bound to parent
//   final FocusNode _searchFocus = FocusNode();
//   Timer? _debounce;
//   String _sessionToken = const Uuid().v4();

//   List<PlaceItem> _results = [];
//   bool _loading = false;
//   String? _error;

//   // ---- Location bias ----
//   LatLng _biasCenter = const LatLng(10.8505, 76.2711);
//   String? _currentStateName;
//   LatLng? _pendingCameraTarget;

//   // ---- Confirm-sheet pre-fill ----
//   String? _pendingAddressTitle;
//   String? _pendingFullAddress;
//   LatLng? _pendingLatLng;

//   // ---- Confirm sheet controllers ----
//   final TextEditingController _houseCtrl = TextEditingController();
//   final TextEditingController _nameCtrl = TextEditingController();
//   final TextEditingController _phoneCtrl = TextEditingController();
//   final TextEditingController _instructionCtrl = TextEditingController();
//   final TextEditingController _pkgOtherCtrl = TextEditingController();

//   bool _useMyMobile = false;
//   String? _pkgSelectedKey; // e.g., 'document', 'other'
//   bool get _showPkgOtherField => _pkgSelectedKey == 'other';
//   bool _confirmed = false; // to decide if we should clear parent field on back

//   // ---- Selected place metadata (for saving) ----
//   String? _selectedPlaceId; // google placeId or null for local cache hit
//   String _selectedSource = 'google'; // 'google' or 'local'

//   // ---- Package type map (for confirm sheet) ----
//   final Map<String, Map<String, dynamic>> _packageTypeMap = const {
//     'document': {'label': 'Document', 'icon': Icons.description},
//     'box': {'label': 'Box', 'icon': Icons.inbox},
//     'food': {'label': 'Food', 'icon': Icons.fastfood},
//     'gift': {'label': 'Gift', 'icon': Icons.card_giftcard},
//     'electronics': {'label': 'Electronics', 'icon': Icons.devices_other},
//     'clothes': {'label': 'Clothes', 'icon': Icons.checkroom},
//     'fragile': {'label': 'Fragile', 'icon': Icons.emoji_objects},
//     'other': {'label': 'Other', 'icon': Icons.more_horiz},
//   };

//   @override
//   void initState() {
//     super.initState();
//     _searchCtrl = widget.controller; // bind to parent
//     _nameCtrl.text = widget.defaultSenderName ?? "";
//     _phoneCtrl.text = widget.defaultSenderMobile ?? "";
//     _initLocationAndBias();

//     _searchFocus.addListener(() {
//       // Re-run search when focus comes back (if there is text)
//       if (_searchFocus.hasFocus && _searchCtrl.text.trim().length >= 2) {
//         _search(_searchCtrl.text.trim());
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
//     _debounce?.cancel();
//     _searchFocus.dispose();
//     if (!_confirmed) {
//       _searchCtrl.clear(); // clear user input on back if not confirmed
//     }
//     _houseCtrl.dispose();
//     _nameCtrl.dispose();
//     _phoneCtrl.dispose();
//     _instructionCtrl.dispose();
//     _pkgOtherCtrl.dispose();
//     super.dispose();
//   }

//   // ---------- Location bias ----------
//   Future<void> _initLocationAndBias() async {
//     try {
//       if (!await Geolocator.isLocationServiceEnabled()) return;

//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//       }
//       if (permission == LocationPermission.deniedForever ||
//           permission == LocationPermission.denied) {
//         return;
//       }

//       final pos = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );

//       final newCenter = LatLng(pos.latitude, pos.longitude);
//       final places =
//           await placemarkFromCoordinates(pos.latitude, pos.longitude);

//       if (!mounted) return;
//       setState(() {
//         _biasCenter = newCenter;
//         _currentStateName =
//             places.isNotEmpty ? places.first.administrativeArea : null;
//         _pendingCameraTarget = newCenter;
//       });

//       if (mapController != null && _pendingCameraTarget != null) {
//         await mapController!.animateCamera(
//           CameraUpdate.newCameraPosition(
//             CameraPosition(target: _pendingCameraTarget!, zoom: 15.0),
//           ),
//         );
//         _pendingCameraTarget = null;
//       }
//     } catch (_) {
//       // ignore
//     }
//   }

//   // ---------- SEARCH: Local Firestore first, then Google ----------
//   Future<void> _onChanged(String text) async {
//     _debounce?.cancel();
//     _debounce = Timer(const Duration(milliseconds: 260), () {
//       _search(text.trim());
//     });
//   }

//   Future<void> _search(String input) async {
//     if (!_searchFocus.hasFocus) return;

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
//       _results = [];
//     });

//     try {
//       // 1) LOCAL (secondary Firestore) prefix search on lowercased name
//       final local = await _searchLocal(input);

//       if (!mounted) return;

//       if (local.isNotEmpty) {
//         setState(() {
//           _results = local;
//           _loading = false;
//         });
//         return; // ✅ found local results; don't hit Google
//       }

//       // 2) GOOGLE Places autocomplete (fallback)
//       final places = gmws.GoogleMapsPlaces(
//         apiKey: googleApiKey,
//         apiHeaders: await const GoogleApiHeaders().getHeaders(),
//       );

//       final resp = await places.autocomplete(
//         input,
//         sessionToken: _sessionToken,
//         language: 'en',
//         components: [gmws.Component(gmws.Component.country, 'in')],
//         location: gmws.Location(
//             lat: _biasCenter.latitude, lng: _biasCenter.longitude),
//         radius: 60000,
//         strictbounds: false,
//       );

//       if (!mounted) return;

//       if (resp.isOkay) {
//         final items = resp.predictions.map((p) {
//           final main =
//               p.structuredFormatting?.mainText ?? (p.description ?? '');
//           final secondary = p.structuredFormatting?.secondaryText ?? '';
//           return PlaceItem(
//             id: p.placeId ?? const Uuid().v4(),
//             title: main,
//             subtitle: secondary,
//             source: 'google',
//             prediction: p,
//           );
//         }).toList();

//         setState(() {
//           _results = items;
//           _error = null;
//           _loading = false;
//         });
//       } else {
//         setState(() {
//           _results = [];
//           _error = resp.errorMessage ?? 'No results';
//           _loading = false;
//         });
//       }
//     } catch (e) {
//       if (!mounted) return;
//       setState(() {
//         _results = [];
//         _error = e.toString();
//         _loading = false;
//       });
//     }
//   }

//   Future<List<PlaceItem>> _searchLocal(String q) async {
//     final qlc = q.toLowerCase();

//     // Firestore range query on name_lc for prefix match (SECONDARY DB)
//     final snap = await widget.gServiceDb
//         .collection('places_cache') // lives in g-service
//         .orderBy('name_lc')
//         .startAt([qlc])
//         .endAt([qlc + '\uf8ff'])
//         .limit(12)
//         .get();

//     return snap.docs.map((d) {
//       final data = d.data();
//       final title = (data['name'] ?? '') as String;
//       final address = (data['address'] ?? '') as String;
//       final lat = (data['lat'] as num?)?.toDouble();
//       final lng = (data['lng'] as num?)?.toDouble();
//       final LatLng? ll = (lat != null && lng != null) ? LatLng(lat, lng) : null;

//       return PlaceItem(
//         id: d.id,
//         title: title,
//         subtitle: address,
//         latLng: ll,
//         source: 'local',
//         docRef: d.reference,
//       );
//     }).toList();
//   }

//   // ---------- Selection ----------
//   Future<void> _selectItem(PlaceItem item) async {
//     // new autocomplete session if user taps an item
//     _sessionToken = const Uuid().v4();

//     if (item.source == 'local') {
//       _selectedSource = 'local';
//       _selectedPlaceId = null; // local objects don’t guarantee Google placeId
//       final target = item.latLng;
//       if (target != null) {
//         await _onPickedTarget(
//           title: item.title,
//           fullAddress: item.subtitle,
//           target: target,
//         );
//         // bump hits for analytics
//         await item.docRef?.set({
//           'hits': FieldValue.increment(1),
//           'updatedAt': FieldValue.serverTimestamp(),
//         }, SetOptions(merge: true));
//       }
//       return;
//     }

//     // source == 'google' -> fetch details, cache, then open confirm
//     try {
//       _selectedSource = 'google';

//       final placeId = item.prediction?.placeId;
//       if (placeId == null) return;
//       _selectedPlaceId = placeId;

//       final places = gmws.GoogleMapsPlaces(
//         apiKey: googleApiKey,
//         apiHeaders: await const GoogleApiHeaders().getHeaders(),
//       );

//       final detail = await places.getDetailsByPlaceId(placeId);
//       if (!detail.isOkay) {
//         if (!mounted) return;
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//               content: Text(detail.errorMessage ?? 'Place details failed')),
//         );
//         return;
//       }

//       final geometry = detail.result.geometry;
//       if (geometry == null) return;

//       final target = LatLng(geometry.location.lat, geometry.location.lng);
//       final title = detail.result.name;
//       final fullAddress = detail.result.formattedAddress ??
//           (item.subtitle.isNotEmpty ? item.subtitle : item.title);

//       // Save to secondary Firestore (cache)
//       await _upsertCache(
//         placeId: placeId,
//         name: title,
//         address: fullAddress,
//         latLng: target,
//         stateName: detail.result.addressComponents
//             .firstWhere(
//               (c) => c.types.contains('administrative_area_level_1'),
//               orElse: () => gmws.AddressComponent(
//                   longName: _currentStateName ?? '', shortName: '', types: []),
//             )
//             .longName,
//       );

//       await _onPickedTarget(
//           title: title, fullAddress: fullAddress, target: target);
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to fetch place details: $e')),
//       );
//     }
//   }

//   // ---------- Save selection to dService (SECONDARY DB) ----------
//   Future<void> _saveSelectionToDService({
//     required String label,
//     required String address,
//     required LatLng latLng,
//     required String senderName,
//     required String senderPhone,
//     String? house,
//     String? instruction,
//     String? packageTypeKey,
//     String? packageTypeLabel,
//     String? packageTypeCustom,
//   }) async {
//     // Split per-flow collections by label for easier querying
//     final col = label.toLowerCase().contains('drop')
//         ? 'dservice_drop_places'
//         : label.toLowerCase().contains('pickup')
//             ? 'dservice_pickup_places'
//             : 'dservice_stop_places';

//     await widget.gServiceDb.collection(col).add({
//       // place info
//       'placeId': _selectedPlaceId, // null for local-only
//       'source': _selectedSource, // 'google' or 'local'
//       'label': label,
//       'address': address,
//       'lat': latLng.latitude,
//       'lng': latLng.longitude,
//       'state': _currentStateName,

//       // sheet details
//       'house': house,
//       'instruction': instruction,
//       'senderName': senderName,
//       'senderPhone': senderPhone,
//       'packageTypeKey': packageTypeKey,
//       'packageTypeLabel': packageTypeLabel,
//       'packageTypeCustom': packageTypeCustom,

//       // bookkeeping
//       'createdAt': FieldValue.serverTimestamp(),
//       'updatedAt': FieldValue.serverTimestamp(),
//     });
//   }

//   // ---------- Cache upsert in SECONDARY DB ----------
//   Future<void> _upsertCache({
//     required String placeId,
//     required String name,
//     required String address,
//     required LatLng latLng,
//     String? stateName,
//   }) async {
//     final nameLc = name.toLowerCase();

//     final byId = await widget.gServiceDb
//         .collection('places_cache') // lives in g-service
//         .where('placeId', isEqualTo: placeId)
//         .limit(1)
//         .get();

//     final data = {
//       'placeId': placeId,
//       'name': name,
//       'name_lc': nameLc,
//       'address': address,
//       'lat': latLng.latitude,
//       'lng': latLng.longitude,
//       'state': stateName ?? _currentStateName,
//       'hits': FieldValue.increment(1),
//       'updatedAt': FieldValue.serverTimestamp(),
//       'createdAt': FieldValue.serverTimestamp(),
//     };

//     if (byId.docs.isNotEmpty) {
//       await byId.docs.first.reference.set(data, SetOptions(merge: true));
//     } else {
//       await widget.gServiceDb.collection('places_cache').add(data);
//     }
//   }

//   // ---------- After picking target on map ----------
//   Future<void> _onPickedTarget({
//     required String title,
//     required String fullAddress,
//     required LatLng target,
//   }) async {
//     setState(() {
//       _biasCenter = target;
//       _markers
//         ..clear()
//         ..add(
//           Marker(
//             markerId: const MarkerId('picked'),
//             position: target,
//             infoWindow: InfoWindow(title: title, snippet: fullAddress),
//           ),
//         );

//       _pendingAddressTitle = title;
//       _pendingFullAddress = fullAddress;
//       _pendingLatLng = target;
//     });

//     await mapController?.animateCamera(
//       CameraUpdate.newCameraPosition(
//         CameraPosition(target: target, zoom: 16.0),
//       ),
//     );

//     if (mounted) _showConfirmSheet();
//   }

//   // ---------- UI ----------
//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width; // <-- width*
//     final double spacerTop = width * .05;
//     final double fieldHeight = width * .105;
//     final double panelPad = width * .0125;
//     final double cardRadius = width * .03;
//     final double borderWidth = width * .005;
//     final double iconSize = width * .034;
//     final double gap = width * .01;

//     final String hintText = 'Search ${widget.label.toLowerCase()} location';

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

//             // Search + suggestions
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
//                         // colored leading dot
//                         SizedBox(
//                           height: fieldHeight,
//                           child: Center(
//                             child: Container(
//                               width: width * 0.04,
//                               height: width * 0.04,
//                               decoration: BoxDecoration(
//                                 border: Border.all(
//                                   width: width * .005,
//                                   color: Colors.black.withOpacity(.25),
//                                 ),
//                                 color: widget.accentColor,
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

//                         // Search field + suggestion panel
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
//                                     hintText: hintText,
//                                     hintStyle:
//                                         TextStyle(fontSize: width * .032),
//                                     prefixIcon: Icon(Icons.search,
//                                         size: iconSize,
//                                         color: widget.accentColor),
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
//                                         EdgeInsets.only(top: width * .0125),
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
//                                   decoration: BoxDecoration(
//                                     color: const Color(0xFFEDEDED),
//                                     borderRadius:
//                                         BorderRadius.circular(width * .04),
//                                     border: Border.all(
//                                         color: Colors.black26,
//                                         width: borderWidth),
//                                     boxShadow: [
//                                       BoxShadow(
//                                         color: Colors.black.withOpacity(.18),
//                                         blurRadius: width * .03,
//                                         offset: Offset(0, width * .01),
//                                       ),
//                                     ],
//                                   ),
//                                   child: Column(
//                                     children: [
//                                       Align(
//                                         alignment: Alignment.centerLeft,
//                                         child: Padding(
//                                           padding: EdgeInsets.symmetric(
//                                               vertical: gap * .5,
//                                               horizontal: gap * .5),
//                                           child: Text(
//                                             _results.isNotEmpty &&
//                                                     _results.first.source ==
//                                                         'local'
//                                                 ? "from g-service cache"
//                                                 : "popular locations near you",
//                                             style: TextStyle(
//                                               fontSize: width * .028,
//                                               color: Colors.black54,
//                                               fontWeight: FontWeight.w500,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                       Builder(builder: (context) {
//                                         if (_loading) {
//                                           return SizedBox(
//                                             height: width * .08,
//                                             child: const Center(
//                                                 child:
//                                                     CupertinoActivityIndicator()),
//                                           );
//                                         }

//                                         if (_error != null) {
//                                           return Padding(
//                                             padding:
//                                                 EdgeInsets.all(width * .01),
//                                             child: Text(
//                                               _error!,
//                                               style: TextStyle(
//                                                 color: Colors.redAccent,
//                                                 fontSize: width * .032,
//                                               ),
//                                             ),
//                                           );
//                                         }

//                                         if (_results.isEmpty) {
//                                           // skeletons
//                                           return Column(
//                                             children: List.generate(4, (i) {
//                                               return Container(
//                                                 margin: EdgeInsets.symmetric(
//                                                     vertical: gap * .6),
//                                                 decoration: BoxDecoration(
//                                                   color: Colors.white,
//                                                   borderRadius:
//                                                       BorderRadius.circular(
//                                                           cardRadius),
//                                                   boxShadow: [
//                                                     BoxShadow(
//                                                       color: Colors.black
//                                                           .withOpacity(.06),
//                                                       blurRadius: width * .02,
//                                                       offset: Offset(
//                                                           0, width * .005),
//                                                     ),
//                                                   ],
//                                                 ),
//                                                 padding: EdgeInsets.symmetric(
//                                                   horizontal: width * .022,
//                                                   vertical: width * .018,
//                                                 ),
//                                                 child: SizedBox(
//                                                     height: width * .03),
//                                               );
//                                             }),
//                                           );
//                                         }

//                                         // results
//                                         return ListView.separated(
//                                           padding: EdgeInsets.zero,
//                                           shrinkWrap: true,
//                                           itemCount: _results.length,
//                                           separatorBuilder: (_, __) =>
//                                               SizedBox(height: gap * .6),
//                                           itemBuilder: (context, i) {
//                                             final item = _results[i];

//                                             return InkWell(
//                                               onTap: () => _selectItem(item),
//                                               borderRadius:
//                                                   BorderRadius.circular(
//                                                       cardRadius),
//                                               child: Container(
//                                                 padding: EdgeInsets.symmetric(
//                                                   horizontal: width * .022,
//                                                   vertical: width * .018,
//                                                 ),
//                                                 decoration: BoxDecoration(
//                                                   color: Colors.white,
//                                                   borderRadius:
//                                                       BorderRadius.circular(
//                                                           cardRadius),
//                                                   boxShadow: [
//                                                     BoxShadow(
//                                                       color: Colors.black
//                                                           .withOpacity(.06),
//                                                       blurRadius: width * .02,
//                                                       offset: Offset(
//                                                           0, width * .005),
//                                                     ),
//                                                   ],
//                                                 ),
//                                                 child: Row(
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.start,
//                                                   children: [
//                                                     Container(
//                                                       width: width * .06,
//                                                       height: width * .06,
//                                                       decoration: BoxDecoration(
//                                                         shape: BoxShape.circle,
//                                                         color: (item.source ==
//                                                                     'local'
//                                                                 ? Colors.green
//                                                                 : widget
//                                                                     .accentColor)
//                                                             .withOpacity(.12),
//                                                       ),
//                                                       child: Icon(
//                                                         item.source == 'local'
//                                                             ? Icons
//                                                                 .cloud_done_outlined
//                                                             : Icons
//                                                                 .place_outlined,
//                                                         size: iconSize,
//                                                         color: item.source ==
//                                                                 'local'
//                                                             ? Colors.green
//                                                             : widget
//                                                                 .accentColor,
//                                                       ),
//                                                     ),
//                                                     SizedBox(
//                                                         width: width * .02),
//                                                     Expanded(
//                                                       child: Column(
//                                                         crossAxisAlignment:
//                                                             CrossAxisAlignment
//                                                                 .start,
//                                                         children: [
//                                                           Text(
//                                                             item.title,
//                                                             maxLines: 2,
//                                                             overflow:
//                                                                 TextOverflow
//                                                                     .ellipsis,
//                                                             style: TextStyle(
//                                                               fontSize:
//                                                                   width * .034,
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .w600,
//                                                             ),
//                                                           ),
//                                                           if (item.subtitle
//                                                               .isNotEmpty) ...[
//                                                             SizedBox(
//                                                                 height: width *
//                                                                     .005),
//                                                             Text(
//                                                               item.subtitle,
//                                                               maxLines: 2,
//                                                               overflow:
//                                                                   TextOverflow
//                                                                       .ellipsis,
//                                                               style: TextStyle(
//                                                                 fontSize:
//                                                                     width *
//                                                                         .028,
//                                                                 color: Colors
//                                                                     .black
//                                                                     .withOpacity(
//                                                                         .6),
//                                                               ),
//                                                             ),
//                                                           ],
//                                                         ],
//                                                       ),
//                                                     ),
//                                                     SizedBox(
//                                                         width: width * .01),
//                                                     Icon(Icons.north_east,
//                                                         size: iconSize,
//                                                         color: Colors.black45),
//                                                   ],
//                                                 ),
//                                               ),
//                                             );
//                                           },
//                                         );
//                                       }),
//                                       SizedBox(height: gap),
//                                     ],
//                                   ),
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

//   // ---------- Confirm Sheet ----------
//   Future<void> _showConfirmSheet() async {
//     if (!mounted) return; // avoid duplicate sheets

//     await showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.white,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(
//           top: Radius.circular(MediaQuery.of(context).size.width * .05),
//         ),
//       ),
//       builder: (sheetCtx) {
//         final width = MediaQuery.of(sheetCtx).size.width;
//         final bottomInset = MediaQuery.of(sheetCtx).viewInsets.bottom;
//         final inputH = width * .105;
//         final packageTypeKeys = _packageTypeMap.keys.toList(growable: false);

//         Widget buildLinedField({
//           required TextEditingController controller,
//           required String hint,
//           TextInputType? keyboardType,
//           Widget? suffixIcon,
//           bool enabled = true,
//         }) {
//           return SizedBox(
//             height: inputH,
//             child: TextField(
//               controller: controller,
//               keyboardType: keyboardType,
//               enabled: enabled,
//               maxLines: 1,
//               textAlignVertical: TextAlignVertical.center,
//               style: TextStyle(fontSize: width * .034),
//               decoration: InputDecoration(
//                 hintText: hint,
//                 hintStyle: TextStyle(fontSize: width * .032),
//                 contentPadding: EdgeInsets.symmetric(horizontal: width * .035),
//                 suffixIcon: suffixIcon,
//                 filled: true,
//                 fillColor: Colors.white,
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(width * .03),
//                   borderSide: const BorderSide(color: Color(0xFFDFE3EA)),
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(width * .03),
//                   borderSide: const BorderSide(color: Color(0xFFDFE3EA)),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(width * .03),
//                   borderSide: const BorderSide(color: Color(0xFF2F6BFF)),
//                 ),
//               ),
//             ),
//           );
//         }

//         Widget buildPackageTile(
//           String key,
//           void Function(VoidCallback) setSheet,
//         ) {
//           final item = _packageTypeMap[key]!;
//           final bool isSelected = _pkgSelectedKey == key;

//           return GestureDetector(
//             onTap: () {
//               setSheet(() {
//                 _pkgSelectedKey = key;
//                 if (!_showPkgOtherField) _pkgOtherCtrl.clear();
//               });
//             },
//             child: Container(
//               decoration: BoxDecoration(
//                 color: isSelected ? Colors.blue.withOpacity(0.05) : null,
//                 border: Border.all(
//                   color:
//                       isSelected ? Colors.blue : Colors.black.withOpacity(0.25),
//                   width: isSelected ? width * 0.005 : width * 0.003,
//                 ),
//                 borderRadius: BorderRadius.circular(width * 0.025),
//               ),
//               padding: EdgeInsets.symmetric(vertical: width * 0.02),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     item['icon'] as IconData,
//                     color: isSelected ? Colors.blue : Colors.black,
//                     size: width * 0.07,
//                   ),
//                   SizedBox(height: width * 0.015),
//                   Text(
//                     item['label'] as String,
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontSize: width * 0.025,
//                       color: isSelected ? Colors.blue : Colors.black,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }

//         return StatefulBuilder(
//           builder: (ctx, setSheet) {
//             bool canConfirm() =>
//                 _nameCtrl.text.trim().isNotEmpty &&
//                 _phoneCtrl.text.trim().isNotEmpty &&
//                 _pkgSelectedKey != null &&
//                 _pendingLatLng != null;

//             String? pkgLabel() {
//               if (_pkgSelectedKey == null) return null;
//               if (_pkgSelectedKey == 'other') {
//                 final custom = _pkgOtherCtrl.text.trim();
//                 return custom.isNotEmpty ? custom : 'Other';
//               }
//               return _packageTypeMap[_pkgSelectedKey!]!['label'] as String;
//             }

//             return Padding(
//               padding: EdgeInsets.only(bottom: bottomInset),
//               child: SafeArea(
//                 top: false,
//                 child: SingleChildScrollView(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // drag handle
//                       Center(
//                         child: Container(
//                           width: width * .18,
//                           height: width * .013,
//                           margin: EdgeInsets.only(
//                               bottom: width * .03, top: width * .02),
//                           decoration: BoxDecoration(
//                             color: Colors.black12,
//                             borderRadius: BorderRadius.circular(width * .01),
//                           ),
//                         ),
//                       ),

//                       Padding(
//                         padding: EdgeInsets.symmetric(
//                             horizontal: width * .05, vertical: width * .02),
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             // Location row
//                             Row(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Icon(Icons.place,
//                                     color: Colors.green, size: width * .05),
//                                 SizedBox(width: width * .02),
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         _pendingAddressTitle ?? widget.label,
//                                         style: TextStyle(
//                                           fontSize: width * .04,
//                                           fontWeight: FontWeight.w700,
//                                         ),
//                                       ),
//                                       SizedBox(height: width * .01),
//                                       Text(
//                                         _pendingFullAddress ?? '',
//                                         style: TextStyle(
//                                           color: Colors.black87,
//                                           height: 1.2,
//                                           fontSize: width * .032,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 TextButton(
//                                   onPressed: () => Navigator.pop(sheetCtx),
//                                   child: Text("Change",
//                                       style: TextStyle(fontSize: width * .032)),
//                                 ),
//                               ],
//                             ),
//                             SizedBox(height: width * .03),

//                             // House/Shop
//                             buildLinedField(
//                               controller: _houseCtrl,
//                               hint: "House / Apartment / Shop (optional)",
//                             ),
//                             SizedBox(height: width * .02),

//                             // Sender name
//                             Text("Sender's Name",
//                                 style: TextStyle(
//                                     fontSize: width * .032,
//                                     fontWeight: FontWeight.w500)),
//                             SizedBox(height: width * .01),
//                             SizedBox(
//                               height: inputH,
//                               child: TextField(
//                                 controller: _nameCtrl,
//                                 onChanged: (_) => setSheet(() {}),
//                                 maxLines: 1,
//                                 textAlignVertical: TextAlignVertical.center,
//                                 style: TextStyle(fontSize: width * .034),
//                                 decoration: InputDecoration(
//                                   hintText: "Enter sender name",
//                                   hintStyle: TextStyle(fontSize: width * .032),
//                                   contentPadding: EdgeInsets.symmetric(
//                                       horizontal: width * .035),
//                                   filled: true,
//                                   fillColor: Colors.white,
//                                   border: OutlineInputBorder(
//                                     borderRadius:
//                                         BorderRadius.circular(width * .03),
//                                     borderSide: const BorderSide(
//                                         color: Color(0xFFDFE3EA)),
//                                   ),
//                                   enabledBorder: OutlineInputBorder(
//                                     borderRadius:
//                                         BorderRadius.circular(width * .03),
//                                     borderSide: const BorderSide(
//                                         color: Color(0xFFDFE3EA)),
//                                   ),
//                                   focusedBorder: OutlineInputBorder(
//                                     borderRadius:
//                                         BorderRadius.circular(width * .03),
//                                     borderSide: const BorderSide(
//                                         color: Color(0xFF2F6BFF)),
//                                   ),
//                                   suffixIcon: Icon(Icons.recent_actors_outlined,
//                                       size: width * .05),
//                                 ),
//                               ),
//                             ),
//                             SizedBox(height: width * .02),

//                             // Sender phone
//                             Text("Sender's Mobile number",
//                                 style: TextStyle(
//                                     fontSize: width * .032,
//                                     fontWeight: FontWeight.w500)),
//                             SizedBox(height: width * .01),
//                             SizedBox(
//                               height: inputH,
//                               child: TextField(
//                                 controller: _phoneCtrl,
//                                 keyboardType: TextInputType.phone,
//                                 onChanged: (_) => setSheet(() {}),
//                                 maxLines: 1,
//                                 textAlignVertical: TextAlignVertical.center,
//                                 style: TextStyle(fontSize: width * .034),
//                                 decoration: InputDecoration(
//                                   hintText: "Enter mobile number",
//                                   hintStyle: TextStyle(fontSize: width * .032),
//                                   contentPadding: EdgeInsets.symmetric(
//                                       horizontal: width * .035),
//                                   filled: true,
//                                   fillColor: Colors.white,
//                                   border: OutlineInputBorder(
//                                     borderRadius:
//                                         BorderRadius.circular(width * .03),
//                                     borderSide: const BorderSide(
//                                         color: Color(0xFFDFE3EA)),
//                                   ),
//                                   enabledBorder: OutlineInputBorder(
//                                     borderRadius:
//                                         BorderRadius.circular(width * .03),
//                                     borderSide: const BorderSide(
//                                         color: Color(0xFFDFE3EA)),
//                                   ),
//                                   focusedBorder: OutlineInputBorder(
//                                     borderRadius:
//                                         BorderRadius.circular(width * .03),
//                                     borderSide: const BorderSide(
//                                         color: Color(0xFF2F6BFF)),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             SizedBox(height: width * .01),

//                             // Use my mobile checkbox
//                             Row(
//                               children: [
//                                 SizedBox(
//                                   width: width * .06,
//                                   height: width * .06,
//                                   child: Checkbox(
//                                     value: _useMyMobile,
//                                     onChanged: (v) {
//                                       setSheet(() {
//                                         _useMyMobile = v ?? false;
//                                         final def =
//                                             widget.defaultSenderMobile ?? '';
//                                         if (_useMyMobile && def.isNotEmpty) {
//                                           _phoneCtrl.text = def;
//                                         }
//                                       });
//                                     },
//                                   ),
//                                 ),
//                                 SizedBox(width: width * .02),
//                                 Expanded(
//                                   child: Text(
//                                     "Use my mobile number${(widget.defaultSenderMobile ?? '').isNotEmpty ? " : ${widget.defaultSenderMobile}" : ""}",
//                                     style: TextStyle(fontSize: width * .032),
//                                   ),
//                                 ),
//                               ],
//                             ),

//                             SizedBox(height: width * .03),

//                             // Package Type
//                             Text(
//                               "Package Type (required)",
//                               style: TextStyle(
//                                   fontSize: width * .034,
//                                   fontWeight: FontWeight.w700),
//                             ),
//                             SizedBox(height: width * .02),

//                             GridView.builder(
//                               padding: EdgeInsets.zero,
//                               shrinkWrap: true,
//                               physics: const NeverScrollableScrollPhysics(),
//                               itemCount: packageTypeKeys.length,
//                               gridDelegate:
//                                   SliverGridDelegateWithFixedCrossAxisCount(
//                                 crossAxisCount: 4,
//                                 mainAxisSpacing: width * 0.02,
//                                 crossAxisSpacing: width * 0.02,
//                                 childAspectRatio: 1,
//                               ),
//                               itemBuilder: (context, index) {
//                                 final key = packageTypeKeys[index];
//                                 return buildPackageTile(key, setSheet);
//                               },
//                             ),

//                             if (_showPkgOtherField) ...[
//                               SizedBox(height: width * .02),
//                               SizedBox(
//                                 height: inputH,
//                                 child: TextField(
//                                   controller: _pkgOtherCtrl,
//                                   maxLines: 1,
//                                   textAlignVertical: TextAlignVertical.center,
//                                   style: TextStyle(fontSize: width * .034),
//                                   decoration: const InputDecoration(
//                                     labelText: "Enter package type",
//                                     border: OutlineInputBorder(),
//                                   ),
//                                 ),
//                               ),
//                             ],

//                             SizedBox(height: width * .03),

//                             // Instruction
//                             Text(
//                               "Courier instruction (optional)",
//                               style: TextStyle(
//                                   fontSize: width * .032,
//                                   fontWeight: FontWeight.w500),
//                             ),
//                             SizedBox(height: width * .01),
//                             SizedBox(
//                               height: inputH,
//                               child: TextField(
//                                 controller: _instructionCtrl,
//                                 maxLines: 1,
//                                 textAlignVertical: TextAlignVertical.center,
//                                 style: TextStyle(fontSize: width * .034),
//                                 decoration: InputDecoration(
//                                   hintText:
//                                       "E.g. call on arrival, leave with security, fragile, etc.",
//                                   hintStyle: TextStyle(fontSize: width * .032),
//                                   contentPadding: EdgeInsets.symmetric(
//                                       horizontal: width * .035),
//                                   filled: true,
//                                   fillColor: Colors.white,
//                                   border: OutlineInputBorder(
//                                     borderRadius:
//                                         BorderRadius.circular(width * .03),
//                                     borderSide: const BorderSide(
//                                         color: Color(0xFFDFE3EA)),
//                                   ),
//                                   enabledBorder: OutlineInputBorder(
//                                     borderRadius:
//                                         BorderRadius.circular(width * .03),
//                                     borderSide: const BorderSide(
//                                         color: Color(0xFFDFE3EA)),
//                                   ),
//                                   focusedBorder: OutlineInputBorder(
//                                     borderRadius:
//                                         BorderRadius.circular(width * .03),
//                                     borderSide: const BorderSide(
//                                         color: Color(0xFF2F6BFF)),
//                                   ),
//                                 ),
//                               ),
//                             ),

//                             SizedBox(height: width * .04),

//                             // Confirm button
//                             SizedBox(
//                               width: double.infinity,
//                               child: ElevatedButton(
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: canConfirm()
//                                       ? const Color(0xFF2F6BFF)
//                                       : const Color(0xFFBFC7DB),
//                                   foregroundColor: Colors.white,
//                                   padding: EdgeInsets.symmetric(
//                                     vertical: width * .04,
//                                     horizontal: width * .035,
//                                   ),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius:
//                                         BorderRadius.circular(width * .035),
//                                   ),
//                                 ),
//                                 onPressed: canConfirm()
//                                     ? () async {
//                                         _confirmed = true;

//                                         // Keep the confirmed address in the parent field
//                                         if (_pendingFullAddress != null) {
//                                           _searchCtrl.text =
//                                               _pendingFullAddress!;
//                                         }

//                                         final String? pkgKey = _pkgSelectedKey;
//                                         final String? pkgText = pkgLabel();
//                                         final String? pkgCustom =
//                                             _showPkgOtherField &&
//                                                     _pkgOtherCtrl.text
//                                                         .trim()
//                                                         .isNotEmpty
//                                                 ? _pkgOtherCtrl.text.trim()
//                                                 : null;

//                                         // Persist to secondary Firestore
//                                         try {
//                                           await _saveSelectionToDService(
//                                             label: widget.label,
//                                             address: _pendingFullAddress ??
//                                                 _searchCtrl.text,
//                                             latLng: _pendingLatLng!,
//                                             senderName: _nameCtrl.text.trim(),
//                                             senderPhone: _phoneCtrl.text.trim(),
//                                             house: _houseCtrl.text.trim(),
//                                             instruction:
//                                                 _instructionCtrl.text.trim(),
//                                             packageTypeKey: pkgKey,
//                                             packageTypeLabel: pkgText,
//                                             packageTypeCustom: pkgCustom,
//                                           );
//                                         } catch (e) {
//                                           if (mounted) {
//                                             ScaffoldMessenger.of(context)
//                                                 .showSnackBar(
//                                               SnackBar(
//                                                 content: Text(
//                                                   'Save failed: $e',
//                                                 ),
//                                               ),
//                                             );
//                                           }
//                                         }

//                                         // 1) Close the sheet
//                                         Navigator.of(sheetCtx).pop();
//                                         // 2) Pop THIS PAGE with payload to the caller
//                                         if (mounted) {
//                                           Navigator.of(context).pop({
//                                             'address': _pendingFullAddress ??
//                                                 _searchCtrl.text,
//                                             'latLng': _pendingLatLng,
//                                             'label': widget.label,
//                                             'house': _houseCtrl.text.trim(),
//                                             'senderName': _nameCtrl.text.trim(),
//                                             'senderPhone':
//                                                 _phoneCtrl.text.trim(),
//                                             'instruction':
//                                                 _instructionCtrl.text.trim(),
//                                             'packageTypeKey': pkgKey,
//                                             'packageTypeLabel': pkgText,
//                                             'packageTypeCustom': pkgCustom,
//                                           });
//                                         }
//                                       }
//                                     : null,
//                                 child: Text(
//                                   "Confirm and Proceed",
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.w700,
//                                     fontSize: width * .036,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             if (!canConfirm())
//                               Padding(
//                                 padding: EdgeInsets.only(top: width * .02),
//                                 child: Text(
//                                   "Select a package type, and enter sender name & mobile number to continue.",
//                                   style: TextStyle(
//                                     color: Colors.red.shade600,
//                                     fontSize: width * .03,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                               ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

// ------------------------------------------

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
//   const D2dPlaceSearchPage({
//     super.key,
//     required this.controller, // <-- FROM/TO controller (parent)
//     required this.accentColor, // <-- green/red
//     required this.label, // <-- "Pickup" or "Destination"
//     this.defaultSenderName,
//     this.defaultSenderMobile,
//   });

//   final TextEditingController controller;
//   final Color accentColor;
//   final String label;

//   /// Optional defaults for the confirm sheet
//   final String? defaultSenderName;
//   final String? defaultSenderMobile;

//   @override
//   State<D2dPlaceSearchPage> createState() => _D2dPlaceSearchPageState();
// }

// class _D2dPlaceSearchPageState extends State<D2dPlaceSearchPage> {
//   final String googleApiKey = "AIzaSyDwD1BJXVxky_Cy6xzyQh_5A2PW9cTOO0I";

//   GoogleMapController? mapController;

//   // Search state
//   late TextEditingController _searchCtrl; // bound to parent
//   final FocusNode _searchFocus = FocusNode();
//   Timer? _debounce;
//   String _sessionToken = const Uuid().v4();

//   List<gmws.Prediction> _results = [];
//   bool _loading = false;
//   String? _error;

//   // Location/state
//   LatLng _biasCenter = const LatLng(10.8505, 76.2711); // fallback: Kerala
//   String? _currentStateName;
//   LatLng? _pendingCameraTarget;

//   // Map/markers
//   final Set<Marker> _markers = {};
//   final CameraPosition _initialPosition = const CameraPosition(
//     target: LatLng(10.8505, 76.2711),
//     zoom: 14.0,
//   );

//   // --- Confirm sheet temp values (set on selection) ---
//   String? _pendingAddressTitle;
//   String? _pendingFullAddress;
//   LatLng? _pendingLatLng;

//   // Confirm sheet controllers
//   final TextEditingController _houseCtrl = TextEditingController();
//   final TextEditingController _nameCtrl = TextEditingController();
//   final TextEditingController _phoneCtrl = TextEditingController();
//   final TextEditingController _instructionCtrl = TextEditingController();
//   final TextEditingController _pkgOtherCtrl = TextEditingController();

//   bool _useMyMobile = false;

//   // Package type selection (confirm sheet)
//   String? _pkgSelectedKey; // e.g., 'document', 'other'
//   bool get _showPkgOtherField => _pkgSelectedKey == 'other';

//   // Track whether user confirmed (so we know whether to keep/clear text on pop)
//   bool _confirmed = false;

//   // Package type map
//   final Map<String, Map<String, dynamic>> _packageTypeMap = const {
//     'document': {'label': 'Document', 'icon': Icons.description},
//     'box': {'label': 'Box', 'icon': Icons.inbox},
//     'food': {'label': 'Food', 'icon': Icons.fastfood},
//     'gift': {'label': 'Gift', 'icon': Icons.card_giftcard},
//     'electronics': {'label': 'Electronics', 'icon': Icons.devices_other},
//     'clothes': {'label': 'Clothes', 'icon': Icons.checkroom},
//     'fragile': {'label': 'Fragile', 'icon': Icons.emoji_objects},
//     'other': {'label': 'Other', 'icon': Icons.more_horiz},
//   };

//   @override
//   void initState() {
//     super.initState();
//     _searchCtrl = widget.controller; // <-- bind
//     _initLocationAndBias();

//     // seed defaults for sheet
//     _nameCtrl.text = widget.defaultSenderName ?? "";
//     _phoneCtrl.text = widget.defaultSenderMobile ?? "";

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
//     if (!_confirmed) {
//       _searchCtrl.clear();
//     }
//     _searchFocus.dispose();
//     _debounce?.cancel();
//     _houseCtrl.dispose();
//     _nameCtrl.dispose();
//     _phoneCtrl.dispose();
//     _instructionCtrl.dispose();
//     _pkgOtherCtrl.dispose();
//     super.dispose();
//   }

//   // ---------- Init location & state ----------
//   Future<void> _initLocationAndBias() async {
//     try {
//       if (!await Geolocator.isLocationServiceEnabled()) return;

//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//       }
//       if (permission == LocationPermission.deniedForever ||
//           permission == LocationPermission.denied) {
//         return;
//       }

//       final pos = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );

//       final newCenter = LatLng(pos.latitude, pos.longitude);
//       final places =
//           await placemarkFromCoordinates(pos.latitude, pos.longitude);

//       setState(() {
//         _biasCenter = newCenter;
//         _currentStateName =
//             places.isNotEmpty ? places.first.administrativeArea : null;
//         _pendingCameraTarget = newCenter;
//       });

//       if (mapController != null) {
//         await mapController!.animateCamera(
//           CameraUpdate.newCameraPosition(
//             CameraPosition(target: newCenter, zoom: 15.0),
//           ),
//         );
//         _pendingCameraTarget = null;
//       }
//     } catch (_) {/* ignore and keep fallback */}
//   }

//   // ---------- Places search ----------
//   Future<void> _onChanged(String text) async {
//     _debounce?.cancel();
//     _debounce = Timer(const Duration(milliseconds: 260), () {
//       _search(text.trim());
//     });
//   }

//   Future<void> _search(String input) async {
//     if (!_searchFocus.hasFocus) return;
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
//         components: [gmws.Component(gmws.Component.country, 'in')],
//         location: gmws.Location(
//           lat: _biasCenter.latitude,
//           lng: _biasCenter.longitude,
//         ),
//         radius: 60000,
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
//     _sessionToken = const Uuid().v4();

//     final places = gmws.GoogleMapsPlaces(
//       apiKey: googleApiKey,
//       apiHeaders: await const GoogleApiHeaders().getHeaders(),
//     );

//     final detail = await places.getDetailsByPlaceId(p.placeId!);
//     final geometry = detail.result.geometry;
//     if (geometry == null) return;

//     final target = LatLng(geometry.location.lat, geometry.location.lng);
//     final title = detail.result.name;
//     final fullAddress =
//         detail.result.formattedAddress ?? (p.description ?? title);

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
//             infoWindow: InfoWindow(title: title, snippet: fullAddress),
//           ),
//         );

//       _pendingAddressTitle = title;
//       _pendingFullAddress = fullAddress;
//       _pendingLatLng = target;
//     });

//     await mapController?.animateCamera(
//       CameraUpdate.newCameraPosition(
//         CameraPosition(target: target, zoom: 16.0),
//       ),
//     );

//     _showConfirmSheet();
//   }

//   Future<void> _showConfirmSheet() async {
//     final String userMobile =
//         widget.defaultSenderMobile ?? _phoneCtrl.text; // optional default

//     await showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.white,
//       // ⬇️ No max-height constraints; let it expand to full content height.
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(
//           top: Radius.circular(MediaQuery.of(context).size.width * .05),
//         ),
//       ),
//       builder: (ctx) {
//         final width = MediaQuery.of(ctx).size.width;
//         final bottomInset = MediaQuery.of(ctx).viewInsets.bottom;
//         final inputH = width * .105; // uniform height for all fields
//         final packageTypeKeys =
//             _packageTypeMap.keys.toList(growable: false); // grid items

//         Widget buildLinedField({
//           required TextEditingController controller,
//           required String hint,
//           TextInputType? keyboardType,
//           Widget? suffixIcon,
//           bool enabled = true,
//         }) {
//           return SizedBox(
//             height: inputH,
//             child: TextField(
//               controller: controller,
//               keyboardType: keyboardType,
//               enabled: enabled,
//               maxLines: 1,
//               textAlignVertical: TextAlignVertical.center,
//               style: TextStyle(fontSize: width * .034),
//               decoration: InputDecoration(
//                 hintText: hint,
//                 hintStyle: TextStyle(fontSize: width * .032),
//                 contentPadding: EdgeInsets.symmetric(
//                   horizontal: width * .035,
//                 ),
//                 suffixIcon: suffixIcon,
//                 filled: true,
//                 fillColor: Colors.white,
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(width * .03),
//                   borderSide: const BorderSide(color: Color(0xFFDFE3EA)),
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(width * .03),
//                   borderSide: const BorderSide(color: Color(0xFFDFE3EA)),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(width * .03),
//                   borderSide: const BorderSide(color: Color(0xFF2F6BFF)),
//                 ),
//               ),
//             ),
//           );
//         }

//         Widget buildPackageTile(
//             String key, void Function(VoidCallback) setSheet) {
//           final item = _packageTypeMap[key]!;
//           final bool isSelected = _pkgSelectedKey == key;

//           return GestureDetector(
//             onTap: () {
//               setSheet(() {
//                 _pkgSelectedKey = key;
//                 if (!_showPkgOtherField) _pkgOtherCtrl.clear();
//               });
//             },
//             child: Container(
//               decoration: BoxDecoration(
//                 color: isSelected ? Colors.blue.withOpacity(0.05) : null,
//                 border: Border.all(
//                   color:
//                       isSelected ? Colors.blue : Colors.black.withOpacity(0.25),
//                   width: isSelected ? width * 0.005 : width * 0.003,
//                 ),
//                 borderRadius: BorderRadius.circular(width * 0.025),
//               ),
//               padding: EdgeInsets.symmetric(vertical: width * 0.02),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     item['icon'] as IconData,
//                     color: isSelected ? Colors.blue : Colors.black,
//                     size: width * 0.07,
//                   ),
//                   SizedBox(height: width * 0.015),
//                   Text(
//                     item['label'] as String,
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontSize: width * 0.025,
//                       color: isSelected ? Colors.blue : Colors.black,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }

//         return StatefulBuilder(
//           builder: (ctx, setSheet) {
//             bool canConfirm() =>
//                 _nameCtrl.text.trim().isNotEmpty &&
//                 _phoneCtrl.text.trim().isNotEmpty &&
//                 _pkgSelectedKey != null; // must select one item in grid

//             String? pkgLabel() {
//               if (_pkgSelectedKey == null) return null;
//               if (_pkgSelectedKey == 'other') {
//                 final custom = _pkgOtherCtrl.text.trim();
//                 return custom.isNotEmpty ? custom : 'Other';
//               }
//               return _packageTypeMap[_pkgSelectedKey!]!['label'] as String;
//             }

//             return Padding(
//               padding: EdgeInsets.only(bottom: bottomInset),
//               child: SafeArea(
//                 top: false,
//                 child: SingleChildScrollView(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min, // ⬅️ Wrap to full content
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // drag handle
//                       Center(
//                         child: Container(
//                           width: width * .18,
//                           height: width * .013,
//                           margin: EdgeInsets.only(
//                               bottom: width * .03, top: width * .02),
//                           decoration: BoxDecoration(
//                             color: Colors.black12,
//                             borderRadius: BorderRadius.circular(width * .01),
//                           ),
//                         ),
//                       ),

//                       Padding(
//                         padding: EdgeInsets.symmetric(
//                           horizontal: width * .05,
//                           vertical: width * .02,
//                         ),
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             // Location row
//                             Row(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Icon(Icons.place,
//                                     color: Colors.green, size: width * .05),
//                                 SizedBox(width: width * .02),
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         _pendingAddressTitle ?? widget.label,
//                                         style: TextStyle(
//                                           fontSize: width * .04,
//                                           fontWeight: FontWeight.w700,
//                                         ),
//                                       ),
//                                       SizedBox(height: width * .01),
//                                       Text(
//                                         _pendingFullAddress ?? '',
//                                         style: TextStyle(
//                                           color: Colors.black87,
//                                           height: 1.2,
//                                           fontSize: width * .032,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 TextButton(
//                                   onPressed: () => Navigator.pop(ctx),
//                                   child: Text("Change",
//                                       style: TextStyle(fontSize: width * .032)),
//                                 ),
//                               ],
//                             ),
//                             SizedBox(height: width * .03),

//                             // House/Shop
//                             buildLinedField(
//                               controller: _houseCtrl,
//                               hint: "House / Apartment / Shop (optional)",
//                             ),
//                             SizedBox(height: width * .02),

//                             // Sender name
//                             Text("Sender's Name",
//                                 style: TextStyle(
//                                     fontSize: width * .032,
//                                     fontWeight: FontWeight.w500)),
//                             SizedBox(height: width * .01),
//                             SizedBox(
//                               height: inputH,
//                               child: TextField(
//                                 controller: _nameCtrl,
//                                 onChanged: (_) => setSheet(() {}),
//                                 maxLines: 1,
//                                 textAlignVertical: TextAlignVertical.center,
//                                 style: TextStyle(fontSize: width * .034),
//                                 decoration: InputDecoration(
//                                   hintText: "Enter sender name",
//                                   hintStyle: TextStyle(fontSize: width * .032),
//                                   contentPadding: EdgeInsets.symmetric(
//                                       horizontal: width * .035),
//                                   filled: true,
//                                   fillColor: Colors.white,
//                                   border: OutlineInputBorder(
//                                     borderRadius:
//                                         BorderRadius.circular(width * .03),
//                                     borderSide: const BorderSide(
//                                         color: Color(0xFFDFE3EA)),
//                                   ),
//                                   enabledBorder: OutlineInputBorder(
//                                     borderRadius:
//                                         BorderRadius.circular(width * .03),
//                                     borderSide: const BorderSide(
//                                         color: Color(0xFFDFE3EA)),
//                                   ),
//                                   focusedBorder: OutlineInputBorder(
//                                     borderRadius:
//                                         BorderRadius.circular(width * .03),
//                                     borderSide: const BorderSide(
//                                         color: Color(0xFF2F6BFF)),
//                                   ),
//                                   suffixIcon: Icon(Icons.recent_actors_outlined,
//                                       size: width * .05),
//                                 ),
//                               ),
//                             ),
//                             SizedBox(height: width * .02),

//                             // Sender phone
//                             Text("Sender's Mobile number",
//                                 style: TextStyle(
//                                     fontSize: width * .032,
//                                     fontWeight: FontWeight.w500)),
//                             SizedBox(height: width * .01),
//                             SizedBox(
//                               height: inputH,
//                               child: TextField(
//                                 controller: _phoneCtrl,
//                                 keyboardType: TextInputType.phone,
//                                 onChanged: (_) => setSheet(() {}),
//                                 maxLines: 1,
//                                 textAlignVertical: TextAlignVertical.center,
//                                 style: TextStyle(fontSize: width * .034),
//                                 decoration: InputDecoration(
//                                   hintText: "Enter mobile number",
//                                   hintStyle: TextStyle(fontSize: width * .032),
//                                   contentPadding: EdgeInsets.symmetric(
//                                       horizontal: width * .035),
//                                   filled: true,
//                                   fillColor: Colors.white,
//                                   border: OutlineInputBorder(
//                                     borderRadius:
//                                         BorderRadius.circular(width * .03),
//                                     borderSide: const BorderSide(
//                                         color: Color(0xFFDFE3EA)),
//                                   ),
//                                   enabledBorder: OutlineInputBorder(
//                                     borderRadius:
//                                         BorderRadius.circular(width * .03),
//                                     borderSide: const BorderSide(
//                                         color: Color(0xFFDFE3EA)),
//                                   ),
//                                   focusedBorder: OutlineInputBorder(
//                                     borderRadius:
//                                         BorderRadius.circular(width * .03),
//                                     borderSide: const BorderSide(
//                                         color: Color(0xFF2F6BFF)),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             SizedBox(height: width * .01),

//                             // Use my mobile checkbox
//                             Row(
//                               children: [
//                                 SizedBox(
//                                   width: width * .06,
//                                   height: width * .06,
//                                   child: Checkbox(
//                                     value: _useMyMobile,
//                                     onChanged: (v) {
//                                       setSheet(() {
//                                         _useMyMobile = v ?? false;
//                                         if (_useMyMobile &&
//                                             userMobile.isNotEmpty) {
//                                           _phoneCtrl.text = userMobile;
//                                         }
//                                       });
//                                     },
//                                   ),
//                                 ),
//                                 SizedBox(width: width * .02),
//                                 Expanded(
//                                   child: Text(
//                                     "Use my mobile number${userMobile.isNotEmpty ? " : $userMobile" : ""}",
//                                     style: TextStyle(fontSize: width * .032),
//                                   ),
//                                 ),
//                               ],
//                             ),

//                             SizedBox(height: width * .03),

//                             // Package Type
//                             Text(
//                               "Package Type (required)",
//                               style: TextStyle(
//                                   fontSize: width * .034,
//                                   fontWeight: FontWeight.w700),
//                             ),
//                             SizedBox(height: width * .02),

//                             GridView.builder(
//                               padding: EdgeInsets.zero,
//                               shrinkWrap: true,
//                               physics: const NeverScrollableScrollPhysics(),
//                               itemCount: packageTypeKeys.length,
//                               gridDelegate:
//                                   SliverGridDelegateWithFixedCrossAxisCount(
//                                 crossAxisCount: 4,
//                                 mainAxisSpacing: width * 0.02,
//                                 crossAxisSpacing: width * 0.02,
//                                 childAspectRatio: 1,
//                               ),
//                               itemBuilder: (context, index) {
//                                 final key = packageTypeKeys[index];
//                                 return buildPackageTile(key, setSheet);
//                               },
//                             ),

//                             if (_showPkgOtherField) ...[
//                               SizedBox(height: width * .02),
//                               SizedBox(
//                                 height: inputH,
//                                 child: TextField(
//                                   controller: _pkgOtherCtrl,
//                                   maxLines: 1,
//                                   textAlignVertical: TextAlignVertical.center,
//                                   style: TextStyle(fontSize: width * .034),
//                                   decoration: const InputDecoration(
//                                     labelText: "Enter package type",
//                                     border: OutlineInputBorder(),
//                                   ),
//                                 ),
//                               ),
//                             ],

//                             SizedBox(height: width * .03),

//                             // Instruction (single-line, same height)
//                             Text(
//                               "Courier instruction (optional)",
//                               style: TextStyle(
//                                   fontSize: width * .032,
//                                   fontWeight: FontWeight.w500),
//                             ),
//                             SizedBox(height: width * .01),
//                             SizedBox(
//                               height: inputH,
//                               child: TextField(
//                                 controller: _instructionCtrl,
//                                 maxLines: 1,
//                                 textAlignVertical: TextAlignVertical.center,
//                                 style: TextStyle(fontSize: width * .034),
//                                 decoration: InputDecoration(
//                                   hintText:
//                                       "E.g. call on arrival, leave with security, fragile, etc.",
//                                   hintStyle: TextStyle(fontSize: width * .032),
//                                   contentPadding: EdgeInsets.symmetric(
//                                       horizontal: width * .035),
//                                   filled: true,
//                                   fillColor: Colors.white,
//                                   border: OutlineInputBorder(
//                                     borderRadius:
//                                         BorderRadius.circular(width * .03),
//                                     borderSide: const BorderSide(
//                                         color: Color(0xFFDFE3EA)),
//                                   ),
//                                   enabledBorder: OutlineInputBorder(
//                                     borderRadius:
//                                         BorderRadius.circular(width * .03),
//                                     borderSide: const BorderSide(
//                                         color: Color(0xFFDFE3EA)),
//                                   ),
//                                   focusedBorder: OutlineInputBorder(
//                                     borderRadius:
//                                         BorderRadius.circular(width * .03),
//                                     borderSide: const BorderSide(
//                                         color: Color(0xFF2F6BFF)),
//                                   ),
//                                 ),
//                               ),
//                             ),

//                             SizedBox(height: width * .04),

//                             // Confirm button
//                             SizedBox(
//                               width: double.infinity,
//                               child: ElevatedButton(
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: canConfirm()
//                                       ? const Color(0xFF2F6BFF)
//                                       : const Color(0xFFBFC7DB),
//                                   foregroundColor: Colors.white,
//                                   padding: EdgeInsets.symmetric(
//                                     vertical: width * .04,
//                                     horizontal: width * .035,
//                                   ),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius:
//                                         BorderRadius.circular(width * .035),
//                                   ),
//                                 ),
//                                 onPressed: canConfirm()
//                                     ? () {
//                                         _confirmed = true;

//                                         // write address back to parent textfield
//                                         if (_pendingFullAddress != null) {
//                                           _searchCtrl.text =
//                                               _pendingFullAddress!;
//                                         }

//                                         final String? pkgKey = _pkgSelectedKey;
//                                         final String? pkgText = pkgLabel();
//                                         final String? pkgCustom =
//                                             _showPkgOtherField &&
//                                                     _pkgOtherCtrl.text
//                                                         .trim()
//                                                         .isNotEmpty
//                                                 ? _pkgOtherCtrl.text.trim()
//                                                 : null;

//                                         Navigator.pop(ctx);
//                                         Navigator.of(context).pop({
//                                           'address': _pendingFullAddress ??
//                                               _searchCtrl.text,
//                                           'latLng': _pendingLatLng,
//                                           'label': widget.label,
//                                           'house': _houseCtrl.text.trim(),
//                                           'senderName': _nameCtrl.text.trim(),
//                                           'senderPhone': _phoneCtrl.text.trim(),
//                                           'instruction':
//                                               _instructionCtrl.text.trim(),
//                                           'packageTypeKey':
//                                               pkgKey, // e.g., 'food', 'other'
//                                           'packageTypeLabel':
//                                               pkgText, // user-friendly label
//                                           'packageTypeCustom':
//                                               pkgCustom // text if "Other"
//                                         });
//                                       }
//                                     : null,
//                                 child: Text(
//                                   "Confirm and Proceed",
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.w700,
//                                     fontSize: width * .036,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             if (!canConfirm())
//                               Padding(
//                                 padding: EdgeInsets.only(top: width * .02),
//                                 child: Text(
//                                   "Select a package type, and enter sender name & mobile number to continue.",
//                                   style: TextStyle(
//                                     color: Colors.red.shade600,
//                                     fontSize: width * .03,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                               ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width; // <-- width*
//     final double spacerTop = width * .05;
//     final double fieldHeight = width * .105;
//     final double panelPad = width * .0125;
//     final double cardRadius = width * .03;
//     final double borderWidth = width * .005;
//     final double iconSize = width * .034;
//     final double gap = width * .01;

//     final String hintText = 'Search ${widget.label.toLowerCase()} location';

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

//             // Search + suggestions
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
//                         // colored leading dot
//                         SizedBox(
//                           height: fieldHeight,
//                           child: Center(
//                             child: Container(
//                               width: width * 0.04,
//                               height: width * 0.04,
//                               decoration: BoxDecoration(
//                                 border: Border.all(
//                                   width: width * .005,
//                                   color: Colors.black.withOpacity(.25),
//                                 ),
//                                 color: widget.accentColor,
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

//                         // Search field + suggestion panel
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
//                                     hintText: hintText,
//                                     hintStyle:
//                                         TextStyle(fontSize: width * .032),
//                                     prefixIcon: Icon(
//                                       Icons.search,
//                                       size: iconSize,
//                                       color: widget.accentColor,
//                                     ),
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
//                                         EdgeInsets.only(top: width * .0125),
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
//                                   // constraints:
//                                   //     BoxConstraints(maxHeight: width * .6),
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
//                                   child: Column(
//                                     children: [
//                                       Align(
//                                         alignment: Alignment.centerLeft,
//                                         child: Padding(
//                                           padding: EdgeInsets.symmetric(
//                                               vertical: gap * .5,
//                                               horizontal: gap * .5),
//                                           child: Text(
//                                               "popular locations near you",
//                                               style: TextStyle(
//                                                   fontSize: width * .028,
//                                                   color: Colors.black54,
//                                                   fontWeight: FontWeight.w500)),
//                                         ),
//                                       ),
//                                       Builder(builder: (context) {
//                                         if (_loading) {
//                                           return SizedBox(
//                                             height: width * .08,
//                                             child: const Center(
//                                               child:
//                                                   CupertinoActivityIndicator(),
//                                             ),
//                                           );
//                                         }

//                                         if (_error != null) {
//                                           return Padding(
//                                             padding:
//                                                 EdgeInsets.all(width * .01),
//                                             child: Text(
//                                               _error!,
//                                               style: TextStyle(
//                                                 color: Colors.redAccent,
//                                                 fontSize: width * .032,
//                                               ),
//                                             ),
//                                           );
//                                         }

//                                         if (_results.isEmpty) {
//                                           return Column(
//                                             children: List.generate(4, (i) {
//                                               return Container(
//                                                 margin: EdgeInsets.symmetric(
//                                                   vertical: gap * .6,
//                                                 ),
//                                                 decoration: BoxDecoration(
//                                                   color: Colors.white,
//                                                   borderRadius:
//                                                       BorderRadius.circular(
//                                                           cardRadius),
//                                                   boxShadow: [
//                                                     BoxShadow(
//                                                       color: Colors.black
//                                                           .withOpacity(.06),
//                                                       blurRadius: width * .02,
//                                                       offset: Offset(
//                                                           0, width * .005),
//                                                     ),
//                                                   ],
//                                                 ),
//                                                 padding: EdgeInsets.symmetric(
//                                                   horizontal: width * .022,
//                                                   vertical: width * .018,
//                                                 ),
//                                                 child: SizedBox(
//                                                     height: width * .03),
//                                               );
//                                             }),
//                                           );
//                                         }

//                                         // results
//                                         return ListView.separated(
//                                           padding: EdgeInsets.zero,
//                                           shrinkWrap: true,
//                                           itemCount: _results.length,
//                                           separatorBuilder: (_, __) =>
//                                               SizedBox(height: gap * .6),
//                                           itemBuilder: (context, i) {
//                                             final p = _results[i];
//                                             final main = p.structuredFormatting
//                                                     ?.mainText ??
//                                                 (p.description ?? '');
//                                             final secondary = p
//                                                     .structuredFormatting
//                                                     ?.secondaryText ??
//                                                 '';

//                                             return InkWell(
//                                               onTap: () => _selectPrediction(p),
//                                               borderRadius:
//                                                   BorderRadius.circular(
//                                                       cardRadius),
//                                               child: Container(
//                                                 padding: EdgeInsets.symmetric(
//                                                   horizontal: width * .022,
//                                                   vertical: width * .018,
//                                                 ),
//                                                 decoration: BoxDecoration(
//                                                   color: Colors.white,
//                                                   borderRadius:
//                                                       BorderRadius.circular(
//                                                           cardRadius),
//                                                   boxShadow: [
//                                                     BoxShadow(
//                                                       color: Colors.black
//                                                           .withOpacity(.06),
//                                                       blurRadius: width * .02,
//                                                       offset: Offset(
//                                                           0, width * .005),
//                                                     ),
//                                                   ],
//                                                 ),
//                                                 child: Row(
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.start,
//                                                   children: [
//                                                     Container(
//                                                       width: width * .06,
//                                                       height: width * .06,
//                                                       decoration: BoxDecoration(
//                                                         shape: BoxShape.circle,
//                                                         color: widget
//                                                             .accentColor
//                                                             .withOpacity(.12),
//                                                       ),
//                                                       child: Icon(
//                                                         Icons.place_outlined,
//                                                         size: iconSize,
//                                                         color:
//                                                             widget.accentColor,
//                                                       ),
//                                                     ),
//                                                     SizedBox(
//                                                         width: width * .02),
//                                                     Expanded(
//                                                       child: Column(
//                                                         crossAxisAlignment:
//                                                             CrossAxisAlignment
//                                                                 .start,
//                                                         children: [
//                                                           Text(
//                                                             main,
//                                                             maxLines: 2,
//                                                             overflow:
//                                                                 TextOverflow
//                                                                     .ellipsis,
//                                                             style: TextStyle(
//                                                               fontSize:
//                                                                   width * .034,
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .w600,
//                                                             ),
//                                                           ),
//                                                           if (secondary
//                                                               .isNotEmpty) ...[
//                                                             SizedBox(
//                                                                 height: width *
//                                                                     .005),
//                                                             Text(
//                                                               secondary,
//                                                               maxLines: 2,
//                                                               overflow:
//                                                                   TextOverflow
//                                                                       .ellipsis,
//                                                               style: TextStyle(
//                                                                 fontSize:
//                                                                     width *
//                                                                         .028,
//                                                                 color: Colors
//                                                                     .black
//                                                                     .withOpacity(
//                                                                         .6),
//                                                               ),
//                                                             ),
//                                                           ],
//                                                         ],
//                                                       ),
//                                                     ),
//                                                     SizedBox(
//                                                         width: width * .01),
//                                                     Icon(Icons.north_east,
//                                                         size: iconSize,
//                                                         color: Colors.black45),
//                                                   ],
//                                                 ),
//                                               ),
//                                             );
//                                           },
//                                         );
//                                       }),
//                                       SizedBox(height: gap),
//                                       Align(
//                                         alignment: Alignment.centerRight,
//                                         child: GestureDetector(
//                                           onTap: () {
//                                             // setState(() {
//                                             //   _showAllResults = !_showAllResults;
//                                             // });
//                                           },
//                                           child: Container(
//                                             decoration: BoxDecoration(
//                                               color: Colors.white,
//                                               border: Border.all(
//                                                 color: Colors.black26,
//                                                 width: width * .003,
//                                               ),
//                                               borderRadius:
//                                                   BorderRadius.circular(
//                                                       width * .02),
//                                             ),
//                                             child: Padding(
//                                               padding:
//                                                   EdgeInsets.all(width * .008),
//                                               child: Text("show more",
//                                                   style: TextStyle(
//                                                       fontSize: width * .028,
//                                                       color: Colors.black54,
//                                                       fontWeight:
//                                                           FontWeight.w500)),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
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

// --------------------------------------------
// import 'dart:async';

// import 'package:drivex/main.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// // Google Places (legacy SDK you’re using)
// import 'package:flutter_google_places_hoc081098/google_maps_webservice_places.dart'
//     as gmws;
// import 'package:google_api_headers/google_api_headers.dart';

// // Current location + reverse geocoding
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';

// // 🔥 Firestore
// import 'package:cloud_firestore/cloud_firestore.dart';

// import 'package:uuid/uuid.dart';

// class D2dPlaceSearchPage extends StatefulWidget {
//   const D2dPlaceSearchPage({
//     super.key,
//     required this.controller, // FROM/TO controller (parent)
//     required this.accentColor, // green/red
//     required this.label, // "Pickup" or "Destination"
//     this.defaultSenderName,
//     this.defaultSenderMobile,
//   });

//   final TextEditingController controller;
//   final Color accentColor;
//   final String label;

//   /// Optional defaults for the confirm sheet
//   final String? defaultSenderName;
//   final String? defaultSenderMobile;

//   @override
//   State<D2dPlaceSearchPage> createState() => _D2dPlaceSearchPageState();
// }

// /// Row used when showing Firebase cache results
// class _LocalPlace {
//   final String id;
//   final String title;
//   final String subtitle;
//   final LatLng? latLng;
//   final DocumentReference<Map<String, dynamic>> docRef;

//   _LocalPlace({
//     required this.id,
//     required this.title,
//     required this.subtitle,
//     required this.latLng,
//     required this.docRef,
//   });
// }

// bool _shouldCacheByAddressComponents(List<gmws.AddressComponent> comps) {
//   const granular = {
//     'sublocality',
//     'sublocality_level_1',
//     'sublocality_level_2',
//     'neighborhood',
//     'premise',
//     'route',
//     'street_number',
//   };
//   final hasGranular = comps.any((c) => c.types.any(granular.contains));
//   return !hasGranular; // only cache if NOT granular
// }

// enum _SelectionSource { google, localCache, pin }

// class _D2dPlaceSearchPageState extends State<D2dPlaceSearchPage> {
//   // NOTE: keep using your existing key here (legacy SDK). Make sure Places/Maps are enabled.
//   final String googleApiKey = "AIzaSyDwD1BJXVxky_Cy6xzyQh_5A2PW9cTOO0I";

//   GoogleMapController? mapController;

//   // 👉 Convenience getters so we never mix DBs up
//   FirebaseFirestore get _main => AppFire.mainDb; // drivex
//   FirebaseFirestore get _gsvc => AppFire.gServiceDb; // g-service

//   // Search state
//   late TextEditingController _searchCtrl; // bound to parent
//   final FocusNode _searchFocus = FocusNode();
//   Timer? _debounce;
//   String _sessionToken = const Uuid().v4();

//   // Google results
//   List<gmws.Prediction> _results = [];

//   // Local (Firestore) results
//   List<_LocalPlace> _localResults = [];

//   // Which list is currently displayed in the panel
//   bool _showingLocal = false;

//   bool _loading = false;
//   String? _error;

//   // Location/state
//   LatLng _biasCenter = const LatLng(10.8505, 76.2711); // fallback: Kerala
//   String? _currentStateName;
//   LatLng? _pendingCameraTarget;

//   // Map/markers
//   final Set<Marker> _markers = {};
//   final CameraPosition _initialPosition = const CameraPosition(
//     target: LatLng(10.8505, 76.2711),
//     zoom: 14.0,
//   );

//   // --- Confirm sheet temp values (set on selection) ---
//   String? _pendingAddressTitle;
//   String? _pendingFullAddress;
//   LatLng? _pendingLatLng;

//   // Confirm sheet controllers
//   final TextEditingController _houseCtrl = TextEditingController();
//   final TextEditingController _nameCtrl = TextEditingController();
//   final TextEditingController _phoneCtrl = TextEditingController();
//   final TextEditingController _instructionCtrl = TextEditingController();
//   final TextEditingController _pkgOtherCtrl = TextEditingController();

//   bool _useMyMobile = false;

//   // Package type selection (confirm sheet)
//   String? _pkgSelectedKey; // e.g., 'document', 'other'
//   bool get _showPkgOtherField => _pkgSelectedKey == 'other';

//   // Track whether user confirmed (so we know whether to keep/clear text on pop)
//   bool _confirmed = false;

//   // Where current selection came from
//   _SelectionSource? _selectionSource;

//   // Package type map
//   final Map<String, Map<String, dynamic>> _packageTypeMap = const {
//     'document': {'label': 'Document', 'icon': Icons.description},
//     'box': {'label': 'Box', 'icon': Icons.inbox},
//     'food': {'label': 'Food', 'icon': Icons.fastfood},
//     'gift': {'label': 'Gift', 'icon': Icons.card_giftcard},
//     'electronics': {'label': 'Electronics', 'icon': Icons.devices_other},
//     'clothes': {'label': 'Clothes', 'icon': Icons.checkroom},
//     'fragile': {'label': 'Fragile', 'icon': Icons.emoji_objects},
//     'other': {'label': 'Other', 'icon': Icons.more_horiz},
//   };

//   @override
//   void initState() {
//     super.initState();
//     _searchCtrl = widget.controller; // <-- bind
//     _initLocationAndBias();

//     // seed defaults for sheet
//     _nameCtrl.text = widget.defaultSenderName ?? "";
//     _phoneCtrl.text = widget.defaultSenderMobile ?? "";

//     _searchFocus.addListener(() {
//       if (_searchFocus.hasFocus && _searchCtrl.text.trim().length >= 2) {
//         // default to LOCAL first when the field gains focus (g-service cache)
//         _showingLocal = true;
//         _searchLocal(_searchCtrl.text.trim());
//       }
//       if (!_searchFocus.hasFocus) {
//         setState(() {
//           _results = [];
//           _localResults = [];
//           _error = null;
//           _loading = false;
//         });
//       }
//     });
//   }

//   @override
//   void dispose() {
//     if (!_confirmed) {
//       _searchCtrl.clear();
//     }
//     _searchFocus.dispose();
//     _debounce?.cancel();
//     _houseCtrl.dispose();
//     _nameCtrl.dispose();
//     _phoneCtrl.dispose();
//     _instructionCtrl.dispose();
//     _pkgOtherCtrl.dispose();
//     super.dispose();
//   }

//   // ---------- Firestore cache upsert (SECONDARY g-service) ----------
//   Future<void> _upsertPlaceCache({
//     required String placeId,
//     required String name,
//     required String address,
//     required LatLng latLng,
//     String? stateName,
//   }) async {
//     final data = {
//       'placeId': placeId,
//       'name': name,
//       'name_lc': name.toLowerCase(),
//       'address': address, // may be String even if older docs used Map
//       'lat': latLng.latitude,
//       'lng': latLng.longitude,
//       'state': stateName,
//       'hits': FieldValue.increment(1),
//       'updatedAt': FieldValue.serverTimestamp(),
//       'createdAt': FieldValue.serverTimestamp(),
//     };

//     // if this place already exists, merge + increment hits
//     final existing = await _gsvc
//         .collection('places_cache')
//         .where('placeId', isEqualTo: placeId)
//         .limit(1)
//         .get();

//     if (existing.docs.isNotEmpty) {
//       await existing.docs.first.reference.set(data, SetOptions(merge: true));
//     } else {
//       await _gsvc.collection('places_cache').add(data);
//     }
//   }

//   // ---------- Init location & state ----------
//   Future<void> _initLocationAndBias() async {
//     try {
//       if (!await Geolocator.isLocationServiceEnabled()) return;

//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//       }
//       if (permission == LocationPermission.deniedForever ||
//           permission == LocationPermission.denied) {
//         return;
//       }

//       final pos = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );

//       final newCenter = LatLng(pos.latitude, pos.longitude);
//       final places =
//           await placemarkFromCoordinates(pos.latitude, pos.longitude);

//       if (!mounted) return;
//       setState(() {
//         _biasCenter = newCenter;
//         _currentStateName =
//             places.isNotEmpty ? places.first.administrativeArea : null;
//         _pendingCameraTarget = newCenter;
//       });

//       if (mapController != null) {
//         await mapController!.animateCamera(
//           CameraUpdate.newCameraPosition(
//             CameraPosition(target: newCenter, zoom: 15.0),
//           ),
//         );
//         _pendingCameraTarget = null;
//       }
//     } catch (_) {/* ignore and keep fallback */}
//   }

//   // ---------- Places search (Google) ----------
//   Future<void> _onChanged(String text) async {
//     _debounce?.cancel();
//     _debounce = Timer(const Duration(milliseconds: 260), () {
//       // typing => try LOCAL first (g-service cache)
//       _showingLocal = true;
//       _searchLocal(text.trim());
//     });
//   }

//   Future<void> _search(String input) async {
//     if (!_searchFocus.hasFocus) return;
//     if (input.length < 2) {
//       setState(() {
//         _results = [];
//         _localResults = [];
//         _error = null;
//         _loading = false;
//       });
//       return;
//     }

//     setState(() {
//       _loading = true;
//       _error = null;
//       _results = [];
//       _localResults = [];
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
//         components: [gmws.Component(gmws.Component.country, 'in')],
//         location: gmws.Location(
//           lat: _biasCenter.latitude,
//           lng: _biasCenter.longitude,
//         ),
//         radius: 60000,
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

//   // ---------- Firebase (places_cache) search — SECONDARY g-service ----------
//   Future<void> _searchLocal(String input) async {
//     final q = input.trim().toLowerCase();
//     if (q.isEmpty) {
//       setState(() {
//         _localResults = [];
//         _error = 'Type to search';
//         _loading = false;
//       });
//       return;
//     }

//     setState(() {
//       _loading = true;
//       _error = null;
//       _localResults = [];
//     });

//     try {
//       final snap = await _gsvc
//           .collection('places_cache')
//           .orderBy('name_lc')
//           .startAt([q])
//           .endAt([q + '\uf8ff'])
//           .limit(25)
//           .get();

//       final items = <_LocalPlace>[];
//       for (final d in snap.docs) {
//         final data = d.data();

//         // ---- robust parsing of `address` (String OR Map) ----
//         String subtitle = '';
//         final addr = data['address'];
//         if (addr is String) {
//           subtitle = addr;
//         } else if (addr is Map) {
//           // prefer `formatted`, otherwise stitch common parts
//           subtitle = (addr['formatted'] as String?) ??
//               _joinNonEmpty([
//                 addr['premise'],
//                 addr['route'],
//                 addr['streetNumber'],
//                 addr['sublocality'],
//                 addr['locality'],
//                 addr['subDistrict'],
//                 addr['district'],
//                 addr['state'],
//                 addr['postalCode'],
//                 addr['countryCode'], // short
//               ]);
//         } else {
//           subtitle = '';
//         }

//         final String title =
//             (data['name'] as String?)?.trim().isNotEmpty == true
//                 ? data['name'] as String
//                 : (subtitle.isNotEmpty ? subtitle : 'Unknown');

//         final lat = (data['lat'] as num?)?.toDouble();
//         final lng = (data['lng'] as num?)?.toDouble();

//         items.add(_LocalPlace(
//           id: d.id,
//           title: title,
//           subtitle: subtitle,
//           latLng: (lat != null && lng != null) ? LatLng(lat, lng) : null,
//           docRef: d.reference,
//         ));
//       }

//       if (!mounted) return;
//       if (items.isNotEmpty) {
//         setState(() {
//           _localResults = items;
//           _error = null;
//           _loading = false;
//           _showingLocal = true; // stay on local list
//         });
//       } else {
//         // no local matches -> fall back to Google
//         setState(() {
//           _localResults = const [];
//           _error = null;
//           _loading = false;
//         });
//         _showingLocal = false;
//         await _search(input); // reuse your Google search
//       }
//     } catch (e) {
//       if (!mounted) return;
//       setState(() {
//         _localResults = [];
//         _error = e.toString();
//         _loading = false;
//       });
//     }
//   }

//   // helper to join address parts safely
//   String _joinNonEmpty(List parts) {
//     return parts
//         .whereType<String>()
//         .map((s) => s.trim())
//         .where((s) => s.isNotEmpty)
//         .join(', ');
//   }

//   // ---------- Selection handlers ----------
//   Future<void> _selectPrediction(gmws.Prediction p) async {
//     _sessionToken = const Uuid().v4();

//     final places = gmws.GoogleMapsPlaces(
//       apiKey: googleApiKey,
//       apiHeaders: await const GoogleApiHeaders().getHeaders(),
//     );

//     final detail = await places.getDetailsByPlaceId(p.placeId!);
//     final geometry = detail.result.geometry;
//     if (geometry == null) return;

//     final target = LatLng(geometry.location.lat, geometry.location.lng);
//     final title = detail.result.name;
//     final fullAddress =
//         detail.result.formattedAddress ?? (p.description ?? title);

//     // pull state (administrative_area_level_1) if present
//     String? stateName = detail.result.addressComponents
//         .firstWhere(
//           (c) => c.types.contains('administrative_area_level_1'),
//           orElse: () =>
//               gmws.AddressComponent(longName: '', shortName: '', types: []),
//         )
//         .longName;
//     if (stateName?.isEmpty ?? true) stateName = _currentStateName;

//     // ✅ Decide if this place is too granular to cache
//     // If any of these granular components exist, SKIP caching into places_cache.
//     // final granularTypes = <String>{
//     //   'sublocality',
//     //   'sublocality_level_1',
//     //   'neighborhood',
//     //   'premise',
//     //   'route',
//     //   'street_number',
//     // };
//     // final hasGranular = detail.result.addressComponents
//     //     .any((c) => c.types.any(granularTypes.contains));

//     // ✅ Save ONLY Google selections to g-service cache — and only if NOT granular
//     if (_shouldCacheByAddressComponents(detail.result.addressComponents)) {
//       try {
//         await _upsertPlaceCache(
//           placeId: p.placeId!,
//           name: title,
//           address: fullAddress,
//           latLng: target,
//           stateName: stateName,
//         );
//       } catch (_) {/* log or ignore */}
//     }

//     // (existing UI updates)
//     setState(() {
//       _selectionSource = _SelectionSource.google;
//       _biasCenter = target;
//       _currentStateName = stateName;
//       _markers
//         ..clear()
//         ..add(Marker(
//           markerId: const MarkerId('picked'),
//           position: target,
//           infoWindow: InfoWindow(title: title, snippet: fullAddress),
//         ));
//       _pendingAddressTitle = title;
//       _pendingFullAddress = fullAddress;
//       _pendingLatLng = target;
//     });

//     await mapController?.animateCamera(
//       CameraUpdate.newCameraPosition(
//           CameraPosition(target: target, zoom: 16.0)),
//     );

//     _showConfirmSheet();
//   }

//   Future<void> _selectLocal(_LocalPlace item) async {
//     final target = item.latLng;
//     if (target == null) return;

//     setState(() {
//       _selectionSource = _SelectionSource.localCache;
//       _biasCenter = target;
//       _markers
//         ..clear()
//         ..add(
//           Marker(
//             markerId: const MarkerId('picked'),
//             position: target,
//             infoWindow: InfoWindow(title: item.title, snippet: item.subtitle),
//           ),
//         );
//       _pendingAddressTitle = item.title;
//       _pendingFullAddress = item.subtitle;
//       _pendingLatLng = target;
//     });

//     // bump hits on the SAME g-service document (NO new upsert to places_cache)
//     await item.docRef.set({
//       'hits': FieldValue.increment(1),
//       'updatedAt': FieldValue.serverTimestamp(),
//     }, SetOptions(merge: true));

//     await mapController?.animateCamera(
//       CameraUpdate.newCameraPosition(
//         CameraPosition(target: target, zoom: 16.0),
//       ),
//     );

//     _showConfirmSheet();
//   }

//   // ---------- Pin flow (NO cache writes) ----------
//   Future<void> _onMapLongPress(LatLng pos) async {
//     String title = "Pinned location";
//     String full =
//         "${pos.latitude.toStringAsFixed(6)}, ${pos.longitude.toStringAsFixed(6)}";
//     try {
//       final marks = await placemarkFromCoordinates(pos.latitude, pos.longitude);
//       if (marks.isNotEmpty) {
//         final p = marks.first;
//         title = [
//           if ((p.name ?? '').trim().isNotEmpty) p.name,
//           if ((p.subLocality ?? '').trim().isNotEmpty) p.subLocality,
//         ]
//             .whereType<String>()
//             .map((s) => s.trim())
//             .where((s) => s.isNotEmpty)
//             .join(", ");
//         if (title.trim().isEmpty) title = "Pinned location";
//         full = [
//           p.name,
//           p.street,
//           p.subLocality,
//           p.locality,
//           p.administrativeArea,
//           p.postalCode
//         ]
//             .whereType<String>()
//             .map((s) => s.trim())
//             .where((s) => s.isNotEmpty)
//             .join(", ");
//       }
//     } catch (_) {}

//     setState(() {
//       _selectionSource = _SelectionSource.pin; // mark as pin
//       _markers
//         ..clear()
//         ..add(Marker(
//           markerId: const MarkerId('pinned'),
//           position: pos,
//           infoWindow: InfoWindow(title: title, snippet: full),
//         ));
//       _pendingLatLng = pos;
//       _pendingAddressTitle = title;
//       _pendingFullAddress = full;
//     });

//     await mapController?.animateCamera(
//       CameraUpdate.newCameraPosition(CameraPosition(target: pos, zoom: 16)),
//     );

//     _showConfirmSheet();
//   }

//   Future<void> _savePinnedToMain({
//     String collectionPath = 'saved_locations', // change if you want user-scoped
//   }) async {
//     if (_pendingLatLng == null) return;
//     try {
//       await _main.collection(collectionPath).add({
//         'label': widget.label, // "Pickup"/"Destination"
//         'title': _pendingAddressTitle ?? 'Pinned location',
//         'address': _pendingFullAddress ?? '',
//         'lat': _pendingLatLng!.latitude,
//         'lng': _pendingLatLng!.longitude,
//         'createdAt': FieldValue.serverTimestamp(),
//         'updatedAt': FieldValue.serverTimestamp(),
//         // extra context (optional)
//         'house': _houseCtrl.text.trim(),
//         'senderName': _nameCtrl.text.trim(),
//         'senderPhone': _phoneCtrl.text.trim(),
//         'instruction': _instructionCtrl.text.trim(),
//         'packageTypeKey': _pkgSelectedKey,
//         'packageTypeCustom':
//             _showPkgOtherField ? _pkgOtherCtrl.text.trim() : null,
//       });
//     } catch (_) {
//       // optionally handle/log
//     }
//   }

//   // ---------- Confirm sheet ----------
//   Future<void> _showConfirmSheet() async {
//     final String userMobile =
//         widget.defaultSenderMobile ?? _phoneCtrl.text; // optional default

//     await showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.white,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(
//           top: Radius.circular(MediaQuery.of(context).size.width * .05),
//         ),
//       ),
//       builder: (ctx) {
//         final width = MediaQuery.of(ctx).size.width;
//         final bottomInset = MediaQuery.of(ctx).viewInsets.bottom;
//         final inputH = width * .105; // uniform height

//         Widget buildLinedField({
//           required TextEditingController controller,
//           required String hint,
//           TextInputType? keyboardType,
//           Widget? suffixIcon,
//           bool enabled = true,
//         }) {
//           return SizedBox(
//             height: inputH,
//             child: TextField(
//               controller: controller,
//               keyboardType: keyboardType,
//               enabled: enabled,
//               maxLines: 1,
//               textAlignVertical: TextAlignVertical.center,
//               style: TextStyle(fontSize: width * .034),
//               decoration: InputDecoration(
//                 hintText: hint,
//                 hintStyle: TextStyle(fontSize: width * .032),
//                 contentPadding: EdgeInsets.symmetric(
//                   horizontal: width * .035,
//                 ),
//                 suffixIcon: suffixIcon,
//                 filled: true,
//                 fillColor: Colors.white,
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(width * .03),
//                   borderSide: const BorderSide(color: Color(0xFFDFE3EA)),
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(width * .03),
//                   borderSide: const BorderSide(color: Color(0xFFDFE3EA)),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(width * .03),
//                   borderSide: const BorderSide(color: Color(0xFF2F6BFF)),
//                 ),
//               ),
//             ),
//           );
//         }

//         return StatefulBuilder(
//           builder: (ctx, setSheet) {
//             bool canConfirm() =>
//                 _nameCtrl.text.trim().isNotEmpty &&
//                 _phoneCtrl.text.trim().isNotEmpty &&
//                 _pkgSelectedKey != null; // must select one item in grid

//             String? pkgLabel() {
//               if (_pkgSelectedKey == null) return null;
//               if (_pkgSelectedKey == 'other') {
//                 final custom = _pkgOtherCtrl.text.trim();
//                 return custom.isNotEmpty ? custom : 'Other';
//               }
//               return _packageTypeMap[_pkgSelectedKey!]!['label'] as String;
//             }

//             // Little header chips for context
//             Widget chip(String text, IconData icon) => Container(
//                   padding: EdgeInsets.symmetric(
//                       horizontal: width * .02, vertical: width * .012),
//                   margin: EdgeInsets.only(right: width * .015),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFF4F7FF),
//                     borderRadius: BorderRadius.circular(width * .025),
//                     border: Border.all(color: const Color(0xFFE3E8F8)),
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Icon(icon,
//                           size: width * .035, color: const Color(0xFF2F6BFF)),
//                       SizedBox(width: width * .01),
//                       Text(text,
//                           style: TextStyle(
//                               fontSize: width * .028,
//                               color: const Color(0xFF2F3A4B),
//                               fontWeight: FontWeight.w600)),
//                     ],
//                   ),
//                 );

//             return Padding(
//               padding: EdgeInsets.only(bottom: bottomInset),
//               child: SafeArea(
//                 top: false,
//                 child: SingleChildScrollView(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // drag handle
//                       Center(
//                         child: Container(
//                           width: width * .18,
//                           height: width * .013,
//                           margin: EdgeInsets.only(
//                               bottom: width * .02, top: width * .02),
//                           decoration: BoxDecoration(
//                             color: Colors.black12,
//                             borderRadius: BorderRadius.circular(width * .01),
//                           ),
//                         ),
//                       ),

//                       // header chips
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: width * .05),
//                         child: Wrap(
//                           children: [
//                             chip(widget.label, Icons.flag),
//                             if (_selectionSource == _SelectionSource.pin)
//                               chip("Pinned", Icons.push_pin_outlined)
//                             else if (_selectionSource ==
//                                 _SelectionSource.localCache)
//                               chip("From cache", Icons.cloud_done_outlined)
//                             else
//                               chip("Google", Icons.place_outlined),
//                           ],
//                         ),
//                       ),

//                       Padding(
//                         padding: EdgeInsets.symmetric(
//                           horizontal: width * .05,
//                           vertical: width * .02,
//                         ),
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             // Location row
//                             Row(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Icon(Icons.place,
//                                     color: Colors.green, size: width * .05),
//                                 SizedBox(width: width * .02),
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         _pendingAddressTitle ?? widget.label,
//                                         style: TextStyle(
//                                           fontSize: width * .04,
//                                           fontWeight: FontWeight.w700,
//                                         ),
//                                       ),
//                                       SizedBox(height: width * .01),
//                                       Text(
//                                         _pendingFullAddress ?? '',
//                                         style: TextStyle(
//                                           color: Colors.black87,
//                                           height: 1.2,
//                                           fontSize: width * .032,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 TextButton(
//                                   onPressed: () => Navigator.pop(ctx),
//                                   child: Text("Change",
//                                       style: TextStyle(fontSize: width * .032)),
//                                 ),
//                               ],
//                             ),
//                             SizedBox(height: width * .03),

//                             // House/Shop
//                             buildLinedField(
//                               controller: _houseCtrl,
//                               hint: "House / Apartment / Shop (optional)",
//                             ),
//                             SizedBox(height: width * .02),

//                             // Sender name
//                             Text("Sender's Name",
//                                 style: TextStyle(
//                                     fontSize: width * .032,
//                                     fontWeight: FontWeight.w500)),
//                             SizedBox(height: width * .01),
//                             SizedBox(
//                               height: inputH,
//                               child: TextField(
//                                 controller: _nameCtrl,
//                                 onChanged: (_) => setSheet(() {}),
//                                 maxLines: 1,
//                                 textAlignVertical: TextAlignVertical.center,
//                                 style: TextStyle(fontSize: width * .034),
//                                 decoration: InputDecoration(
//                                   hintText: "Enter sender name",
//                                   hintStyle: TextStyle(fontSize: width * .032),
//                                   contentPadding: EdgeInsets.symmetric(
//                                       horizontal: width * .035),
//                                   filled: true,
//                                   fillColor: Colors.white,
//                                   border: OutlineInputBorder(
//                                     borderRadius:
//                                         BorderRadius.circular(width * .03),
//                                     borderSide: const BorderSide(
//                                         color: Color(0xFFDFE3EA)),
//                                   ),
//                                   enabledBorder: OutlineInputBorder(
//                                     borderRadius:
//                                         BorderRadius.circular(width * .03),
//                                     borderSide: const BorderSide(
//                                         color: Color(0xFFDFE3EA)),
//                                   ),
//                                   focusedBorder: OutlineInputBorder(
//                                     borderRadius:
//                                         BorderRadius.circular(width * .03),
//                                     borderSide: const BorderSide(
//                                         color: Color(0xFF2F6BFF)),
//                                   ),
//                                   suffixIcon: Icon(Icons.recent_actors_outlined,
//                                       size: width * .05),
//                                 ),
//                               ),
//                             ),
//                             SizedBox(height: width * .02),

//                             // Sender phone
//                             Text("Sender's Mobile number",
//                                 style: TextStyle(
//                                     fontSize: width * .032,
//                                     fontWeight: FontWeight.w500)),
//                             SizedBox(height: width * .01),
//                             SizedBox(
//                               height: inputH,
//                               child: TextField(
//                                 controller: _phoneCtrl,
//                                 keyboardType: TextInputType.phone,
//                                 onChanged: (_) => setSheet(() {}),
//                                 maxLines: 1,
//                                 textAlignVertical: TextAlignVertical.center,
//                                 style: TextStyle(fontSize: width * .034),
//                                 decoration: InputDecoration(
//                                   hintText: "Enter mobile number",
//                                   hintStyle: TextStyle(fontSize: width * .032),
//                                   contentPadding: EdgeInsets.symmetric(
//                                       horizontal: width * .035),
//                                   filled: true,
//                                   fillColor: Colors.white,
//                                   border: OutlineInputBorder(
//                                     borderRadius:
//                                         BorderRadius.circular(width * .03),
//                                     borderSide: const BorderSide(
//                                         color: Color(0xFFDFE3EA)),
//                                   ),
//                                   enabledBorder: OutlineInputBorder(
//                                     borderRadius:
//                                         BorderRadius.circular(width * .03),
//                                     borderSide: const BorderSide(
//                                         color: Color(0xFFDFE3EA)),
//                                   ),
//                                   focusedBorder: OutlineInputBorder(
//                                     borderRadius:
//                                         BorderRadius.circular(width * .03),
//                                     borderSide: const BorderSide(
//                                         color: Color(0xFF2F6BFF)),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             SizedBox(height: width * .01),

//                             // Use my mobile checkbox
//                             Row(
//                               children: [
//                                 SizedBox(
//                                   width: width * .06,
//                                   height: width * .06,
//                                   child: Checkbox(
//                                     value: _useMyMobile,
//                                     onChanged: (v) {
//                                       setSheet(() {
//                                         _useMyMobile = v ?? false;
//                                         if (_useMyMobile &&
//                                             (widget.defaultSenderMobile ?? '')
//                                                 .isNotEmpty) {
//                                           _phoneCtrl.text =
//                                               widget.defaultSenderMobile!;
//                                         }
//                                       });
//                                     },
//                                   ),
//                                 ),
//                                 SizedBox(width: width * .02),
//                                 Expanded(
//                                   child: Text(
//                                     "Use my mobile number${(widget.defaultSenderMobile ?? '').isNotEmpty ? " : ${widget.defaultSenderMobile}" : ""}",
//                                     style: TextStyle(fontSize: width * .032),
//                                   ),
//                                 ),
//                               ],
//                             ),

//                             SizedBox(height: width * .03),

//                             // Package Type
//                             Text(
//                               "Package Type (required)",
//                               style: TextStyle(
//                                   fontSize: width * .034,
//                                   fontWeight: FontWeight.w700),
//                             ),
//                             SizedBox(height: width * .02),

//                             GridView.builder(
//                               padding: EdgeInsets.zero,
//                               shrinkWrap: true,
//                               physics: const NeverScrollableScrollPhysics(),
//                               itemCount: _packageTypeMap.keys.toList().length,
//                               gridDelegate:
//                                   SliverGridDelegateWithFixedCrossAxisCount(
//                                 crossAxisCount: 4,
//                                 mainAxisSpacing: width * 0.02,
//                                 crossAxisSpacing: width * 0.02,
//                                 childAspectRatio: 1,
//                               ),
//                               itemBuilder: (context, index) {
//                                 final key =
//                                     _packageTypeMap.keys.toList()[index];
//                                 return _buildPackageTile(key, setSheet, width);
//                               },
//                             ),

//                             if (_showPkgOtherField) ...[
//                               SizedBox(height: width * .02),
//                               SizedBox(
//                                 height: inputH,
//                                 child: TextField(
//                                   controller: _pkgOtherCtrl,
//                                   maxLines: 1,
//                                   textAlignVertical: TextAlignVertical.center,
//                                   style: TextStyle(fontSize: width * .034),
//                                   decoration: const InputDecoration(
//                                     labelText: "Enter package type",
//                                     border: OutlineInputBorder(),
//                                   ),
//                                 ),
//                               ),
//                             ],

//                             SizedBox(height: width * .03),

//                             // Instruction (single-line, same height)
//                             Text(
//                               "Courier instruction (optional)",
//                               style: TextStyle(
//                                   fontSize: width * .032,
//                                   fontWeight: FontWeight.w500),
//                             ),
//                             SizedBox(height: width * .01),
//                             SizedBox(
//                               height: inputH,
//                               child: TextField(
//                                 controller: _instructionCtrl,
//                                 maxLines: 1,
//                                 textAlignVertical: TextAlignVertical.center,
//                                 style: TextStyle(fontSize: width * .034),
//                                 decoration: InputDecoration(
//                                   hintText:
//                                       "E.g. call on arrival, leave with security, fragile, etc.",
//                                   hintStyle: TextStyle(fontSize: width * .032),
//                                   contentPadding: EdgeInsets.symmetric(
//                                       horizontal: width * .035),
//                                   filled: true,
//                                   fillColor: Colors.white,
//                                   border: OutlineInputBorder(
//                                     borderRadius:
//                                         BorderRadius.circular(width * .03),
//                                     borderSide: const BorderSide(
//                                         color: Color(0xFFDFE3EA)),
//                                   ),
//                                   enabledBorder: OutlineInputBorder(
//                                     borderRadius:
//                                         BorderRadius.circular(width * .03),
//                                     borderSide: const BorderSide(
//                                         color: Color(0xFFDFE3EA)),
//                                   ),
//                                   focusedBorder: OutlineInputBorder(
//                                     borderRadius:
//                                         BorderRadius.circular(width * .03),
//                                     borderSide: const BorderSide(
//                                         color: Color(0xFF2F6BFF)),
//                                   ),
//                                 ),
//                               ),
//                             ),

//                             SizedBox(height: width * .04),

//                             // Confirm button
//                             SizedBox(
//                               width: double.infinity,
//                               child: ElevatedButton(
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: canConfirm()
//                                       ? const Color(0xFF2F6BFF)
//                                       : const Color(0xFFBFC7DB),
//                                   foregroundColor: Colors.white,
//                                   padding: EdgeInsets.symmetric(
//                                     vertical: width * .04,
//                                     horizontal: width * .035,
//                                   ),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius:
//                                         BorderRadius.circular(width * .035),
//                                   ),
//                                 ),
//                                 onPressed: canConfirm()
//                                     ? () async {
//                                         _confirmed = true;

//                                         // write address back to parent textfield
//                                         if (_pendingFullAddress != null) {
//                                           _searchCtrl.text =
//                                               _pendingFullAddress!;
//                                         }

//                                         final String? pkgKey = _pkgSelectedKey;
//                                         final String? pkgText = pkgLabel();
//                                         final String? pkgCustom =
//                                             _showPkgOtherField &&
//                                                     _pkgOtherCtrl.text
//                                                         .trim()
//                                                         .isNotEmpty
//                                                 ? _pkgOtherCtrl.text.trim()
//                                                 : null;

//                                         // 🔒 If this selection came from a PIN, save ONLY to MAIN DB.
//                                         if (_selectionSource ==
//                                             _SelectionSource.pin) {
//                                           await _savePinnedToMain();
//                                         }

//                                         Navigator.pop(ctx);
//                                         Navigator.of(context).pop({
//                                           'address': _pendingFullAddress ??
//                                               _searchCtrl.text,
//                                           'latLng': _pendingLatLng,
//                                           'label': widget.label,
//                                           'house': _houseCtrl.text.trim(),
//                                           'senderName': _nameCtrl.text.trim(),
//                                           'senderPhone': _phoneCtrl.text.trim(),
//                                           'instruction':
//                                               _instructionCtrl.text.trim(),
//                                           'packageTypeKey': pkgKey,
//                                           'packageTypeLabel': pkgText,
//                                           'packageTypeCustom': pkgCustom,
//                                         });
//                                       }
//                                     : null,
//                                 child: Text(
//                                   "Confirm and Proceed",
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.w700,
//                                     fontSize: width * .036,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             if (!canConfirm())
//                               Padding(
//                                 padding: EdgeInsets.only(top: width * .02),
//                                 child: Text(
//                                   "Select a package type, and enter sender name & mobile number to continue.",
//                                   style: TextStyle(
//                                     color: Colors.red.shade600,
//                                     fontSize: width * .03,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                               ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   Widget _buildPackageTile(
//     String key,
//     void Function(VoidCallback) setSheet,
//     double width,
//   ) {
//     final item = _packageTypeMap[key]!;
//     final bool isSelected = _pkgSelectedKey == key;

//     return GestureDetector(
//       onTap: () {
//         setSheet(() {
//           _pkgSelectedKey = key;
//           if (!_showPkgOtherField) _pkgOtherCtrl.clear();
//         });
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           color: isSelected ? Colors.blue.withOpacity(0.05) : null,
//           border: Border.all(
//             color: isSelected ? Colors.blue : Colors.black.withOpacity(0.25),
//             width: isSelected ? width * 0.005 : width * 0.003,
//           ),
//           borderRadius: BorderRadius.circular(width * 0.025),
//         ),
//         padding: EdgeInsets.symmetric(vertical: width * 0.02),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               item['icon'] as IconData,
//               color: isSelected ? Colors.blue : Colors.black,
//               size: width * 0.07,
//             ),
//             SizedBox(height: width * 0.015),
//             Text(
//               item['label'] as String,
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: width * 0.025,
//                 color: isSelected ? Colors.blue : Colors.black,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width; // <-- width*
//     final double spacerTop = width * .05;
//     final double fieldHeight = width * .105;
//     final double panelPad = width * .0125;
//     final double cardRadius = width * .03;
//     final double borderWidth = width * .005;
//     final double iconSize = width * .034;
//     final double gap = width * .01;

//     final String hintText = 'Search ${widget.label.toLowerCase()} location';

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
//               onLongPress: _onMapLongPress, // 👈 Pin flow
//             ),

//             // Search + suggestions
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
//                         // colored leading dot
//                         SizedBox(
//                           height: fieldHeight,
//                           child: Center(
//                             child: Container(
//                               width: width * 0.04,
//                               height: width * 0.04,
//                               decoration: BoxDecoration(
//                                 border: Border.all(
//                                   width: width * .005,
//                                   color: Colors.black.withOpacity(.25),
//                                 ),
//                                 color: widget.accentColor,
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

//                         // Search field + suggestion panel
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
//                                     hintText: hintText,
//                                     hintStyle:
//                                         TextStyle(fontSize: width * .032),
//                                     prefixIcon: Icon(
//                                       Icons.search,
//                                       size: iconSize,
//                                       color: widget.accentColor,
//                                     ),
//                                     suffixIcon: _searchCtrl.text.isEmpty
//                                         ? null
//                                         : IconButton(
//                                             icon: Icon(Icons.close,
//                                                 size: iconSize),
//                                             onPressed: () {
//                                               setState(() {
//                                                 _searchCtrl.clear();
//                                                 _results = [];
//                                                 _localResults = [];
//                                                 _error = null;
//                                               });
//                                             },
//                                           ),
//                                     border: InputBorder.none,
//                                     contentPadding:
//                                         EdgeInsets.only(top: width * .0125),
//                                   ),
//                                   style: TextStyle(fontSize: width * .035),
//                                 ),
//                               ),

//                               SizedBox(height: gap),

//                               // suggestion panel (INLINE)
//                               if (_searchFocus.hasFocus &&
//                                   (_loading ||
//                                       (!_showingLocal && _results.isNotEmpty) ||
//                                       (_showingLocal &&
//                                           _localResults.isNotEmpty) ||
//                                       (_error != null &&
//                                           _searchCtrl.text.isNotEmpty)))
//                                 Container(
//                                   padding: EdgeInsets.all(panelPad),
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
//                                   child: Column(
//                                     children: [
//                                       Align(
//                                         alignment: Alignment.centerLeft,
//                                         child: Padding(
//                                           padding: EdgeInsets.symmetric(
//                                               vertical: gap * .5,
//                                               horizontal: gap * .5),
//                                           child: Text(
//                                             _showingLocal
//                                                 ? "from g-service cache"
//                                                 : "popular locations near you",
//                                             style: TextStyle(
//                                               fontSize: width * .028,
//                                               color: Colors.black54,
//                                               fontWeight: FontWeight.w500,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                       if (_loading)
//                                         SizedBox(
//                                           height: width * .08,
//                                           child: const Center(
//                                               child:
//                                                   CupertinoActivityIndicator()),
//                                         )
//                                       else if (_error != null)
//                                         Padding(
//                                           padding: EdgeInsets.all(width * .01),
//                                           child: Text(
//                                             _error!,
//                                             style: TextStyle(
//                                               color: Colors.redAccent,
//                                               fontSize: width * .032,
//                                             ),
//                                           ),
//                                         )
//                                       else if (!_showingLocal &&
//                                           _results.isNotEmpty)
//                                         // GOOGLE results list
//                                         ListView.separated(
//                                           padding: EdgeInsets.zero,
//                                           shrinkWrap: true,
//                                           itemCount: _results.length,
//                                           separatorBuilder: (_, __) =>
//                                               SizedBox(height: gap * .6),
//                                           itemBuilder: (context, i) {
//                                             final p = _results[i];
//                                             final main = p.structuredFormatting
//                                                     ?.mainText ??
//                                                 (p.description ?? '');
//                                             final secondary = p
//                                                     .structuredFormatting
//                                                     ?.secondaryText ??
//                                                 '';
//                                             return InkWell(
//                                               onTap: () => _selectPrediction(p),
//                                               borderRadius:
//                                                   BorderRadius.circular(
//                                                       cardRadius),
//                                               child: Container(
//                                                 padding: EdgeInsets.symmetric(
//                                                   horizontal: width * .022,
//                                                   vertical: width * .018,
//                                                 ),
//                                                 decoration: BoxDecoration(
//                                                   color: Colors.white,
//                                                   borderRadius:
//                                                       BorderRadius.circular(
//                                                           cardRadius),
//                                                   boxShadow: [
//                                                     BoxShadow(
//                                                       color: Colors.black
//                                                           .withOpacity(.06),
//                                                       blurRadius: width * .02,
//                                                       offset: Offset(
//                                                           0, width * .005),
//                                                     ),
//                                                   ],
//                                                 ),
//                                                 child: Row(
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.start,
//                                                   children: [
//                                                     Container(
//                                                       width: width * .06,
//                                                       height: width * .06,
//                                                       decoration: BoxDecoration(
//                                                         shape: BoxShape.circle,
//                                                         color: widget
//                                                             .accentColor
//                                                             .withOpacity(.12),
//                                                       ),
//                                                       child: Icon(
//                                                         Icons.place_outlined,
//                                                         size: iconSize,
//                                                         color:
//                                                             widget.accentColor,
//                                                       ),
//                                                     ),
//                                                     SizedBox(
//                                                         width: width * .02),
//                                                     Expanded(
//                                                       child: Column(
//                                                         crossAxisAlignment:
//                                                             CrossAxisAlignment
//                                                                 .start,
//                                                         children: [
//                                                           Text(
//                                                             main,
//                                                             maxLines: 2,
//                                                             overflow:
//                                                                 TextOverflow
//                                                                     .ellipsis,
//                                                             style: TextStyle(
//                                                               fontSize:
//                                                                   width * .034,
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .w600,
//                                                             ),
//                                                           ),
//                                                           if (secondary
//                                                               .isNotEmpty) ...[
//                                                             SizedBox(
//                                                                 height: width *
//                                                                     .005),
//                                                             Text(
//                                                               secondary,
//                                                               maxLines: 2,
//                                                               overflow:
//                                                                   TextOverflow
//                                                                       .ellipsis,
//                                                               style: TextStyle(
//                                                                 fontSize:
//                                                                     width *
//                                                                         .028,
//                                                                 color: Colors
//                                                                     .black
//                                                                     .withOpacity(
//                                                                         .6),
//                                                               ),
//                                                             ),
//                                                           ],
//                                                         ],
//                                                       ),
//                                                     ),
//                                                     SizedBox(
//                                                         width: width * .01),
//                                                     Icon(Icons.north_east,
//                                                         size: iconSize,
//                                                         color: Colors.black45),
//                                                   ],
//                                                 ),
//                                               ),
//                                             );
//                                           },
//                                         )
//                                       else if (_showingLocal &&
//                                           _localResults.isNotEmpty)
//                                         // FIREBASE results list (g-service)
//                                         ListView.separated(
//                                           padding: EdgeInsets.zero,
//                                           shrinkWrap: true,
//                                           itemCount: _localResults.length,
//                                           separatorBuilder: (_, __) =>
//                                               SizedBox(height: gap * .6),
//                                           itemBuilder: (context, i) {
//                                             final item = _localResults[i];
//                                             return InkWell(
//                                               onTap: () => _selectLocal(item),
//                                               borderRadius:
//                                                   BorderRadius.circular(
//                                                       cardRadius),
//                                               child: Container(
//                                                 padding: EdgeInsets.symmetric(
//                                                   horizontal: width * .022,
//                                                   vertical: width * .018,
//                                                 ),
//                                                 decoration: BoxDecoration(
//                                                   color: Colors.white,
//                                                   borderRadius:
//                                                       BorderRadius.circular(
//                                                           cardRadius),
//                                                   boxShadow: [
//                                                     BoxShadow(
//                                                       color: Colors.black
//                                                           .withOpacity(.06),
//                                                       blurRadius: width * .02,
//                                                       offset: Offset(
//                                                           0, width * .005),
//                                                     ),
//                                                   ],
//                                                 ),
//                                                 child: Row(
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.start,
//                                                   children: [
//                                                     Container(
//                                                       width: width * .06,
//                                                       height: width * .06,
//                                                       decoration: BoxDecoration(
//                                                         shape: BoxShape.circle,
//                                                         color: Colors.green
//                                                             .withOpacity(.12),
//                                                       ),
//                                                       child: Icon(
//                                                         Icons
//                                                             .cloud_done_outlined,
//                                                         size: iconSize,
//                                                         color: Colors.green,
//                                                       ),
//                                                     ),
//                                                     SizedBox(
//                                                         width: width * .02),
//                                                     Expanded(
//                                                       child: Column(
//                                                         crossAxisAlignment:
//                                                             CrossAxisAlignment
//                                                                 .start,
//                                                         children: [
//                                                           Text(
//                                                             item.title,
//                                                             maxLines: 2,
//                                                             overflow:
//                                                                 TextOverflow
//                                                                     .ellipsis,
//                                                             style: TextStyle(
//                                                               fontSize:
//                                                                   width * .034,
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .w600,
//                                                             ),
//                                                           ),
//                                                           if (item.subtitle
//                                                               .isNotEmpty) ...[
//                                                             SizedBox(
//                                                                 height: width *
//                                                                     .005),
//                                                             Text(
//                                                               item.subtitle,
//                                                               maxLines: 2,
//                                                               overflow:
//                                                                   TextOverflow
//                                                                       .ellipsis,
//                                                               style: TextStyle(
//                                                                 fontSize:
//                                                                     width *
//                                                                         .028,
//                                                                 color: Colors
//                                                                     .black
//                                                                     .withOpacity(
//                                                                         .6),
//                                                               ),
//                                                             ),
//                                                           ],
//                                                         ],
//                                                       ),
//                                                     ),
//                                                     SizedBox(
//                                                         width: width * .01),
//                                                     Icon(Icons.north_east,
//                                                         size: iconSize,
//                                                         color: Colors.black45),
//                                                   ],
//                                                 ),
//                                               ),
//                                             );
//                                           },
//                                         )
//                                       else
//                                         // skeletons
//                                         Column(
//                                           children: List.generate(4, (i) {
//                                             return Container(
//                                               margin: EdgeInsets.symmetric(
//                                                 vertical: gap * .6,
//                                               ),
//                                               decoration: BoxDecoration(
//                                                 color: Colors.white,
//                                                 borderRadius:
//                                                     BorderRadius.circular(
//                                                         cardRadius),
//                                                 boxShadow: [
//                                                   BoxShadow(
//                                                     color: Colors.black
//                                                         .withOpacity(.06),
//                                                     blurRadius: width * .02,
//                                                     offset:
//                                                         Offset(0, width * .005),
//                                                   ),
//                                                 ],
//                                               ),
//                                               padding: EdgeInsets.symmetric(
//                                                 horizontal: width * .022,
//                                                 vertical: width * .018,
//                                               ),
//                                               child:
//                                                   SizedBox(height: width * .03),
//                                             );
//                                           }),
//                                         ),
//                                       SizedBox(height: gap),
//                                       Align(
//                                         alignment: Alignment.centerRight,
//                                         child: GestureDetector(
//                                           onTap: () async {
//                                             // Toggle: Google <-> Firebase
//                                             setState(() {
//                                               _error = null;
//                                             });
//                                             if (_showingLocal) {
//                                               _showingLocal = false;
//                                               // back to Google list (reuse current text)
//                                               await _search(
//                                                   _searchCtrl.text.trim());
//                                             } else {
//                                               _showingLocal = true;
//                                               await _searchLocal(
//                                                   _searchCtrl.text.trim());
//                                             }
//                                           },
//                                           child: Container(
//                                             decoration: BoxDecoration(
//                                               color: Colors.white,
//                                               border: Border.all(
//                                                 color: Colors.black26,
//                                                 width: width * .003,
//                                               ),
//                                               borderRadius:
//                                                   BorderRadius.circular(
//                                                       width * .02),
//                                             ),
//                                             child: Padding(
//                                               padding:
//                                                   EdgeInsets.all(width * .008),
//                                               child: Text(
//                                                 _showingLocal
//                                                     ? "show Google results"
//                                                     : "show places cache",
//                                                 style: TextStyle(
//                                                   fontSize: width * .028,
//                                                   color: Colors.black54,
//                                                   fontWeight: FontWeight.w500,
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
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

// -----------------------------------------

import 'dart:async';

import 'package:drivex/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// Google Places (legacy SDK you’re using)
import 'package:flutter_google_places_hoc081098/google_maps_webservice_places.dart'
    as gmws;
import 'package:google_api_headers/google_api_headers.dart';

// Current location + reverse geocoding
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

// 🔥 Firestore
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// uuid (fix: lowercase file name)
import 'package:uuid/uuid.dart';

class D2dPlaceSearchPage extends StatefulWidget {
  const D2dPlaceSearchPage({
    super.key,
    required this.controller, // FROM/TO controller (parent)
    required this.accentColor, // green/red
    required this.label, // "Pickup" or "Destination"
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

/// Row used when showing Firebase cache results
class _LocalPlace {
  final String id;
  final String title;
  final String subtitle;
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

class _D2dPlaceSearchPageState extends State<D2dPlaceSearchPage> {
  // NOTE: keep using your existing key here (legacy SDK). Make sure Places/Maps are enabled.
  final String googleApiKey = "AIzaSyDwD1BJXVxky_Cy6xzyQh_5A2PW9cTOO0I";

  GoogleMapController? mapController;

  // 👉 Convenience getters so we never mix DBs up
  FirebaseFirestore get _main => AppFire.mainDb; // drivex
  FirebaseFirestore get _gsvc => AppFire.gServiceDb; // g-service
  User? get _user => FirebaseAuth.instance.currentUser;

  // Search state
  late TextEditingController _searchCtrl; // bound to parent
  final FocusNode _searchFocus = FocusNode();
  Timer? _debounce;
  String _sessionToken = const Uuid().v4();

  // Google results
  List<gmws.Prediction> _results = [];

  // Local (Firestore) results
  List<_LocalPlace> _localResults = [];

  // Which list is currently displayed in the panel
  bool _showingLocal = false;

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
        // default to LOCAL first when the field gains focus (g-service cache)
        _showingLocal = true;
        _searchLocal(_searchCtrl.text.trim());
      }
      if (!_searchFocus.hasFocus) {
        setState(() {
          _results = [];
          _localResults = [];
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

  // ---------- Firestore cache upsert (SECONDARY g-service) ----------
  Future<void> _upsertPlaceCache({
    required String placeId,
    required String name,
    required String address,
    required LatLng latLng,
    String? stateName,
  }) async {
    final data = {
      'placeId': placeId,
      'name': name,
      'name_lc': name.toLowerCase(),
      'address': address, // may be String even if older docs used Map
      'lat': latLng.latitude,
      'lng': latLng.longitude,
      'state': stateName,
      'hits': FieldValue.increment(1),
      'updatedAt': FieldValue.serverTimestamp(),
      'createdAt': FieldValue.serverTimestamp(),
    };

    // if this place already exists, merge + increment hits
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

      if (!mounted) return;
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

  // ---------- Places search (Google) ----------
  Future<void> _onChanged(String text) async {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 260), () {
      // typing => try LOCAL first (g-service cache)
      _showingLocal = true;
      _searchLocal(text.trim());
    });
  }

  Future<void> _search(String input) async {
    if (!_searchFocus.hasFocus) return;
    if (input.length < 2) {
      setState(() {
        _results = [];
        _localResults = [];
        _error = null;
        _loading = false;
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
      _results = [];
      _localResults = [];
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

  // ---------- Firebase (places_cache) search — SECONDARY g-service ----------
  Future<void> _searchLocal(String input) async {
    final q = input.trim().toLowerCase();
    if (q.isEmpty) {
      setState(() {
        _localResults = [];
        _error = 'Type to search';
        _loading = false;
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
      _localResults = [];
    });

    try {
      final snap = await _gsvc
          .collection('places_cache')
          .orderBy('name_lc')
          .startAt([q])
          .endAt([q + '\uf8ff'])
          .limit(5)
          .get();

      final items = <_LocalPlace>[];
      for (final d in snap.docs) {
        final data = d.data();

        // ---- robust parsing of `address` (String OR Map) ----
        String subtitle = '';
        final addr = data['address'];
        if (addr is String) {
          subtitle = addr;
        } else if (addr is Map) {
          // prefer `formatted`, otherwise stitch common parts
          subtitle = (addr['formatted'] as String?) ??
              _joinNonEmpty([
                addr['premise'],
                addr['route'],
                addr['streetNumber'],
                addr['sublocality'],
                addr['locality'],
                addr['subDistrict'],
                addr['district'],
                addr['state'],
                addr['postalCode'],
                addr['countryCode'], // short
              ]);
        } else {
          subtitle = '';
        }

        final String title =
            (data['name'] as String?)?.trim().isNotEmpty == true
                ? data['name'] as String
                : (subtitle.isNotEmpty ? subtitle : 'Unknown');

        final lat = (data['lat'] as num?)?.toDouble();
        final lng = (data['lng'] as num?)?.toDouble();

        items.add(_LocalPlace(
          id: d.id,
          title: title,
          subtitle: subtitle,
          latLng: (lat != null && lng != null) ? LatLng(lat, lng) : null,
          docRef: d.reference,
        ));
      }

      if (!mounted) return;
      if (items.isNotEmpty) {
        setState(() {
          _localResults = items;
          _error = null;
          _loading = false;
          _showingLocal = true; // stay on local list
        });
      } else {
        // no local matches -> fall back to Google
        setState(() {
          _localResults = const [];
          _error = null;
          _loading = false;
        });
        _showingLocal = false;
        await _search(input); // reuse your Google search
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _localResults = [];
        _error = e.toString();
        _loading = false;
      });
    }
  }

  // helper to join address parts safely
  String _joinNonEmpty(List parts) {
    return parts
        .whereType<String>()
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .join(', ');
  }

  // ---------- Saved addresses helpers (Main DB) ----------
  String _displaySavedAddress(Map<String, dynamic> d) {
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

    final parts2 = <String>[
      (d['area'] as String?)?.trim() ?? '',
      (d['district'] as String?)?.trim() ?? '',
      (d['state'] as String?)?.trim() ?? '',
      (d['postalCode'] as String?)?.trim() ?? '',
    ].where((e) => e.isNotEmpty).toList();

    return parts2.isNotEmpty ? parts2.join(', ') : 'Saved location';
  }

  LatLng? _extractLatLng(Map<String, dynamic> d) {
    final gp = d['location'];
    if (gp is GeoPoint) return LatLng(gp.latitude, gp.longitude);
    if (gp is Map) {
      final la = (gp['lat'] as num?)?.toDouble();
      final ln = (gp['lng'] as num?)?.toDouble();
      if (la != null && ln != null) return LatLng(la, ln);
    }
    final la = (d['lat'] as num?)?.toDouble();
    final ln = (d['lng'] as num?)?.toDouble();
    if (la != null && ln != null) return LatLng(la, ln);

    final am = d['addressMap'];
    if (am is Map) {
      final la2 = (am['lat'] as num?)?.toDouble();
      final ln2 = (am['lng'] as num?)?.toDouble();
      if (la2 != null && ln2 != null) return LatLng(la2, ln2);
    }
    return null;
  }

  Future<void> _selectSavedAndReturn(Map<String, dynamic> d) async {
    final addr = _displaySavedAddress(d);
    final ll = _extractLatLng(d);
    if (ll == null) return;

    setState(() {
      _biasCenter = ll;
      _markers
        ..clear()
        ..add(Marker(
          markerId: const MarkerId('saved_pick'),
          position: ll,
          infoWindow: InfoWindow(title: d['label'] ?? 'Saved', snippet: addr),
        ));
      _pendingAddressTitle = d['label'] ?? 'Saved';
      _pendingFullAddress = addr;
      _pendingLatLng = ll;
    });

    await mapController?.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(target: ll, zoom: 16)),
    );

    // show on map for 3 seconds
    await Future.delayed(const Duration(seconds: 3));

    // write address back to parent textfield (NOT coordinates)
    _confirmed = true;
    _searchCtrl.text = addr;

    if (mounted) {
      Navigator.of(context).pop({
        'address': addr,
        'latLng': ll,
        'label': widget.label,
        'house': '',
        'senderName': _nameCtrl.text.trim(),
        'senderPhone': _phoneCtrl.text.trim(),
        'instruction': '',
        'packageTypeKey': null,
        'packageTypeLabel': null,
        'packageTypeCustom': null,
      });
    }
  }

  // ---------- Selection handlers (Google / local) ----------
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

    // pull state (administrative_area_level_1) if present
    String? stateName = detail.result.addressComponents
        .firstWhere(
          (c) => c.types.contains('administrative_area_level_1'),
          orElse: () =>
              gmws.AddressComponent(longName: '', shortName: '', types: []),
        )
        .longName;
    if (stateName?.isEmpty ?? true) stateName = _currentStateName;

    // 🔥 save/merge into g-service cache
    await _upsertPlaceCache(
      placeId: p.placeId!,
      name: title,
      address: fullAddress,
      latLng: target,
      stateName: stateName,
    );

    // (existing UI updates)
    setState(() {
      _biasCenter = target;
      _currentStateName = stateName;
      _markers
        ..clear()
        ..add(Marker(
          markerId: const MarkerId('picked'),
          position: target,
          infoWindow: InfoWindow(title: title, snippet: fullAddress),
        ));
      _pendingAddressTitle = title;
      _pendingFullAddress = fullAddress;
      _pendingLatLng = target;
    });

    await mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
          CameraPosition(target: target, zoom: 16.0)),
    );

    _showConfirmSheet();
  }

  Future<void> _selectLocal(_LocalPlace item) async {
    final target = item.latLng;
    if (target == null) return;

    setState(() {
      _biasCenter = target;
      _markers
        ..clear()
        ..add(
          Marker(
            markerId: const MarkerId('picked'),
            position: target,
            infoWindow: InfoWindow(title: item.title, snippet: item.subtitle),
          ),
        );
      _pendingAddressTitle = item.title;
      _pendingFullAddress = item.subtitle;
      _pendingLatLng = target;
    });

    // bump hits on the SAME g-service document
    await item.docRef.set({
      'hits': FieldValue.increment(1),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    await mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: target, zoom: 16.0),
      ),
    );

    _showConfirmSheet();
  }

  // ---------- Confirm sheet (for Google / g-service selections) ----------
  Future<void> _showConfirmSheet() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(MediaQuery.of(context).size.width * .05),
        ),
      ),
      builder: (ctx) {
        final width = MediaQuery.of(ctx).size.width;
        final bottomInset = MediaQuery.of(ctx).viewInsets.bottom;
        final inputH = width * .105; // uniform height

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

            Widget chip(String text, IconData icon) => Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: width * .02, vertical: width * .012),
                  margin: EdgeInsets.only(right: width * .015),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F7FF),
                    borderRadius: BorderRadius.circular(width * .025),
                    border: Border.all(color: const Color(0xFFE3E8F8)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon,
                          size: width * .035, color: const Color(0xFF2F6BFF)),
                      SizedBox(width: width * .01),
                      Text(text,
                          style: TextStyle(
                              fontSize: width * .028,
                              color: const Color(0xFF2F3A4B),
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                );

            return Padding(
              padding: EdgeInsets.only(bottom: bottomInset),
              child: SafeArea(
                top: false,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // drag handle
                      Center(
                        child: Container(
                          width: width * .18,
                          height: width * .013,
                          margin: EdgeInsets.only(
                              bottom: width * .02, top: width * .02),
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(width * .01),
                          ),
                        ),
                      ),

                      // header chips
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * .05),
                        child: Wrap(
                          children: [
                            chip(widget.label, Icons.flag),
                          ],
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
                                            (widget.defaultSenderMobile ?? '')
                                                .isNotEmpty) {
                                          _phoneCtrl.text =
                                              widget.defaultSenderMobile!;
                                        }
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(width: width * .02),
                                Expanded(
                                  child: Text(
                                    "Use my mobile number${(widget.defaultSenderMobile ?? '').isNotEmpty ? " : ${widget.defaultSenderMobile}" : ""}",
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
                              itemCount: _packageTypeMap.keys.toList().length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                mainAxisSpacing: width * 0.02,
                                crossAxisSpacing: width * 0.02,
                                childAspectRatio: 1,
                              ),
                              itemBuilder: (context, index) {
                                final key =
                                    _packageTypeMap.keys.toList()[index];
                                return _buildPackageTile(key, setSheet, width);
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

                            // Instruction (single-line)
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
                                    ? () async {
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
                                          'packageTypeKey': pkgKey,
                                          'packageTypeLabel': pkgText,
                                          'packageTypeCustom': pkgCustom,
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

  Widget _buildPackageTile(
    String key,
    void Function(VoidCallback) setSheet,
    double width,
  ) {
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
            color: isSelected ? Colors.blue : Colors.black.withOpacity(0.25),
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

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final width = mq.size.width; // <-- width*
    final double spacerTop = width * .05;
    final double fieldHeight = width * .105;
    final double panelPad = width * .0125;
    final double cardRadius = width * .03;
    final double borderWidth = width * .005;
    final double iconSize = width * .034;
    final double gap = width * .01;

    // Limit suggestion panel height so it won’t collide with keyboard
    final double kb = mq.viewInsets.bottom;
    final double screenH = mq.size.height;
    final double maxPanelH = (screenH - kb) * 0.7;

    final String hintText = 'Search ${widget.label.toLowerCase()} location';

    return Scaffold(
      resizeToAvoidBottomInset: true,
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

            // Search + saved locations + suggestions
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

                        // Search field + saved chips + suggestion panel
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
                                                _localResults = [];
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

                              // ===== Saved Locations row (horizontal) =====
                              if (_user != null)
                                Padding(
                                  padding: EdgeInsets.only(bottom: gap),
                                  child: StreamBuilder<
                                      QuerySnapshot<Map<String, dynamic>>>(
                                    stream: _main
                                        .collection('users')
                                        .doc(_user!.uid)
                                        .collection('saved_addresses')
                                        .orderBy('updatedAt', descending: true)
                                        .limit(20)
                                        .snapshots(),
                                    builder: (context, snap) {
                                      if (snap.connectionState ==
                                          ConnectionState.waiting) {
                                        return SizedBox(
                                          height: width * .12,
                                          child: const Center(
                                            child: CupertinoActivityIndicator(),
                                          ),
                                        );
                                      }
                                      if (snap.hasError) {
                                        return const SizedBox.shrink();
                                      }
                                      final docs = snap.data?.docs ?? [];
                                      if (docs.isEmpty) {
                                        return const SizedBox.shrink();
                                      }

                                      return Padding(
                                        padding: EdgeInsets.only(top: gap),
                                        child: SizedBox(
                                          height: width * .09,
                                          child: ListView.separated(
                                            scrollDirection: Axis.horizontal,
                                            padding: EdgeInsets.zero,
                                            itemCount: docs.length,
                                            separatorBuilder: (_, __) =>
                                                SizedBox(width: width * .02),
                                            itemBuilder: (_, i) {
                                              final data = docs[i].data();
                                              final label =
                                                  (data['label'] as String?)
                                                      ?.trim();
                                              final type =
                                                  (data['type'] as String?) ??
                                                      'other';
                                              final emoji = type == 'home'
                                                  ? '🏠'
                                                  : type == 'work'
                                                      ? '🏢'
                                                      : '📍';
                                              final text = (label?.isNotEmpty ==
                                                      true)
                                                  ? label!
                                                  : _displaySavedAddress(data);

                                              return GestureDetector(
                                                onTap: () =>
                                                    _selectSavedAndReturn(data),
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: width * .03,
                                                    vertical: width * .02,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(
                                                        color: Colors.black12),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            width * .03),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(.06),
                                                        blurRadius:
                                                            width * .015,
                                                        offset: Offset(
                                                            0, width * .005),
                                                      ),
                                                    ],
                                                  ),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Text(emoji,
                                                          style: TextStyle(
                                                              fontSize: width *
                                                                  .035)),
                                                      SizedBox(
                                                          width: width * .015),
                                                      ConstrainedBox(
                                                        constraints:
                                                            BoxConstraints(
                                                                maxWidth:
                                                                    width *
                                                                        .46),
                                                        child: Text(
                                                          text,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                            fontSize:
                                                                width * .032,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
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
                                  ),
                                ),

                              // suggestion panel (height-limited + scrollable)
                              if (_searchFocus.hasFocus &&
                                  (_loading ||
                                      (!_showingLocal && _results.isNotEmpty) ||
                                      (_showingLocal &&
                                          _localResults.isNotEmpty) ||
                                      (_error != null &&
                                          _searchCtrl.text.isNotEmpty)))
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxHeight: maxPanelH.clamp(200, 420),
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.all(panelPad),
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
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: gap * .5,
                                                  horizontal: gap * .5),
                                              child: Text(
                                                _showingLocal
                                                    ? "from g-service cache"
                                                    : "popular locations near you",
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
                                                  child:
                                                      CupertinoActivityIndicator()),
                                            )
                                          else if (_error != null)
                                            Padding(
                                              padding:
                                                  EdgeInsets.all(width * .01),
                                              child: Text(
                                                _error!,
                                                style: TextStyle(
                                                  color: Colors.redAccent,
                                                  fontSize: width * .032,
                                                ),
                                              ),
                                            )
                                          else if (!_showingLocal &&
                                              _results.isNotEmpty)
                                            // GOOGLE results list
                                            ListView.separated(
                                              padding: EdgeInsets.zero,
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount: _results.length,
                                              separatorBuilder: (_, __) =>
                                                  SizedBox(height: gap * .6),
                                              itemBuilder: (context, i) {
                                                final p = _results[i];
                                                final main = p
                                                        .structuredFormatting
                                                        ?.mainText ??
                                                    (p.description ?? '');
                                                final secondary = p
                                                        .structuredFormatting
                                                        ?.secondaryText ??
                                                    '';
                                                return InkWell(
                                                  onTap: () =>
                                                      _selectPrediction(p),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          cardRadius),
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
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
                                                          blurRadius:
                                                              width * .02,
                                                          offset: Offset(
                                                              0, width * .005),
                                                        ),
                                                      ],
                                                    ),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          width: width * .06,
                                                          height: width * .06,
                                                          decoration:
                                                              BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color: widget
                                                                .accentColor
                                                                .withOpacity(
                                                                    .12),
                                                          ),
                                                          child: Icon(
                                                            Icons
                                                                .place_outlined,
                                                            size: iconSize,
                                                            color: widget
                                                                .accentColor,
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
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      width *
                                                                          .034,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              ),
                                                              if (secondary
                                                                  .isNotEmpty) ...[
                                                                SizedBox(
                                                                    height:
                                                                        width *
                                                                            .005),
                                                                Text(
                                                                  secondary,
                                                                  maxLines: 2,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style:
                                                                      TextStyle(
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
                                                            color:
                                                                Colors.black45),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            )
                                          else if (_showingLocal &&
                                              _localResults.isNotEmpty)
                                            // FIREBASE results list (g-service)
                                            ListView.separated(
                                              padding: EdgeInsets.zero,
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount: _localResults.length,
                                              separatorBuilder: (_, __) =>
                                                  SizedBox(height: gap * .6),
                                              itemBuilder: (context, i) {
                                                final item = _localResults[i];
                                                return InkWell(
                                                  onTap: () =>
                                                      _selectLocal(item),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          cardRadius),
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
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
                                                          blurRadius:
                                                              width * .02,
                                                          offset: Offset(
                                                              0, width * .005),
                                                        ),
                                                      ],
                                                    ),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          width: width * .06,
                                                          height: width * .06,
                                                          decoration:
                                                              BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color: Colors.green
                                                                .withOpacity(
                                                                    .12),
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
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      width *
                                                                          .034,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              ),
                                                              if (item.subtitle
                                                                  .isNotEmpty) ...[
                                                                SizedBox(
                                                                    height:
                                                                        width *
                                                                            .005),
                                                                Text(
                                                                  item.subtitle,
                                                                  maxLines: 2,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style:
                                                                      TextStyle(
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
                                                            color:
                                                                Colors.black45),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            )
                                          else
                                            // skeletons
                                            Column(
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
                                                        offset: Offset(
                                                            0, width * .005),
                                                      ),
                                                    ],
                                                  ),
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: width * .022,
                                                    vertical: width * .018,
                                                  ),
                                                  child: SizedBox(
                                                      height: width * .03),
                                                );
                                              }),
                                            ),
                                          SizedBox(height: gap),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: GestureDetector(
                                              onTap: () async {
                                                // Toggle: Google <-> Firebase
                                                setState(() {
                                                  _error = null;
                                                });
                                                if (_showingLocal) {
                                                  _showingLocal = false;
                                                  await _search(
                                                      _searchCtrl.text.trim());
                                                } else {
                                                  _showingLocal = true;
                                                  await _searchLocal(
                                                      _searchCtrl.text.trim());
                                                }
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border.all(
                                                    color: Colors.black26,
                                                    width: width * .003,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          width * .02),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.all(
                                                      width * .008),
                                                  child: Text(
                                                    _showingLocal
                                                        ? "show Google results"
                                                        : "show places cache",
                                                    style: TextStyle(
                                                      fontSize: width * .028,
                                                      color: Colors.black54,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
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
          ],
        ),
      ),
    );
  }
}
