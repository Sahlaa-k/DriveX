// import 'dart:async';
// import 'dart:convert';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:drivex/core/constants/color_constant.dart';
// import 'package:drivex/core/constants/imageConstants.dart';
// import 'package:drivex/core/constants/localVariables.dart';
// import 'package:drivex/feature/bottomNavigation/pages/D2D/D2D_placeSearchPage.dart';
// import 'package:drivex/feature/bottomNavigation/pages/D2D/PickUpDetailPage.dart';
// import 'package:drivex/feature/bottomNavigation/pages/D2DPage_02.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
// import 'package:flutter_google_places_hoc081098/google_maps_webservice_places.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:http/http.dart' as http;
// import 'package:geolocator/geolocator.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:uuid/uuid.dart';
// // import 'share';

// const String googleApiKey = "";

// class D2DPage01 extends StatefulWidget {
//   const D2DPage01({super.key});

//   @override
//   State<D2DPage01> createState() => _D2DPage01State();
// }

// class _D2DPage01State extends State<D2DPage01> {
//   bool isFieldEnabled = true;
//   GoogleMapController? _mapController;
//   LatLng pickup = LatLng(10.998, 76.990);
//   LatLng drop = LatLng(10.995, 76.995);

//   final TextEditingController fromController = TextEditingController();
//   final TextEditingController toController = TextEditingController();
//   final FocusNode fromFocus = FocusNode();
//   final FocusNode toFocus = FocusNode();

//   bool isFieldActive = false;
//   String activeField = "";
//   List<dynamic> suggestions = [];

//   final String googleApiKey = "AIzaSyDwD1BJXVxky_Cy6xzyQh_5A2PW9cTOO0I";

//   @override
//   void initState() {
//     super.initState();
//     createTripDocument();
//     // tripSubscription?.cancel();
//     // listenToTripStream(tripId!);
//     // listenToTrip(tripId!);

//     fromFocus.addListener(() {
//       if (fromFocus.hasFocus) {
//         setState(() {
//           isFieldActive = true;
//           activeField = "from";
//         });
//       }
//     });

//     toFocus.addListener(() {
//       if (toFocus.hasFocus) {
//         setState(() {
//           isFieldActive = true;
//           activeField = "to";
//         });
//       }
//     });
//   }

//   // 🔑 Separate request IDs
//   String? pickupRequestId;
//   String? dropRequestId;

//   /// 1️⃣ Create a new location request (pickup or drop)
//   Future<void> createLocationRequest({
//     required bool isPickup,
//     required String senderName,
//     required String senderPhone,
//   }) async {
//     final docRef =
//         await FirebaseFirestore.instance.collection("locationRequests").add({
//       "type": isPickup ? "pickup" : "drop",
//       "senderName": senderName,
//       "senderPhone": senderPhone,
//       "coordinates": {}, // 👈 empty map, not empty string
//       "createdAt": FieldValue.serverTimestamp(),
//     });

//     if (isPickup) {
//       pickupRequestId = docRef.id;
//     } else {
//       dropRequestId = docRef.id;
//     }

//     // Generate unique link with requestId
//     String link = "https://drivex-2a34e.web.app/?id=${docRef.id}";

//     // Share the link
//     await Share.share("Please share your location using this link: $link");

//     // Start listening immediately
//     listenToLocationUpdate(docRef.id, isPickup);
//   }

//   /// 2️⃣ Listen for location updates
//   void listenToLocationUpdate(String requestId, bool isPickup) {
//     FirebaseFirestore.instance
//         .collection("locationRequests")
//         .doc(requestId)
//         .snapshots()
//         .listen((doc) {
//       if (doc.exists &&
//           doc.data()?['coordinates'] != null &&
//           (doc['coordinates'] as Map).isNotEmpty) {
//         final coords = doc['coordinates'];
//         final lat = coords['lat'];
//         final lng = coords['lng'];

//         setState(() {
//           if (isPickup) {
//             fromController.text = "$lat, $lng";
//           } else {
//             toController.text = "$lat, $lng";
//           }
//         });

//         print("✅ Got ${isPickup ? "Pickup" : "Drop"} Location: $lat, $lng");
//       }
//     });
//   }

//   String generateMapLink(double lat, double lng) {
//     return "https://www.google.com/maps?q=$lat,$lng";
//   }

//   ///////////////////////////////////

//   ///////////////////////////////////

//   Future<void> requestLocation(TextEditingController controller) async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       throw Exception("Location services are disabled.");
//     }

//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         throw Exception("Location permission denied.");
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       throw Exception("Location permission permanently denied.");
//     }

//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);

//     String link = generateMapLink(position.latitude, position.longitude);

//     controller.text = link;

//     Share.share("Here is my location: $link");
//   }

//   /////////////////////////////
//   ///
//   ///
//   String? tripId;

//   Map<String, double>? pickupCoordinates;
//   Map<String, double>? dropCoordinates;

//   Future<void> sendLocationRequest(String type) async {
//     if (tripId == null) return;
//     String link =
//         "https://drivex-2a34e.web.app/?id=$tripId&type=$type"; // link includes type
//     await Share.share(
//         "Please share your $type location using this link: $link");
//   }

//   Future<void> createTripDocument() async {
//     final docRef =
//         await FirebaseFirestore.instance.collection("locationRequests").add({
//       "pickupLocation": null,
//       "dropLocation": null,
//       "senderName": "Kamal",
//       "senderPhone": "9876543210",
//       "createdAt": FieldValue.serverTimestamp(),
//     });

//     tripId = docRef.id;

//     // Start listening to the document
//     // await Duration(seconds: 10);
//     listenToTripUpdates();
//   }

//   void listenToTripUpdates() {
//     FirebaseFirestore.instance
//         .collection("locationRequests")
//         .doc(tripId)
//         .snapshots()
//         .listen((doc) {
//       if (!doc.exists) return;

//       final data = doc.data()!;
//       if (data['pickup'] != null) {
//         final coords = Map<String, dynamic>.from(data['pickup']);
//         setState(() {
//           pickupCoordinates = {
//             "lat": coords['lat'],
//             "lng": coords['lng'],
//           };
//           fromController.text = "${coords['lat']}, ${coords['lng']}";
//         });
//       }
//       if (data['drop'] != null) {
//         final coords = Map<String, dynamic>.from(data['drop']);
//         setState(() {
//           dropCoordinates = {
//             "lat": coords['lat'],
//             "lng": coords['lng'],
//           };
//           toController.text = "${coords['lat']}, ${coords['lng']}";
//         });
//       }
//     });
//   }

//   void NextPage() {
//     final pickup = fromController.text.trim();
//     final drop = toController.text.trim();

//     if (pickup.isEmpty || drop.isEmpty) {
//       _showSnackBar("Please fill both Pick-Up and Drop-Off Locations.");
//       return;
//     }

//     _showSnackBar("Driver requested successfully!");

//     Navigator.push(
//       context,
//       CupertinoPageRoute(
//         builder: (context) => D2Dpage02(
//           pickupLocation: pickup,
//           dropLocation: drop,
//         ),
//       ),
//     );

//     // Navigator.push(
//     //     context,
//     //     MaterialPageRoute(
//     //       builder: (context) => D2Dpage02(
//     //         pickupLocation: '',
//     //         dropLocation: '',
//     //       ),
//     //     ));
//   }

//   void _showSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message)),
//     );
//   }

//   // void listenForPickupLocation(String requestId) {
//   //   FirebaseFirestore.instance
//   //       .collection("locationRequests")
//   //       .doc(requestId)
//   //       .snapshots()
//   //       .listen((snapshot) {
//   //     if (snapshot.exists) {
//   //       final data = snapshot.data();
//   //       final lat = data?["pickupLat"];
//   //       final lng = data?["pickupLng"];
//   //       if (lat != null && lng != null) {
//   //         // Convert coordinates to address using Geocoding
//   //         placemarkFromCoordinates(lat, lng).then((placemarks) {
//   //           if (placemarks.isNotEmpty) {
//   //             final place = placemarks.first;
//   //             String address =
//   //                 "${place.name}, ${place.locality}, ${place.administrativeArea}";
//   //             // Update your field
//   //             fromController.text = address;
//   //           }
//   //         });
//   //       }
//   //     }
//   //   });
//   // }

//   // StreamBuilder<DocumentSnapshot<Map<String, dynamic>>> tripLocationStream(
//   //     String tripId) {
//   //   return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
//   //     stream: FirebaseFirestore.instance
//   //         .collection("trips")
//   //         .doc(tripId)
//   //         .snapshots(),
//   //     builder: (context, snapshot) {
//   //       if (snapshot.connectionState == ConnectionState.waiting) {
//   //         return const CircularProgressIndicator();
//   //       }
//   //       if (!snapshot.hasData || !snapshot.data!.exists) {
//   //         return const Text("No data found");
//   //       }
//   //       final data = snapshot.data!.data();
//   //       if (data == null) return const Text("No data available");
//   //       final pickup = data["pickupLocation"];
//   //       final drop = data["dropLocation"];
//   //       // ✅ Update your existing controllers
//   //       if (pickup != null) {
//   //         fromController.text = "(${pickup['lat']}, ${pickup['lng']})";
//   //       }
//   //       if (drop != null) {
//   //         toController.text = "(${drop['lat']}, ${drop['lng']})";
//   //       }
//   //       // You can return any widget you want here
//   //       return Column(
//   //         children: [
//   //           TextFormField(
//   //             controller: fromController,
//   //             decoration: const InputDecoration(labelText: "Pickup Location"),
//   //             readOnly: true,
//   //           ),
//   //           const SizedBox(height: 10),
//   //           TextFormField(
//   //             controller: toController,
//   //             decoration: const InputDecoration(labelText: "Drop Location"),
//   //             readOnly: true,
//   //           ),
//   //         ],
//   //       );
//   //     },
//   //   );
//   // }

//   // StreamSubscription? tripSubscription;

//   // void listenToTripLocations(String tripId) {
//   //   tripSubscription = FirebaseFirestore.instance
//   //       .collection(
//   //           "trips") // 👈 or "locationRequests" if that's your final collection
//   //       .doc(tripId)
//   //       .snapshots()
//   //       .listen((doc) {
//   //     if (!doc.exists) return;

//   //     final data = doc.data();
//   //     if (data == null) return;

//   //     // Listen for pickup
//   //     if (data["pickupLocation"] != null) {
//   //       final pickup = Map<String, dynamic>.from(data["pickupLocation"]);
//   //       fromController.text = "(${pickup['lat']}, ${pickup['lng']})";
//   //     }

//   //     // Listen for drop
//   //     if (data["dropLocation"] != null) {
//   //       final drop = Map<String, dynamic>.from(data["dropLocation"]);
//   //       toController.text = "(${drop['lat']}, ${drop['lng']})";
//   //     }
//   //   });
//   // }

//   void listenToTripStream(String tripId) {
//     FirebaseFirestore.instance
//         .collection("trips")
//         .doc(tripId)
//         .snapshots()
//         .listen((snapshot) {
//       if (!snapshot.exists) return;

//       final data = snapshot.data();
//       if (data == null) return;

//       final pickup = data["pickupLocation"];
//       final drop = data["dropLocation"];

//       if (pickup != null) {
//         fromController.text = "(${pickup['lat']}, ${pickup['lng']})";
//       }

//       if (drop != null) {
//         toController.text = "(${drop['lat']}, ${drop['lng']})";
//       }
//     });
//   }

//   // void listenToTrip(String tripId) {
//   //   FirebaseFirestore.instance
//   //       .collection("trips")
//   //       .doc(tripId)
//   //       .snapshots()
//   //       .listen((doc) {
//   //     if (doc.exists) {
//   //       var data = doc.data() as Map<String, dynamic>;
//   //       // pickup
//   //       if (data["pickupLocation"] != null) {
//   //         var pickup = data["pickupLocation"];
//   //         fromController.text =
//   //             "${pickup['lat']}, ${pickup['lng']}"; // or format nicely
//   //       }
//   //       // drop
//   //       if (data["dropLocation"] != null) {
//   //         var drop = data["dropLocation"];
//   //         toController.text = "${drop['lat']}, ${drop['lng']}";
//   //       }
//   //     }
//   //   });
//   // }

//   Stream<Map<String, dynamic>> streamTripData(String tripId) {
//     return FirebaseFirestore.instance
//         .collection("locationRequests") // change collection name if different
//         .doc(tripId)
//         .snapshots()
//         .map((snapshot) {
//       if (snapshot.exists) {
//         final data = snapshot.data() ?? {};
//         return {
//           "pickupLocation": data["pickupLocation"],
//           "dropLocation": data["dropLocation"],
//           "senderName": data["senderName"],
//           "senderPhone": data["senderPhone"],
//           "status": data["status"],
//         };
//       } else {
//         return {};
//       }
//     });
//   }

//   /////////////////////////////
//   double? pickupLat;
//   double? pickupLng;
//   String? pickupAddress;

//   double? dropLat;
//   double? dropLng;
//   String? dropAddress;

//   String? generatedLink;
//   final GoogleMapsPlaces _places =
//       GoogleMapsPlaces(apiKey: "");
//   // Future<void> _searchLocation(bool isPickup) async {
//   //   Prediction? p = await PlacesAutocomplete.show(
//   //     context: context,
//   //     apiKey: googleApiKey,
//   //     mode: Mode.overlay,
//   //     language: "en",
//   //     components: [Component(Component.country, "in")],
//   //   );

//   //   if (p != null) {
//   //     PlacesDetailsResponse detail =
//   //         await _places.getDetailsByPlaceId(p.placeId!);
//   //     final lat = detail.result.geometry!.location.lat;
//   //     final lng = detail.result.geometry!.location.lng;
//   //     final address = detail.result.formattedAddress ?? p.description!;

//   //     setState(() {
//   //       if (isPickup) {
//   //         pickupLat = lat;
//   //         pickupLng = lng;
//   //         pickupAddress = address;
//   //       } else {
//   //         dropLat = lat;
//   //         dropLng = lng;
//   //         dropAddress = address;
//   //       }
//   //     });
//   //   }
//   // }

//   void generateLink() {
//     if (pickupLat != null &&
//         pickupLng != null &&
//         dropLat != null &&
//         dropLng != null) {
//       generatedLink =
//           "https://www.google.com/maps/dir/$pickupLat,$pickupLng/$dropLat,$dropLng";
//       setState(() {});
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Please set both pickup and drop locations")),
//       );
//     }
//   }

//   ////////////////////////////

//   Future<void> getPlaceSuggestions(String input) async {
//     if (input.isEmpty) {
//       setState(() => suggestions = []);
//       return;
//     }

//     final sessionToken = Uuid().v4();
//     final url =
//         "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$googleApiKey&sessiontoken=$sessionToken&components=country:in";
//     final response = await http.get(Uri.parse(url));

//     if (response.statusCode == 200) {
//       final body = jsonDecode(response.body);
//       if (body['status'] == 'OK') {
//         setState(() {
//           suggestions = body['predictions'];
//         });
//       } else {
//         setState(() => suggestions = []);
//       }
//     }
//   }

//   Future<void> getCurrentLocationAndSetField() async {
//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);

//     final latLng = LatLng(position.latitude, position.longitude);

//     final url =
//         "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$googleApiKey";
//     final response = await http.get(Uri.parse(url));

//     if (response.statusCode == 200) {
//       final body = jsonDecode(response.body);
//       String address = "Current location";
//       if (body['status'] == 'OK') {
//         address = body['results'][0]['formatted_address'];
//       }

//       setState(() {
//         if (activeField == "from") {
//           pickup = latLng;
//           fromController.text = address;
//           _mapController?.animateCamera(CameraUpdate.newLatLng(pickup));
//         } else if (activeField == "to") {
//           drop = latLng;
//           toController.text = address;
//           _mapController?.animateCamera(CameraUpdate.newLatLng(drop));
//         }
//         isFieldActive = false;
//         suggestions.clear();
//       });
//     }
//   }

//   void selectSuggestion(String placeId) async {
//     final url =
//         "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$googleApiKey";
//     final response = await http.get(Uri.parse(url));

//     if (response.statusCode == 200) {
//       final result = jsonDecode(response.body)['result'];
//       final lat = result['geometry']['location']['lat'];
//       final lng = result['geometry']['location']['lng'];
//       final address = result['formatted_address'];

//       // setState(() {
//       //   if (activeField == "from") {
//       //     pickup = LatLng(lat, lng);
//       //     fromController.text = address;
//       //     _mapController?.animateCamera(CameraUpdate.newLatLng(pickup));
//       //   } else if (activeField == "to") {
//       //     drop = LatLng(lat, lng);
//       //     toController.text = address;
//       //     _mapController?.animateCamera(CameraUpdate.newLatLng(drop));
//       //   }
//       //   isFieldActive = false;
//       //   suggestions.clear();
//       // });
//     }
//   }

//   Stream<void> listenToTripData(
//       String tripId,
//       TextEditingController fromController,
//       TextEditingController toController) {
//     return FirebaseFirestore.instance
//         .collection("locationRequests")
//         .doc(tripId)
//         .snapshots()
//         .map((doc) {
//       if (doc.exists) {
//         final data = doc.data();

//         if (data != null) {
//           final pickup = data["pickupLocation"];
//           final drop = data["dropLocation"];

//           if (pickup != null) {
//             final lat = pickup["lat"];
//             final lng = pickup["lng"];
//             fromController.text = "Lat: $lat, Lng: $lng";
//           }

//           if (drop != null) {
//             final lat = drop["lat"];
//             final lng = drop["lng"];
//             toController.text = "Lat: $lat, Lng: $lng";
//           }
//         }
//       }
//     });
//   }

//   void _showCurrentLocationSheet(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//       ),
//       builder: (_) {
//         return Container(
//           padding: EdgeInsets.all(16),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               GestureDetector(
//                 onTap: () {
//                   Navigator.pop(context);
//                   getCurrentLocationAndSetField();
//                 },
//                 child: Row(
//                   children: [
//                     Icon(Icons.my_location, color: Colors.blue),
//                     SizedBox(width: 12),
//                     Text(
//                       "Use Current Location",
//                       style:
//                           TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 12),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   //////////////
//   Placemark? details;
//   Future<String> getPlaceFromCoordinates(double lat, double lon) async {
//     try {
//       List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);
//       if (placemarks.isNotEmpty) {
//         final place = placemarks.first;
//         details = place;
//         String address = [
//           place.name,
//           place.street,
//           place.subLocality,
//           place.locality,
//           place.administrativeArea,
//           place.country,
//           place.postalCode
//         ].where((part) => part != null && part!.isNotEmpty).join(', ');
//         return address;
//       } else {
//         return "No place found for the given coordinates.";
//       }
//     } catch (e) {
//       return "Error getting place: ${e.toString()}";
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Container(
//         color: ColorConstant.color1.withOpacity(.15),
//         child: Stack(
//           children: [
//             // Column(children: [],),

//             Container(
//               height: height * 1,
//               // color: ColorConstant.backgroundColor,
//               child: SingleChildScrollView(
//                 child: SafeArea(
//                   child: Stack(
//                     children: [
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: width * .02),
//                         child: Center(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               SizedBox(
//                                 height: width * .1,
//                               ),
//                               SizedBox(
//                                 height: width * .3,
//                               ),
//                               Container(
//                                 width: width * .75,
//                                 // height: width * .15,
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius:
//                                       BorderRadius.circular(width * .025),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.black12,
//                                       blurRadius: width * .02,
//                                       offset:
//                                           Offset(width * .01, width * .0125),
//                                     )
//                                   ],
//                                 ),
//                                 child: Padding(
//                                   padding: EdgeInsets.all(width * .02),
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         "How to use ?",
//                                         style: TextStyle(
//                                             fontSize: width * .03,
//                                             fontWeight: FontWeight.w500),
//                                       ),
//                                       Text(
//                                         "Tap the "
//                                         '"Request Location"'
//                                         " button and you will get a link\n"
//                                         "Share the link and Ask the other person to get in the link and Tap "
//                                         '"Share Location"',
//                                         style:
//                                             TextStyle(fontSize: width * .0275),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                               // Image.asset(
//                               //   // 'assets/images/pzerson-doing-delivery-activities-pack.png',
//                               //   // 'assets/images/DeliveryMan.png',
//                               //   ImageConstant.deliveryman1,
//                               //   width: width * .6,
//                               //   // width: width * .75,

//                               //   // height: 100,
//                               // ),

//                               StreamBuilder<DocumentSnapshot>(
//                                 stream: FirebaseFirestore.instance
//                                     .collection("locationRequests")
//                                     .doc(tripId) // replace with your trip id
//                                     .snapshots(),
//                                 builder: (context, snapshot) {
//                                   if (!snapshot.hasData) {
//                                     return CircularProgressIndicator();
//                                   }

//                                   var data = snapshot.data!.data()
//                                       as Map<String, dynamic>?;

//                                   if (data != null &&
//                                       data["pickupLocation"] != null) {
//                                     final pickup = data["pickupLocation"];
//                                     // update controller with stream data
//                                     fromController.text =
//                                         "(${pickup["lat"]},${pickup["lng"]})";
//                                   }
//                                   if (data != null &&
//                                       data["dropLocation"] != null) {
//                                     final drop = data["dropLocation"];
//                                     toController.text =
//                                         "(${drop["lat"]},${drop["lng"]})";
//                                   }

//                                   // if (data != null) {
//                                   //   // ✅ If pickup location exists
//                                   //   if (data["pickupLocation"] != null) {
//                                   //     final pickup = data["pickupLocation"];
//                                   //     fromController.text =
//                                   //         "Lat: ${pickup["lat"]}, Lng: ${pickup["lng"]}";
//                                   //   }

//                                   //   // ✅ If drop location exists
//                                   //   if (data["dropLocation"] != null) {
//                                   //     final drop = data["dropLocation"];
//                                   //     toController.text =
//                                   //         "Lat: ${drop["lat"]}, Lng: ${drop["lng"]}";
//                                   //   }
//                                   // }

//                                   return SizedBox(
//                                     width: width * .825,
//                                     child: Column(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.end,
//                                       children: [
//                                         SizedBox(
//                                           height: width * .1,
//                                         ),
//                                         Row(
//                                           children: [
//                                             Text("Enter PickUp Details",
//                                                 style: TextStyle(
//                                                     fontWeight: FontWeight.w500,
//                                                     fontSize: width * .035))
//                                           ],
//                                         ),
//                                         SizedBox(
//                                           height: width * .02,
//                                         ),
//                                         SizedBox(
//                                           width: width * .825,
//                                           child: Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceBetween,
//                                             children: [
//                                               Container(
//                                                 width: width * 0.04,
//                                                 height: width * 0.04,
//                                                 decoration: BoxDecoration(
//                                                   border: Border.all(
//                                                       width: width * .005,
//                                                       color: Colors.black
//                                                           .withOpacity(.25)),
//                                                   color: Colors
//                                                       .green, // Change for "To" field
//                                                   shape: BoxShape.circle,
//                                                 ),
//                                                 child: Center(
//                                                   child: Container(
//                                                       width: width * 0.04 / 2,
//                                                       height: width * 0.04 / 2,
//                                                       decoration: BoxDecoration(
//                                                         color: Colors.black
//                                                             .withOpacity(
//                                                                 0.5), // Change for "To" field
//                                                         shape: BoxShape.circle,
//                                                       )),
//                                                 ),
//                                               ),
//                                               GestureDetector(
//                                                 onTap: () async {
//                                                   await Navigator.push(
//                                                     context,
//                                                     CupertinoPageRoute(
//                                                       builder: (_) =>
//                                                           D2dPlaceSearchPage(
//                                                         controller:
//                                                             fromController, // bind FROM
//                                                         accentColor: Colors
//                                                             .green, // green page
//                                                         label: "Pickup",
//                                                       ),
//                                                     ),
//                                                   );
//                                                   setState(
//                                                       () {}); // refresh UI with updated text
//                                                 },
//                                                 child: Container(
//                                                   height: width * .125,
//                                                   width: width * .75,
//                                                   padding: EdgeInsets.only(
//                                                       left: width * 0.03),
//                                                   decoration: BoxDecoration(
//                                                     color: Colors.white,
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             width * 0.03),
//                                                   ),
//                                                   child: Row(
//                                                     children: [
//                                                       Expanded(
//                                                         child: Text(
//                                                           fromController
//                                                                   .text.isEmpty
//                                                               ? "Enter PickUp location"
//                                                               : fromController
//                                                                   .text,
//                                                           style: TextStyle(
//                                                             color: fromController
//                                                                     .text
//                                                                     .isEmpty
//                                                                 ? Colors.black
//                                                                     .withOpacity(
//                                                                         .5)
//                                                                 : Colors.black,
//                                                             fontSize:
//                                                                 width * 0.035,
//                                                           ),
//                                                         ),
//                                                       ),
//                                                       Padding(
//                                                         padding: EdgeInsets.all(
//                                                             width * .01),
//                                                         child: GestureDetector(
//                                                           onTap: () {
//                                                             sendLocationRequest(
//                                                                 "pickup");
//                                                           },
//                                                           child: Container(
//                                                             height:
//                                                                 double.infinity,
//                                                             width: width * .225,
//                                                             decoration:
//                                                                 BoxDecoration(
//                                                               color: ColorConstant
//                                                                   .greenColor
//                                                                   .withOpacity(
//                                                                       .9),
//                                                               borderRadius:
//                                                                   BorderRadius
//                                                                       .circular(
//                                                                           width *
//                                                                               0.02),
//                                                             ),
//                                                             child: Center(
//                                                               child: Text(
//                                                                 "Request\nLocation",
//                                                                 textAlign:
//                                                                     TextAlign
//                                                                         .center,
//                                                                 style:
//                                                                     TextStyle(
//                                                                   fontSize:
//                                                                       width *
//                                                                           .03,
//                                                                   fontWeight:
//                                                                       FontWeight
//                                                                           .w500,
//                                                                   color: Colors
//                                                                       .white,
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       )
//                                                     ],
//                                                   ),
//                                                 ),
//                                               )
//                                             ],
//                                           ),
//                                         ),
//                                         Center(
//                                           child: Text(
//                                             fromController.text,
//                                             style: TextStyle(
//                                                 fontSize: width * .025,
//                                                 color: Colors.black
//                                                     .withOpacity(.5)),
//                                           ),
//                                         ),
//                                         SizedBox(height: width * 0.1),
//                                         Row(
//                                           children: [
//                                             Text(
//                                               "Enter Drop Details",
//                                               style: TextStyle(
//                                                   fontWeight: FontWeight.w500,
//                                                   fontSize: width * .035),
//                                             )
//                                           ],
//                                         ),
//                                         SizedBox(
//                                           height: width * .02,
//                                         ),
//                                         SizedBox(
//                                           width: width * .825,
//                                           child: Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceBetween,
//                                             children: [
//                                               Container(
//                                                 width: width * 0.04,
//                                                 height: width * 0.04,
//                                                 decoration: BoxDecoration(
//                                                   border: Border.all(
//                                                       width: width * .005,
//                                                       color: Colors.black
//                                                           .withOpacity(.25)),
//                                                   color: Colors.redAccent[
//                                                       200], // Change for "To" field
//                                                   shape: BoxShape.circle,
//                                                 ),
//                                                 child: Center(
//                                                   child: Container(
//                                                       width: width * 0.04 / 2,
//                                                       height: width * 0.04 / 2,
//                                                       decoration: BoxDecoration(
//                                                         color: Colors.black
//                                                             .withOpacity(
//                                                                 0.5), // Change for "To" field
//                                                         shape: BoxShape.circle,
//                                                       )),
//                                                 ),
//                                               ),
//                                               GestureDetector(
//                                                 onTap: () async {
//                                                   await Navigator.push(
//                                                     context,
//                                                     CupertinoPageRoute(
//                                                       builder: (_) =>
//                                                           D2dPlaceSearchPage(
//                                                         controller:
//                                                             toController, // bind TO
//                                                         accentColor: Colors
//                                                             .redAccent, // red page
//                                                         label: "Drop",
//                                                       ),
//                                                     ),
//                                                   );
//                                                   setState(() {});
//                                                 },
//                                                 child: Container(
//                                                   width: width * .75,
//                                                   height: width * .125,
//                                                   padding: EdgeInsets.only(
//                                                       left: width * 0.03),
//                                                   decoration: BoxDecoration(
//                                                     color: Colors.white,
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             width * 0.03),
//                                                   ),
//                                                   child: Row(
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment
//                                                             .spaceBetween,
//                                                     children: [
//                                                       Expanded(
//                                                         child: Text(
//                                                           toController
//                                                                   .text.isEmpty
//                                                               ? "Enter Drop location"
//                                                               : toController
//                                                                   .text,
//                                                           style: TextStyle(
//                                                             color: toController
//                                                                     .text
//                                                                     .isEmpty
//                                                                 ? Colors.black
//                                                                     .withOpacity(
//                                                                         .5)
//                                                                 : Colors.black,
//                                                             fontSize:
//                                                                 width * 0.035,
//                                                           ),
//                                                         ),
//                                                       ),
//                                                       Padding(
//                                                         padding: EdgeInsets.all(
//                                                             width * .01),
//                                                         child: GestureDetector(
//                                                           onTap: () {
//                                                             sendLocationRequest(
//                                                                 "drop");
//                                                           },
//                                                           child: Container(
//                                                             height:
//                                                                 double.infinity,
//                                                             width: width * .225,
//                                                             decoration:
//                                                                 BoxDecoration(
//                                                               color: ColorConstant
//                                                                   .greenColor
//                                                                   .withOpacity(
//                                                                       .9),
//                                                               borderRadius:
//                                                                   BorderRadius
//                                                                       .circular(
//                                                                           width *
//                                                                               0.02),
//                                                             ),
//                                                             child: Center(
//                                                               child: Text(
//                                                                 "Request\nLocation",
//                                                                 textAlign:
//                                                                     TextAlign
//                                                                         .center,
//                                                                 style:
//                                                                     TextStyle(
//                                                                   fontSize:
//                                                                       width *
//                                                                           .03,
//                                                                   fontWeight:
//                                                                       FontWeight
//                                                                           .w500,
//                                                                   color: Colors
//                                                                       .white,
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               )
//                                             ],
//                                           ),
//                                         ),
//                                         Center(
//                                           child: Text(
//                                             toController.text,
//                                             style: TextStyle(
//                                                 fontSize: width * .025,
//                                                 color: Colors.black
//                                                     .withOpacity(.5)),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   );
//                                 },
//                               ),
//                               // StreamBuilder<DocumentSnapshot>(
//                               //   stream: FirebaseFirestore.instance
//                               //       .collection("locationRequests")
//                               //       .doc(tripId) // replace with your trip id
//                               //       .snapshots(),
//                               //   builder: (context, snapshot) {
//                               //     if (!snapshot.hasData) {
//                               //       return const Center(
//                               //           child: CircularProgressIndicator());
//                               //     }

//                               //     var data = snapshot.data!.data()
//                               //         as Map<String, dynamic>?;

//                               //     if (data != null &&
//                               //         data["pickupLocation"] != null) {
//                               //       final pickup = data["pickupLocation"];
//                               //       double lat = pickup["lat"];
//                               //       double lng = pickup["lng"];

//                               //       // 🔹 Convert to place name asynchronously
//                               //       getPlaceFromCoordinates(lat, lng)
//                               //           .then((placeName) {
//                               //         if (fromController.text != placeName) {
//                               //           fromController.text = placeName;
//                               //         }
//                               //       });
//                               //     }

//                               //     if (data != null &&
//                               //         data["dropLocation"] != null) {
//                               //       final drop = data["dropLocation"];
//                               //       double lat = drop["lat"];
//                               //       double lng = drop["lng"];

//                               //       // 🔹 Convert to place name asynchronously
//                               //       getPlaceFromCoordinates(lat, lng)
//                               //           .then((placeName) {
//                               //         if (toController.text != placeName) {
//                               //           toController.text = placeName;
//                               //         }
//                               //       });
//                               //     }

//                               //     return SizedBox(
//                               //       width: width * .825,
//                               //       child: Column(
//                               //         mainAxisAlignment:
//                               //             MainAxisAlignment.center,
//                               //         crossAxisAlignment:
//                               //             CrossAxisAlignment.end,
//                               //         children: [
//                               //           SizedBox(height: width * .1),
//                               //           Row(
//                               //             children: [
//                               //               Text("Enter PickUp Details",
//                               //                   style: TextStyle(
//                               //                       fontWeight: FontWeight.w500,
//                               //                       fontSize: width * .035))
//                               //             ],
//                               //           ),
//                               //           SizedBox(height: width * .02),
//                               //           SizedBox(
//                               //             width: width * .825,
//                               //             child: Row(
//                               //               mainAxisAlignment:
//                               //                   MainAxisAlignment.spaceBetween,
//                               //               children: [
//                               //                 Container(
//                               //                   width: width * 0.04,
//                               //                   height: width * 0.04,
//                               //                   decoration: BoxDecoration(
//                               //                     border: Border.all(
//                               //                         width: width * .005,
//                               //                         color: Colors.black
//                               //                             .withOpacity(.25)),
//                               //                     color: Colors.green,
//                               //                     shape: BoxShape.circle,
//                               //                   ),
//                               //                   child: Center(
//                               //                     child: Container(
//                               //                         width: width * 0.04 / 2,
//                               //                         height: width * 0.04 / 2,
//                               //                         decoration: BoxDecoration(
//                               //                           color: Colors.black
//                               //                               .withOpacity(0.5),
//                               //                           shape: BoxShape.circle,
//                               //                         )),
//                               //                   ),
//                               //                 ),
//                               //                 Container(
//                               //                   height: width * .125,
//                               //                   width: width * .75,
//                               //                   padding: EdgeInsets.only(
//                               //                       left: width * 0.03),
//                               //                   decoration: BoxDecoration(
//                               //                     color: Colors.white,
//                               //                     borderRadius:
//                               //                         BorderRadius.circular(
//                               //                             width * 0.03),
//                               //                   ),
//                               //                   child: Row(
//                               //                     children: [
//                               //                       Expanded(
//                               //                         child: TextFormField(
//                               //                           focusNode: fromFocus,
//                               //                           controller:
//                               //                               fromController,
//                               //                           onChanged:
//                               //                               getPlaceSuggestions,
//                               //                           style: TextStyle(
//                               //                             color: Colors.black,
//                               //                             fontSize:
//                               //                                 width * 0.04,
//                               //                           ),
//                               //                           decoration:
//                               //                               InputDecoration(
//                               //                             isDense: true,
//                               //                             hintText:
//                               //                                 "Enter PickUp location",
//                               //                             label: Text(
//                               //                               "From",
//                               //                               style: TextStyle(
//                               //                                 color: Colors
//                               //                                     .black
//                               //                                     .withOpacity(
//                               //                                         .75),
//                               //                                 fontSize:
//                               //                                     width * 0.035,
//                               //                               ),
//                               //                             ),
//                               //                             hintStyle: TextStyle(
//                               //                                 fontSize:
//                               //                                     width * .035,
//                               //                                 color: Colors
//                               //                                     .black
//                               //                                     .withOpacity(
//                               //                                         .5)),
//                               //                             border:
//                               //                                 InputBorder.none,
//                               //                           ),
//                               //                         ),
//                               //                       ),
//                               //                       Padding(
//                               //                         padding: EdgeInsets.all(
//                               //                             width * .01),
//                               //                         child: GestureDetector(
//                               //                           onTap: () {
//                               //                             sendLocationRequest(
//                               //                                 "pickup");
//                               //                           },
//                               //                           child: Container(
//                               //                             height:
//                               //                                 double.infinity,
//                               //                             width: width * .225,
//                               //                             decoration:
//                               //                                 BoxDecoration(
//                               //                               color: ColorConstant
//                               //                                   .greenColor
//                               //                                   .withOpacity(
//                               //                                       .9),
//                               //                               borderRadius:
//                               //                                   BorderRadius
//                               //                                       .circular(
//                               //                                           width *
//                               //                                               0.02),
//                               //                             ),
//                               //                             child: Center(
//                               //                               child: Text(
//                               //                                 "Request\nLocation",
//                               //                                 textAlign:
//                               //                                     TextAlign
//                               //                                         .center,
//                               //                                 style: TextStyle(
//                               //                                     fontSize:
//                               //                                         width *
//                               //                                             .03,
//                               //                                     fontWeight:
//                               //                                         FontWeight
//                               //                                             .w500,
//                               //                                     color: Colors
//                               //                                         .white),
//                               //                               ),
//                               //                             ),
//                               //                           ),
//                               //                         ),
//                               //                       )
//                               //                     ],
//                               //                   ),
//                               //                 ),
//                               //               ],
//                               //             ),
//                               //           ),
//                               //           Center(
//                               //             child: Text(
//                               //               fromController.text,
//                               //               style: TextStyle(
//                               //                   fontSize: width * .025,
//                               //                   color: Colors.black
//                               //                       .withOpacity(.5)),
//                               //             ),
//                               //           ),
//                               //           SizedBox(height: width * 0.1),
//                               //           Row(
//                               //             children: [
//                               //               Text(
//                               //                 "Enter Drop Details",
//                               //                 style: TextStyle(
//                               //                     fontWeight: FontWeight.w500,
//                               //                     fontSize: width * .035),
//                               //               )
//                               //             ],
//                               //           ),
//                               //           SizedBox(height: width * .02),
//                               //           SizedBox(
//                               //             width: width * .825,
//                               //             child: Row(
//                               //               mainAxisAlignment:
//                               //                   MainAxisAlignment.spaceBetween,
//                               //               children: [
//                               //                 Container(
//                               //                   width: width * 0.04,
//                               //                   height: width * 0.04,
//                               //                   decoration: BoxDecoration(
//                               //                     border: Border.all(
//                               //                         width: width * .005,
//                               //                         color: Colors.black
//                               //                             .withOpacity(.25)),
//                               //                     color: Colors.redAccent[200],
//                               //                     shape: BoxShape.circle,
//                               //                   ),
//                               //                   child: Center(
//                               //                     child: Container(
//                               //                         width: width * 0.04 / 2,
//                               //                         height: width * 0.04 / 2,
//                               //                         decoration: BoxDecoration(
//                               //                           color: Colors.black
//                               //                               .withOpacity(0.5),
//                               //                           shape: BoxShape.circle,
//                               //                         )),
//                               //                   ),
//                               //                 ),
//                               //                 Container(
//                               //                   width: width * .75,
//                               //                   height: width * .125,
//                               //                   padding: EdgeInsets.only(
//                               //                       left: width * 0.03),
//                               //                   decoration: BoxDecoration(
//                               //                     color: Colors.white,
//                               //                     borderRadius:
//                               //                         BorderRadius.circular(
//                               //                             width * 0.03),
//                               //                   ),
//                               //                   child: Row(
//                               //                     mainAxisAlignment:
//                               //                         MainAxisAlignment
//                               //                             .spaceBetween,
//                               //                     children: [
//                               //                       Expanded(
//                               //                         child: TextFormField(
//                               //                           focusNode: toFocus,
//                               //                           controller:
//                               //                               toController,
//                               //                           onChanged:
//                               //                               getPlaceSuggestions,
//                               //                           style: TextStyle(
//                               //                             color: Colors.black,
//                               //                             fontSize:
//                               //                                 width * 0.04,
//                               //                           ),
//                               //                           decoration:
//                               //                               InputDecoration(
//                               //                             isDense: true,
//                               //                             hintText:
//                               //                                 "Enter Drop location",
//                               //                             label: Text(
//                               //                               "To",
//                               //                               style: TextStyle(
//                               //                                 color: Colors
//                               //                                     .black
//                               //                                     .withOpacity(
//                               //                                         .75),
//                               //                                 fontSize:
//                               //                                     width * 0.035,
//                               //                               ),
//                               //                             ),
//                               //                             hintStyle: TextStyle(
//                               //                                 fontSize:
//                               //                                     width * .035,
//                               //                                 color: Colors
//                               //                                     .black
//                               //                                     .withOpacity(
//                               //                                         .5)),
//                               //                             border:
//                               //                                 InputBorder.none,
//                               //                           ),
//                               //                         ),
//                               //                       ),
//                               //                       Padding(
//                               //                         padding: EdgeInsets.all(
//                               //                             width * .01),
//                               //                         child: GestureDetector(
//                               //                           onTap: () {
//                               //                             sendLocationRequest(
//                               //                                 "drop");
//                               //                           },
//                               //                           child: Container(
//                               //                             height:
//                               //                                 double.infinity,
//                               //                             width: width * .225,
//                               //                             decoration:
//                               //                                 BoxDecoration(
//                               //                               color: ColorConstant
//                               //                                   .greenColor
//                               //                                   .withOpacity(
//                               //                                       .9),
//                               //                               borderRadius:
//                               //                                   BorderRadius
//                               //                                       .circular(
//                               //                                           width *
//                               //                                               0.02),
//                               //                             ),
//                               //                             child: Center(
//                               //                               child: Text(
//                               //                                 "Request\nLocation",
//                               //                                 textAlign:
//                               //                                     TextAlign
//                               //                                         .center,
//                               //                                 style: TextStyle(
//                               //                                     fontSize:
//                               //                                         width *
//                               //                                             .03,
//                               //                                     fontWeight:
//                               //                                         FontWeight
//                               //                                             .w500,
//                               //                                     color: Colors
//                               //                                         .white),
//                               //                               ),
//                               //                             ),
//                               //                           ),
//                               //                         ),
//                               //                       )
//                               //                     ],
//                               //                   ),
//                               //                 ),
//                               //               ],
//                               //             ),
//                               //           ),
//                               //           Center(
//                               //             child: Text(
//                               //               toController.text,
//                               //               style: TextStyle(
//                               //                   fontSize: width * .025,
//                               //                   color: Colors.black
//                               //                       .withOpacity(.5)),
//                               //             ),
//                               //           ),
//                               //         ],
//                               //       ),
//                               //     );
//                               //   },
//                               // ),

//                               // SizedBox(
//                               //   width: width * .825,
//                               //   child: Column(
//                               //     mainAxisAlignment: MainAxisAlignment.center,
//                               //     crossAxisAlignment: CrossAxisAlignment.end,
//                               //     children: [
//                               //       SizedBox(
//                               //         height: width * .1,
//                               //       ),
//                               //       Row(
//                               //         children: [
//                               //           Text("Enter PickUp Details",
//                               //               style: TextStyle(
//                               //                   fontWeight: FontWeight.w500,
//                               //                   fontSize: width * .035))
//                               //         ],
//                               //       ),
//                               //       SizedBox(
//                               //         height: width * .02,
//                               //       ),
//                               //       SizedBox(
//                               //         width: width * .825,
//                               //         child: Row(
//                               //           mainAxisAlignment:
//                               //               MainAxisAlignment.spaceBetween,
//                               //           children: [
//                               //             Container(
//                               //               width: width * 0.04,
//                               //               height: width * 0.04,
//                               //               decoration: BoxDecoration(
//                               //                 border: Border.all(
//                               //                     width: width * .005,
//                               //                     color: Colors.black
//                               //                         .withOpacity(.25)),
//                               //                 color: Colors
//                               //                     .green, // Change for "To" field
//                               //                 shape: BoxShape.circle,
//                               //               ),
//                               //               child: Center(
//                               //                 child: Container(
//                               //                     width: width * 0.04 / 2,
//                               //                     height: width * 0.04 / 2,
//                               //                     decoration: BoxDecoration(
//                               //                       color: Colors.black.withOpacity(
//                               //                           0.5), // Change for "To" field
//                               //                       shape: BoxShape.circle,
//                               //                     )),
//                               //               ),
//                               //             ),
//                               //             Container(
//                               //               // width: width * .825,
//                               //               height: width * .125,
//                               //               width: width * .75,
//                               //               padding: EdgeInsets.only(
//                               //                   left: width * 0.03),
//                               //               decoration: BoxDecoration(
//                               //                 // border: Border.all(
//                               //                 //     width: width * .005,
//                               //                 //     color: Colors.black.withOpacity(.1)),
//                               //                 // color: Color(0xFF3A3A3A).withOpacity(.25),
//                               //                 color: Colors.white,
//                               //                 // border: Border.all(
//                               //                 //     width: 2, color: Colors.black.withOpacity(.5)),
//                               //                 borderRadius:
//                               //                     BorderRadius.circular(
//                               //                         width * 0.03),
//                               //                 // boxShadow: [
//                               //                 //   BoxShadow(
//                               //                 //     color: Colors.black.withOpacity(0.3),
//                               //                 //     blurRadius: width * 0.02,
//                               //                 //     offset: Offset(0, width * 0.01),
//                               //                 //   ),
//                               //                 // ],
//                               //               ),
//                               //               child: Row(
//                               //                 children: [
//                               //                   Expanded(
//                               //                     child: TextFormField(
//                               //                       focusNode: fromFocus,
//                               //                       controller: fromController,
//                               //                       onChanged:
//                               //                           getPlaceSuggestions,
//                               //                       style: TextStyle(
//                               //                         color: Colors.black,
//                               //                         fontSize: width * 0.04,
//                               //                       ),
//                               //                       decoration: InputDecoration(
//                               //                         isDense: true,

//                               //                         hintText:
//                               //                             "Enter PickUp location",
//                               //                         label: Text(
//                               //                           "From",
//                               //                           style: TextStyle(
//                               //                             color: Colors.black
//                               //                                 .withOpacity(.75),
//                               //                             fontSize:
//                               //                                 width * 0.035,
//                               //                           ),
//                               //                         ),
//                               //                         // hintText:
//                               //                         //     "Al Shifa Hospital Rd, Valiyangadi...",
//                               //                         hintStyle: TextStyle(
//                               //                             fontSize:
//                               //                                 width * .035,
//                               //                             color: Colors.black
//                               //                                 .withOpacity(.5)),
//                               //                         border: InputBorder.none,
//                               //                       ),
//                               //                     ),
//                               //                   ),
//                               //                   Padding(
//                               //                     padding: EdgeInsets.all(
//                               //                         width * .01),
//                               //                     child: GestureDetector(
//                               //                       onTap: () {
//                               //                         sendLocationRequest(
//                               //                             "pickup");

//                               //                         // String requestId =
//                               //                         //     sendLocationRequest(
//                               //                         //         "pickup");

//                               //                         // Start listening for updates to that requestId
//                               //                         //   listenForPickupLocation(
//                               //                         //       requestId);
//                               //                       },
//                               //                       // onTap: () async {
//                               //                       //   // Save pickup in Firestore
//                               //                       //   final tripId =
//                               //                       //       await sendLocationRequest(
//                               //                       //           "pickup");

//                               //                       //   // Start listening to updates for that trip
//                               //                       //   if (tripId != null) {
//                               //                       //     listenToTripLocations(
//                               //                       //         tripId);
//                               //                       //   }
//                               //                       // },
//                               //                       child: Container(
//                               //                         height: double.infinity,
//                               //                         width: width * .225,
//                               //                         decoration: BoxDecoration(
//                               //                             color: Colors.blue
//                               //                                 .withOpacity(.9),
//                               //                             borderRadius:
//                               //                                 BorderRadius
//                               //                                     .circular(
//                               //                                         width *
//                               //                                             0.02)),
//                               //                         child: Center(
//                               //                           child: Text(
//                               //                             "Request\nLocation",
//                               //                             textAlign:
//                               //                                 TextAlign.center,
//                               //                             style: TextStyle(
//                               //                                 fontSize:
//                               //                                     width * .03,
//                               //                                 fontWeight:
//                               //                                     FontWeight
//                               //                                         .w500,
//                               //                                 color:
//                               //                                     Colors.white),
//                               //                           ),
//                               //                         ),
//                               //                       ),
//                               //                     ),
//                               //                   )
//                               //                 ],
//                               //               ),
//                               //             ),
//                               //           ],
//                               //         ),
//                               //       ),
//                               //       SizedBox(height: width * 0.1),
//                               //       Row(
//                               //         children: [
//                               //           Text(
//                               //             "Enter Drop Details",
//                               //             style: TextStyle(
//                               //                 fontWeight: FontWeight.w500,
//                               //                 fontSize: width * .035),
//                               //           )
//                               //         ],
//                               //       ),
//                               //       SizedBox(
//                               //         height: width * .02,
//                               //       ),
//                               //       SizedBox(
//                               //         width: width * .825,
//                               //         child: Row(
//                               //           mainAxisAlignment:
//                               //               MainAxisAlignment.spaceBetween,
//                               //           children: [
//                               //             Container(
//                               //               width: width * 0.04,
//                               //               height: width * 0.04,
//                               //               decoration: BoxDecoration(
//                               //                 border: Border.all(
//                               //                     width: width * .005,
//                               //                     color: Colors.black
//                               //                         .withOpacity(.25)),
//                               //                 color: Colors.redAccent[
//                               //                     200], // Change for "To" field
//                               //                 shape: BoxShape.circle,
//                               //               ),
//                               //               child: Center(
//                               //                 child: Container(
//                               //                     width: width * 0.04 / 2,
//                               //                     height: width * 0.04 / 2,
//                               //                     decoration: BoxDecoration(
//                               //                       color: Colors.black.withOpacity(
//                               //                           0.5), // Change for "To" field
//                               //                       shape: BoxShape.circle,
//                               //                     )),
//                               //               ),
//                               //             ),
//                               //             Container(
//                               //               width: width * .75,
//                               //               height: width * .125,
//                               //               // width: width * .825,
//                               //               padding: EdgeInsets.only(
//                               //                   left: width * 0.03),
//                               //               decoration: BoxDecoration(
//                               //                 color: Colors.white,
//                               //                 borderRadius:
//                               //                     BorderRadius.circular(
//                               //                         width * 0.03),
//                               //               ),
//                               //               child: Row(
//                               //                 mainAxisAlignment:
//                               //                     MainAxisAlignment
//                               //                         .spaceBetween,
//                               //                 children: [
//                               //                   Expanded(
//                               //                     child: TextFormField(
//                               //                       focusNode: toFocus,
//                               //                       controller: toController,
//                               //                       // onChanged: (value) {
//                               //                       // },
//                               //                       onChanged:
//                               //                           getPlaceSuggestions,
//                               //                       style: TextStyle(
//                               //                         color: Colors.black,
//                               //                         fontSize: width * 0.04,
//                               //                       ),
//                               //                       decoration: InputDecoration(
//                               //                         isDense: true,
//                               //                         hintText:
//                               //                             "Enter Drop location",
//                               //                         label: Text(
//                               //                           "To",
//                               //                           style: TextStyle(
//                               //                             color: Colors.black
//                               //                                 .withOpacity(.75),
//                               //                             fontSize:
//                               //                                 width * 0.035,
//                               //                           ),
//                               //                         ),
//                               //                         // hintText:
//                               //                         //     "Al Shifa Hospital Rd, Valiyangadi...",
//                               //                         hintStyle: TextStyle(
//                               //                             fontSize:
//                               //                                 width * .035,
//                               //                             color: Colors.black
//                               //                                 .withOpacity(.5)),
//                               //                         border: InputBorder.none,
//                               //                       ),
//                               //                     ),
//                               //                   ),
//                               //                   Padding(
//                               //                     padding: EdgeInsets.all(
//                               //                         width * .01),
//                               //                     child: GestureDetector(
//                               //                       onTap: () {
//                               //                         // createLocationRequest(
//                               //                         //   isPickup: false,
//                               //                         //   senderName:
//                               //                         //       "senderName",
//                               //                         //   senderPhone:
//                               //                         //       "senderPhone",
//                               //                         // );
//                               //                         sendLocationRequest(
//                               //                             "drop");
//                               //                       },
//                               //                       child: Container(
//                               //                         height: double.infinity,
//                               //                         width: width * .225,
//                               //                         decoration: BoxDecoration(
//                               //                             color: Colors.blue
//                               //                                 .withOpacity(.9),
//                               //                             borderRadius:
//                               //                                 BorderRadius
//                               //                                     .circular(
//                               //                                         width *
//                               //                                             0.02)),
//                               //                         child: Center(
//                               //                           child: Text(
//                               //                             "Request\nLocation",
//                               //                             textAlign:
//                               //                                 TextAlign.center,
//                               //                             style: TextStyle(
//                               //                                 fontSize:
//                               //                                     width * .03,
//                               //                                 fontWeight:
//                               //                                     FontWeight
//                               //                                         .w500,
//                               //                                 color:
//                               //                                     Colors.white),
//                               //                           ),
//                               //                         ),
//                               //                       ),
//                               //                     ),
//                               //                   )
//                               //                 ],
//                               //               ),
//                               //             ),
//                               //           ],
//                               //         ),
//                               //       ),
//                               //     ],
//                               //   ),
//                               // ),

//                               SizedBox(
//                                 height: width * .1,
//                               ),
//                               GestureDetector(
//                                 onTap: () {
//                                   // print("object");
//                                   // print(
//                                   //     "Pickup: $pickupCoordinates, Drop: $dropCoordinates");
//                                   // print("Trip ID: $tripId");
//                                   // // FirebaseFirestore.instance
//                                   // //     .collection("locationRequests")
//                                   // //     .doc(tripId)
//                                   // //     .get()
//                                   // //     .then((doc) {
//                                   // //   if (doc.exists) {
//                                   // //     final data = doc.data();
//                                   // //     print("Trip Data: $data");

//                                   // //     // print(data["pickupLocation"]);
//                                   // //   } else {
//                                   // //     print("No such document!");
//                                   // //   }
//                                   // // }).catchError((error) {
//                                   // //   print("Error getting document: $error");
//                                   // // });
//                                   // FirebaseFirestore.instance
//                                   //     .collection("locationRequests")
//                                   //     .doc(tripId)
//                                   //     .get()
//                                   //     .then((doc) {
//                                   //   if (doc.exists) {
//                                   //     final data = doc.data();

//                                   //     if (data != null) {
//                                   //       final pickup = data["pickupLocation"];
//                                   //       final drop = data["dropLocation"];

//                                   //       if (pickup != null) {
//                                   //         fromController.text =
//                                   //             "Lat: ${pickup["lat"]}, Lng: ${pickup["lng"]}";
//                                   //       }

//                                   //       if (drop != null) {
//                                   //         toController.text =
//                                   //             "Lat: ${drop["lat"]}, Lng: ${drop["lng"]}";
//                                   //       }
//                                   //     }
//                                   //   } else {
//                                   //     print("No such document!");
//                                   //   }
//                                   // }).catchError((error) {
//                                   //   print("Error getting document: $error");
//                                   // });
//                                   NextPage();
//                                   // Navigator.push(
//                                   //     context,
//                                   //     MaterialPageRoute(
//                                   //       builder: (context) => D2Dpage02(
//                                   //         pickupLocation: '',
//                                   //         dropLocation: '',
//                                   //       ),
//                                   //     ));
//                                 },
//                                 child: Container(
//                                   width: width * .4,
//                                   padding: EdgeInsets.symmetric(
//                                       vertical: width * .025),
//                                   decoration: BoxDecoration(
//                                     color: Colors.blue,
//                                     borderRadius:
//                                         BorderRadius.circular(width * .025),
//                                     boxShadow: [
//                                       BoxShadow(
//                                         color: Colors.black26,
//                                         blurRadius: width * .02,
//                                         offset:
//                                             Offset(width * .01, width * .0125),
//                                       )
//                                     ],
//                                   ),
//                                   child: Center(
//                                     child: Text(
//                                       "Next",
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: width * .04,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: width * .5,
//                               ),
//                               // Container(
//                               //   width: width * .75,
//                               //   // height: width * .15,
//                               //   decoration: BoxDecoration(
//                               //     color: Colors.white,
//                               //     borderRadius:
//                               //         BorderRadius.circular(width * .025),
//                               //     boxShadow: [
//                               //       BoxShadow(
//                               //         color: Colors.black12,
//                               //         blurRadius: width * .02,
//                               //         offset:
//                               //             Offset(width * .01, width * .0125),
//                               //       )
//                               //     ],
//                               //   ),
//                               //   child: Padding(
//                               //     padding: EdgeInsets.all(width * .02),
//                               //     child: Column(
//                               //       crossAxisAlignment:
//                               //           CrossAxisAlignment.start,
//                               //       children: [
//                               //         Text(
//                               //           "How to use ?",
//                               //           style: TextStyle(
//                               //               fontSize: width * .03,
//                               //               fontWeight: FontWeight.w500),
//                               //         ),
//                               //         Text(
//                               //           "Tap the "
//                               //           '"Request Location"'
//                               //           " button and you will get a link\n"
//                               //           "Share the link and Ask the other person to get in the link and Tap "
//                               //           '"Share Location"',
//                               //           style:
//                               //               TextStyle(fontSize: width * .0275),
//                               //         ),
//                               //       ],
//                               //     ),
//                               //   ),
//                               // ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       Align(
//                         child: Padding(
//                           padding: EdgeInsets.only(
//                               // top: height * .7,
//                               top: height * .065,
//                               right: width * .06),
//                           child: Container(
//                             width: width * .5,
//                             // height: width * .15,
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(width * .025),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black12,
//                                   blurRadius: width * .02,
//                                   offset: Offset(width * .01, width * .0125),
//                                 )
//                               ],
//                             ),
//                             child: Padding(
//                               padding: EdgeInsets.all(width * .01),
//                               child: Text(
//                                 "Please use current location or Request location for accurate location",
//                                 style: TextStyle(fontSize: width * .025),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       Align(
//                         alignment: Alignment.topRight,
//                         child: Padding(
//                           padding: EdgeInsets.only(
//                               top: height * .09,
//                               // top: height * .725,
//                               right: width * .1),
//                           child: Image.asset(
//                             // height: height * .1,
//                             ImageConstant.deliveryman2,
//                             height: width * .25,
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             // if (isFieldActive)
//             //   Align(
//             //     alignment: Alignment.bottomCenter,
//             //     child: Padding(
//             //       padding: EdgeInsets.all(width * .02),
//             //       child: GestureDetector(
//             //         onTap: () {
//             //           getCurrentLocationAndSetField();
//             //         },
//             //         child: Container(
//             //           height: width * .125,
//             //           width: width * .75,
//             //           decoration: BoxDecoration(
//             //               color: ColorConstant.bgColor,
//             //               border: Border.all(
//             //                   width: width * .005,
//             //                   color: Colors.black.withOpacity(.25)),
//             //               borderRadius:
//             //                   BorderRadius.all(Radius.circular(width * .25))),
//             //           // padding: EdgeInsets.all(16),
//             //           child: Row(
//             //             mainAxisAlignment: MainAxisAlignment.center,
//             //             crossAxisAlignment: CrossAxisAlignment.center,
//             //             children: [
//             //               Icon(Icons.my_location, color: Colors.blue),
//             //               SizedBox(width: width * .02),
//             //               Text(
//             //                 "Use Current Location",
//             //                 style: TextStyle(
//             //                     fontSize: width * .04,
//             //                     fontWeight: FontWeight.w500),
//             //               ),
//             //             ],
//             //           ),
//             //         ),
//             //       ),
//             //     ),
//             //   ),
//             // if (isFieldActive && suggestions.isNotEmpty)
//             //   Align(
//             //     alignment: Alignment.bottomCenter,
//             //     child: Padding(
//             //       padding: EdgeInsets.all(width * .02),
//             //       child: GestureDetector(
//             //         onTap: () {
//             //           getCurrentLocationAndSetField();
//             //         },
//             //         child: Container(
//             //           height: width * .125,
//             //           width: width * .75,
//             //           decoration: BoxDecoration(
//             //               color: Colors.white,
//             //               border: Border.all(
//             //                   width: width * .005,
//             //                   color: Colors.black.withOpacity(.25)),
//             //               borderRadius:
//             //                   BorderRadius.all(Radius.circular(width * .25))),
//             //           // padding: EdgeInsets.all(16),
//             //           child: Row(
//             //             mainAxisAlignment: MainAxisAlignment.center,
//             //             crossAxisAlignment: CrossAxisAlignment.center,
//             //             children: [
//             //               Icon(Icons.my_location, color: Colors.blue),
//             //               SizedBox(width: width * .02),
//             //               Text(
//             //                 "Use Current Location",
//             //                 style: TextStyle(
//             //                     fontSize: width * .04,
//             //                     fontWeight: FontWeight.w500),
//             //               ),
//             //             ],
//             //           ),
//             //         ),
//             //       ),
//             //     ),
//             //   ),
//           ],
//         ),
//       ),
//     );
//   }
// }

///////////////////////

// import 'dart:async';
// import 'dart:convert';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dotted_border/dotted_border.dart';
// import 'package:drivex/core/constants/color_constant.dart';
// import 'package:drivex/core/constants/imageConstants.dart';
// import 'package:drivex/core/constants/localVariables.dart';
// import 'package:drivex/feature/bottomNavigation/pages/D2D/D2D_placeSearchPage.dart';
// import 'package:drivex/feature/bottomNavigation/pages/D2DPage_02.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_google_places_hoc081098/google_maps_webservice_places.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:http/http.dart' as http;
// import 'package:geolocator/geolocator.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:smooth_page_indicator/smooth_page_indicator.dart';
// import 'package:uuid/uuid.dart';

// const String googleApiKey =
//     ""; // one source of truth

// class D2DPage01 extends StatefulWidget {
//   const D2DPage01({super.key});
//   @override
//   State<D2DPage01> createState() => _D2DPage01State();
// }

// class _D2DPage01State extends State<D2DPage01> {
//   // ─────────────────────────────────────────────────────────────────────────────
//   // STATE: controllers, focus, maps, trip/session
//   // ─────────────────────────────────────────────────────────────────────────────
//   final TextEditingController fromController = TextEditingController();
//   final TextEditingController toController = TextEditingController();
//   final FocusNode fromFocus = FocusNode();
//   final FocusNode toFocus = FocusNode();

//   // show/hide drop logic helper
//   bool get _hasPickup => fromController.text.trim().isNotEmpty;

//   bool isFieldActive = false;
//   String activeField = ""; // "from" | "to"
//   List<dynamic> suggestions = [];

//   GoogleMapController? _mapController;
//   LatLng pickup = const LatLng(10.998, 76.990);
//   LatLng drop = const LatLng(10.995, 76.995);

//   String? tripId;
//   StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? tripSub;

//   // optional, if you want to hold coordinates locally
//   Map<String, double>? pickupCoordinates;
//   Map<String, double>? dropCoordinates;

//   // Places client
//   final GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: googleApiKey);

//   // ─────────────────────────────────────────────────────────────────────────────
//   // LOCAL RECENTS (SharedPreferences)
//   // ─────────────────────────────────────────────────────────────────────────────
//   static const _kRecentPickupKey = 'recent_pickup_locations';
//   static const _kRecentDropKey = 'recent_drop_locations';

//   Future<List<Map<String, dynamic>>> _loadRecents(String slot) async {
//     final prefs = await SharedPreferences.getInstance();
//     final key = slot == 'pickup' ? _kRecentPickupKey : _kRecentDropKey;
//     final list = prefs.getStringList(key) ?? const [];
//     return list.map((s) => Map<String, dynamic>.from(jsonDecode(s))).toList();
//   }

//   Future<void> _saveRecent(
//     String slot, {
//     required double lat,
//     required double lng,
//     required String label,
//   }) async {
//     final prefs = await SharedPreferences.getInstance();
//     final key = slot == 'pickup' ? _kRecentPickupKey : _kRecentDropKey;
//     final list = prefs.getStringList(key) ?? [];

//     // de-dup
//     list.removeWhere((s) {
//       final m = Map<String, dynamic>.from(jsonDecode(s));
//       final sameCoords = (m['lat'] == lat && m['lng'] == lng);
//       final sameLabel = (m['label'] == label);
//       return sameCoords || sameLabel;
//     });

//     list.insert(
//       0,
//       jsonEncode({
//         'lat': lat,
//         'lng': lng,
//         'label': label,
//         'savedAt': DateTime.now().toIso8601String(),
//       }),
//     );

//     // keep last 5
//     if (list.length > 5) list.removeRange(5, list.length);
//     await prefs.setStringList(key, list);
//   }

//   // ─────────────────────────────────────────────────────────────────────────────
//   // SHARE LINK SHEET (request location from other person)
//   // ─────────────────────────────────────────────────────────────────────────────
//   void openRequestLocationSheet(BuildContext context, String slot) {
//     showCupertinoModalPopup(
//       context: context,
//       barrierColor: Colors.black.withOpacity(.35),
//       builder: (ctx) {
//         Future<Map<String, dynamic>>? linkFuture;

//         return StatefulBuilder(
//           builder: (ctx, setSheet) {
//             linkFuture ??= _sendLocationRequest(slot);
//             final size = MediaQuery.of(ctx).size;
//             final width = size.width;
//             final height = size.height;

//             return Material(
//               color: Colors.transparent,
//               child: SafeArea(
//                 top: false,
//                 child: Align(
//                   alignment: Alignment.bottomCenter,
//                   child: Container(
//                     width: width,
//                     height: height * .65,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.vertical(
//                           top: Radius.circular(width * .05)),
//                     ),
//                     child: Padding(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: width * .05,
//                         vertical: width * .04,
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           // drag handle
//                           Center(
//                             child: Container(
//                               width: width * .18,
//                               height: width * .013,
//                               decoration: BoxDecoration(
//                                 color: Colors.black12,
//                                 borderRadius:
//                                     BorderRadius.circular(width * .01),
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: width * .035),
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: Text(
//                                   "Request Location",
//                                   style: TextStyle(
//                                     fontSize: width * .05,
//                                     fontWeight: FontWeight.w700,
//                                   ),
//                                 ),
//                               ),
//                               CupertinoButton(
//                                 padding: EdgeInsets.zero,
//                                 onPressed: () => Navigator.pop(ctx),
//                                 child: Icon(
//                                   CupertinoIcons.xmark,
//                                   size: width * .06,
//                                 ),
//                               )
//                             ],
//                           ),
//                           SizedBox(height: width * .01),
//                           Text(
//                             'Share the link below to get the ${slot.toUpperCase()} location.',
//                             style: TextStyle(
//                               fontSize: width * .0325,
//                               color: Colors.black54,
//                             ),
//                           ),
//                           SizedBox(height: width * .04),
//                           Expanded(
//                             child: FutureBuilder<Map<String, dynamic>>(
//                               future: linkFuture,
//                               builder: (ctx, snap) {
//                                 if (snap.connectionState ==
//                                     ConnectionState.waiting) {
//                                   return Center(
//                                     child: Column(
//                                       mainAxisSize: MainAxisSize.min,
//                                       children: [
//                                         const CupertinoActivityIndicator(
//                                             radius: 14),
//                                         SizedBox(height: width * .03),
//                                         Text(
//                                           "Generating secure link…",
//                                           style: TextStyle(
//                                             fontSize: width * .034,
//                                             color: Colors.black54,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   );
//                                 }
//                                 if (snap.hasError) {
//                                   return Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Icon(
//                                         CupertinoIcons.exclamationmark_triangle,
//                                         color: Colors.red,
//                                         size: width * .12,
//                                       ),
//                                       SizedBox(height: width * .02),
//                                       Text(
//                                         "Couldn't create link",
//                                         style: TextStyle(
//                                           fontSize: width * .042,
//                                           fontWeight: FontWeight.w600,
//                                         ),
//                                       ),
//                                       SizedBox(height: width * .02),
//                                       Text(
//                                         "${snap.error}",
//                                         textAlign: TextAlign.center,
//                                         style: TextStyle(
//                                           fontSize: width * .032,
//                                           color: Colors.black54,
//                                         ),
//                                       ),
//                                       SizedBox(height: width * .04),
//                                       CupertinoButton.filled(
//                                         onPressed: () => setSheet(
//                                           () => linkFuture =
//                                               _sendLocationRequest(slot),
//                                         ),
//                                         child: const Text("Try again"),
//                                       ),
//                                     ],
//                                   );
//                                 }

//                                 final data = snap.data!;
//                                 final link = data['link'] as String;
//                                 final expiresAt = data['expiresAt'] as String?;

//                                 return Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Container(
//                                       padding: EdgeInsets.all(width * .035),
//                                       decoration: BoxDecoration(
//                                         color: const Color(0xFFF5F7FA),
//                                         border: Border.all(
//                                           color: const Color(0xFFE5E9F0),
//                                         ),
//                                         borderRadius:
//                                             BorderRadius.circular(width * .03),
//                                       ),
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             "Share this link",
//                                             style: TextStyle(
//                                               fontSize: width * .035,
//                                               color: Colors.black54,
//                                             ),
//                                           ),
//                                           SizedBox(height: width * .02),
//                                           SelectableText(
//                                             link,
//                                             style: TextStyle(
//                                               fontSize: width * .034,
//                                               fontFamily: 'monospace',
//                                             ),
//                                           ),
//                                           if (expiresAt != null) ...[
//                                             SizedBox(height: width * .02),
//                                             Text(
//                                               "Expires: $expiresAt",
//                                               style: TextStyle(
//                                                 fontSize: width * .03,
//                                                 color: Colors.black45,
//                                               ),
//                                             ),
//                                           ],
//                                           SizedBox(height: width * .02),
//                                           Row(
//                                             children: [
//                                               // Copy
//                                               Expanded(
//                                                 child: CupertinoButton(
//                                                   color:
//                                                       const Color(0xFFE8F3FF),
//                                                   padding: EdgeInsets.symmetric(
//                                                     vertical: width * .028,
//                                                   ),
//                                                   onPressed: () async {
//                                                     await Clipboard.setData(
//                                                       ClipboardData(text: link),
//                                                     );
//                                                     if (mounted) {
//                                                       ScaffoldMessenger.of(
//                                                               context)
//                                                           .showSnackBar(
//                                                         const SnackBar(
//                                                           content: Text(
//                                                               "Link copied"),
//                                                           behavior:
//                                                               SnackBarBehavior
//                                                                   .floating,
//                                                           duration: Duration(
//                                                               seconds: 1),
//                                                         ),
//                                                       );
//                                                     }
//                                                   },
//                                                   child: Row(
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment
//                                                             .center,
//                                                     children: [
//                                                       Icon(
//                                                         CupertinoIcons
//                                                             .doc_on_doc,
//                                                         size: width * .05,
//                                                         color: const Color(
//                                                             0xFF1976D2),
//                                                       ),
//                                                       SizedBox(
//                                                           width: width * .02),
//                                                       Text(
//                                                         "Copy link",
//                                                         style: TextStyle(
//                                                           fontSize:
//                                                               width * .035,
//                                                           fontWeight:
//                                                               FontWeight.w700,
//                                                           color: const Color(
//                                                               0xFF1976D2),
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ),
//                                               SizedBox(width: width * .03),
//                                               // Share
//                                               Expanded(
//                                                 child: CupertinoButton.filled(
//                                                   padding: EdgeInsets.symmetric(
//                                                     vertical: width * .028,
//                                                   ),
//                                                   onPressed: () async {
//                                                     await Share.share(
//                                                       link,
//                                                       subject:
//                                                           "Share your ${slot.toUpperCase()} location",
//                                                     );
//                                                   },
//                                                   child: Row(
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment
//                                                             .center,
//                                                     children: [
//                                                       Icon(CupertinoIcons.share,
//                                                           size: width * .05),
//                                                       SizedBox(
//                                                           width: width * .02),
//                                                       Text(
//                                                         "Share",
//                                                         style: TextStyle(
//                                                           fontSize:
//                                                               width * .035,
//                                                           fontWeight:
//                                                               FontWeight.w700,
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     SizedBox(height: width * .04),

//                                     // Recent Requests placeholder
//                                     Text(
//                                       "Recent Request",
//                                       style: TextStyle(
//                                         fontSize: width * .036,
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                     ),
//                                     SizedBox(height: width * .025),
//                                     Container(
//                                       height: width * .25,
//                                       decoration: BoxDecoration(
//                                         color: const Color(0xFFF5F7FA),
//                                         border:
//                                             Border.all(color: Colors.black12),
//                                         borderRadius:
//                                             BorderRadius.circular(width * .03),
//                                       ),
//                                       child: Center(
//                                         child: Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.center,
//                                           children: [
//                                             Icon(
//                                               CupertinoIcons.location_solid,
//                                               color: Colors.redAccent,
//                                               size: width * .06,
//                                             ),
//                                             SizedBox(width: width * .03),
//                                             Text(
//                                               "No recent Location",
//                                               style: TextStyle(
//                                                 fontSize: width * .04,
//                                                 color: Colors.black54,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                     SizedBox(height: width * .025),
//                                     SizedBox(
//                                       width: double.infinity,
//                                       child: CupertinoButton(
//                                         color: const Color(0xFF1E88E5),
//                                         onPressed: () => Navigator.pop(ctx),
//                                         child: Text(
//                                           "Done",
//                                           style: TextStyle(
//                                               fontSize: width * .04,
//                                               color: Colors.white,
//                                               fontWeight: FontWeight.w700),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 );
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   Future<Map<String, dynamic>> _sendLocationRequest(String type) async {
//     if (tripId == null) {
//       await _createTripDocument(); // ensure exists
//     }
//     final id = tripId!;
//     final shareId = const Uuid().v4();
//     final expiresAtDt = DateTime.now().add(const Duration(hours: 24));
//     final expiresAtIso = expiresAtDt.toIso8601String();

//     // your deep link
//     final link = "https://drivex-2a34e.web.app/?id=$id&type=$type&sid=$shareId";

//     // log the share
//     await FirebaseFirestore.instance
//         .collection("locationRequests")
//         .doc(id)
//         .collection("shares")
//         .doc(shareId)
//         .set({
//       "type": type,
//       "link": link,
//       "status": "sent",
//       "createdAt": FieldValue.serverTimestamp(),
//       "expiresAt": Timestamp.fromDate(expiresAtDt),
//     });

//     return {"link": link, "expiresAt": expiresAtIso, "shareId": shareId};
//   }

//   // ─────────────────────────────────────────────────────────────────────────────
//   // FIRESTORE: create trip + listen to updates
//   // ─────────────────────────────────────────────────────────────────────────────
//   Future<void> _createTripDocument() async {
//     final docRef =
//         await FirebaseFirestore.instance.collection("locationRequests").add({
//       "pickupLocation": null,
//       "dropLocation": null,
//       "senderName": "Kamal",
//       "senderPhone": "9876543210",
//       "createdAt": FieldValue.serverTimestamp(),
//     });

//     tripId = docRef.id;
//     _listenToTripUpdates();
//   }

//   void _listenToTripUpdates() {
//     tripSub?.cancel();
//     final id = tripId;
//     if (id == null) return;
//     tripSub = FirebaseFirestore.instance
//         .collection("locationRequests")
//         .doc(id)
//         .snapshots()
//         .listen((doc) {
//       if (!doc.exists) return;
//       final data = doc.data();
//       if (data == null) return;

//       // pickup
//       if (data['pickupLocation'] != null) {
//         final coords = Map<String, dynamic>.from(data['pickupLocation']);
//         setState(() {
//           pickupCoordinates = {
//             "lat": coords['lat'] * 1.0,
//             "lng": coords['lng'] * 1.0
//           };
//           fromController.text = "${coords['lat']}, ${coords['lng']}";
//         });
//       }

//       // drop
//       if (data['dropLocation'] != null) {
//         final coords = Map<String, dynamic>.from(data['dropLocation']);
//         setState(() {
//           dropCoordinates = {
//             "lat": coords['lat'] * 1.0,
//             "lng": coords['lng'] * 1.0
//           };
//           toController.text = "${coords['lat']}, ${coords['lng']}";
//         });
//       }
//     });
//   }

//   // ─────────────────────────────────────────────────────────────────────────────
//   // LOCATION (self) + utility
//   // ─────────────────────────────────────────────────────────────────────────────
//   String _generateMapLink(double lat, double lng) =>
//       "https://www.google.com/maps?q=$lat,$lng";

//   Future<void> requestLocation(TextEditingController controller) async {
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       throw Exception("Location services are disabled.");
//     }

//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         throw Exception("Location permission denied.");
//       }
//     }
//     if (permission == LocationPermission.deniedForever) {
//       throw Exception("Location permission permanently denied.");
//     }

//     final position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//     final link = _generateMapLink(position.latitude, position.longitude);
//     controller.text = link;
//     await Share.share("Here is my location: $link");
//   }

//   Future<void> getCurrentLocationAndSetField() async {
//     final position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//     final latLng = LatLng(position.latitude, position.longitude);

//     // reverse geocode
//     final url =
//         "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$googleApiKey";
//     final response = await http.get(Uri.parse(url));
//     String address = "Current location";
//     if (response.statusCode == 200) {
//       final body = jsonDecode(response.body);
//       if (body['status'] == 'OK') {
//         address = body['results'][0]['formatted_address'];
//       }
//     }

//     setState(() {
//       if (activeField == "from") {
//         pickup = latLng;
//         fromController.text = address;
//         _mapController?.animateCamera(CameraUpdate.newLatLng(pickup));
//       } else if (activeField == "to") {
//         drop = latLng;
//         toController.text = address;
//         _mapController?.animateCamera(CameraUpdate.newLatLng(drop));
//       }
//       isFieldActive = false;
//       suggestions.clear();
//     });
//   }

//   Future<String> getPlaceFromCoordinates(double lat, double lon) async {
//     try {
//       final placemarks = await placemarkFromCoordinates(lat, lon);
//       if (placemarks.isNotEmpty) {
//         final p = placemarks.first;
//         final parts = <String?>[
//           p.name,
//           p.street,
//           p.subLocality,
//           p.locality,
//           p.administrativeArea,
//           p.country,
//           p.postalCode
//         ].where((e) => e != null && e!.isNotEmpty).map((e) => e!).toList();
//         return parts.join(', ');
//       }
//       return "No place found for the given coordinates.";
//     } catch (e) {
//       return "Error getting place: $e";
//     }
//   }

//   // ─────────────────────────────────────────────────────────────────────────────
//   // GOOGLE PLACES: Autocomplete & Details
//   // ─────────────────────────────────────────────────────────────────────────────
//   Future<void> getPlaceSuggestions(String input) async {
//     if (input.isEmpty) {
//       setState(() => suggestions = []);
//       return;
//     }
//     final sessionToken = const Uuid().v4();
//     final url =
//         "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$googleApiKey&sessiontoken=$sessionToken&components=country:in";
//     final response = await http.get(Uri.parse(url));
//     if (response.statusCode == 200) {
//       final body = jsonDecode(response.body);
//       if (body['status'] == 'OK') {
//         setState(() => suggestions = body['predictions']);
//       } else {
//         setState(() => suggestions = []);
//       }
//     }
//   }

//   Future<void> selectSuggestion(String placeId) async {
//     final url =
//         "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$googleApiKey";
//     final response = await http.get(Uri.parse(url));
//     if (response.statusCode == 200) {
//       final result = jsonDecode(response.body)['result'];
//       final lat = (result['geometry']['location']['lat'] as num).toDouble();
//       final lng = (result['geometry']['location']['lng'] as num).toDouble();
//       final address = result['formatted_address'] as String? ?? "";

//       setState(() {
//         if (activeField == "from") {
//           pickup = LatLng(lat, lng);
//           fromController.text = address;
//           _mapController?.animateCamera(CameraUpdate.newLatLng(pickup));
//         } else if (activeField == "to") {
//           drop = LatLng(lat, lng);
//           toController.text = address;
//           _mapController?.animateCamera(CameraUpdate.newLatLng(drop));
//         }
//         isFieldActive = false;
//         suggestions.clear();
//       });
//     }
//   }

//   // ─────────────────────────────────────────────────────────────────────────────
//   // LIFECYCLE
//   // ─────────────────────────────────────────────────────────────────────────────
//   @override
//   void initState() {
//     super.initState();
//     _createTripDocument();

//     fromFocus.addListener(() {
//       if (fromFocus.hasFocus) {
//         setState(() {
//           isFieldActive = true;
//           activeField = "from";
//         });
//       }
//     });
//     toFocus.addListener(() {
//       if (toFocus.hasFocus) {
//         setState(() {
//           isFieldActive = true;
//           activeField = "to";
//         });
//       }
//     });

//     // show/hide Drop dynamically + clear Drop when Pickup cleared
//     fromController.addListener(() {
//       final hasPickup = fromController.text.trim().isNotEmpty;
//       if (!hasPickup && toController.text.isNotEmpty) {
//         toController.clear(); // auto-clear drop when pickup removed
//       }
//       if (mounted) setState(() {}); // rebuild to update visibility
//     });
//   }

//   @override
//   void dispose() {
//     fromController.dispose();
//     toController.dispose();
//     fromFocus.dispose();
//     toFocus.dispose();
//     tripSub?.cancel();
//     super.dispose();
//   }

//   // ─────────────────────────────────────────────────────────────────────────────
//   // UI HELPERS
//   // ─────────────────────────────────────────────────────────────────────────────
//   void _nextPage() {
//     final pickupText = fromController.text.trim();
//     final dropText = toController.text.trim();
//     if (pickupText.isEmpty || dropText.isEmpty) {
//       _showSnackBar("Please fill both Pick-Up and Drop-Off Locations.");
//       return;
//     }
//     _showSnackBar("Driver requested successfully!");
//     Navigator.push(
//       context,
//       CupertinoPageRoute(
//         builder: (context) => D2Dpage02(
//           pickupLocation: pickupText,
//           dropLocation: dropText,
//         ),
//       ),
//     );
//   }

//   void _showSnackBar(String message) {
//     ScaffoldMessenger.of(context)
//         .showSnackBar(SnackBar(content: Text(message)));
//   }

//   // ─────────────────────────────────────────────────────────────────────────────
//   // BUILD
//   // ─────────────────────────────────────────────────────────────────────────────
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final width = size.width;
//     final height = size.height;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Container(
//         color: ColorConstant.color1.withOpacity(.15),
//         child: Stack(
//           children: [
//             // MAIN SCROLL
//             SizedBox(
//               height: height,
//               child: SingleChildScrollView(
//                 child: SafeArea(
//                   child: Stack(
//                     children: [
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: width * .02),
//                         child: Center(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               SizedBox(height: width * .1),
//                               SizedBox(height: width * .3),

//                               // How to use
//                               Container(
//                                 width: width * .75,
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius:
//                                       BorderRadius.circular(width * .025),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.black12,
//                                       blurRadius: width * .02,
//                                       offset:
//                                           Offset(width * .01, width * .0125),
//                                     )
//                                   ],
//                                 ),
//                                 child: Padding(
//                                   padding: EdgeInsets.all(width * .02),
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         "How to use ?",
//                                         style: TextStyle(
//                                           fontSize: width * .03,
//                                           fontWeight: FontWeight.w500,
//                                         ),
//                                       ),
//                                       Text(
//                                         'Tap the "Request Location" button and you will get a link.\n'
//                                         'Share the link and ask the other person to open it and tap "Share Location".',
//                                         style: TextStyle(
//                                           fontSize: width * .0275,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),

//                               // Live Firestore -> updates input fields
//                               StreamBuilder<
//                                   DocumentSnapshot<Map<String, dynamic>>>(
//                                 stream: (tripId == null)
//                                     ? const Stream.empty()
//                                     : FirebaseFirestore.instance
//                                         .collection("locationRequests")
//                                         .doc(tripId)
//                                         .snapshots(),
//                                 builder: (context, snap) {
//                                   if (snap.connectionState ==
//                                       ConnectionState.waiting) {
//                                     return Padding(
//                                       padding:
//                                           EdgeInsets.only(top: width * .06),
//                                       child: const CircularProgressIndicator(),
//                                     );
//                                   }

//                                   if (snap.hasData && snap.data!.exists) {
//                                     final data = snap.data!.data();
//                                     if (data != null) {
//                                       if (data["pickupLocation"] != null) {
//                                         final p = data["pickupLocation"];
//                                         fromController.text =
//                                             "(${p["lat"]},${p["lng"]})";
//                                       }
//                                       if (data["dropLocation"] != null) {
//                                         final d = data["dropLocation"];
//                                         toController.text =
//                                             "(${d["lat"]},${d["lng"]})";
//                                       }
//                                     }
//                                   }

//                                   return SizedBox(
//                                     width: width * .825,
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.end,
//                                       children: [
//                                         SizedBox(height: width * .1),

//                                         // PICKUP
//                                         Row(
//                                           children: [
//                                             Text(
//                                               "Enter PickUp Details",
//                                               style: TextStyle(
//                                                 fontWeight: FontWeight.w500,
//                                                 fontSize: width * .035,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                         SizedBox(height: width * .02),
//                                         Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceBetween,
//                                           children: [
//                                             // dot
//                                             Container(
//                                               width: width * 0.04,
//                                               height: width * 0.04,
//                                               decoration: BoxDecoration(
//                                                 border: Border.all(
//                                                   width: width * .005,
//                                                   color: Colors.black
//                                                       .withOpacity(.25),
//                                                 ),
//                                                 color: Colors.green,
//                                                 shape: BoxShape.circle,
//                                               ),
//                                               child: Center(
//                                                 child: Container(
//                                                   width: width * 0.02,
//                                                   height: width * 0.02,
//                                                   decoration: BoxDecoration(
//                                                     color: Colors.black
//                                                         .withOpacity(0.5),
//                                                     shape: BoxShape.circle,
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),

//                                             // field (navigate to place search page)
//                                             GestureDetector(
//                                               onTap: () async {
//                                                 await Navigator.push(
//                                                   context,
//                                                   CupertinoPageRoute(
//                                                     builder: (_) =>
//                                                         D2dPlaceSearchPage(
//                                                       controller:
//                                                           fromController,
//                                                       accentColor: Colors.green,
//                                                       label: "Pickup",
//                                                     ),
//                                                   ),
//                                                 );
//                                                 setState(() {});
//                                               },
//                                               child: Container(
//                                                 height: width * .125,
//                                                 width: width * .75,
//                                                 padding: EdgeInsets.only(
//                                                     left: width * 0.03),
//                                                 decoration: BoxDecoration(
//                                                   color: Colors.white,
//                                                   borderRadius:
//                                                       BorderRadius.circular(
//                                                           width * 0.03),
//                                                 ),
//                                                 child: Row(
//                                                   children: [
//                                                     Expanded(
//                                                       child: Text(
//                                                         fromController
//                                                                 .text.isEmpty
//                                                             ? "Enter PickUp location"
//                                                             : fromController
//                                                                 .text,
//                                                         style: TextStyle(
//                                                           color: fromController
//                                                                   .text.isEmpty
//                                                               ? Colors.black
//                                                                   .withOpacity(
//                                                                       .5)
//                                                               : Colors.black,
//                                                           fontSize:
//                                                               width * 0.035,
//                                                         ),
//                                                       ),
//                                                     ),
//                                                     Padding(
//                                                       padding: EdgeInsets.all(
//                                                           width * .01),
//                                                       child: GestureDetector(
//                                                         onTap: () {
//                                                           openRequestLocationSheet(
//                                                             context,
//                                                             "pickup",
//                                                           );
//                                                         },
//                                                         child: Container(
//                                                           height:
//                                                               double.infinity,
//                                                           width: width * .225,
//                                                           decoration:
//                                                               BoxDecoration(
//                                                             color: ColorConstant
//                                                                 .greenColor
//                                                                 .withOpacity(
//                                                                     .9),
//                                                             borderRadius:
//                                                                 BorderRadius
//                                                                     .circular(
//                                                               width * 0.02,
//                                                             ),
//                                                           ),
//                                                           child: Center(
//                                                             child: Text(
//                                                               "Request\nLocation",
//                                                               textAlign:
//                                                                   TextAlign
//                                                                       .center,
//                                                               style: TextStyle(
//                                                                 fontSize:
//                                                                     width * .03,
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .w500,
//                                                                 color: Colors
//                                                                     .white,
//                                                               ),
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         ),

//                                         Center(
//                                           child: Text(
//                                             fromController.text,
//                                             style: TextStyle(
//                                               fontSize: width * .025,
//                                               color:
//                                                   Colors.black.withOpacity(.5),
//                                             ),
//                                           ),
//                                         ),

//                                         // ───────── DROP (conditionally visible) ─────────
//                                         if (_hasPickup) ...[
//                                           SizedBox(height: width * 0.1 / 2),
//                                           // SizedBox(height: width * 0.1 / 2),
//                                           Row(
//                                             children: [
//                                               Text(
//                                                 "Enter Destination Details",
//                                                 style: TextStyle(
//                                                   fontWeight: FontWeight.w500,
//                                                   fontSize: width * .035,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                           SizedBox(height: width * .02),
//                                           Row(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceBetween,
//                                             children: [
//                                               Column(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.start,
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.start,
//                                                 children: [
//                                                   SizedBox(
//                                                     height: height * .02,
//                                                   ),
//                                                   Padding(
//                                                     padding: EdgeInsets.only(
//                                                         left: width * 0.005),
//                                                     child: Container(
//                                                       width: width * 0.04,
//                                                       height: width * 0.04,
//                                                       decoration: BoxDecoration(
//                                                         border: Border.all(
//                                                           width: width * .005,
//                                                           color: Colors.black
//                                                               .withOpacity(.25),
//                                                         ),
//                                                         color: Colors
//                                                             .redAccent[200],
//                                                         shape: BoxShape.circle,
//                                                       ),
//                                                       child: Center(
//                                                         child: Container(
//                                                           width: width * 0.02,
//                                                           height: width * 0.02,
//                                                           decoration:
//                                                               BoxDecoration(
//                                                             color: Colors.black
//                                                                 .withOpacity(
//                                                                     0.5),
//                                                             shape:
//                                                                 BoxShape.circle,
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                   Padding(
//                                                     padding: EdgeInsets.only(
//                                                         left: width * 0.025),
//                                                     child: DottedBorder(
//                                                       color: Colors.black54,
//                                                       strokeWidth:
//                                                           width * .0025,
//                                                       dashPattern: const [4, 3],
//                                                       strokeCap:
//                                                           StrokeCap.round,
//                                                       padding: EdgeInsets.zero,
//                                                       customPath: (size) {
//                                                         final p = Path()
//                                                           ..moveTo(0,
//                                                               0) // ← left edge
//                                                           ..lineTo(
//                                                               0, size.height)
//                                                           ..moveTo(0,
//                                                               size.height) // ↓ bottom edge
//                                                           ..lineTo(size.width,
//                                                               size.height);
//                                                         return p;
//                                                       },
//                                                       child: SizedBox(
//                                                         width: width * .05,
//                                                         height: height * .055,
//                                                       ),
//                                                     ),
//                                                   )
//                                                 ],
//                                               ),

//                                               // field
//                                               Column(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.start,
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.start,
//                                                 children: [
//                                                   GestureDetector(
//                                                     onTap: () async {
//                                                       await Navigator.push(
//                                                         context,
//                                                         CupertinoPageRoute(
//                                                           builder: (_) =>
//                                                               D2dPlaceSearchPage(
//                                                             controller:
//                                                                 toController,
//                                                             accentColor: Colors
//                                                                 .redAccent,
//                                                             label: "Drop",
//                                                           ),
//                                                         ),
//                                                       );
//                                                       setState(() {});
//                                                     },
//                                                     child: Container(
//                                                       width: width * .75,
//                                                       height: width * .125,
//                                                       padding: EdgeInsets.only(
//                                                           left: width * 0.03),
//                                                       decoration: BoxDecoration(
//                                                         color: Colors.white,
//                                                         borderRadius:
//                                                             BorderRadius
//                                                                 .circular(
//                                                                     width *
//                                                                         0.03),
//                                                       ),
//                                                       child: Row(
//                                                         mainAxisAlignment:
//                                                             MainAxisAlignment
//                                                                 .spaceBetween,
//                                                         children: [
//                                                           Expanded(
//                                                             child: Text(
//                                                               toController.text
//                                                                       .isEmpty
//                                                                   ? "Enter Destination location"
//                                                                   : toController
//                                                                       .text,
//                                                               style: TextStyle(
//                                                                 color: toController
//                                                                         .text
//                                                                         .isEmpty
//                                                                     ? Colors
//                                                                         .black
//                                                                         .withOpacity(
//                                                                             .5)
//                                                                     : Colors
//                                                                         .black,
//                                                                 fontSize:
//                                                                     width *
//                                                                         0.035,
//                                                               ),
//                                                             ),
//                                                           ),
//                                                           Padding(
//                                                             padding:
//                                                                 EdgeInsets.all(
//                                                                     width *
//                                                                         .01),
//                                                             child:
//                                                                 GestureDetector(
//                                                               onTap: () {
//                                                                 openRequestLocationSheet(
//                                                                   context,
//                                                                   "drop",
//                                                                 );
//                                                               },
//                                                               child: Container(
//                                                                 height: double
//                                                                     .infinity,
//                                                                 width: width *
//                                                                     .225,
//                                                                 decoration:
//                                                                     BoxDecoration(
//                                                                   color: ColorConstant
//                                                                       .greenColor
//                                                                       .withOpacity(
//                                                                           .9),
//                                                                   borderRadius:
//                                                                       BorderRadius
//                                                                           .circular(
//                                                                     width *
//                                                                         0.02,
//                                                                   ),
//                                                                 ),
//                                                                 child: Center(
//                                                                   child: Text(
//                                                                     "Request\nLocation",
//                                                                     textAlign:
//                                                                         TextAlign
//                                                                             .center,
//                                                                     style:
//                                                                         TextStyle(
//                                                                       fontSize:
//                                                                           width *
//                                                                               .03,
//                                                                       fontWeight:
//                                                                           FontWeight
//                                                                               .w500,
//                                                                       color: Colors
//                                                                           .white,
//                                                                     ),
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                   ),
//                                                   SizedBox(
//                                                     height: width * .025,
//                                                   ),
//                                                   GestureDetector(
//                                                     onTap: _nextPage,
//                                                     child: Container(
//                                                       width: width * .4,
//                                                       padding:
//                                                           EdgeInsets.symmetric(
//                                                         vertical: width * .025,
//                                                       ),
//                                                       decoration: BoxDecoration(
//                                                         color: Colors.blue,
//                                                         borderRadius:
//                                                             BorderRadius
//                                                                 .circular(
//                                                                     width *
//                                                                         .025),
//                                                         boxShadow: [
//                                                           BoxShadow(
//                                                             color:
//                                                                 Colors.black26,
//                                                             blurRadius:
//                                                                 width * .02,
//                                                             offset: Offset(
//                                                                 width * .01,
//                                                                 width * .0125),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                       child: Center(
//                                                         child: Text(
//                                                           "Add Destination",
//                                                           style: TextStyle(
//                                                             color: Colors.white,
//                                                             fontSize:
//                                                                 width * .04,
//                                                             fontWeight:
//                                                                 FontWeight.bold,
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                               //////
//                                             ],
//                                           ),

//                                           Center(
//                                             child: Text(
//                                               toController.text,
//                                               style: TextStyle(
//                                                 fontSize: width * .025,
//                                                 color: Colors.black
//                                                     .withOpacity(.5),
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ],
//                                     ),
//                                   );
//                                 },
//                               ),

//                               SizedBox(height: width * .1),

//                               // NEXT BUTTON
//                               GestureDetector(
//                                 onTap: _nextPage,
//                                 child: Container(
//                                   width: width * .4,
//                                   padding: EdgeInsets.symmetric(
//                                     vertical: width * .025,
//                                   ),
//                                   decoration: BoxDecoration(
//                                     color: Colors.blue,
//                                     borderRadius:
//                                         BorderRadius.circular(width * .025),
//                                     boxShadow: [
//                                       BoxShadow(
//                                         color: Colors.black26,
//                                         blurRadius: width * .02,
//                                         offset:
//                                             Offset(width * .01, width * .0125),
//                                       ),
//                                     ],
//                                   ),
//                                   child: Center(
//                                     child: Text(
//                                       "Next",
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: width * .04,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),

//                               SizedBox(height: width * .5),
//                             ],
//                           ),
//                         ),
//                       ),

//                       // top info card
//                       Align(
//                         child: Padding(
//                           padding: EdgeInsets.only(
//                             top: height * .065,
//                             right: width * .06,
//                           ),
//                           child: Container(
//                             width: width * .5,
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(width * .025),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black12,
//                                   blurRadius: width * .02,
//                                   offset: Offset(width * .01, width * .0125),
//                                 )
//                               ],
//                             ),
//                             child: Padding(
//                               padding: EdgeInsets.all(width * .01),
//                               child: Text(
//                                 "Please use current location or Request location for accurate location",
//                                 style: TextStyle(fontSize: width * .025),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),

//                       // illustration
//                       Align(
//                         alignment: Alignment.topRight,
//                         child: Padding(
//                           padding: EdgeInsets.only(
//                             top: height * .09,
//                             right: width * .1,
//                           ),
//                           child: Image.asset(
//                             ImageConstant.deliveryman2,
//                             height: width * .25,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),

//             // bottom floating "Use current location" when typing
//             if (isFieldActive)
//               Align(
//                 alignment: Alignment.bottomCenter,
//                 child: Padding(
//                   padding: EdgeInsets.all(width * .02),
//                   child: GestureDetector(
//                     onTap: getCurrentLocationAndSetField,
//                     child: Container(
//                       height: width * .125,
//                       width: width * .75,
//                       decoration: BoxDecoration(
//                         color: ColorConstant.bgColor,
//                         border: Border.all(
//                           width: width * .005,
//                           color: Colors.black.withOpacity(.25),
//                         ),
//                         borderRadius:
//                             BorderRadius.all(Radius.circular(width * .25)),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const Icon(Icons.my_location, color: Colors.blue),
//                           SizedBox(width: width * .02),
//                           Text(
//                             "Use Current Location",
//                             style: TextStyle(
//                               fontSize: width * .04,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

///////////////////////////////////////////////////////////////

// import 'dart:async';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dotted_border/dotted_border.dart';
// import 'package:drivex/core/constants/color_constant.dart';
// import 'package:drivex/core/constants/imageConstants.dart';
// import 'package:drivex/feature/bottomNavigation/pages/D2D/D2D_placeSearchPage.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:uuid/uuid.dart';

// class D2DPage01 extends StatefulWidget {
//   const D2DPage01({super.key});

//   @override
//   State<D2DPage01> createState() => _D2DPage01State();
// }

// class _D2DPage01State extends State<D2DPage01> {
//   String? tripId;

//   StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? tripSub;

//   Map<String, double>? pickupCoordinates;
//   Map<String, double>? dropCoordinates;
//   // Pickup controller
//   final TextEditingController fromController = TextEditingController();

//   final TextEditingController toController = TextEditingController();
//   final FocusNode fromFocus = FocusNode();
//   final FocusNode toFocus = FocusNode();

//   // Dynamic destination controllers (start with one)
//   final List<TextEditingController> _destControllers = [
//     TextEditingController(),
//   ];
//   bool isFieldActive = false;
//   String activeField = "";

//   @override
//   void initState() {
//     super.initState();
//     _createTripDocument();

//     fromFocus.addListener(() {
//       if (fromFocus.hasFocus) {
//         setState(() {
//           isFieldActive = true;
//           activeField = "from";
//         });
//       }
//     });
//     toFocus.addListener(() {
//       if (toFocus.hasFocus) {
//         setState(() {
//           isFieldActive = true;
//           activeField = "to";
//         });
//       }
//     });

//     // show/hide Drop dynamically + clear Drop when Pickup cleared
//     fromController.addListener(() {
//       final hasPickup = fromController.text.trim().isNotEmpty;
//       if (!hasPickup && toController.text.isNotEmpty) {
//         toController.clear(); // auto-clear drop when pickup removed
//       }
//       if (mounted) setState(() {}); // rebuild to update visibility
//     });
//   }

//   // UI helper
//   void _showSnackBar(BuildContext context, String msg) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
//   }

//   // Insert a new destination controller (optionally after an index)
//   void _addDestination({int? afterIndex}) {
//     setState(() {
//       final c = TextEditingController();
//       if (afterIndex == null ||
//           afterIndex < 0 ||
//           afterIndex >= _destControllers.length) {
//         _destControllers.add(c);
//       } else {
//         _destControllers.insert(afterIndex + 1, c);
//       }
//     });
//   }

//   // Optional: remove a destination
//   void _removeDestination(int index) {
//     if (_destControllers.length == 1) {
//       _showSnackBar(context, "At least one destination is required.");
//       return;
//     }
//     setState(() {
//       _destControllers.removeAt(index).dispose();
//     });
//   }

//   // Placeholder for your share-link sheet
//   // void openRequestLocationSheet(BuildContext context, String slot) {
//   //   _showSnackBar(context, "Share link for $slot (stub).");
//   // }
//   void openRequestLocationSheet(BuildContext context, String slot) {
//     showCupertinoModalPopup(
//       context: context,
//       barrierColor: Colors.black.withOpacity(.35),
//       builder: (ctx) {
//         Future<Map<String, dynamic>>? linkFuture;

//         return StatefulBuilder(
//           builder: (ctx, setSheet) {
//             linkFuture ??= _sendLocationRequest(slot);
//             final size = MediaQuery.of(ctx).size;
//             final width = size.width;
//             final height = size.height;

//             return Material(
//               color: Colors.transparent,
//               child: SafeArea(
//                 top: false,
//                 child: Align(
//                   alignment: Alignment.bottomCenter,
//                   child: Container(
//                     width: width,
//                     height: height * .65,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.vertical(
//                           top: Radius.circular(width * .05)),
//                     ),
//                     child: Padding(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: width * .05,
//                         vertical: width * .04,
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           // drag handle
//                           Center(
//                             child: Container(
//                               width: width * .18,
//                               height: width * .013,
//                               decoration: BoxDecoration(
//                                 color: Colors.black12,
//                                 borderRadius:
//                                     BorderRadius.circular(width * .01),
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: width * .035),
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: Text(
//                                   "Request Location",
//                                   style: TextStyle(
//                                     fontSize: width * .05,
//                                     fontWeight: FontWeight.w700,
//                                   ),
//                                 ),
//                               ),
//                               CupertinoButton(
//                                 padding: EdgeInsets.zero,
//                                 onPressed: () => Navigator.pop(ctx),
//                                 child: Icon(
//                                   CupertinoIcons.xmark,
//                                   size: width * .06,
//                                 ),
//                               )
//                             ],
//                           ),
//                           SizedBox(height: width * .01),
//                           Text(
//                             'Share the link below to get the ${slot.toUpperCase()} location.',
//                             style: TextStyle(
//                               fontSize: width * .0325,
//                               color: Colors.black54,
//                             ),
//                           ),
//                           SizedBox(height: width * .04),
//                           Expanded(
//                             child: FutureBuilder<Map<String, dynamic>>(
//                               future: linkFuture,
//                               builder: (ctx, snap) {
//                                 if (snap.connectionState ==
//                                     ConnectionState.waiting) {
//                                   return Center(
//                                     child: Column(
//                                       mainAxisSize: MainAxisSize.min,
//                                       children: [
//                                         const CupertinoActivityIndicator(
//                                             radius: 14),
//                                         SizedBox(height: width * .03),
//                                         Text(
//                                           "Generating secure link…",
//                                           style: TextStyle(
//                                             fontSize: width * .034,
//                                             color: Colors.black54,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   );
//                                 }
//                                 if (snap.hasError) {
//                                   return Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Icon(
//                                         CupertinoIcons.exclamationmark_triangle,
//                                         color: Colors.red,
//                                         size: width * .12,
//                                       ),
//                                       SizedBox(height: width * .02),
//                                       Text(
//                                         "Couldn't create link",
//                                         style: TextStyle(
//                                           fontSize: width * .042,
//                                           fontWeight: FontWeight.w600,
//                                         ),
//                                       ),
//                                       SizedBox(height: width * .02),
//                                       Text(
//                                         "${snap.error}",
//                                         textAlign: TextAlign.center,
//                                         style: TextStyle(
//                                           fontSize: width * .032,
//                                           color: Colors.black54,
//                                         ),
//                                       ),
//                                       SizedBox(height: width * .04),
//                                       CupertinoButton.filled(
//                                         onPressed: () => setSheet(
//                                           () => linkFuture =
//                                               _sendLocationRequest(slot),
//                                         ),
//                                         child: const Text("Try again"),
//                                       ),
//                                     ],
//                                   );
//                                 }

//                                 final data = snap.data!;
//                                 final link = data['link'] as String;
//                                 final expiresAt = data['expiresAt'] as String?;

//                                 return Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Container(
//                                       padding: EdgeInsets.all(width * .035),
//                                       decoration: BoxDecoration(
//                                         color: const Color(0xFFF5F7FA),
//                                         border: Border.all(
//                                           color: const Color(0xFFE5E9F0),
//                                         ),
//                                         borderRadius:
//                                             BorderRadius.circular(width * .03),
//                                       ),
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             "Share this link",
//                                             style: TextStyle(
//                                               fontSize: width * .035,
//                                               color: Colors.black54,
//                                             ),
//                                           ),
//                                           SizedBox(height: width * .02),
//                                           SelectableText(
//                                             link,
//                                             style: TextStyle(
//                                               fontSize: width * .034,
//                                               fontFamily: 'monospace',
//                                             ),
//                                           ),
//                                           if (expiresAt != null) ...[
//                                             SizedBox(height: width * .02),
//                                             Text(
//                                               "Expires: $expiresAt",
//                                               style: TextStyle(
//                                                 fontSize: width * .03,
//                                                 color: Colors.black45,
//                                               ),
//                                             ),
//                                           ],
//                                           SizedBox(height: width * .02),
//                                           Row(
//                                             children: [
//                                               // Copy
//                                               Expanded(
//                                                 child: CupertinoButton(
//                                                   color:
//                                                       const Color(0xFFE8F3FF),
//                                                   padding: EdgeInsets.symmetric(
//                                                     vertical: width * .028,
//                                                   ),
//                                                   onPressed: () async {
//                                                     await Clipboard.setData(
//                                                       ClipboardData(text: link),
//                                                     );
//                                                     if (mounted) {
//                                                       ScaffoldMessenger.of(
//                                                               context)
//                                                           .showSnackBar(
//                                                         const SnackBar(
//                                                           content: Text(
//                                                               "Link copied"),
//                                                           behavior:
//                                                               SnackBarBehavior
//                                                                   .floating,
//                                                           duration: Duration(
//                                                               seconds: 1),
//                                                         ),
//                                                       );
//                                                     }
//                                                   },
//                                                   child: Row(
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment
//                                                             .center,
//                                                     children: [
//                                                       Icon(
//                                                         CupertinoIcons
//                                                             .doc_on_doc,
//                                                         size: width * .05,
//                                                         color: const Color(
//                                                             0xFF1976D2),
//                                                       ),
//                                                       SizedBox(
//                                                           width: width * .02),
//                                                       Text(
//                                                         "Copy link",
//                                                         style: TextStyle(
//                                                           fontSize:
//                                                               width * .035,
//                                                           fontWeight:
//                                                               FontWeight.w700,
//                                                           color: const Color(
//                                                               0xFF1976D2),
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ),
//                                               SizedBox(width: width * .03),
//                                               // Share
//                                               Expanded(
//                                                 child: CupertinoButton.filled(
//                                                   padding: EdgeInsets.symmetric(
//                                                     vertical: width * .028,
//                                                   ),
//                                                   onPressed: () async {
//                                                     await Share.share(
//                                                       link,
//                                                       subject:
//                                                           "Share your ${slot.toUpperCase()} location",
//                                                     );
//                                                   },
//                                                   child: Row(
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment
//                                                             .center,
//                                                     children: [
//                                                       Icon(CupertinoIcons.share,
//                                                           size: width * .05),
//                                                       SizedBox(
//                                                           width: width * .02),
//                                                       Text(
//                                                         "Share",
//                                                         style: TextStyle(
//                                                           fontSize:
//                                                               width * .035,
//                                                           fontWeight:
//                                                               FontWeight.w700,
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     SizedBox(height: width * .04),

//                                     // Recent Requests placeholder
//                                     Text(
//                                       "Recent Request",
//                                       style: TextStyle(
//                                         fontSize: width * .036,
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                     ),
//                                     SizedBox(height: width * .025),
//                                     Container(
//                                       height: width * .25,
//                                       decoration: BoxDecoration(
//                                         color: const Color(0xFFF5F7FA),
//                                         border:
//                                             Border.all(color: Colors.black12),
//                                         borderRadius:
//                                             BorderRadius.circular(width * .03),
//                                       ),
//                                       child: Center(
//                                         child: Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.center,
//                                           children: [
//                                             Icon(
//                                               CupertinoIcons.location_solid,
//                                               color: Colors.redAccent,
//                                               size: width * .06,
//                                             ),
//                                             SizedBox(width: width * .03),
//                                             Text(
//                                               "No recent Location",
//                                               style: TextStyle(
//                                                 fontSize: width * .04,
//                                                 color: Colors.black54,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                     SizedBox(height: width * .025),
//                                     SizedBox(
//                                       width: double.infinity,
//                                       child: CupertinoButton(
//                                         color: const Color(0xFF1E88E5),
//                                         onPressed: () => Navigator.pop(ctx),
//                                         child: Text(
//                                           "Done",
//                                           style: TextStyle(
//                                               fontSize: width * .04,
//                                               color: Colors.white,
//                                               fontWeight: FontWeight.w700),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 );
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   Future<void> _createTripDocument() async {
//     final docRef =
//         await FirebaseFirestore.instance.collection("locationRequests").add({
//       "pickupLocation": null,
//       "dropLocation": null,
//       "senderName": "Kamal",
//       "senderPhone": "9876543210",
//       "createdAt": FieldValue.serverTimestamp(),
//     });

//     tripId = docRef.id;
//     _listenToTripUpdates();
//   }

//   void _listenToTripUpdates() {
//     tripSub?.cancel();
//     final id = tripId;
//     if (id == null) return;
//     tripSub = FirebaseFirestore.instance
//         .collection("locationRequests")
//         .doc(id)
//         .snapshots()
//         .listen((doc) {
//       if (!doc.exists) return;
//       final data = doc.data();
//       if (data == null) return;

//       // pickup
//       if (data['pickupLocation'] != null) {
//         final coords = Map<String, dynamic>.from(data['pickupLocation']);
//         setState(() {
//           pickupCoordinates = {
//             "lat": coords['lat'] * 1.0,
//             "lng": coords['lng'] * 1.0
//           };
//           fromController.text = "${coords['lat']}, ${coords['lng']}";
//         });
//       }

//       // drop
//       if (data['dropLocation'] != null) {
//         final coords = Map<String, dynamic>.from(data['dropLocation']);
//         setState(() {
//           dropCoordinates = {
//             "lat": coords['lat'] * 1.0,
//             "lng": coords['lng'] * 1.0
//           };
//           toController.text = "${coords['lat']}, ${coords['lng']}";
//         });
//       }
//     });
//   }

//   Future<Map<String, dynamic>> _sendLocationRequest(String type) async {
//     if (tripId == null) {
//       await _createTripDocument(); // ensure exists
//     }
//     final id = tripId!;
//     final shareId = const Uuid().v4();
//     final expiresAtDt = DateTime.now().add(const Duration(hours: 24));
//     final expiresAtIso = expiresAtDt.toIso8601String();

//     // your deep link
//     final link = "https://drivex-2a34e.web.app/?id=$id&type=$type&sid=$shareId";

//     // log the share
//     await FirebaseFirestore.instance
//         .collection("locationRequests")
//         .doc(id)
//         .collection("shares")
//         .doc(shareId)
//         .set({
//       "type": type,
//       "link": link,
//       "status": "sent",
//       "createdAt": FieldValue.serverTimestamp(),
//       "expiresAt": Timestamp.fromDate(expiresAtDt),
//     });

//     return {"link": link, "expiresAt": expiresAtIso, "shareId": shareId};
//   }

//   // Next page validation
//   void _nextPage() {
//     final pickup = fromController.text.trim();
//     final dests = _destControllers.map((c) => c.text.trim()).toList();

//     if (pickup.isEmpty) {
//       _showSnackBar(context, "Please enter Pick-Up location.");
//       return;
//     }
//     if (dests.any((d) => d.isEmpty)) {
//       _showSnackBar(context, "Please fill all Destination locations.");
//       return;
//     }

//     _showSnackBar(context, "Proceeding with ${dests.length} destination(s).");
//     // TODO: Navigate with your data
//   }

//   @override
//   void dispose() {
//     fromController.dispose();
//     for (final c in _destControllers) {
//       c.dispose();
//     }
//     toController.dispose();
//     fromFocus.dispose();
//     toFocus.dispose();
//     tripSub?.cancel();
//     super.dispose();
//   }

//   // @override
//   // void dispose() {
//   //   fromController.dispose();
//   //   for (final c in _destControllers) {
//   //     c.dispose();
//   //   }
//   //   super.dispose();
//   // }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final width = size.width;
//     final height = size.height;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Container(
//         color: ColorConstant.color1.withOpacity(.15),
//         child: SizedBox(
//           height: height,
//           child: SingleChildScrollView(
//             child: SafeArea(
//               child: Padding(
//                 padding: EdgeInsets.symmetric(horizontal: width * .02),
//                 child: Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       SizedBox(height: width * .1),
//                       SizedBox(height: width * .3),
//                       SizedBox(
//                         width: width * .75,
//                         height: width * .5,
//                         child: Center(
//                           child: Stack(
//                             children: [
//                               Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//                                   Center(
//                                     child: Container(
//                                       width: width * .5,
//                                       decoration: BoxDecoration(
//                                         color: Colors.white,
//                                         borderRadius:
//                                             BorderRadius.circular(width * .025),
//                                         boxShadow: [
//                                           BoxShadow(
//                                             color: Colors.black12,
//                                             blurRadius: width * .02,
//                                             offset: Offset(
//                                                 width * .01, width * .0125),
//                                           )
//                                         ],
//                                       ),
//                                       child: Padding(
//                                         padding: EdgeInsets.all(width * .01),
//                                         child: Text(
//                                           "Please use current location or Request location for accurate location",
//                                           style:
//                                               TextStyle(fontSize: width * .025),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     height: height * .1,
//                                   ),
//                                   // How to use
//                                   Container(
//                                     width: width * .75,
//                                     decoration: BoxDecoration(
//                                       color: Colors.white,
//                                       borderRadius:
//                                           BorderRadius.circular(width * .025),
//                                       boxShadow: [
//                                         BoxShadow(
//                                           color: Colors.black12,
//                                           blurRadius: width * .02,
//                                           offset: Offset(
//                                               width * .01, width * .0125),
//                                         )
//                                       ],
//                                     ),
//                                     child: Padding(
//                                       padding: EdgeInsets.all(width * .02),
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             "How to use ?",
//                                             style: TextStyle(
//                                               fontSize: width * .03,
//                                               fontWeight: FontWeight.w500,
//                                             ),
//                                           ),
//                                           Text(
//                                             'Tap the field to search and select locations. Use "Add Destination" to insert more stops.',
//                                             style: TextStyle(
//                                               fontSize: width * .0275,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               Align(
//                                 alignment: Alignment.topRight,
//                                 child: Padding(
//                                   padding: EdgeInsets.only(
//                                     top: height * .05,
//                                     right: width * .025,
//                                   ),
//                                   child: Image.asset(
//                                     ImageConstant.deliveryman2,
//                                     height: width * .25,
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                       ),

//                       // ───────── PICKUP ─────────
//                       SizedBox(height: width * .1),
//                       Row(
//                         children: [
//                           Text(
//                             "Enter PickUp Details",
//                             style: TextStyle(
//                               fontWeight: FontWeight.w500,
//                               fontSize: width * .035,
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: width * .02),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           // dot
//                           Padding(
//                             padding: EdgeInsets.only(right: width * .025),
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
//                           // SizedBox(width: ,),

//                           // field (navigate to place search page)
//                           GestureDetector(
//                             onTap: () async {
//                               await Navigator.push(
//                                 context,
//                                 CupertinoPageRoute(
//                                   builder: (_) => D2dPlaceSearchPage(
//                                     controller: fromController,
//                                     accentColor: Colors.green,
//                                     label: "Pickup",
//                                   ),
//                                 ),
//                               );
//                               setState(() {});
//                             },
//                             child: Container(
//                               height: width * .125,
//                               width: width * .85,
//                               padding: EdgeInsets.only(left: width * 0.03),
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius:
//                                     BorderRadius.circular(width * 0.03),
//                               ),
//                               child: Row(
//                                 children: [
//                                   Expanded(
//                                     child: Text(
//                                       fromController.text.isEmpty
//                                           ? "Enter PickUp location"
//                                           : fromController.text,
//                                       style: TextStyle(
//                                         color: fromController.text.isEmpty
//                                             ? Colors.black.withOpacity(.5)
//                                             : Colors.black,
//                                         fontSize: width * 0.035,
//                                       ),
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: EdgeInsets.all(width * .01),
//                                     child: GestureDetector(
//                                       onTap: () {
//                                         openRequestLocationSheet(
//                                           context,
//                                           "pickup",
//                                         );
//                                       },
//                                       child: Container(
//                                         height: double.infinity,
//                                         width: width * .225,
//                                         decoration: BoxDecoration(
//                                           color: ColorConstant.greenColor
//                                               .withOpacity(.9),
//                                           borderRadius: BorderRadius.circular(
//                                             width * 0.02,
//                                           ),
//                                         ),
//                                         child: Center(
//                                           child: Text(
//                                             "Request\nLocation",
//                                             textAlign: TextAlign.center,
//                                             style: TextStyle(
//                                               fontSize: width * .03,
//                                               fontWeight: FontWeight.w500,
//                                               color: Colors.white,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),

//                       // ───────── DESTINATIONS (ListView.builder) ─────────
//                       if (fromController.text.trim().isNotEmpty) ...[
//                         SizedBox(height: width * .05),
//                         Row(
//                           children: [
//                             Text(
//                               "Enter Destination Details",
//                               style: TextStyle(
//                                 fontWeight: FontWeight.w500,
//                                 fontSize: width * .035,
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: width * .02),

//                         // Builder with shrinkWrap
//                         ListView.builder(
//                           shrinkWrap: true,
//                           physics: const NeverScrollableScrollPhysics(),
//                           itemCount: _destControllers.length,
//                           itemBuilder: (context, index) {
//                             final toController = _destControllers[index];
//                             final bool isLast =
//                                 index == _destControllers.length - 1;
//                             final bool isFirst = index == 0;

//                             final double topSegH =
//                                 height * .02; // same height as your dotted top
//                             final double bottomSegH =
//                                 height * .03; // your existing bottom height

//                             void _insertAt(int i) {
//                               setState(() {
//                                 _destControllers.insert(
//                                     i, TextEditingController());
//                               });
//                             }

//                             void _removeAt(int i) {
//                               setState(() {
//                                 _destControllers.removeAt(i);
//                               });
//                             }

//                             void _showSnack(String msg) {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 SnackBar(
//                                   content: Text(msg),
//                                   behavior: SnackBarBehavior.floating,
//                                   duration: const Duration(seconds: 1),
//                                   margin: EdgeInsets.all(width * .03),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius:
//                                         BorderRadius.circular(width * .02),
//                                   ),
//                                 ),
//                               );
//                             }

//                             return Padding(
//                               padding: EdgeInsets.zero,
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//                                   // ───────── Add Stop ABOVE this row ─────────
//                                   SizedBox(
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.start,
//                                       children: [
//                                         // Left lead-in: hide dots for first index, keep spacing
//                                         if (!isFirst)
//                                           Padding(
//                                             padding: EdgeInsets.only(
//                                                 left: width * 0.025),
//                                             child: DottedBorder(
//                                               color: Colors.black54,
//                                               strokeWidth: width * .0025,
//                                               dashPattern: const [4, 3],
//                                               strokeCap: StrokeCap.round,
//                                               padding: EdgeInsets.zero,
//                                               customPath: (size) => Path()
//                                                 ..moveTo(0, 0)
//                                                 ..lineTo(0, size.height),
//                                               child: SizedBox(
//                                                 width: width * .05,
//                                                 height: height * .0375,
//                                               ),
//                                             ),
//                                           )
//                                         else
//                                           Padding(
//                                             padding: EdgeInsets.only(
//                                                 left: width * 0.025),
//                                             child: SizedBox(
//                                               width: width * .05,
//                                               height: height * .0375,
//                                             ),
//                                           ),
//                                         SizedBox(width: width * .025),

//                                         // Add Stop button (GLOBAL guard: all live destinations must be filled)
//                                         GestureDetector(
//                                           onTap: () {
//                                             // Check every current destination has data
//                                             final int firstMissing =
//                                                 _destControllers
//                                                     .toList()
//                                                     .indexWhere((c) =>
//                                                         c.text.trim().isEmpty);

//                                             if (firstMissing != -1) {
//                                               _showSnack(
//                                                   "Please enter Destination ${firstMissing + 1} first.");
//                                               return;
//                                             }

//                                             // All fields filled → insert ABOVE (before this row), as in your original code
//                                             _insertAt(index);
//                                           },
//                                           child: Padding(
//                                             padding: EdgeInsets.only(
//                                                 bottom: width * 0.025),
//                                             child: Container(
//                                               padding: EdgeInsets.symmetric(
//                                                 vertical: width * .0125,
//                                                 horizontal: width * .04,
//                                               ),
//                                               decoration: BoxDecoration(
//                                                 color: Colors.black12,
//                                                 borderRadius:
//                                                     BorderRadius.circular(
//                                                         width * .025),
//                                               ),
//                                               child: Row(
//                                                 mainAxisSize: MainAxisSize.min,
//                                                 children: [
//                                                   Icon(Icons.add,
//                                                       size: width * .05,
//                                                       color: Colors.black54),
//                                                   SizedBox(width: width * .01),
//                                                   Text(
//                                                     "Add Stop",
//                                                     style: TextStyle(
//                                                       color: Colors.black54,
//                                                       fontSize: width * .035,
//                                                       fontWeight:
//                                                           FontWeight.bold,
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),

//                                   // ───────── Row: left rail + destination card + (outside) delete ─────────
//                                   Row(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       // Left rail
//                                       Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           // TOP segment: spacer for first, dotted for others
//                                           Padding(
//                                             padding: EdgeInsets.only(
//                                                 left: width * 0.025),
//                                             child: isFirst
//                                                 ? SizedBox(
//                                                     width: width * .05,
//                                                     height: topSegH)
//                                                 : DottedBorder(
//                                                     color: Colors.black54,
//                                                     strokeWidth: width * .0025,
//                                                     dashPattern: const [4, 3],
//                                                     strokeCap: StrokeCap.round,
//                                                     padding: EdgeInsets.zero,
//                                                     customPath: (size) => Path()
//                                                       ..moveTo(0, 0)
//                                                       ..lineTo(0, size.height),
//                                                     child: SizedBox(
//                                                         width: width * .05,
//                                                         height: topSegH),
//                                                   ),
//                                           ),

//                                           // RED DOT
//                                           Padding(
//                                             padding: EdgeInsets.only(
//                                                 left: width * 0.005),
//                                             child: Container(
//                                               width: width * 0.04,
//                                               height: width * 0.04,
//                                               decoration: BoxDecoration(
//                                                 border: Border.all(
//                                                   width: width * .005,
//                                                   color: Colors.black
//                                                       .withOpacity(.25),
//                                                 ),
//                                                 color: Colors.redAccent[200],
//                                                 shape: BoxShape.circle,
//                                               ),
//                                               child: Center(
//                                                 child: Container(
//                                                   width: width * 0.02,
//                                                   height: width * 0.02,
//                                                   decoration: BoxDecoration(
//                                                     color: Colors.black
//                                                         .withOpacity(0.5),
//                                                     shape: BoxShape.circle,
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                           ),

//                                           // BOTTOM segment — only if NOT last
//                                           if (!isLast)
//                                             Padding(
//                                               padding: EdgeInsets.only(
//                                                   left: width * 0.025),
//                                               child: DottedBorder(
//                                                 color: Colors.black54,
//                                                 strokeWidth: width * .0025,
//                                                 dashPattern: const [4, 3],
//                                                 strokeCap: StrokeCap.round,
//                                                 padding: EdgeInsets.zero,
//                                                 customPath: (size) => Path()
//                                                   ..moveTo(0, 0)
//                                                   ..lineTo(0, size.height),
//                                                 child: SizedBox(
//                                                     width: width * .05,
//                                                     height: bottomSegH),
//                                               ),
//                                             ),
//                                         ],
//                                       ),

//                                       SizedBox(width: width * .02),

//                                       // Destination card (Flexible to avoid overflow)
//                                       Expanded(
//                                         child: GestureDetector(
//                                           onTap: () async {
//                                             await Navigator.push(
//                                               context,
//                                               CupertinoPageRoute(
//                                                 builder: (_) =>
//                                                     D2dPlaceSearchPage(
//                                                   controller: toController,
//                                                   accentColor: Colors.redAccent,
//                                                   label:
//                                                       "Destination ${index + 1}",
//                                                 ),
//                                               ),
//                                             );
//                                             setState(() {});
//                                           },
//                                           child: Container(
//                                             height: width * .125,
//                                             padding: EdgeInsets.only(
//                                               left: width * 0.03,
//                                               right: width * .01,
//                                             ),
//                                             decoration: BoxDecoration(
//                                               color: Colors.white,
//                                               borderRadius:
//                                                   BorderRadius.circular(
//                                                       width * 0.03),
//                                             ),
//                                             child: Row(
//                                               children: [
//                                                 Expanded(
//                                                   child: Text(
//                                                     toController.text.isEmpty
//                                                         ? "Enter Destination location"
//                                                         : toController.text,
//                                                     maxLines: 2,
//                                                     overflow:
//                                                         TextOverflow.ellipsis,
//                                                     style: TextStyle(
//                                                       color: toController
//                                                               .text.isEmpty
//                                                           ? Colors.black
//                                                               .withOpacity(.5)
//                                                           : Colors.black,
//                                                       fontSize: width * 0.035,
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 GestureDetector(
//                                                   onTap: () =>
//                                                       openRequestLocationSheet(
//                                                           context, "drop"),
//                                                   child: Padding(
//                                                     padding: EdgeInsets.all(
//                                                         width * .01),
//                                                     child: Container(
//                                                       height: double.infinity,
//                                                       width: width * .2,
//                                                       decoration: BoxDecoration(
//                                                         color: ColorConstant
//                                                             .greenColor
//                                                             .withOpacity(.9),
//                                                         borderRadius:
//                                                             BorderRadius
//                                                                 .circular(
//                                                                     width *
//                                                                         0.02),
//                                                       ),
//                                                       child: Center(
//                                                         child: Text(
//                                                           "Request\nLocation",
//                                                           textAlign:
//                                                               TextAlign.center,
//                                                           style: TextStyle(
//                                                             fontSize:
//                                                                 width * .028,
//                                                             fontWeight:
//                                                                 FontWeight.w600,
//                                                             color: Colors.white,
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       ),

//                                       SizedBox(width: width * .015),

//                                       // DELETE — show only if there are 2+ destinations
//                                       if (_destControllers.length > 1)
//                                         GestureDetector(
//                                           onTap: () => _removeAt(index),
//                                           child: Container(
//                                             height: width * .125,
//                                             width: width * .1,
//                                             decoration: BoxDecoration(
//                                               color: Colors.redAccent
//                                                   .withOpacity(.12),
//                                               borderRadius:
//                                                   BorderRadius.circular(
//                                                       width * .02),
//                                               border: Border.all(
//                                                 color: Colors.redAccent
//                                                     .withOpacity(.4),
//                                                 width: width * .002,
//                                               ),
//                                             ),
//                                             child: Icon(
//                                               Icons.delete_outline,
//                                               size: width * .06,
//                                               color: Colors.redAccent,
//                                             ),
//                                           ),
//                                         ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             );
//                           },
//                         ),
//                       ],

//                       // NEXT BUTTON
//                       SizedBox(height: width * .08),
//                       GestureDetector(
//                         onTap: _nextPage,
//                         child: Container(
//                           width: width * .4,
//                           padding: EdgeInsets.symmetric(
//                             vertical: width * .025,
//                           ),
//                           decoration: BoxDecoration(
//                             color: Colors.blue,
//                             borderRadius: BorderRadius.circular(width * .025),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black26,
//                                 blurRadius: width * .02,
//                                 offset: Offset(width * .01, width * .0125),
//                               ),
//                             ],
//                           ),
//                           child: Center(
//                             child: Text(
//                               "Next",
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: width * .04,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),

//                       SizedBox(height: width * .5),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

////////////////////////////////////////////////

// import 'dart:async';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dotted_border/dotted_border.dart';
// import 'package:drivex/core/constants/color_constant.dart';
// import 'package:drivex/core/constants/imageConstants.dart';
// import 'package:drivex/feature/bottomNavigation/pages/D2D/D2D_placeSearchPage.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:uuid/uuid.dart';

// class D2DPage01 extends StatefulWidget {
//   const D2DPage01({super.key});

//   @override
//   State<D2DPage01> createState() => _D2DPage01State();
// }

// class _D2DPage01State extends State<D2DPage01> {
//   String? tripId;
//   StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? tripSub;

//   Map<String, double>? pickupCoordinates;
//   Map<String, double>? dropCoordinates;

//   // Pickup controller
//   final TextEditingController fromController = TextEditingController();

//   // Dynamic destination controllers (start with one)
//   final List<TextEditingController> _destControllers = [
//     TextEditingController(),
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _createTripDocument();

//     // show/hide Destinations dynamically + clear Destinations when Pickup cleared
//     fromController.addListener(() {
//       final hasPickup = fromController.text.trim().isNotEmpty;
//       if (!hasPickup) {
//         // (Optional) clear destination values when pickup removed
//         for (final c in _destControllers) {
//           c.clear();
//         }
//       }
//       if (mounted) setState(() {}); // rebuild to update visibility
//     });
//   }

//   // UI helper
//   void _showSnackBar(BuildContext context, String msg) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(msg),
//         behavior: SnackBarBehavior.floating,
//         duration: const Duration(seconds: 1),
//       ),
//     );
//   }

//   // Insert a new destination controller (optionally after an index)
//   void _addDestination({int? afterIndex}) {
//     setState(() {
//       final c = TextEditingController();
//       if (afterIndex == null ||
//           afterIndex < 0 ||
//           afterIndex >= _destControllers.length) {
//         _destControllers.add(c);
//       } else {
//         _destControllers.insert(afterIndex + 1, c);
//       }
//     });
//   }

//   // Remove a destination (dispose controller to avoid leaks)
//   void _removeDestination(int index) {
//     if (_destControllers.length == 1) {
//       _showSnackBar(context, "At least one destination is required.");
//       return;
//     }
//     setState(() {
//       final c = _destControllers.removeAt(index);
//       c.dispose();
//     });
//   }

//   void openRequestLocationSheet(BuildContext context, String slot) {
//     showCupertinoModalPopup(
//       context: context,
//       barrierColor: Colors.black.withOpacity(.35),
//       builder: (ctx) {
//         Future<Map<String, dynamic>>? linkFuture;

//         return StatefulBuilder(
//           builder: (ctx, setSheet) {
//             linkFuture ??= _sendLocationRequest(slot);
//             final size = MediaQuery.of(ctx).size;
//             final width = size.width;
//             final height = size.height;

//             return Material(
//               color: Colors.transparent,
//               child: SafeArea(
//                 top: false,
//                 child: Align(
//                   alignment: Alignment.bottomCenter,
//                   child: Container(
//                     width: width,
//                     height: height * .65,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.vertical(
//                         top: Radius.circular(width * .05),
//                       ),
//                     ),
//                     child: Padding(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: width * .05,
//                         vertical: width * .04,
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           // drag handle
//                           Center(
//                             child: Container(
//                               width: width * .18,
//                               height: width * .013,
//                               decoration: BoxDecoration(
//                                 color: Colors.black12,
//                                 borderRadius:
//                                     BorderRadius.circular(width * .01),
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: width * .035),
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: Text(
//                                   "Request Location",
//                                   style: TextStyle(
//                                     fontSize: width * .05,
//                                     fontWeight: FontWeight.w700,
//                                   ),
//                                 ),
//                               ),
//                               CupertinoButton(
//                                 padding: EdgeInsets.zero,
//                                 onPressed: () => Navigator.pop(ctx),
//                                 child: Icon(
//                                   CupertinoIcons.xmark,
//                                   size: width * .06,
//                                 ),
//                               )
//                             ],
//                           ),
//                           SizedBox(height: width * .01),
//                           Text(
//                             'Share the link below to get the ${slot.toUpperCase()} location.',
//                             style: TextStyle(
//                               fontSize: width * .0325,
//                               color: Colors.black54,
//                             ),
//                           ),
//                           SizedBox(height: width * .04),
//                           Expanded(
//                             child: FutureBuilder<Map<String, dynamic>>(
//                               future: linkFuture,
//                               builder: (ctx, snap) {
//                                 if (snap.connectionState ==
//                                     ConnectionState.waiting) {
//                                   return Center(
//                                     child: Column(
//                                       mainAxisSize: MainAxisSize.min,
//                                       children: [
//                                         const CupertinoActivityIndicator(
//                                             radius: 14),
//                                         SizedBox(height: width * .03),
//                                         Text(
//                                           "Generating secure link…",
//                                           style: TextStyle(
//                                             fontSize: width * .034,
//                                             color: Colors.black54,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   );
//                                 }
//                                 if (snap.hasError) {
//                                   return Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Icon(
//                                         CupertinoIcons.exclamationmark_triangle,
//                                         color: Colors.red,
//                                         size: width * .12,
//                                       ),
//                                       SizedBox(height: width * .02),
//                                       Text(
//                                         "Couldn't create link",
//                                         style: TextStyle(
//                                           fontSize: width * .042,
//                                           fontWeight: FontWeight.w600,
//                                         ),
//                                       ),
//                                       SizedBox(height: width * .02),
//                                       Text(
//                                         "${snap.error}",
//                                         textAlign: TextAlign.center,
//                                         style: TextStyle(
//                                           fontSize: width * .032,
//                                           color: Colors.black54,
//                                         ),
//                                       ),
//                                       SizedBox(height: width * .04),
//                                       CupertinoButton.filled(
//                                         onPressed: () => setSheet(
//                                           () => linkFuture =
//                                               _sendLocationRequest(slot),
//                                         ),
//                                         child: const Text("Try again"),
//                                       ),
//                                     ],
//                                   );
//                                 }

//                                 final data = snap.data!;
//                                 final link = data['link'] as String;
//                                 final expiresAt = data['expiresAt'] as String?;

//                                 return Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Container(
//                                       padding: EdgeInsets.all(width * .035),
//                                       decoration: BoxDecoration(
//                                         color: const Color(0xFFF5F7FA),
//                                         border: Border.all(
//                                           color: const Color(0xFFE5E9F0),
//                                         ),
//                                         borderRadius:
//                                             BorderRadius.circular(width * .03),
//                                       ),
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             "Share this link",
//                                             style: TextStyle(
//                                               fontSize: width * .035,
//                                               color: Colors.black54,
//                                             ),
//                                           ),
//                                           SizedBox(height: width * .02),
//                                           SelectableText(
//                                             link,
//                                             style: TextStyle(
//                                               fontSize: width * .034,
//                                               fontFamily: 'monospace',
//                                             ),
//                                           ),
//                                           if (expiresAt != null) ...[
//                                             SizedBox(height: width * .02),
//                                             Text(
//                                               "Expires: $expiresAt",
//                                               style: TextStyle(
//                                                 fontSize: width * .03,
//                                                 color: Colors.black45,
//                                               ),
//                                             ),
//                                           ],
//                                           SizedBox(height: width * .02),
//                                           Row(
//                                             children: [
//                                               // Copy
//                                               Expanded(
//                                                 child: CupertinoButton(
//                                                   color:
//                                                       const Color(0xFFE8F3FF),
//                                                   padding: EdgeInsets.symmetric(
//                                                     vertical: width * .028,
//                                                   ),
//                                                   onPressed: () async {
//                                                     await Clipboard.setData(
//                                                       ClipboardData(text: link),
//                                                     );
//                                                     if (mounted) {
//                                                       ScaffoldMessenger.of(
//                                                               context)
//                                                           .showSnackBar(
//                                                         const SnackBar(
//                                                           content: Text(
//                                                               "Link copied"),
//                                                           behavior:
//                                                               SnackBarBehavior
//                                                                   .floating,
//                                                           duration: Duration(
//                                                               seconds: 1),
//                                                         ),
//                                                       );
//                                                     }
//                                                   },
//                                                   child: Row(
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment
//                                                             .center,
//                                                     children: [
//                                                       Icon(
//                                                         CupertinoIcons
//                                                             .doc_on_doc,
//                                                         size: width * .05,
//                                                         color: const Color(
//                                                             0xFF1976D2),
//                                                       ),
//                                                       SizedBox(
//                                                           width: width * .02),
//                                                       Text(
//                                                         "Copy link",
//                                                         style: TextStyle(
//                                                           fontSize:
//                                                               width * .035,
//                                                           fontWeight:
//                                                               FontWeight.w700,
//                                                           color: const Color(
//                                                               0xFF1976D2),
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ),
//                                               SizedBox(width: width * .03),
//                                               // Share
//                                               Expanded(
//                                                 child: CupertinoButton.filled(
//                                                   padding: EdgeInsets.symmetric(
//                                                     vertical: width * .028,
//                                                   ),
//                                                   onPressed: () async {
//                                                     await Share.share(
//                                                       link,
//                                                       subject:
//                                                           "Share your ${slot.toUpperCase()} location",
//                                                     );
//                                                   },
//                                                   child: Row(
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment
//                                                             .center,
//                                                     children: [
//                                                       Icon(CupertinoIcons.share,
//                                                           size: width * .05),
//                                                       SizedBox(
//                                                           width: width * .02),
//                                                       Text(
//                                                         "Share",
//                                                         style: TextStyle(
//                                                           fontSize:
//                                                               width * .035,
//                                                           fontWeight:
//                                                               FontWeight.w700,
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     SizedBox(height: width * .04),

//                                     // Recent Requests placeholder
//                                     Text(
//                                       "Recent Request",
//                                       style: TextStyle(
//                                         fontSize: width * .036,
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                     ),
//                                     SizedBox(height: width * .025),
//                                     Container(
//                                       height: width * .25,
//                                       decoration: BoxDecoration(
//                                         color: const Color(0xFFF5F7FA),
//                                         border:
//                                             Border.all(color: Colors.black12),
//                                         borderRadius:
//                                             BorderRadius.circular(width * .03),
//                                       ),
//                                       child: Center(
//                                         child: Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.center,
//                                           children: [
//                                             Icon(
//                                               CupertinoIcons.location_solid,
//                                               color: Colors.redAccent,
//                                               size: width * .06,
//                                             ),
//                                             SizedBox(width: width * .03),
//                                             Text(
//                                               "No recent Location",
//                                               style: TextStyle(
//                                                 fontSize: width * .04,
//                                                 color: Colors.black54,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                     SizedBox(height: width * .025),
//                                     SizedBox(
//                                       width: double.infinity,
//                                       child: CupertinoButton(
//                                         color: const Color(0xFF1E88E5),
//                                         onPressed: () => Navigator.pop(ctx),
//                                         child: Text(
//                                           "Done",
//                                           style: TextStyle(
//                                             fontSize: width * .04,
//                                             color: Colors.white,
//                                             fontWeight: FontWeight.w700,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 );
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   Future<void> _createTripDocument() async {
//     final docRef =
//         await FirebaseFirestore.instance.collection("locationRequests").add({
//       "pickupLocation": null,
//       "dropLocation": null,
//       "senderName": "Kamal",
//       "senderPhone": "9876543210",
//       "createdAt": FieldValue.serverTimestamp(),
//     });

//     tripId = docRef.id;
//     _listenToTripUpdates();
//   }

//   void _listenToTripUpdates() {
//     tripSub?.cancel();
//     final id = tripId;
//     if (id == null) return;
//     tripSub = FirebaseFirestore.instance
//         .collection("locationRequests")
//         .doc(id)
//         .snapshots()
//         .listen((doc) {
//       if (!doc.exists) return;
//       final data = doc.data();
//       if (data == null) return;

//       // pickup
//       if (data['pickupLocation'] != null) {
//         final coords = Map<String, dynamic>.from(data['pickupLocation']);
//         setState(() {
//           pickupCoordinates = {
//             "lat": (coords['lat'] as num).toDouble(),
//             "lng": (coords['lng'] as num).toDouble()
//           };
//           fromController.text =
//               "${pickupCoordinates!['lat']}, ${pickupCoordinates!['lng']}";
//         });
//       }

//       // drop → populate the first destination field
//       if (data['dropLocation'] != null) {
//         final coords = Map<String, dynamic>.from(data['dropLocation']);
//         setState(() {
//           dropCoordinates = {
//             "lat": (coords['lat'] as num).toDouble(),
//             "lng": (coords['lng'] as num).toDouble()
//           };
//           if (_destControllers.isNotEmpty) {
//             _destControllers.first.text =
//                 "${dropCoordinates!['lat']}, ${dropCoordinates!['lng']}";
//           }
//         });
//       }
//     });
//   }

//   Future<Map<String, dynamic>> _sendLocationRequest(String type) async {
//     if (tripId == null) {
//       await _createTripDocument(); // ensure exists
//     }
//     final id = tripId!;
//     final shareId = const Uuid().v4();
//     final expiresAtDt = DateTime.now().add(const Duration(hours: 24));
//     final expiresAtIso = expiresAtDt.toIso8601String();

//     // your deep link
//     final link = "https://drivex-2a34e.web.app/?id=$id&type=$type&sid=$shareId";

//     // log the share
//     await FirebaseFirestore.instance
//         .collection("locationRequests")
//         .doc(id)
//         .collection("shares")
//         .doc(shareId)
//         .set({
//       "type": type,
//       "link": link,
//       "status": "sent",
//       "createdAt": FieldValue.serverTimestamp(),
//       "expiresAt": Timestamp.fromDate(expiresAtDt),
//     });

//     return {"link": link, "expiresAt": expiresAtIso, "shareId": shareId};
//   }

//   // Next page validation
//   void _nextPage() {
//     final pickup = fromController.text.trim();
//     final dests = _destControllers.map((c) => c.text.trim()).toList();

//     if (pickup.isEmpty) {
//       _showSnackBar(context, "Please enter Pick-Up location.");
//       return;
//     }
//     if (dests.any((d) => d.isEmpty)) {
//       _showSnackBar(context, "Please fill all Destination locations.");
//       return;
//     }

//     _showSnackBar(context, "Proceeding with ${dests.length} destination(s).");
//     // TODO: Navigate with your data
//   }

//   @override
//   void dispose() {
//     fromController.dispose();
//     for (final c in _destControllers) {
//       c.dispose();
//     }
//     tripSub?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final width = size.width;
//     final height = size.height;

//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Container(
//         color: ColorConstant.color1.withOpacity(.15),
//         child: SizedBox(
//           height: height,
//           child: SingleChildScrollView(
//             child: SafeArea(
//               child: Padding(
//                 padding: EdgeInsets.symmetric(horizontal: width * .02),
//                 child: Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       SizedBox(height: width * .1),
//                       SizedBox(height: width * .3),
//                       SizedBox(
//                         width: width * .75,
//                         height: width * .5,
//                         child: Center(
//                           child: Stack(
//                             children: [
//                               Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//                                   Center(
//                                     child: Container(
//                                       width: width * .5,
//                                       decoration: BoxDecoration(
//                                         color: Colors.white,
//                                         borderRadius:
//                                             BorderRadius.circular(width * .025),
//                                         boxShadow: [
//                                           BoxShadow(
//                                             color: Colors.black12,
//                                             blurRadius: width * .02,
//                                             offset: Offset(
//                                                 width * .01, width * .0125),
//                                           )
//                                         ],
//                                       ),
//                                       child: Padding(
//                                         padding: EdgeInsets.all(width * .01),
//                                         child: Text(
//                                           "Please use current location or Request location for accurate location",
//                                           style:
//                                               TextStyle(fontSize: width * .025),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(height: height * .1),
//                                   // How to use
//                                   Container(
//                                     width: width * .75,
//                                     decoration: BoxDecoration(
//                                       color: Colors.white,
//                                       borderRadius:
//                                           BorderRadius.circular(width * .025),
//                                       boxShadow: [
//                                         BoxShadow(
//                                           color: Colors.black12,
//                                           blurRadius: width * .02,
//                                           offset: Offset(
//                                               width * .01, width * .0125),
//                                         )
//                                       ],
//                                     ),
//                                     child: Padding(
//                                       padding: EdgeInsets.all(width * .02),
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             "How to use ?",
//                                             style: TextStyle(
//                                               fontSize: width * .03,
//                                               fontWeight: FontWeight.w500,
//                                             ),
//                                           ),
//                                           Text(
//                                             'Tap the field to search and select locations. Use "Add Destination" to insert more stops.',
//                                             style: TextStyle(
//                                               fontSize: width * .0275,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               Align(
//                                 alignment: Alignment.topRight,
//                                 child: Padding(
//                                   padding: EdgeInsets.only(
//                                     top: height * .05,
//                                     right: width * .025,
//                                   ),
//                                   child: Image.asset(
//                                     ImageConstant.deliveryman2,
//                                     height: width * .25,
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                       ),

//                       // ───────── PICKUP ─────────
//                       SizedBox(height: width * .1),
//                       Row(
//                         children: [
//                           Text(
//                             "Enter PickUp Details",
//                             style: TextStyle(
//                               fontWeight: FontWeight.w500,
//                               fontSize: width * .035,
//                             ),
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: width * .02),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           // dot
//                           Padding(
//                             padding: EdgeInsets.only(right: width * .025),
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
//                           // field (navigate to place search page)
//                           GestureDetector(
//                             onTap: () async {
//                               await Navigator.push(
//                                 context,
//                                 CupertinoPageRoute(
//                                   builder: (_) => D2dPlaceSearchPage(
//                                     controller: fromController,
//                                     accentColor: Colors.green,
//                                     label: "Pickup",
//                                   ),
//                                 ),
//                               );
//                               setState(() {});
//                             },
//                             child: Container(
//                               height: width * .125,
//                               width: width * .85,
//                               padding: EdgeInsets.only(left: width * 0.03),
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius:
//                                     BorderRadius.circular(width * 0.03),
//                               ),
//                               child: Row(
//                                 children: [
//                                   Expanded(
//                                     child: Text(
//                                       fromController.text.isEmpty
//                                           ? "Enter PickUp location"
//                                           : fromController.text,
//                                       style: TextStyle(
//                                         color: fromController.text.isEmpty
//                                             ? Colors.black.withOpacity(.5)
//                                             : Colors.black,
//                                         fontSize: width * 0.035,
//                                       ),
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: EdgeInsets.all(width * .01),
//                                     child: GestureDetector(
//                                       onTap: () => openRequestLocationSheet(
//                                         context,
//                                         "pickup",
//                                       ),
//                                       child: Container(
//                                         height: double.infinity,
//                                         width: width * .225,
//                                         decoration: BoxDecoration(
//                                           color: ColorConstant.greenColor
//                                               .withOpacity(.9),
//                                           borderRadius: BorderRadius.circular(
//                                             width * 0.02,
//                                           ),
//                                         ),
//                                         child: Center(
//                                           child: Text(
//                                             "Request\nLocation",
//                                             textAlign: TextAlign.center,
//                                             style: TextStyle(
//                                               fontSize: width * .03,
//                                               fontWeight: FontWeight.w500,
//                                               color: Colors.white,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),

//                       // ───────── DESTINATIONS (ListView.builder) ─────────
//                       if (fromController.text.trim().isNotEmpty) ...[
//                         SizedBox(height: width * .05),
//                         Row(
//                           children: [
//                             Text(
//                               "Enter Destination Details",
//                               style: TextStyle(
//                                 fontWeight: FontWeight.w500,
//                                 fontSize: width * .035,
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: width * .02),

//                         // Builder with shrinkWrap
//                         ListView.builder(
//                           shrinkWrap: true,
//                           physics: const NeverScrollableScrollPhysics(),
//                           itemCount: _destControllers.length,
//                           itemBuilder: (context, index) {
//                             final destController = _destControllers[index];
//                             final bool isLast =
//                                 index == _destControllers.length - 1;
//                             final bool isFirst = index == 0;

//                             final double topSegH = height * .02;
//                             final double bottomSegH = height * .03;

//                             void _insertAt(int i) {
//                               setState(() {
//                                 _destControllers.insert(
//                                     i, TextEditingController());
//                               });
//                             }

//                             void _removeAt(int i) {
//                               setState(() {
//                                 final c = _destControllers.removeAt(i);
//                                 c.dispose();
//                               });
//                             }

//                             void _showSnack(String msg) =>
//                                 _showSnackBar(context, msg);

//                             return Padding(
//                               padding: EdgeInsets.zero,
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//                                   // ───────── Add Stop ABOVE this row ─────────
//                                   SizedBox(
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.start,
//                                       children: [
//                                         // Left lead-in: hide dots for first index, keep spacing
//                                         if (!isFirst)
//                                           Padding(
//                                             padding: EdgeInsets.only(
//                                                 left: width * 0.025),
//                                             child: DottedBorder(
//                                               color: Colors.black54,
//                                               strokeWidth: width * .0025,
//                                               dashPattern: const [4, 3],
//                                               strokeCap: StrokeCap.round,
//                                               padding: EdgeInsets.zero,
//                                               customPath: (size) => Path()
//                                                 ..moveTo(0, 0)
//                                                 ..lineTo(0, size.height),
//                                               child: SizedBox(
//                                                 width: width * .05,
//                                                 height: height * .0375,
//                                               ),
//                                             ),
//                                           )
//                                         else
//                                           Padding(
//                                             padding: EdgeInsets.only(
//                                                 left: width * 0.025),
//                                             child: SizedBox(
//                                               width: width * .05,
//                                               height: height * .0375,
//                                             ),
//                                           ),
//                                         SizedBox(width: width * .025),

//                                         // Add Stop button (GLOBAL guard: all live destinations must be filled)
//                                         GestureDetector(
//                                           onTap: () {
//                                             // Check every current destination has data
//                                             final int firstMissing =
//                                                 _destControllers.indexWhere(
//                                                     (c) =>
//                                                         c.text.trim().isEmpty);

//                                             if (firstMissing != -1) {
//                                               _showSnack(
//                                                 "Please enter Destination ${firstMissing + 1} first.",
//                                               );
//                                               return;
//                                             }

//                                             // All fields filled → insert ABOVE (before this row), as per your original code
//                                             _insertAt(index);
//                                           },
//                                           child: Padding(
//                                             padding: EdgeInsets.only(
//                                                 bottom: width * 0.025),
//                                             child: Container(
//                                               padding: EdgeInsets.symmetric(
//                                                 vertical: width * .0125,
//                                                 horizontal: width * .04,
//                                               ),
//                                               decoration: BoxDecoration(
//                                                 color: Colors.black12,
//                                                 borderRadius:
//                                                     BorderRadius.circular(
//                                                   width * .025,
//                                                 ),
//                                               ),
//                                               child: Row(
//                                                 mainAxisSize: MainAxisSize.min,
//                                                 children: [
//                                                   Icon(
//                                                     Icons.add,
//                                                     size: width * .05,
//                                                     color: Colors.black54,
//                                                   ),
//                                                   SizedBox(width: width * .01),
//                                                   Text(
//                                                     "Add Stop",
//                                                     style: TextStyle(
//                                                       color: Colors.black54,
//                                                       fontSize: width * .035,
//                                                       fontWeight:
//                                                           FontWeight.bold,
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),

//                                   // ───────── Row: left rail + destination card + (outside) delete ─────────
//                                   Row(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       // Left rail
//                                       Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           // TOP segment: spacer for first, dotted for others
//                                           Padding(
//                                             padding: EdgeInsets.only(
//                                                 left: width * 0.025),
//                                             child: isFirst
//                                                 ? SizedBox(
//                                                     width: width * .05,
//                                                     height: topSegH)
//                                                 : DottedBorder(
//                                                     color: Colors.black54,
//                                                     strokeWidth: width * .0025,
//                                                     dashPattern: const [4, 3],
//                                                     strokeCap: StrokeCap.round,
//                                                     padding: EdgeInsets.zero,
//                                                     customPath: (size) => Path()
//                                                       ..moveTo(0, 0)
//                                                       ..lineTo(0, size.height),
//                                                     child: SizedBox(
//                                                       width: width * .05,
//                                                       height: topSegH,
//                                                     ),
//                                                   ),
//                                           ),

//                                           // RED DOT
//                                           Padding(
//                                             padding: EdgeInsets.only(
//                                                 left: width * 0.005),
//                                             child: Container(
//                                               width: width * 0.04,
//                                               height: width * 0.04,
//                                               decoration: BoxDecoration(
//                                                 border: Border.all(
//                                                   width: width * .005,
//                                                   color: Colors.black
//                                                       .withOpacity(.25),
//                                                 ),
//                                                 color: Colors.redAccent[200],
//                                                 shape: BoxShape.circle,
//                                               ),
//                                               child: Center(
//                                                 child: Container(
//                                                   width: width * 0.02,
//                                                   height: width * 0.02,
//                                                   decoration: BoxDecoration(
//                                                     color: Colors.black
//                                                         .withOpacity(0.5),
//                                                     shape: BoxShape.circle,
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                           ),

//                                           // BOTTOM segment — only if NOT last
//                                           if (!isLast)
//                                             Padding(
//                                               padding: EdgeInsets.only(
//                                                   left: width * 0.025),
//                                               child: DottedBorder(
//                                                 color: Colors.black54,
//                                                 strokeWidth: width * .0025,
//                                                 dashPattern: const [4, 3],
//                                                 strokeCap: StrokeCap.round,
//                                                 padding: EdgeInsets.zero,
//                                                 customPath: (size) => Path()
//                                                   ..moveTo(0, 0)
//                                                   ..lineTo(0, size.height),
//                                                 child: SizedBox(
//                                                   width: width * .05,
//                                                   height: bottomSegH,
//                                                 ),
//                                               ),
//                                             ),
//                                         ],
//                                       ),

//                                       SizedBox(width: width * .02),

//                                       // Destination card (Flexible to avoid overflow)
//                                       Expanded(
//                                         child: GestureDetector(
//                                           onTap: () async {
//                                             await Navigator.push(
//                                               context,
//                                               CupertinoPageRoute(
//                                                 builder: (_) =>
//                                                     D2dPlaceSearchPage(
//                                                   controller: destController,
//                                                   accentColor: Colors.redAccent,
//                                                   label:
//                                                       "Destination ${index + 1}",
//                                                 ),
//                                               ),
//                                             );
//                                             setState(() {});
//                                           },
//                                           child: Container(
//                                             height: width * .125,
//                                             padding: EdgeInsets.only(
//                                               left: width * 0.03,
//                                               right: width * .01,
//                                             ),
//                                             decoration: BoxDecoration(
//                                               color: Colors.white,
//                                               borderRadius:
//                                                   BorderRadius.circular(
//                                                 width * 0.03,
//                                               ),
//                                             ),
//                                             child: Row(
//                                               children: [
//                                                 Expanded(
//                                                   child: Text(
//                                                     destController.text.isEmpty
//                                                         ? "Enter Destination location"
//                                                         : destController.text,
//                                                     maxLines: 2,
//                                                     overflow:
//                                                         TextOverflow.ellipsis,
//                                                     style: TextStyle(
//                                                       color: destController
//                                                               .text.isEmpty
//                                                           ? Colors.black
//                                                               .withOpacity(.5)
//                                                           : Colors.black,
//                                                       fontSize: width * 0.035,
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 GestureDetector(
//                                                   onTap: () =>
//                                                       openRequestLocationSheet(
//                                                     context,
//                                                     "drop",
//                                                   ),
//                                                   child: Padding(
//                                                     padding: EdgeInsets.all(
//                                                       width * .01,
//                                                     ),
//                                                     child: Container(
//                                                       height: double.infinity,
//                                                       width: width * .2,
//                                                       decoration: BoxDecoration(
//                                                         color: ColorConstant
//                                                             .greenColor
//                                                             .withOpacity(.9),
//                                                         borderRadius:
//                                                             BorderRadius
//                                                                 .circular(
//                                                           width * 0.02,
//                                                         ),
//                                                       ),
//                                                       child: Center(
//                                                         child: Text(
//                                                           "Request\nLocation",
//                                                           textAlign:
//                                                               TextAlign.center,
//                                                           style: TextStyle(
//                                                             fontSize:
//                                                                 width * .028,
//                                                             fontWeight:
//                                                                 FontWeight.w600,
//                                                             color: Colors.white,
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       ),

//                                       SizedBox(width: width * .015),

//                                       // DELETE — show only if there are 2+ destinations
//                                       if (_destControllers.length > 1)
//                                         GestureDetector(
//                                           onTap: () => _removeAt(index),
//                                           child: Container(
//                                             height: width * .125,
//                                             width: width * .1,
//                                             decoration: BoxDecoration(
//                                               color: Colors.redAccent
//                                                   .withOpacity(.12),
//                                               borderRadius:
//                                                   BorderRadius.circular(
//                                                 width * .02,
//                                               ),
//                                               border: Border.all(
//                                                 color: Colors.redAccent
//                                                     .withOpacity(.4),
//                                                 width: width * .002,
//                                               ),
//                                             ),
//                                             child: Icon(
//                                               Icons.delete_outline,
//                                               size: width * .06,
//                                               color: Colors.redAccent,
//                                             ),
//                                           ),
//                                         ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             );
//                           },
//                         ),
//                       ],

//                       // NEXT BUTTON
//                       SizedBox(height: width * .08),
//                       GestureDetector(
//                         onTap: _nextPage,
//                         child: Container(
//                           width: width * .4,
//                           padding: EdgeInsets.symmetric(
//                             vertical: width * .025,
//                           ),
//                           decoration: BoxDecoration(
//                             color: Colors.blue,
//                             borderRadius: BorderRadius.circular(width * .025),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black26,
//                                 blurRadius: width * .02,
//                                 offset: Offset(width * .01, width * .0125),
//                               ),
//                             ],
//                           ),
//                           child: Center(
//                             child: Text(
//                               "Next",
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: width * .04,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),

//                       SizedBox(height: width * .5),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

////////////////////////////////////////////////////////////////

import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:drivex/core/constants/color_constant.dart';
import 'package:drivex/core/constants/imageConstants.dart';
import 'package:drivex/feature/bottomNavigation/pages/D2D/D2D_estimatePage.dart';
import 'package:drivex/feature/bottomNavigation/pages/D2D/D2D_placeSearchPage.dart';
import 'package:drivex/feature/bottomNavigation/pages/D2D/RouteResult.dart';
import 'package:drivex/feature/bottomNavigation/pages/D2DPage_02.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

const String googleApiKey =
    "AIzaSyDwD1BJXVxky_Cy6xzyQh_5A2PW9cTOO0I"; // one source of truth

class D2DPage01 extends StatefulWidget {
  const D2DPage01({super.key});
  @override
  State<D2DPage01> createState() => _D2DPage01State();
}

class _D2DPage01State extends State<D2DPage01> {
  // -----------------------------------------------------------------------------
  // ---- Secondary Firestore (cache) ----
//   FirebaseFirestore get _cacheDb =>
//       FirebaseFirestore.instanceFor(app: Firebase.app('gservice'));
//   CollectionReference<Map<String, dynamic>> get _cacheCol =>
//       _cacheDb.collection('places_cache');

// // ---- Small utilities ----
//   // Define your secondary Firestore instance here
//   final FirebaseFirestore gServiceDb = FirebaseFirestore.instance;

  String _norm(String s) =>
      s.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');

  bool _isInIndia(double lat, double lng) =>
      lat >= 6.5546079 &&
      lat <= 35.6745457 &&
      lng >= 68.1113787 &&
      lng <= 97.3955610;

  // Future<LatLng?> _findInCacheByQuery(String query) async {
  //   final key = _norm(query);
  //   final snap =
  //       await _cacheCol.where('query_keys', arrayContains: key).limit(1).get();
  //   if (snap.docs.isEmpty) return null;
  //   final d = snap.docs.first.data();
  //   // best-effort touch (ignore errors)
  //   _cacheCol.doc(snap.docs.first.id).update({
  //     'hits': FieldValue.increment(1),
  //     'last_used_at': FieldValue.serverTimestamp(),
  //   }).catchError((_) {});
  //   return LatLng((d['lat'] as num).toDouble(), (d['lng'] as num).toDouble());
  // }

  // Future<void> _saveToCache({
  //   required String placeId,
  //   required String name,
  //   required String address,
  //   required double lat,
  //   required double lng,
  //   required String queryUsed,
  //   String country = 'IN',
  // }) async {
  //   if (!_isInIndia(lat, lng)) return; // India-only cache
  //   final key = _norm(queryUsed);

  //   await _cacheCol.doc(placeId).set({
  //     'place_id': placeId,
  //     'name': name,
  //     'address': address,
  //     'lat': lat,
  //     'lng': lng,
  //     'admin': {'country': country},
  //     'query_keys': FieldValue.arrayUnion([key]),
  //     'hits': FieldValue.increment(1),
  //     'last_used_at': FieldValue.serverTimestamp(),
  //     'expires_at':
  //         Timestamp.fromDate(DateTime.now().add(const Duration(days: 90))),
  //   }, SetOptions(merge: true));
  // }

  // ------------------------------------
  // -----------------------------------------------------------------------------

  // ─────────────────────────────────────────────────────────────────────────────
  // STATE: controllers, focus, maps, trip/session
  // ─────────────────────────────────────────────────────────────────────────────
  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();
  final FocusNode fromFocus = FocusNode();
  final FocusNode toFocus = FocusNode();

  bool get hasPickup => fromController.text.trim().isNotEmpty;

  // VIA stop controllers (address text only)
  final List<TextEditingController> _stops = [];

  bool _isSaving = false;

  // extra metadata to build "route" schema
  // pickup / drop contact info (you can wire these to UI later if needed)
  final pickupNameCtrl = TextEditingController();
  final pickupPhoneCtrl = TextEditingController();
  final pickupNoteCtrl = TextEditingController();

  final dropNameCtrl = TextEditingController();
  final dropPhoneCtrl = TextEditingController();
  final dropNoteCtrl = TextEditingController();

  // stop metadata aligned to _stops
  final List<String> _stopTypes = []; // "pick" | "drop"
  final List<TextEditingController> _stopName = [];
  final List<TextEditingController> _stopPhone = [];
  final List<TextEditingController> _stopNote = [];

  // coordinates cache (filled from share page / current location / geocode)
  LatLng? pickupLatLng;
  LatLng? dropLatLng;
  final List<LatLng?> _stopLatLng = [];

  // total tiles: pickup + stops + destination (destination only when hasPickup)
  int get totalTiles => hasPickup ? (2 + _stops.length) : 1;

  bool isFieldActive = false;
  String activeField = ""; // "from" | "to"
  List<dynamic> suggestions = [];

  GoogleMapController? _mapController;

  String? tripId;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? tripSub;

  // ─────────────────────────────────────────────────────────────────────────────
  // LOCAL RECENTS (SharedPreferences)
  // ─────────────────────────────────────────────────────────────────────────────
  static const _kRecentPickupKey = 'recent_pickup_locations';
  static const _kRecentDropKey = 'recent_drop_locations';

  Future<List<Map<String, dynamic>>> _loadRecents(String slot) async {
    final prefs = await SharedPreferences.getInstance();
    final key = slot == 'pickup' ? _kRecentPickupKey : _kRecentDropKey;
    final list = prefs.getStringList(key) ?? const [];
    return list.map((s) => Map<String, dynamic>.from(jsonDecode(s))).toList();
  }

  Future<void> _saveRecent(
    String slot, {
    required double lat,
    required double lng,
    required String label,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final key = slot == 'pickup' ? _kRecentPickupKey : _kRecentDropKey;
    final list = prefs.getStringList(key) ?? [];

    // de-dup
    list.removeWhere((s) {
      final m = Map<String, dynamic>.from(jsonDecode(s));
      final sameCoords = (m['lat'] == lat && m['lng'] == lng);
      final sameLabel = (m['label'] == label);
      return sameCoords || sameLabel;
    });

    list.insert(
      0,
      jsonEncode({
        'lat': lat,
        'lng': lng,
        'label': label,
        'savedAt': DateTime.now().toIso8601String(),
      }),
    );

    // keep last 5
    if (list.length > 5) list.removeRange(5, list.length);
    await prefs.setStringList(key, list);
  }

  Future<Map<String, String>> _getSenderInfo() async {
    String name = '';
    String phone = '';

    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // direct from auth
      name = user.displayName?.trim() ?? '';
      phone = user.phoneNumber?.trim() ?? '';

      // try Firestore profile if any is missing
      if (name.isEmpty || phone.isEmpty) {
        try {
          final doc = await FirebaseFirestore.instance
              .collection(
                  'users') // <-- change if your profile collection differs
              .doc(user.uid)
              .get();

          if (doc.exists) {
            final data = doc.data() ?? {};
            if (name.isEmpty) {
              name =
                  (data['name'] ?? data['fullName'] ?? data['username'] ?? '')
                      .toString()
                      .trim();
            }
            if (phone.isEmpty) {
              phone =
                  (data['phone'] ?? data['mobile'] ?? data['phoneNumber'] ?? '')
                      .toString()
                      .trim();
            }
          }
        } catch (_) {
          // ignore and keep fallbacks
        }
      }

      // last fallback for name: use email local part
      if (name.isEmpty) {
        final email = user.email ?? '';
        if (email.contains('@')) {
          name = email.split('@').first.trim();
        }
      }
    }

    return {
      'name': name,
      'phone': phone,
    };
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // SHARE LINK SHEET (request location from other person)
  // ─────────────────────────────────────────────────────────────────────────────
  void openRequestLocationSheet(BuildContext context, String slot,
      {int? viaIndex}) {
    showCupertinoModalPopup(
      context: context,
      barrierColor: Colors.black.withOpacity(.35),
      builder: (ctx) {
        Future<Map<String, dynamic>>? linkFuture;

        return StatefulBuilder(
          builder: (ctx, setSheet) {
            linkFuture ??= _sendLocationRequest(slot, viaIndex: viaIndex);
            final size = MediaQuery.of(ctx).size;
            final width = size.width;
            final height = size.height;
            return Material(
              color: Colors.transparent,
              child: SafeArea(
                top: false,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: width,
                    height: height * .65,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(width * .05),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: width * .05,
                        vertical: width * .04,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // drag handle
                          Center(
                            child: Container(
                              width: width * .18,
                              height: width * .013,
                              decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius:
                                    BorderRadius.circular(width * .01),
                              ),
                            ),
                          ),
                          SizedBox(height: width * .035),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Request Location",
                                  style: TextStyle(
                                    fontSize: width * .05,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              CupertinoButton(
                                padding: EdgeInsets.zero,
                                onPressed: () => Navigator.pop(ctx),
                                child: Icon(
                                  CupertinoIcons.xmark,
                                  size: width * .06,
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: width * .01),
                          Text(
                            'Share the link below to get the ${slot.toUpperCase()} location.',
                            style: TextStyle(
                              fontSize: width * .0325,
                              color: Colors.black54,
                            ),
                          ),
                          SizedBox(height: width * .04),
                          Expanded(
                            child: FutureBuilder<Map<String, dynamic>>(
                              future: linkFuture,
                              builder: (ctx, snap) {
                                if (snap.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const CupertinoActivityIndicator(
                                            radius: 14),
                                        SizedBox(height: width * .03),
                                        Text(
                                          "Generating secure link…",
                                          style: TextStyle(
                                            fontSize: width * .034,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                                if (snap.hasError) {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        CupertinoIcons.exclamationmark_triangle,
                                        color: Colors.red,
                                        size: width * .12,
                                      ),
                                      SizedBox(height: width * .02),
                                      Text(
                                        "Couldn't create link",
                                        style: TextStyle(
                                          fontSize: width * .042,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: width * .02),
                                      Text(
                                        "${snap.error}",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: width * .032,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      SizedBox(height: width * .04),
                                      CupertinoButton.filled(
                                        onPressed: () => setSheet(
                                          () => linkFuture =
                                              _sendLocationRequest(slot,
                                                  viaIndex: viaIndex),
                                        ),
                                        child: const Text("Try again"),
                                      ),
                                    ],
                                  );
                                }

                                final data = snap.data!;
                                final link = data['link'] as String;
                                final expiresAt = data['expiresAt'] as String?;

                                // Just show the link (no Firestore write here)
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(width * .035),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF5F7FA),
                                        border: Border.all(
                                            color: const Color(0xFFE5E9F0)),
                                        borderRadius:
                                            BorderRadius.circular(width * .03),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Share this link",
                                            style: TextStyle(
                                              fontSize: width * .035,
                                              color: Colors.black54,
                                            ),
                                          ),
                                          SizedBox(height: width * .02),
                                          SelectableText(
                                            link,
                                            style: TextStyle(
                                              fontSize: width * .034,
                                              fontFamily: 'monospace',
                                            ),
                                          ),
                                          if (expiresAt != null) ...[
                                            SizedBox(height: width * .02),
                                            Text(
                                              "Expires: $expiresAt",
                                              style: TextStyle(
                                                fontSize: width * .03,
                                                color: Colors.black45,
                                              ),
                                            ),
                                          ],
                                          SizedBox(height: width * .02),
                                          Row(
                                            children: [
                                              // Copy
                                              Expanded(
                                                child: CupertinoButton(
                                                  color:
                                                      const Color(0xFFE8F3FF),
                                                  padding: EdgeInsets.symmetric(
                                                    vertical: width * .028,
                                                  ),
                                                  onPressed: () async {
                                                    await Clipboard.setData(
                                                        ClipboardData(
                                                            text: link));
                                                    if (mounted) {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                          content: Text(
                                                              "Link copied"),
                                                          behavior:
                                                              SnackBarBehavior
                                                                  .floating,
                                                          duration: Duration(
                                                              seconds: 1),
                                                        ),
                                                      );
                                                    }
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        CupertinoIcons
                                                            .doc_on_doc,
                                                        size: width * .05,
                                                        color: const Color(
                                                            0xFF1976D2),
                                                      ),
                                                      SizedBox(
                                                          width: width * .02),
                                                      Text(
                                                        "Copy link",
                                                        style: TextStyle(
                                                          fontSize:
                                                              width * .035,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: const Color(
                                                              0xFF1976D2),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: width * .03),
                                              // Share
                                              Expanded(
                                                child: CupertinoButton.filled(
                                                  padding: EdgeInsets.symmetric(
                                                    vertical: width * .028,
                                                  ),
                                                  onPressed: () async {
                                                    await Share.share(
                                                      link,
                                                      subject:
                                                          "Share your ${slot.toUpperCase()} location",
                                                    );
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(CupertinoIcons.share,
                                                          size: width * .05),
                                                      SizedBox(
                                                          width: width * .02),
                                                      Text(
                                                        "Share",
                                                        style: TextStyle(
                                                          fontSize:
                                                              width * .035,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: width * .04),

                                    // Recent Requests placeholder
                                    Text(
                                      "Recent Request",
                                      style: TextStyle(
                                        fontSize: width * .036,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: width * .025),
                                    Container(
                                      height: width * .25,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF5F7FA),
                                        border:
                                            Border.all(color: Colors.black12),
                                        borderRadius:
                                            BorderRadius.circular(width * .03),
                                      ),
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              CupertinoIcons.location_solid,
                                              color: Colors.redAccent,
                                              size: width * .06,
                                            ),
                                            SizedBox(width: width * .03),
                                            Text(
                                              "No recent Location",
                                              style: TextStyle(
                                                fontSize: width * .04,
                                                color: Colors.black54,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: width * .025),
                                    SizedBox(
                                      width: double.infinity,
                                      child: CupertinoButton(
                                        color: const Color(0xFF1E88E5),
                                        onPressed: () => Navigator.pop(ctx),
                                        child: Text(
                                          "Done",
                                          style: TextStyle(
                                            fontSize: width * .04,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Only generate and return a link. No Firestore writes beyond allowed fields.
  Future<Map<String, dynamic>> _sendLocationRequest(String type,
      {int? viaIndex}) async {
    if (tripId == null) {
      await _createTripDocument(); // ensure exists
    }
    final id = tripId!;
    final shareId = const Uuid().v4(); // kept for URL/session purposes
    final expiresAtDt = DateTime.now().add(const Duration(hours: 24));
    final expiresAtIso = expiresAtDt.toIso8601String();

    // deep link with optional vindex (lets your web know which stop)
    final params = {
      "id": id,
      "type": type,
      "sid": shareId,
      if (viaIndex != null) "vindex": "$viaIndex",
    };
    final q = params.entries
        .map((e) => "${e.key}=${Uri.encodeComponent(e.value)}")
        .join("&");
    final link = "https://drivex-2a34e.web.app/?$q";

    return {"link": link, "expiresAt": expiresAtIso, "shareId": shareId};
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // FIRESTORE: create trip + listen to updates
  // ─────────────────────────────────────────────────────────────────────────────
  // Future<void> _createTripDocument() async {
  //   final docRef =
  //       await FirebaseFirestore.instance.collection("D2D_Orders").add({
  //     // Only the allowed fields:
  //     "route": {
  //       "pickup": {
  //         "phone": pickupPhoneCtrl.text.trim(),
  //         "name": pickupNameCtrl.text.trim(),
  //         "note": pickupNoteCtrl.text.trim(),
  //         "locationCoordinates": null,
  //       },
  //       "stops": [],
  //       "dropoff": {
  //         "phone": dropPhoneCtrl.text.trim(),
  //         "name": dropNameCtrl.text.trim(),
  //         "note": dropNoteCtrl.text.trim(),
  //         "locationCoordinates": null,
  //       },
  //     },
  //     "senderName": "",
  //     "senderPhone": "",
  //     "createdAt": FieldValue.serverTimestamp(),
  //     "updatedAt": FieldValue.serverTimestamp(),
  //     "status": "initiated",
  //   });

  //   tripId = docRef.id;
  //   _listenToTripUpdates();
  // }

  ////////////////////////////////////////

  // Future<void> _backfillSenderFieldsIfEmpty() async {
  //   if (tripId == null) return;
  //   final ref = FirebaseFirestore.instance.collection('D2D_Orders').doc(tripId);
  //   final snap = await ref.get();
  //   if (!snap.exists) return;
  //   final data = snap.data() ?? {};
  //   final needsName = (data['senderName'] ?? '').toString().trim().isEmpty;
  //   final needsPhone = (data['senderPhone'] ?? '').toString().trim().isEmpty;
  //   if (needsName || needsPhone) {
  //     final s = await _getSenderInfo();
  //     await ref.update({
  //       if (needsName) "senderName": s['name'] ?? "",
  //       if (needsPhone) "senderPhone": s['phone'] ?? "",
  //       "updatedAt": FieldValue.serverTimestamp(),
  //     });
  //   }
  // }

  Future<void> _createTripDocument() async {
    // get user info first
    final sender = await _getSenderInfo();
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final email = FirebaseAuth.instance.currentUser?.email;

    final docRef =
        await FirebaseFirestore.instance.collection("D2D_Orders").add({
      "route": {
        "pickup": {
          "phone": pickupPhoneCtrl.text.trim(),
          "name": pickupNameCtrl.text.trim(),
          "note": pickupNoteCtrl.text.trim(),
          "locationCoordinates": null,
        },
        "stops": [],
        "dropoff": {
          "phone": dropPhoneCtrl.text.trim(),
          "name": dropNameCtrl.text.trim(),
          "note": dropNoteCtrl.text.trim(),
          "locationCoordinates": null,
        },
      },

      // NEW: identify the customer creating the order
      "senderName": sender['name'] ?? "",
      "senderPhone": sender['phone'] ?? "",
      "createdBy": uid,
      "createdByEmail": email,

      "createdAt": FieldValue.serverTimestamp(),
      "updatedAt": FieldValue.serverTimestamp(),
      "status": "initiated",
    });

    tripId = docRef.id;
    _listenToTripUpdates();
  }

  void _listenToTripUpdates() {
    tripSub?.cancel();
    final id = tripId;
    if (id == null) return;
    tripSub = FirebaseFirestore.instance
        .collection("D2D_Orders")
        .doc(id)
        .snapshots()
        .listen((doc) {
      if (!doc.exists) return;
      final data = doc.data();
      if (data == null) return;

      // Only: route.* updates UI
      final route = (data['route'] as Map<String, dynamic>?) ?? {};

      // pickup
      final pickup = route['pickup'] as Map<String, dynamic>?;
      final pLoc = pickup?['locationCoordinates'] as Map<String, dynamic>?;
      if (pLoc != null && pLoc['lat'] != null && pLoc['lng'] != null) {
        final lat = (pLoc['lat'] as num).toDouble();
        final lng = (pLoc['lng'] as num).toDouble();
        setState(() {
          pickupLatLng = LatLng(lat, lng);
          fromController.text =
              "${lat.toStringAsFixed(6)}, ${lng.toStringAsFixed(6)}";
        });
      }

      // dropoff
      final drop = route['dropoff'] as Map<String, dynamic>?;
      final dLoc = drop?['locationCoordinates'] as Map<String, dynamic>?;
      if (dLoc != null && dLoc['lat'] != null && dLoc['lng'] != null) {
        final lat = (dLoc['lat'] as num).toDouble();
        final lng = (dLoc['lng'] as num).toDouble();
        setState(() {
          dropLatLng = LatLng(lat, lng);
          toController.text =
              "${lat.toStringAsFixed(6)}, ${lng.toStringAsFixed(6)}";
        });
      }

      // stops
      final stops = (route['stops'] as List?)?.cast<dynamic>() ?? const [];
      if (stops.isNotEmpty) {
        setState(() {
          // Ensure UI lists are long enough
          while (_stops.length < stops.length) {
            _stops.add(TextEditingController());
            _stopTypes.add("pick");
            _stopName.add(TextEditingController());
            _stopPhone.add(TextEditingController());
            _stopNote.add(TextEditingController());
            _stopLatLng.add(null);
          }
          for (var i = 0; i < stops.length; i++) {
            final s = (stops[i] as Map?)?.cast<String, dynamic>() ?? {};
            final loc = (s['location'] as Map?)?.cast<String, dynamic>();
            final type = (s['type'] as String?) ?? "pick";
            _stopTypes[i] = type;
            _stopName[i].text = (s['name'] as String?) ?? _stopName[i].text;
            _stopPhone[i].text = (s['phone'] as String?) ?? _stopPhone[i].text;
            _stopNote[i].text = (s['note'] as String?) ?? _stopNote[i].text;

            if (loc != null && loc['lat'] != null && loc['lng'] != null) {
              final lat = (loc['lat'] as num).toDouble();
              final lng = (loc['lng'] as num).toDouble();
              _stopLatLng[i] = LatLng(lat, lng);
              _stops[i].text =
                  "${lat.toStringAsFixed(6)}, ${lng.toStringAsFixed(6)}";
            }
          }
        });
      }
    });
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // LOCATION (self) + utility
  // ─────────────────────────────────────────────────────────────────────────────
  String _generateMapLink(double lat, double lng) =>
      "https://www.google.com/maps?q=$lat,$lng";

  Future<void> requestLocation(TextEditingController controller) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception("Location services are disabled.");
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception("Location permission denied.");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception("Location permission permanently denied.");
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    final link = _generateMapLink(position.latitude, position.longitude);
    controller.text = link;
    await Share.share("Here is my location: $link");
  }

  Future<void> getCurrentLocationAndSetField() async {
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    final latLng = LatLng(position.latitude, position.longitude);

    // reverse geocode
    final url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$googleApiKey";
    final response = await http.get(Uri.parse(url));
    String address = "Current location";
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      if (body['status'] == 'OK') {
        address = body['results'][0]['formatted_address'];
      }
    }

    setState(() {
      if (activeField == "from") {
        pickupLatLng = latLng;
        fromController.text = address;
        _mapController?.animateCamera(CameraUpdate.newLatLng(latLng));
      } else if (activeField == "to") {
        dropLatLng = latLng;
        toController.text = address;
        _mapController?.animateCamera(CameraUpdate.newLatLng(latLng));
      }
      isFieldActive = false;
      suggestions.clear();
    });
  }

  Future<String> getPlaceFromCoordinates(double lat, double lon) async {
    try {
      final placemarks = await placemarkFromCoordinates(lat, lon);
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        final parts = <String?>[
          p.name,
          p.street,
          p.subLocality,
          p.locality,
          p.administrativeArea,
          p.country,
          p.postalCode
        ].where((e) => e != null && e!.isNotEmpty).map((e) => e!).toList();
        return parts.join(', ');
      }
      return "No place found for the given coordinates.";
    } catch (e) {
      return "Error getting place: $e";
    }
  }

  // Future<LatLng?> _geocodeAddress(String address) async {
  //   if (address.trim().isEmpty) return null;
  //   final url =
  //       "https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeComponent(address)}&key=$googleApiKey";
  //   try {
  //     final res = await http.get(Uri.parse(url));
  //     if (res.statusCode == 200) {
  //       final body = jsonDecode(res.body);
  //       if (body['status'] == 'OK' && (body['results'] as List).isNotEmpty) {
  //         final loc = body['results'][0]['geometry']['location'];
  //         final lat = (loc['lat'] as num).toDouble();
  //         final lng = (loc['lng'] as num).toDouble();
  //         return LatLng(lat, lng);
  //       }
  //     }
  //   } catch (_) {}
  //   return null;
  // }

  Future<LatLng?> _geocodeAddress(String address) async {
    final q = address.trim();
    if (q.isEmpty) return null;

    // 1) Try secondary Firestore cache
    // final cached = await _findInCacheByQuery(q);
    // if (cached != null) return cached;

    // 2) Miss → Google Geocoding
    final url =
        "https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeComponent(q)}&key=$googleApiKey";
    try {
      final res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        if (body['status'] == 'OK' && (body['results'] as List).isNotEmpty) {
          final r = body['results'][0];
          final loc = r['geometry']['location'];
          final lat = (loc['lat'] as num).toDouble();
          final lng = (loc['lng'] as num).toDouble();
          final addr = (r['formatted_address'] as String?) ?? q;

          // country (optional)
          String country = 'IN';
          try {
            final comps = (r['address_components'] as List?) ?? const [];
            for (final c in comps) {
              final types = (c['types'] as List?)?.cast<String>() ?? const [];
              if (types.contains('country')) {
                country = (c['short_name'] as String?) ?? 'IN';
                break;
              }
            }
          } catch (_) {}

          // 3) Save to cache (no-op if outside India bbox)
          // await _saveToCache(
          //   placeId: (r['place_id'] as String?) ?? Uri.encodeComponent(addr),
          //   name: addr,
          //   address: addr,
          //   lat: lat,
          //   lng: lng,
          //   queryUsed: q,
          //   country: country,
          // );

          return LatLng(lat, lng);
        }
      }
    } catch (_) {}
    return null;
  }

  Future<void> _ensureAllLocationsResolved() async {
    // pickup
    if (pickupLatLng == null && fromController.text.trim().isNotEmpty) {
      pickupLatLng = await _geocodeAddress(fromController.text.trim());
    }
    // drop
    if (dropLatLng == null && toController.text.trim().isNotEmpty) {
      dropLatLng = await _geocodeAddress(toController.text.trim());
    }
    // stops
    for (var i = 0; i < _stops.length; i++) {
      if (_stopLatLng[i] == null && _stops[i].text.trim().isNotEmpty) {
        _stopLatLng[i] = await _geocodeAddress(_stops[i].text.trim());
      }
    }
  }

  // Map<String, dynamic> _buildRoutePayload() {
  //   Map<String, double>? _coords(LatLng? ll) =>
  //       (ll == null) ? null : {"lat": ll.latitude, "lng": ll.longitude};

  //   final stops = <Map<String, dynamic>>[];
  //   for (var i = 0; i < _stops.length; i++) {
  //     final loc = _coords(_stopLatLng[i]);
  //     if (loc != null) {
  //       stops.add({
  //         "type": _stopTypes[i], // "pick" | "drop"
  //         "location": loc,
  //         "phone": _stopPhone[i].text.trim(),
  //         "name": _stopName[i].text.trim(),
  //         "note": _stopNote[i].text.trim(),
  //       });
  //     }
  //   }

  //   return {
  //     "route": {
  //       "pickup": {
  //         "phone": pickupPhoneCtrl.text.trim(),
  //         "name": pickupNameCtrl.text.trim(),
  //         "note": pickupNoteCtrl.text.trim(),
  //         "locationCoordinates": _coords(pickupLatLng),
  //       },
  //       "stops": stops,
  //       "dropoff": {
  //         "phone": dropPhoneCtrl.text.trim(),
  //         "name": dropNameCtrl.text.trim(),
  //         "note": dropNoteCtrl.text.trim(),
  //         "locationCoordinates": _coords(dropLatLng),
  //       },
  //     },
  //     "updatedAt": FieldValue.serverTimestamp(),
  //   };
  // }

  Map<String, dynamic> _buildRoutePayload() {
    Map<String, double>? _coords(LatLng? ll) =>
        (ll == null) ? null : {"lat": ll.latitude, "lng": ll.longitude};

    final stops = <Map<String, dynamic>>[];
    for (var i = 0; i < _stops.length; i++) {
      final loc = _coords(_stopLatLng[i]);
      if (loc != null) {
        stops.add({
          "type": _stopTypes[i], // "pick" | "drop"
          "address": _stops[i].text.trim(),
          "location": loc,
          "phone": _stopPhone[i].text.trim(),
          "name": _stopName[i].text.trim(),
          "note": _stopNote[i].text.trim(),
        });
      }
    }

    return {
      "route": {
        "pickup": {
          "address": fromController.text.trim(),
          "phone": pickupPhoneCtrl.text.trim(),
          "name": pickupNameCtrl.text.trim(),
          "note": pickupNoteCtrl.text.trim(),
          "locationCoordinates": _coords(pickupLatLng),
        },
        "stops": stops,
        "dropoff": {
          "address": toController.text.trim(),
          "phone": dropPhoneCtrl.text.trim(),
          "name": dropNameCtrl.text.trim(),
          "note": dropNoteCtrl.text.trim(),
          "locationCoordinates": _coords(dropLatLng),
        },
      },
      "updatedAt": FieldValue.serverTimestamp(),
    };
  }

  Future<void> _saveRoute() async {
    if (tripId == null) await _createTripDocument();
    await _ensureAllLocationsResolved();
    final id = tripId!;
    final payload = _buildRoutePayload();
    await FirebaseFirestore.instance
        .collection("D2D_Orders")
        .doc(id)
        .set(payload, SetOptions(merge: true));
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // GOOGLE PLACES: Autocomplete & Details via REST (optional helpers)
  // ─────────────────────────────────────────────────────────────────────────────
  Future<void> getPlaceSuggestions(String input) async {
    if (input.isEmpty) {
      setState(() => suggestions = []);
      return;
    }
    final sessionToken = const Uuid().v4();
    final url =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$googleApiKey&sessiontoken=$sessionToken&components=country:in";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      if (body['status'] == 'OK') {
        setState(() => suggestions = body['predictions']);
      } else {
        setState(() => suggestions = []);
      }
    }
  }

  // Future<void> selectSuggestion(String placeId) async {
  //   final url =
  //       "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$googleApiKey";
  //   final response = await http.get(Uri.parse(url));
  //   if (response.statusCode == 200) {
  //     final result = jsonDecode(response.body)['result'];
  //     final lat = (result['geometry']['location']['lat'] as num).toDouble();
  //     final lng = (result['geometry']['location']['lng'] as num).toDouble();
  //     final address = result['formatted_address'] as String? ?? "";
  //     final ll = LatLng(lat, lng);

  //     setState(() {
  //       if (activeField == "from") {
  //         pickupLatLng = ll;
  //         fromController.text = address;
  //         _mapController?.animateCamera(CameraUpdate.newLatLng(ll));
  //       } else if (activeField == "to") {
  //         dropLatLng = ll;
  //         toController.text = address;
  //         _mapController?.animateCamera(CameraUpdate.newLatLng(ll));
  //       }
  //       isFieldActive = false;
  //       suggestions.clear();
  //     });
  //   }
  // }

  Future<void> selectSuggestion(String placeId) async {
    try {
      // Safety: encode the Place ID
      final url = "https://maps.googleapis.com/maps/api/place/details/json"
          "?place_id=${Uri.encodeComponent(placeId)}&key=$googleApiKey";

      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        _showSnackBar("Places API error: ${response.statusCode}");
        return;
      }

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      if ((body['status'] as String?) != 'OK' || body['result'] == null) {
        _showSnackBar("Couldn't fetch place details.");
        return;
      }

      final result = body['result'] as Map<String, dynamic>;
      final loc =
          (result['geometry']?['location'] as Map?)?.cast<String, dynamic>();
      if (loc == null || loc['lat'] == null || loc['lng'] == null) {
        _showSnackBar("Place has no coordinates.");
        return;
      }

      final double lat = (loc['lat'] as num).toDouble();
      final double lng = (loc['lng'] as num).toDouble();
      final String address = (result['formatted_address'] as String?) ?? "";
      final String name = (result['name'] as String?) ?? address;
      final String pid = (result['place_id'] as String?) ?? placeId;
      final ll = LatLng(lat, lng);

      // Extract country (optional; defaults to IN)
      String country = 'IN';
      try {
        final comps = (result['address_components'] as List?) ?? const [];
        for (final c in comps) {
          final types = (c['types'] as List?)?.cast<String>() ?? const [];
          if (types.contains('country')) {
            country = (c['short_name'] as String?) ?? 'IN';
            break;
          }
        }
      } catch (_) {/* ignore */}

      // Save to the secondary cache (no-op if outside India bbox)
      // await _saveToCache(
      //   placeId: pid,
      //   name: name,
      //   address: address,
      //   lat: lat,
      //   lng: lng,
      //   queryUsed: address.isNotEmpty ? address : name,
      //   country: country,
      // );

      // Update UI
      if (!mounted) return;
      setState(() {
        if (activeField == "from") {
          pickupLatLng = ll;
          fromController.text = address;
          _mapController?.animateCamera(CameraUpdate.newLatLng(ll));
        } else if (activeField == "to") {
          dropLatLng = ll;
          toController.text = address;
          _mapController?.animateCamera(CameraUpdate.newLatLng(ll));
        }
        isFieldActive = false;
        suggestions.clear();
      });
    } catch (e) {
      _showSnackBar("Failed to select place: $e");
    }
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // BOTTOM SHEET: choose stop type (Pick / Drop)
  // ─────────────────────────────────────────────────────────────────────────────
  Future<String?> _askStopType(BuildContext context) async {
    return showCupertinoModalPopup<String>(
      context: context,
      builder: (ctx) => CupertinoActionSheet(
        title: const Text('Add Stop'),
        message: const Text('Which type of point do you want to add here?'),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(ctx, 'pick'),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(CupertinoIcons.arrow_down_circle_fill,
                    color: Colors.green),
                SizedBox(width: 8),
                Text('Pickup'),
              ],
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(ctx, 'drop'),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(CupertinoIcons.arrow_up_circle_fill,
                    color: Colors.redAccent),
                SizedBox(width: 8),
                Text('Drop'),
              ],
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(ctx, null),
          child: const Text('Cancel'),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // LIFECYCLE
  // ─────────────────────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    _createTripDocument();

    fromFocus.addListener(() {
      if (fromFocus.hasFocus) {
        setState(() {
          isFieldActive = true;
          activeField = "from";
        });
      }
    });
    toFocus.addListener(() {
      if (toFocus.hasFocus) {
        setState(() {
          isFieldActive = true;
          activeField = "to";
        });
      }
    });

    // show/hide Drop dynamically + clear Drop when Pickup cleared
    fromController.addListener(() {
      final hasPickupLocal = fromController.text.trim().isNotEmpty;
      if (!hasPickupLocal && toController.text.isNotEmpty) {
        toController.clear(); // auto-clear drop when pickup removed
        dropLatLng = null;
      }
      if (mounted) setState(() {}); // rebuild to update visibility
    });
  }

  @override
  void dispose() {
    fromController.dispose();
    toController.dispose();
    for (final c in _stops) {
      c.dispose();
    }
    for (final c in _stopName) c.dispose();
    for (final c in _stopPhone) c.dispose();
    for (final c in _stopNote) c.dispose();

    pickupNameCtrl.dispose();
    pickupPhoneCtrl.dispose();
    pickupNoteCtrl.dispose();
    dropNameCtrl.dispose();
    dropPhoneCtrl.dispose();
    dropNoteCtrl.dispose();

    fromFocus.dispose();
    toFocus.dispose();
    tripSub?.cancel();
    super.dispose();
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // UI HELPERS
  // ─────────────────────────────────────────────────────────────────────────────
  // Future<void> _onNext() async {
  //   final pickupText = fromController.text.trim();
  //   final dropText = toController.text.trim();
  //   if (pickupText.isEmpty || dropText.isEmpty) {
  //     _showSnackBar("Please fill both Pick-Up and Drop-Off Locations.");
  //     return;
  //   }
  //   // ensure no empty stops
  //   if (_stops.any((s) => s.text.trim().isEmpty)) {
  //     _showSnackBar("Please fill all stops or remove empty ones.");
  //     return;
  //   }

  //   await _saveRoute();

  //   _showSnackBar("Driver requested successfully!");
  //   if (!mounted) return;
  //   Navigator.push(
  //     context,
  //     CupertinoPageRoute(
  //       builder: (context) => D2Dpage02(
  //         pickupLocation: pickupText,
  //         dropLocation: dropText,
  //       ),
  //     ),
  //   );
  // }

  ///////////////

  // Future<void> _onNext() async {
  //   if (_isSaving) return; // prevent double taps

  //   final pickupText = fromController.text.trim();
  //   final dropText = toController.text.trim();

  //   if (pickupText.isEmpty || dropText.isEmpty) {
  //     _showSnackBar("Please fill both Pick-Up and Drop-Off Locations.");
  //     return;
  //   }
  //   if (_stops.any((s) => s.text.trim().isEmpty)) {
  //     _showSnackBar("Please fill all stops or remove empty ones.");
  //     return;
  //   }

  //   setState(() => _isSaving = true);
  //   try {
  //     await _saveRoute(); // creates/updates Firestore with full route payload
  //     if (!mounted) return;

  //     _showSnackBar("Driver requested successfully!");
  //     Navigator.push(
  //       context,
  //       CupertinoPageRoute(
  //         builder: (context) => D2Dpage02(
  //           pickupLocation: pickupText,
  //           dropLocation: dropText,
  //         ),
  //       ),
  //     );
  //   } on FirebaseException catch (e) {
  //     _showSnackBar("Couldn't save: ${e.message ?? 'Unknown error'}");
  //   } catch (e) {
  //     _showSnackBar("Couldn't save: $e");
  //   } finally {
  //     if (mounted) setState(() => _isSaving = false);
  //   }
  // }

  /////////////

  // Future<void> _onNext() async {
  //   if (_isSaving) return;

  //   final pickupText = fromController.text.trim();
  //   final dropText = toController.text.trim();

  //   if (pickupText.isEmpty || dropText.isEmpty) {
  //     _showSnackBar("Please fill both Pick-Up and Drop-Off Locations.");
  //     return;
  //   }
  //   if (_stops.any((s) => s.text.trim().isEmpty)) {
  //     _showSnackBar("Please fill all stops or remove empty ones.");
  //     return;
  //   }

  //   setState(() => _isSaving = true);
  //   try {
  //     // ensure coords exist before saving & navigating
  //     await _ensureAllLocationsResolved();

  //     // 1) Save to Firestore
  //     await _saveRoute();

  //     // 2) Navigate to Estimate with the just-saved (and already resolved) data
  //     // final args = _buildEstimateArgsFromState();
  //     final args = await _buildEstimateArgsFromState();

  //     if (!mounted) return;
  //     // Navigator.push(
  //     //   context,
  //     //   CupertinoPageRoute(
  //     //     builder: (_) => const D2dEstimatepage(),
  //     //     settings: RouteSettings(arguments: args),
  //     //   ),
  //     // );
  //     Navigator.push(
  //       context,
  //       CupertinoPageRoute(
  //         builder: (_) => const D2dEstimatepage(),
  //         settings: RouteSettings(arguments: args),
  //       ),
  //     );
  //   } on FirebaseException catch (e) {
  //     _showSnackBar("Couldn't save: ${e.message ?? 'Unknown error'}");
  //   } catch (e) {
  //     _showSnackBar("Couldn't save: $e");
  //   } finally {
  //     if (mounted) setState(() => _isSaving = false);
  //   }
  // }

  /////////////

  Future<void> _onNext() async {
    if (_isSaving) return;

    final pickupText = fromController.text.trim();
    final dropText = toController.text.trim();

    // basic validation
    if (pickupText.isEmpty || dropText.isEmpty) {
      _showSnackBar("Please fill both Pick-Up and Drop-Off Locations.");
      return;
    }
    if (_stops.any((c) => c.text.trim().isEmpty)) {
      _showSnackBar("Please fill all stops or remove empty ones.");
      return;
    }

    setState(() => _isSaving = true);
    try {
      // 1) ensure we have coordinates for all points
      await _ensureAllLocationsResolved();

      // 2) persist route to Firestore
      await _saveRoute();

      // 3) build navigation args (adds roadKm/etaMins/polyline if Directions succeeds)
      final args = await _buildEstimateArgsFromState();
      if (!mounted) return;

      // 4) go to estimate page (your UI there stays unchanged)
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (_) => D2dEstimateOsrmPage(),
          settings: RouteSettings(arguments: args),
        ),
      );
    } on FirebaseException catch (e) {
      _showSnackBar("Couldn't save: ${e.message ?? 'Unknown error'}");
    } catch (e) {
      _showSnackBar("Couldn't save: $e");
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  // Map<String, dynamic> _buildEstimateArgsFromState() {
  //   // address fallbacks if empty: show lat,lng
  //   String _addrOrCoords(String? address, LatLng? ll) {
  //     if (address != null && address.trim().isNotEmpty) return address.trim();
  //     if (ll != null) {
  //       return "${ll.latitude.toStringAsFixed(6)}, ${ll.longitude.toStringAsFixed(6)}";
  //     }
  //     return ""; // still empty -> estimate page will show coords chain safely
  //   }

  //   final pickupMap = {
  //     "address": _addrOrCoords(fromController.text, pickupLatLng),
  //     "lat": pickupLatLng?.latitude ?? 0.0,
  //     "lng": pickupLatLng?.longitude ?? 0.0,
  //   };

  //   final dropMap = {
  //     "address": _addrOrCoords(toController.text, dropLatLng),
  //     "lat": dropLatLng?.latitude ?? 0.0,
  //     "lng": dropLatLng?.longitude ?? 0.0,
  //   };

  //   final stopsList = <Map<String, dynamic>>[];
  //   for (int i = 0; i < _stops.length; i++) {
  //     final ll = _stopLatLng[i];
  //     if (ll == null) continue; // ignore empty/unresolved stops
  //     stopsList.add({
  //       "address": _addrOrCoords(_stops[i].text, ll),
  //       "lat": ll.latitude,
  //       "lng": ll.longitude,
  //     });
  //   }

  //   return {
  //     "pickup": pickupMap,
  //     "stops": stopsList,
  //     "dropoff": dropMap,
  //   };
  // }

  // put this next to your other helpers
  List<Map<String, double>> _polyToList(List<LatLng> pts) =>
      pts.map((p) => {"lat": p.latitude, "lng": p.longitude}).toList();

  Future<Map<String, dynamic>> _buildEstimateArgsFromState() async {
    // address fallbacks if empty: show lat,lng
    String _addrOrCoords(String? address, LatLng? ll) {
      if (address != null && address.trim().isNotEmpty) return address.trim();
      if (ll != null) {
        return "${ll.latitude.toStringAsFixed(6)}, ${ll.longitude.toStringAsFixed(6)}";
      }
      return "";
    }

    // make sure we actually have coords before calling Directions
    await _ensureAllLocationsResolved();

    final pickupMap = {
      "address": _addrOrCoords(fromController.text, pickupLatLng),
      "lat": pickupLatLng?.latitude ?? 0.0,
      "lng": pickupLatLng?.longitude ?? 0.0,
    };

    final dropMap = {
      "address": _addrOrCoords(toController.text, dropLatLng),
      "lat": dropLatLng?.latitude ?? 0.0,
      "lng": dropLatLng?.longitude ?? 0.0,
    };

    final stopsList = <Map<String, dynamic>>[];
    final via = <LatLng>[];
    for (int i = 0; i < _stops.length; i++) {
      final ll = _stopLatLng[i];
      if (ll == null) continue; // ignore empty/unresolved stops
      stopsList.add({
        "address": _addrOrCoords(_stops[i].text, ll),
        "lat": ll.latitude,
        "lng": ll.longitude,
      });
      via.add(ll);
    }

    // base args (works even if Directions fails)
    final args = <String, dynamic>{
      "pickup": pickupMap,
      "stops": stopsList,
      "dropoff": dropMap,
    };

    // if we don't have both endpoints, return base args
    final origin = pickupLatLng;
    final destination = dropLatLng;
    if (origin == null || destination == null) return args;

    try {
      // final rr = await getRoadRouteDistance(
      //   apiKey: googleApiKey,
      //   origin: origin,
      //   destination: destination,
      //   waypoints: via,
      //   optimize: false, // set true to let Google reorder stops
      // );
      final rr = await getRoadRouteDistance(
        apiKey: googleApiKey,
        origin: origin,
        destination: destination,
        waypoints: via,
        optimize: false,
      );
      if (rr != null) {
        args["roadKm"] = rr.km;
        args["etaMins"] = rr.minutes;
        args["polyline"] = _polyToList(rr.path);
      }
    } catch (_) {
      // swallow — we'll just use base args/haversine on the estimate page
    }

    return args;
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        color: ColorConstant.color1.withOpacity(.15),
        child: Center(
          child: SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width * .02),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: width * .1),

                      // How to use
                      Stack(
                        children: [
                          SizedBox(
                            // decoration:
                            //     BoxDecoration(border: Border.all()),
                            width: width * 1,
                            // height: height * .35,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: width * .5,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.circular(width * .025),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: width * .02,
                                        offset:
                                            Offset(width * .01, width * .0125),
                                      )
                                    ],
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(width * .01),
                                    child: Text(
                                      "Please use current location or Request location for accurate location",
                                      style: TextStyle(fontSize: width * .025),
                                    ),
                                  ),
                                ),
                                SizedBox(height: width * .2),
                                Container(
                                  width: width * .75,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.circular(width * .025),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: width * .02,
                                        offset:
                                            Offset(width * .01, width * .0125),
                                      )
                                    ],
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(width * .02),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "How to use ?",
                                          style: TextStyle(
                                            fontSize: width * .03,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          "Tap the "
                                          '"Request Location"'
                                          " button and you will get a link\n"
                                          "Share the link and Ask the other person to get in the link and Tap "
                                          '"Share Location"',
                                          style: TextStyle(
                                            fontSize: width * .0275,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: height * .04,
                                right: width * .1,
                              ),
                              child: Image.asset(
                                ImageConstant.deliveryman2,
                                height: width * .25,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: width * .1),

                      // Live Firestore -> updates input fields (pickup/drop)
                      StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                        stream: (tripId == null)
                            ? const Stream.empty()
                            : FirebaseFirestore.instance
                                .collection("D2D_Orders")
                                .doc(tripId)
                                .snapshots(),
                        builder: (context, snap) {
                          if (snap.connectionState == ConnectionState.waiting) {
                            return Padding(
                              padding: EdgeInsets.only(top: width * .06),
                              child: const CircularProgressIndicator(),
                            );
                          }

                          // No legacy reads here

                          return SizedBox(
                            width: width * 1,
                            child: ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: totalTiles,
                              // separator index k is the gap *between* item k and k+1
                              separatorBuilder: (context, sepIndex) {
                                if (!hasPickup) return const SizedBox.shrink();

                                final insertStopAt =
                                    sepIndex; // add stop right after item sepIndex
                                return Row(
                                  children: [
                                    // Left rail stub
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: width * 0.02),
                                      child: DottedBorder(
                                        color: Colors.black54,
                                        strokeWidth: width * .0025,
                                        dashPattern: const [4, 3],
                                        strokeCap: StrokeCap.round,
                                        padding: EdgeInsets.zero,
                                        customPath: (size) => Path()
                                          ..moveTo(0, 0)
                                          ..lineTo(0, size.height),
                                        child: SizedBox(height: height * .0375),
                                      ),
                                    ),
                                    SizedBox(width: width * .1),

                                    // Add Stop button
                                    GestureDetector(
                                      onTap: () async {
                                        final pickupFilled = fromController.text
                                            .trim()
                                            .isNotEmpty;
                                        final stopsFilled = _stops.every(
                                            (c) => c.text.trim().isNotEmpty);

                                        if (!(pickupFilled && stopsFilled)) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  "Please fill existing locations first."),
                                            ),
                                          );
                                          return;
                                        }

                                        // ask for type
                                        final type =
                                            await _askStopType(context);
                                        if (type == null) return;

                                        setState(() {
                                          _stops.insert(insertStopAt,
                                              TextEditingController());
                                          _stopTypes.insert(insertStopAt, type);
                                          _stopName.insert(insertStopAt,
                                              TextEditingController());
                                          _stopPhone.insert(insertStopAt,
                                              TextEditingController());
                                          _stopNote.insert(insertStopAt,
                                              TextEditingController());
                                          _stopLatLng.insert(
                                              insertStopAt, null);
                                        });
                                      },
                                      child: Container(
                                        height: height * .03,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: width * .02),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                              width * .0125),
                                          border:
                                              Border.all(color: Colors.black45),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.add,
                                                size: width * .05,
                                                color: Colors.black38),
                                            Text(
                                              "Add Stop",
                                              style: TextStyle(
                                                color: Colors.black38,
                                                fontSize: width * .035,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                              itemBuilder: (context, index) {
                                // 0 -> Pickup
                                // 1.._stops.length -> via stops
                                // last -> Destination (only when hasPickup)

                                // ───────── PICKUP ─────────
                                if (index == 0) {
                                  return Container(
                                    // decoration: BoxDecoration(
                                    //     border: Border.all()),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // left rail + green dot
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: width * 0.02),
                                              // child: DottedBorder(
                                              //   color: Colors.black54,
                                              //   strokeWidth:
                                              //       width * .0025,
                                              //   dashPattern: const [
                                              //     4,
                                              //     3
                                              //   ],
                                              //   strokeCap:
                                              //       StrokeCap.round,
                                              //   padding:
                                              //       EdgeInsets.zero,
                                              //   customPath: (size) =>
                                              //       Path()
                                              //         ..moveTo(0, 0)
                                              //         ..lineTo(0,
                                              //             size.height),
                                              //   child: SizedBox(
                                              //       height:
                                              //           height * .04),
                                              // ),
                                              child: SizedBox(
                                                  height: height * .04),
                                            ),
                                            Container(
                                              width: width * 0.04,
                                              height: width * 0.04,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  width: width * .005,
                                                  color: Colors.black
                                                      .withOpacity(.25),
                                                ),
                                                color: Colors.green,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Center(
                                                child: Container(
                                                  width: width * 0.02,
                                                  height: width * 0.02,
                                                  decoration: BoxDecoration(
                                                    color: Colors.black
                                                        .withOpacity(0.5),
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: width * 0.02),
                                              child: DottedBorder(
                                                color: Colors.black54,
                                                strokeWidth: width * .0025,
                                                dashPattern: const [4, 3],
                                                strokeCap: StrokeCap.round,
                                                padding: EdgeInsets.zero,
                                                customPath: (size) => Path()
                                                  ..moveTo(0, 0)
                                                  ..lineTo(0, size.height),
                                                child: SizedBox(
                                                    height: height * .0375),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(width: width * .02),

                                        // right: label + field
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Enter PickUp Details",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: width * .035,
                                                ),
                                              ),
                                              GestureDetector(
                                                // onTap: () async {
                                                //   await Navigator.push(
                                                //     context,
                                                //     CupertinoPageRoute(
                                                //       builder: (_) =>
                                                //           D2dPlaceSearchPage(
                                                //         controller:
                                                //             fromController,
                                                //         accentColor:
                                                //             Colors.green,
                                                //         label: "Pickup",
                                                //       ),
                                                //     ),
                                                //   );
                                                //   setState(
                                                //       () {}); // reveals separator + destination
                                                // },
                                                // onTap: () async {
                                                //   final res =
                                                //       await Navigator.push(
                                                //     context,
                                                //     CupertinoPageRoute(
                                                //       builder: (_) =>
                                                //           D2dPlaceSearchPage(
                                                //         controller:
                                                //             fromController,
                                                //         accentColor:
                                                //             Colors.green,
                                                //         label: "Pickup",
                                                //       ),
                                                //     ),
                                                //   );

                                                //   if (!mounted || res is! Map)
                                                //     return;
                                                //   final m = res as Map;

                                                //   final LatLng? ll =
                                                //       m['latLng'] as LatLng?;
                                                //   final String? address =
                                                //       m['address'] as String?;
                                                //   final String? name =
                                                //       m['senderName']
                                                //           as String?;
                                                //   final String? phone =
                                                //       m['senderPhone']
                                                //           as String?;
                                                //   final String? house =
                                                //       (m['house'] as String?)
                                                //           ?.trim();
                                                //   final String? instr =
                                                //       (m['instruction']
                                                //               as String?)
                                                //           ?.trim();

                                                //   setState(() {
                                                //     if (address != null &&
                                                //         address.isNotEmpty) {
                                                //       fromController.text =
                                                //           address;
                                                //     }
                                                //     if (ll != null)
                                                //       pickupLatLng = ll;

                                                //     // fill the extra fields so _buildRoutePayload() can save them
                                                //     pickupNameCtrl.text =
                                                //         (name ?? '').trim();
                                                //     pickupPhoneCtrl.text =
                                                //         (phone ?? '').trim();
                                                //     pickupNoteCtrl.text = [
                                                //       if (house != null &&
                                                //           house.isNotEmpty)
                                                //         house,
                                                //       if (instr != null &&
                                                //           instr.isNotEmpty)
                                                //         instr,
                                                //     ].join(' • ');
                                                //   });
                                                // },
                                                onTap: () async {
                                                  final res =
                                                      await Navigator.push(
                                                    context,
                                                    CupertinoPageRoute(
                                                      builder: (_) =>
                                                          D2dPlaceSearchPage(
                                                        controller:
                                                            fromController,
                                                        accentColor:
                                                            Colors.green,
                                                        label: "Pickup",
                                                        // mainDb:
                                                        //     FirebaseFirestore
                                                        //         .instance,
                                                        // gServiceDb:
                                                        //     FirebaseFirestore
                                                        //         .instance,
                                                        // gServiceDb, // 🔥 your secondary Firebase Firestore
                                                      ),
                                                    ),
                                                  );

                                                  if (!mounted || res is! Map)
                                                    return;
                                                  final m = res as Map;

                                                  final LatLng? ll =
                                                      m['latLng'] as LatLng?;
                                                  final String? address =
                                                      m['address'] as String?;
                                                  final String? name =
                                                      m['senderName']
                                                          as String?;
                                                  final String? phone =
                                                      m['senderPhone']
                                                          as String?;
                                                  final String? house =
                                                      (m['house'] as String?)
                                                          ?.trim();
                                                  final String? instr =
                                                      (m['instruction']
                                                              as String?)
                                                          ?.trim();

                                                  setState(() {
                                                    if (address != null &&
                                                        address.isNotEmpty) {
                                                      fromController.text =
                                                          address;
                                                    }
                                                    if (ll != null)
                                                      pickupLatLng = ll;

                                                    // fill the extra fields so _buildRoutePayload() can save them
                                                    pickupNameCtrl.text =
                                                        (name ?? '').trim();
                                                    pickupPhoneCtrl.text =
                                                        (phone ?? '').trim();
                                                    pickupNoteCtrl.text = [
                                                      if (house != null &&
                                                          house.isNotEmpty)
                                                        house,
                                                      if (instr != null &&
                                                          instr.isNotEmpty)
                                                        instr,
                                                    ].join(' • ');
                                                  });
                                                },

                                                child: Container(
                                                  height: width * .125,
                                                  padding: EdgeInsets.only(
                                                      left: width * 0.03),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            width * 0.03),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          fromController
                                                                  .text.isEmpty
                                                              ? "Enter PickUp location"
                                                              : fromController
                                                                  .text,
                                                          style: TextStyle(
                                                            color: fromController
                                                                    .text
                                                                    .isEmpty
                                                                ? Colors.black
                                                                    .withOpacity(
                                                                        .5)
                                                                : Colors.black,
                                                            fontSize:
                                                                width * 0.035,
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets.all(
                                                            width * .01),
                                                        child: GestureDetector(
                                                          onTap: () =>
                                                              openRequestLocationSheet(
                                                            context,
                                                            "pickup",
                                                          ),
                                                          child: Container(
                                                            height:
                                                                double.infinity,
                                                            width: width * .225,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: ColorConstant
                                                                  .greenColor
                                                                  .withOpacity(
                                                                      .9),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          width *
                                                                              0.02),
                                                            ),
                                                            child: Center(
                                                              child: Text(
                                                                "Request\nLocation",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      width *
                                                                          .03,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                      .white,
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
                                              Text(
                                                fromController.text,
                                                style: TextStyle(
                                                  fontSize: width * .025,
                                                  color: Colors.black
                                                      .withOpacity(.5),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }

                                // If we're here and there is no pickup, nothing else to render.
                                if (!hasPickup) return const SizedBox.shrink();

                                // ───────── VIA STOP(S) ─────────
                                final bool isStopTile = index <= _stops.length;
                                if (isStopTile) {
                                  final stopIdx =
                                      index - 1; // 0-based in _stops
                                  final TextEditingController stopCtrl =
                                      _stops[stopIdx];

                                  // color based on type chosen at creation
                                  final bool isPick =
                                      _stopTypes[stopIdx] == "pick";
                                  final Color dotColor = isPick
                                      ? Colors.green
                                      : (Colors.redAccent[200] ??
                                          Colors.redAccent);

                                  return Container(
                                    decoration: const BoxDecoration(),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            // left rail + type-colored dot
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: width * 0.02),
                                                  child: DottedBorder(
                                                    color: Colors.black54,
                                                    strokeWidth: width * .0025,
                                                    dashPattern: const [4, 3],
                                                    strokeCap: StrokeCap.round,
                                                    padding: EdgeInsets.zero,
                                                    customPath: (size) => Path()
                                                      ..moveTo(0, 0)
                                                      ..lineTo(0, size.height),
                                                    child: SizedBox(
                                                        height: height * .02),
                                                  ),
                                                ),
                                                Container(
                                                  width: width * 0.04,
                                                  height: width * 0.04,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      width: width * .005,
                                                      color: Colors.black
                                                          .withOpacity(.25),
                                                    ),
                                                    color: dotColor,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Center(
                                                    child: Container(
                                                      width: width * 0.02,
                                                      height: width * 0.02,
                                                      decoration: BoxDecoration(
                                                        color: Colors.black
                                                            .withOpacity(0.5),
                                                        shape: BoxShape.circle,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: width * 0.02),
                                                  child: DottedBorder(
                                                    color: Colors.black54,
                                                    strokeWidth: width * .0025,
                                                    dashPattern: const [4, 3],
                                                    strokeCap: StrokeCap.round,
                                                    padding: EdgeInsets.zero,
                                                    customPath: (size) => Path()
                                                      ..moveTo(0, 0)
                                                      ..lineTo(0, size.height),
                                                    child: SizedBox(
                                                        height: height * .02),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: width * .02),

                                            // stop field (white container)
                                            Expanded(
                                              child: GestureDetector(
                                                // onTap: () async {
                                                //   await Navigator.push(
                                                //     context,
                                                //     CupertinoPageRoute(
                                                //       builder: (_) =>
                                                //           D2dPlaceSearchPage(
                                                //         controller: stopCtrl,
                                                //         accentColor: isPick
                                                //             ? Colors.green
                                                //             : Colors.redAccent,
                                                //         label: isPick
                                                //             ? "Stop (Pickup)"
                                                //             : "Stop (Drop)",
                                                //       ),
                                                //     ),
                                                //   );
                                                //   setState(() {});
                                                // },
                                                // ------------------------------------------
                                                // onTap: () async {
                                                //   final res =
                                                //       await Navigator.push(
                                                //     context,
                                                //     CupertinoPageRoute(
                                                //       builder: (_) =>
                                                //           D2dPlaceSearchPage(
                                                //         controller: stopCtrl,
                                                //         accentColor: isPick
                                                //             ? Colors.green
                                                //             : Colors.redAccent,
                                                //         label: isPick
                                                //             ? "Stop (Pickup)"
                                                //             : "Stop (Drop)",
                                                //       ),
                                                //     ),
                                                //   );

                                                //   if (!mounted || res is! Map)
                                                //     return;
                                                //   final m = res
                                                //       as Map<String, dynamic>;

                                                //   final LatLng? ll =
                                                //       m['latLng'] as LatLng?;
                                                //   final String? addr =
                                                //       m['address'] as String?;
                                                //   final String? name =
                                                //       m['senderName']
                                                //           as String?;
                                                //   final String? phone =
                                                //       m['senderPhone']
                                                //           as String?;
                                                //   final String? house =
                                                //       (m['house'] as String?)
                                                //           ?.trim();
                                                //   final String? instr =
                                                //       (m['instruction']
                                                //               as String?)
                                                //           ?.trim();

                                                //   setState(() {
                                                //     if (addr != null &&
                                                //         addr.isNotEmpty)
                                                //       stopCtrl.text = addr;
                                                //     if (ll != null)
                                                //       _stopLatLng[stopIdx] = ll;

                                                //     _stopName[stopIdx].text =
                                                //         (name ?? '').trim();
                                                //     _stopPhone[stopIdx].text =
                                                //         (phone ?? '').trim();
                                                //     _stopNote[stopIdx].text = [
                                                //       if (house != null &&
                                                //           house.isNotEmpty)
                                                //         house,
                                                //       if (instr != null &&
                                                //           instr.isNotEmpty)
                                                //         instr,
                                                //     ].join(' • ');
                                                //   });
                                                // },
                                                onTap: () async {
                                                  final res =
                                                      await Navigator.push(
                                                    context,
                                                    CupertinoPageRoute(
                                                      builder: (_) =>
                                                          D2dPlaceSearchPage(
                                                        controller: stopCtrl,
                                                        accentColor: isPick
                                                            ? Colors.green
                                                            : Colors.redAccent,
                                                        label: isPick
                                                            ? "Stop (Pickup)"
                                                            : "Stop (Drop)",
                                                        // mainDb:
                                                        //     FirebaseFirestore
                                                        //         .instance,
                                                        // gServiceDb:
                                                        //     FirebaseFirestore
                                                        //         .instance,
                                                        // gServiceDb, // 🔥 pass SECONDARY Firestore here
                                                      ),
                                                    ),
                                                  );

                                                  if (!mounted ||
                                                      res is! Map<String,
                                                          dynamic>) return;
                                                  final m = res
                                                      as Map<String, dynamic>;

                                                  final LatLng? ll =
                                                      m['latLng'] as LatLng?;
                                                  final String? addr =
                                                      m['address'] as String?;
                                                  final String? name =
                                                      m['senderName']
                                                          as String?;
                                                  final String? phone =
                                                      m['senderPhone']
                                                          as String?;
                                                  final String? house =
                                                      (m['house'] as String?)
                                                          ?.trim();
                                                  final String? instr =
                                                      (m['instruction']
                                                              as String?)
                                                          ?.trim();

                                                  setState(() {
                                                    if (addr != null &&
                                                        addr.isNotEmpty)
                                                      stopCtrl.text = addr;
                                                    if (ll != null)
                                                      _stopLatLng[stopIdx] = ll;

                                                    _stopName[stopIdx].text =
                                                        (name ?? '').trim();
                                                    _stopPhone[stopIdx].text =
                                                        (phone ?? '').trim();
                                                    _stopNote[stopIdx].text = [
                                                      if (house != null &&
                                                          house.isNotEmpty)
                                                        house,
                                                      if (instr != null &&
                                                          instr.isNotEmpty)
                                                        instr,
                                                    ].join(' • ');
                                                  });
                                                },
                                                child: Container(
                                                  height: width * .125,
                                                  padding: EdgeInsets.only(
                                                      left: width * 0.03,
                                                      right: width * .01),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            width * 0.03),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          stopCtrl.text.isEmpty
                                                              ? (isPick
                                                                  ? "Enter Pickup Stop ${stopIdx + 1}"
                                                                  : "Enter Drop Stop ${stopIdx + 1}")
                                                              : stopCtrl.text,
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                            color: stopCtrl.text
                                                                    .isEmpty
                                                                ? Colors.black
                                                                    .withOpacity(
                                                                        .5)
                                                                : Colors.black,
                                                            fontSize:
                                                                width * 0.035,
                                                          ),
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () =>
                                                            openRequestLocationSheet(
                                                          context,
                                                          "via",
                                                          viaIndex: stopIdx,
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  width * .01),
                                                          child: Container(
                                                            height:
                                                                double.infinity,
                                                            width: width * .2,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: ColorConstant
                                                                  .greenColor
                                                                  .withOpacity(
                                                                      .9),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          width *
                                                                              0.02),
                                                            ),
                                                            child: Center(
                                                              child: Text(
                                                                "Request\nLocation",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      width *
                                                                          .03,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: Colors
                                                                      .white,
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

                                            // delete button
                                            if (_stops.isNotEmpty)
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: width * .02),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      _stops
                                                          .removeAt(stopIdx)
                                                          .dispose();
                                                      _stopTypes
                                                          .removeAt(stopIdx);
                                                      _stopName
                                                          .removeAt(stopIdx)
                                                          .dispose();
                                                      _stopPhone
                                                          .removeAt(stopIdx)
                                                          .dispose();
                                                      _stopNote
                                                          .removeAt(stopIdx)
                                                          .dispose();
                                                      _stopLatLng
                                                          .removeAt(stopIdx);
                                                    });
                                                  },
                                                  child: Container(
                                                    height: width * .125,
                                                    width: width * .1125,
                                                    decoration: BoxDecoration(
                                                      color: Colors.redAccent
                                                          .withOpacity(.12),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              width * .02),
                                                      border: Border.all(
                                                        color: Colors.redAccent
                                                            .withOpacity(.4),
                                                        width: width * .002,
                                                      ),
                                                    ),
                                                    child: Icon(
                                                      Icons.delete_outline,
                                                      size: width * .06,
                                                      color: Colors.redAccent,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                        // SizedBox(height: width * .02),
                                        // (Removed the Pick/Drop ChoiceChips per your request)
                                      ],
                                    ),
                                  );
                                }

                                // ───────── DESTINATION ─────────
                                return Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // left rail + red dot
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: width * 0.02),
                                            child: DottedBorder(
                                              color: Colors.black54,
                                              strokeWidth: width * .0025,
                                              dashPattern: const [4, 3],
                                              strokeCap: StrokeCap.round,
                                              padding: EdgeInsets.zero,
                                              customPath: (size) => Path()
                                                ..moveTo(0, 0)
                                                ..lineTo(0, size.height),
                                              child: SizedBox(
                                                  height: height * .04),
                                            ),
                                          ),
                                          Container(
                                            width: width * 0.04,
                                            height: width * 0.04,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                width: width * .005,
                                                color: Colors.black
                                                    .withOpacity(.25),
                                              ),
                                              color: Colors.redAccent[200],
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                              child: Container(
                                                width: width * 0.02,
                                                height: width * 0.02,
                                                decoration: BoxDecoration(
                                                  color: Colors.black
                                                      .withOpacity(0.5),
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: width * 0.02),
                                            // child: DottedBorder(
                                            //   color: Colors.black54,
                                            //   strokeWidth:
                                            //       width * .0025,
                                            //   dashPattern: const [4, 3],
                                            //   strokeCap:
                                            //       StrokeCap.round,
                                            //   padding: EdgeInsets.zero,
                                            //   customPath: (size) =>
                                            //       Path()
                                            //         ..moveTo(0, 0)
                                            //         ..lineTo(
                                            //             0, size.height),
                                            //   child: SizedBox(
                                            //       height:
                                            //           height * .0375),
                                            // ),
                                            child: SizedBox(
                                                height: height * .0375),
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: width * .02),

                                      // right: header + field
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(children: [
                                              Text(
                                                "Enter Destination Details",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: width * .035,
                                                ),
                                              ),
                                            ]),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: GestureDetector(
                                                    // onTap: () async {
                                                    //   await Navigator.push(
                                                    //     context,
                                                    //     CupertinoPageRoute(
                                                    //       builder: (_) =>
                                                    //           D2dPlaceSearchPage(
                                                    //         controller:
                                                    //             toController,
                                                    //         accentColor: Colors
                                                    //             .redAccent,
                                                    //         label: "Drop",
                                                    //       ),
                                                    //     ),
                                                    //   );
                                                    //   setState(() {});
                                                    // },
                                                    // onTap: () async {
                                                    //   final res =
                                                    //       await Navigator.push(
                                                    //     context,
                                                    //     CupertinoPageRoute(
                                                    //       builder: (_) =>
                                                    //           D2dPlaceSearchPage(
                                                    //         controller:
                                                    //             toController,
                                                    //         accentColor: Colors
                                                    //             .redAccent,
                                                    //         label: "Drop",
                                                    //       ),
                                                    //     ),
                                                    //   );

                                                    //   if (!mounted ||
                                                    //       res is! Map) return;
                                                    //   final m = res as Map<
                                                    //       String, dynamic>;

                                                    //   final LatLng? ll =
                                                    //       m['latLng']
                                                    //           as LatLng?;
                                                    //   final String? addr =
                                                    //       m['address']
                                                    //           as String?;
                                                    //   final String? name =
                                                    //       m['senderName']
                                                    //           as String?;
                                                    //   final String? phone =
                                                    //       m['senderPhone']
                                                    //           as String?;
                                                    //   final String? house =
                                                    //       (m['house']
                                                    //               as String?)
                                                    //           ?.trim();
                                                    //   final String? instr =
                                                    //       (m['instruction']
                                                    //               as String?)
                                                    //           ?.trim();

                                                    //   setState(() {
                                                    //     if (addr != null &&
                                                    //         addr.isNotEmpty)
                                                    //       toController.text =
                                                    //           addr;
                                                    //     if (ll != null)
                                                    //       dropLatLng = ll;

                                                    //     // fill extras so _buildRoutePayload() persists them
                                                    //     dropNameCtrl.text =
                                                    //         (name ?? '').trim();
                                                    //     dropPhoneCtrl.text =
                                                    //         (phone ?? '')
                                                    //             .trim();
                                                    //     dropNoteCtrl.text = [
                                                    //       if (house != null &&
                                                    //           house.isNotEmpty)
                                                    //         house,
                                                    //       if (instr != null &&
                                                    //           instr.isNotEmpty)
                                                    //         instr,
                                                    //     ].join(' • ');
                                                    //   });
                                                    // },
                                                    onTap: () async {
                                                      final res =
                                                          await Navigator.push(
                                                        context,
                                                        CupertinoPageRoute(
                                                          builder: (_) =>
                                                              D2dPlaceSearchPage(
                                                            controller:
                                                                toController,
                                                            accentColor: Colors
                                                                .redAccent,
                                                            label: "Drop",
                                                            // mainDb:
                                                            //     FirebaseFirestore
                                                            //         .instance,
                                                            // gServiceDb:
                                                            //     FirebaseFirestore
                                                            //         .instance,
                                                            // gServiceDb, // 🔥 pass SECONDARY Firestore here
                                                          ),
                                                        ),
                                                      );

                                                      if (!mounted ||
                                                          res is! Map<String,
                                                              dynamic>) return;
                                                      final m = res as Map<
                                                          String, dynamic>;

                                                      final LatLng? ll =
                                                          m['latLng']
                                                              as LatLng?;
                                                      final String? addr =
                                                          m['address']
                                                              as String?;
                                                      final String? name =
                                                          m['senderName']
                                                              as String?;
                                                      final String? phone =
                                                          m['senderPhone']
                                                              as String?;
                                                      final String? house =
                                                          (m['house']
                                                                  as String?)
                                                              ?.trim();
                                                      final String? instr =
                                                          (m['instruction']
                                                                  as String?)
                                                              ?.trim();

                                                      setState(() {
                                                        if (addr != null &&
                                                            addr.isNotEmpty)
                                                          toController.text =
                                                              addr;
                                                        if (ll != null)
                                                          dropLatLng = ll;

                                                        // fill extras so _buildRoutePayload() persists them
                                                        dropNameCtrl.text =
                                                            (name ?? '').trim();
                                                        dropPhoneCtrl.text =
                                                            (phone ?? '')
                                                                .trim();
                                                        dropNoteCtrl.text = [
                                                          if (house != null &&
                                                              house.isNotEmpty)
                                                            house,
                                                          if (instr != null &&
                                                              instr.isNotEmpty)
                                                            instr,
                                                        ].join(' • ');
                                                      });
                                                    },
                                                    child: Container(
                                                      height: width * .125,
                                                      padding: EdgeInsets.only(
                                                          left: width * 0.03),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    width *
                                                                        0.03),
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              toController.text
                                                                      .isEmpty
                                                                  ? "Enter Destination location"
                                                                  : toController
                                                                      .text,
                                                              style: TextStyle(
                                                                color: toController
                                                                        .text
                                                                        .isEmpty
                                                                    ? Colors
                                                                        .black
                                                                        .withOpacity(
                                                                            .5)
                                                                    : Colors
                                                                        .black,
                                                                fontSize:
                                                                    width *
                                                                        0.035,
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    width *
                                                                        .01),
                                                            child:
                                                                GestureDetector(
                                                              onTap: () =>
                                                                  openRequestLocationSheet(
                                                                      context,
                                                                      "drop"),
                                                              child: Container(
                                                                height: double
                                                                    .infinity,
                                                                width: width *
                                                                    .225,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: ColorConstant
                                                                      .greenColor
                                                                      .withOpacity(
                                                                          .9),
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          width *
                                                                              0.02),
                                                                ),
                                                                child: Center(
                                                                  child: Text(
                                                                    "Request\nLocation",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          width *
                                                                              .03,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color: Colors
                                                                          .white,
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
                                            // SizedBox(
                                            //     height: width * .015),
                                            Text(
                                              toController.text,
                                              style: TextStyle(
                                                fontSize: width * .025,
                                                color: Colors.black
                                                    .withOpacity(.5),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),

                      SizedBox(height: width * .1),

                      // NEXT BUTTON
                      // GestureDetector(
                      //   onTap: _onNext,
                      //   child: Container(
                      //     width: width * .4,
                      //     padding: EdgeInsets.symmetric(
                      //       vertical: width * .025,
                      //     ),
                      //     decoration: BoxDecoration(
                      //       color: Colors.blue,
                      //       borderRadius: BorderRadius.circular(width * .025),
                      //       boxShadow: [
                      //         BoxShadow(
                      //           color: Colors.black26,
                      //           blurRadius: width * .02,
                      //           offset: Offset(width * .01, width * .0125),
                      //         ),
                      //       ],
                      //     ),
                      //     child: Center(
                      //       child: Text(
                      //         "Next",
                      //         style: TextStyle(
                      //           color: Colors.white,
                      //           fontSize: width * .04,
                      //           fontWeight: FontWeight.bold,
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),

                      GestureDetector(
                        onTap: _isSaving ? null : _onNext,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          width: width * .4,
                          padding: EdgeInsets.symmetric(vertical: width * .025),
                          decoration: BoxDecoration(
                            color: _isSaving
                                ? Colors.blue.withOpacity(.7)
                                : Colors.blue,
                            borderRadius: BorderRadius.circular(width * .025),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: width * .02,
                                offset: Offset(width * .01, width * .0125),
                              ),
                            ],
                          ),
                          child: Center(
                            child: _isSaving
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  )
                                : Text(
                                    "Next",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: width * .04,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ),

                      SizedBox(height: width * .5),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
