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

// const String googleApiKey = "AIzaSyD1fU_UDudvvy1HEPEoJ4Ify_YOYDlhdEY";

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

//   final String googleApiKey = "AIzaSyD1fU_UDudvvy1HEPEoJ4Ify_YOYDlhdEY";

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
//       GoogleMapsPlaces(apiKey: "AIzaSyD1fU_UDudvvy1HEPEoJ4Ify_YOYDlhdEY");
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
//     "AIzaSyD1fU_UDudvvy1HEPEoJ4Ify_YOYDlhdEY"; // one source of truth

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

import 'package:dotted_border/dotted_border.dart';
import 'package:drivex/core/constants/color_constant.dart';
import 'package:drivex/core/constants/imageConstants.dart';
import 'package:drivex/feature/bottomNavigation/pages/D2D/D2D_placeSearchPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class D2DPage01 extends StatefulWidget {
  const D2DPage01({super.key});

  @override
  State<D2DPage01> createState() => _D2DPage01State();
}

class _D2DPage01State extends State<D2DPage01> {
  // Pickup controller
  final TextEditingController fromController = TextEditingController();

  // Dynamic destination controllers (start with one)
  final List<TextEditingController> _destControllers = [
    TextEditingController(),
  ];

  // UI helper
  void _showSnackBar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  // Insert a new destination controller (optionally after an index)
  void _addDestination({int? afterIndex}) {
    setState(() {
      final c = TextEditingController();
      if (afterIndex == null ||
          afterIndex < 0 ||
          afterIndex >= _destControllers.length) {
        _destControllers.add(c);
      } else {
        _destControllers.insert(afterIndex + 1, c);
      }
    });
  }

  // Optional: remove a destination
  void _removeDestination(int index) {
    if (_destControllers.length == 1) {
      _showSnackBar(context, "At least one destination is required.");
      return;
    }
    setState(() {
      _destControllers.removeAt(index).dispose();
    });
  }

  // Placeholder for your share-link sheet
  void openRequestLocationSheet(BuildContext context, String slot) {
    _showSnackBar(context, "Share link for $slot (stub).");
  }

  // Next page validation
  void _nextPage() {
    final pickup = fromController.text.trim();
    final dests = _destControllers.map((c) => c.text.trim()).toList();

    if (pickup.isEmpty) {
      _showSnackBar(context, "Please enter Pick-Up location.");
      return;
    }
    if (dests.any((d) => d.isEmpty)) {
      _showSnackBar(context, "Please fill all Destination locations.");
      return;
    }

    _showSnackBar(context, "Proceeding with ${dests.length} destination(s).");
    // TODO: Navigate with your data
  }

  @override
  void dispose() {
    fromController.dispose();
    for (final c in _destControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        color: ColorConstant.color1.withOpacity(.15),
        child: SizedBox(
          height: height,
          child: SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width * .02),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: width * .1),
                      SizedBox(height: width * .3),
                      SizedBox(
                        width: width * .75,
                        height: width * .5,
                        child: Center(
                          child: Stack(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Center(
                                    child: Container(
                                      width: width * .5,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(width * .025),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: width * .02,
                                            offset: Offset(
                                                width * .01, width * .0125),
                                          )
                                        ],
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(width * .01),
                                        child: Text(
                                          "Please use current location or Request location for accurate location",
                                          style:
                                              TextStyle(fontSize: width * .025),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: height * .1,
                                  ),
                                  // How to use
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
                                          offset: Offset(
                                              width * .01, width * .0125),
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
                                            'Tap the field to search and select locations. Use "Add Destination" to insert more stops.',
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
                              Align(
                                alignment: Alignment.topRight,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    top: height * .05,
                                    right: width * .025,
                                  ),
                                  child: Image.asset(
                                    ImageConstant.deliveryman2,
                                    height: width * .25,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),

                      // ───────── PICKUP ─────────
                      SizedBox(height: width * .1),
                      Row(
                        children: [
                          Text(
                            "Enter PickUp Details",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: width * .035,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: width * .02),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // dot
                          Padding(
                            padding: EdgeInsets.only(right: width * .025),
                            child: Container(
                              width: width * 0.04,
                              height: width * 0.04,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: width * .005,
                                  color: Colors.black.withOpacity(.25),
                                ),
                                color: Colors.green,
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
                          // SizedBox(width: ,),

                          // field (navigate to place search page)
                          GestureDetector(
                            onTap: () async {
                              await Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (_) => D2dPlaceSearchPage(
                                    controller: fromController,
                                    accentColor: Colors.green,
                                    label: "Pickup",
                                  ),
                                ),
                              );
                              setState(() {});
                            },
                            child: Container(
                              height: width * .125,
                              width: width * .75,
                              padding: EdgeInsets.only(left: width * 0.03),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(width * 0.03),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      fromController.text.isEmpty
                                          ? "Enter PickUp location"
                                          : fromController.text,
                                      style: TextStyle(
                                        color: fromController.text.isEmpty
                                            ? Colors.black.withOpacity(.5)
                                            : Colors.black,
                                        fontSize: width * 0.035,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(width * .01),
                                    child: GestureDetector(
                                      onTap: () {
                                        openRequestLocationSheet(
                                          context,
                                          "pickup",
                                        );
                                      },
                                      child: Container(
                                        height: double.infinity,
                                        width: width * .225,
                                        decoration: BoxDecoration(
                                          color: ColorConstant.greenColor
                                              .withOpacity(.9),
                                          borderRadius: BorderRadius.circular(
                                            width * 0.02,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Request\nLocation",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: width * .03,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white,
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
                        ],
                      ),

                      // ───────── DESTINATIONS (ListView.builder) ─────────
                      if (fromController.text.trim().isNotEmpty) ...[
                        SizedBox(height: width * .05),
                        Row(
                          children: [
                            Text(
                              "Enter Destination Details",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: width * .035,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: width * .02),

                        // Builder with shrinkWrap
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _destControllers.length,
                          itemBuilder: (context, index) {
                            final toController = _destControllers[index];

                            return Padding(
                              padding: EdgeInsets.only(),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Left dots + dotted "L"
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // SizedBox(height: height * .02),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: width * 0.025),
                                        child: DottedBorder(
                                          color: Colors.black54,
                                          strokeWidth: width * .0025,
                                          dashPattern: const [4, 4],
                                          strokeCap: StrokeCap.round,
                                          padding: EdgeInsets.zero,
                                          customPath: (size) {
                                            // LEFT edge only
                                            final p = Path()
                                              ..moveTo(0, 0)
                                              ..lineTo(0, size.height);
                                            return p;
                                          },
                                          child: SizedBox(
                                            width: width * .05,
                                            height: height * .02,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: width * 0.005),
                                        child: Container(
                                          width: width * 0.04,
                                          height: width * 0.04,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              width: width * .005,
                                              color:
                                                  Colors.black.withOpacity(.25),
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
                                      ),
                                      if (index ==
                                          _destControllers.length - 1) ...[
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: width * 0.025),
                                          child: DottedBorder(
                                            color: Colors.black54,
                                            strokeWidth: width * .0025,
                                            dashPattern: const [4, 3],
                                            strokeCap: StrokeCap.round,
                                            padding: EdgeInsets.zero,
                                            customPath: (size) {
                                              final p = Path()
                                                ..moveTo(0, 0) // left
                                                ..lineTo(0, size.height)
                                                ..moveTo(
                                                    0, size.height) // bottom
                                                ..lineTo(
                                                    size.width, size.height);
                                              return p;
                                            },
                                            child: SizedBox(
                                              width: width * .05,
                                              height: height * .0525,
                                              // height: height * .025,
                                            ),
                                          ),
                                        )
                                      ] else
                                        Padding(
                                          padding: EdgeInsets.only(
                                              left: width * 0.025),
                                          child: DottedBorder(
                                            color: Colors.black54,
                                            strokeWidth: width * .0025,
                                            dashPattern: const [4, 3],
                                            strokeCap: StrokeCap.round,
                                            padding: EdgeInsets.zero,
                                            customPath: (size) {
                                              // LEFT edge only — no bottom
                                              return Path()
                                                ..moveTo(0, 0)
                                                ..lineTo(0, size.height);
                                            },
                                            child: SizedBox(
                                              width: width * .05,
                                              height: height *
                                                  .04, // or height * .025 if you prefer
                                            ),
                                          ),
                                        )
                                    ],
                                  ),

                                  // Field + Add button
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Destination field
                                      GestureDetector(
                                        onTap: () async {
                                          await Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                              builder: (_) =>
                                                  D2dPlaceSearchPage(
                                                controller: toController,
                                                accentColor: Colors.redAccent,
                                                label:
                                                    "Destination ${index + 1}",
                                              ),
                                            ),
                                          );
                                          setState(() {});
                                        },
                                        child: Container(
                                          width: width * .75,
                                          height: width * .125,
                                          padding: EdgeInsets.only(
                                              left: width * 0.03),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                                width * 0.03),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  toController.text.isEmpty
                                                      ? "Enter Destination location"
                                                      : toController.text,
                                                  style: TextStyle(
                                                    color: toController
                                                            .text.isEmpty
                                                        ? Colors.black
                                                            .withOpacity(.5)
                                                        : Colors.black,
                                                    fontSize: width * 0.035,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.all(width * .01),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    openRequestLocationSheet(
                                                      context,
                                                      "drop",
                                                    );
                                                  },
                                                  child: Container(
                                                    height: double.infinity,
                                                    width: width * .225,
                                                    decoration: BoxDecoration(
                                                      color: ColorConstant
                                                          .greenColor
                                                          .withOpacity(.9),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        width * 0.02,
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        "Request\nLocation",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: width * .03,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.white,
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

                                      SizedBox(height: width * .025),

                                      // Row of actions: Add after this / Remove (optional)
                                      if (index ==
                                          _destControllers.length - 1) ...[
                                        Row(
                                          children: [
                                            // Add Destination (only on last)
                                            GestureDetector(
                                              onTap: () => _addDestination(
                                                  afterIndex: index),
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                  vertical: width * .025,
                                                  horizontal: width * .04,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.blue,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          width * .025),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black26,
                                                      blurRadius: width * .02,
                                                      offset: Offset(
                                                          width * .01,
                                                          width * .0125),
                                                    ),
                                                  ],
                                                ),
                                                child: Text(
                                                  "Add Destination",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: width * .035,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),

                                            SizedBox(width: width * .03),

                                            // Remove (only on last, and only if more than 1)
                                            if (_destControllers.length > 1)
                                              GestureDetector(
                                                onTap: () =>
                                                    _removeDestination(index),
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                    vertical: width * .025,
                                                    horizontal: width * .04,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.redAccent,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            width * .025),
                                                  ),
                                                  child: Text(
                                                    "Remove",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: width * .035,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ] else
                                        SizedBox(height: width * .025),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],

                      // NEXT BUTTON
                      SizedBox(height: width * .08),
                      GestureDetector(
                        onTap: _nextPage,
                        child: Container(
                          width: width * .4,
                          padding: EdgeInsets.symmetric(
                            vertical: width * .025,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue,
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
                            child: Text(
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
