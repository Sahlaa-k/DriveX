// import 'dart:async';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:drivex/core/constants/color_constant.dart';
// import 'package:drivex/core/constants/imageConstants.dart';
// import 'package:drivex/core/constants/localVariables.dart';
// import 'package:drivex/feature/bottomNavigation/pages/D2D/D2D_placeSearchPage.dart';
// import 'package:drivex/feature/bottomNavigation/pages/D2DPage_02.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:uuid/uuid.dart';

// class D2d extends StatefulWidget {
//   const D2d({super.key});

//   @override
//   State<D2d> createState() => _D2dState();
// }

// class _D2dState extends State<D2d> {
//   final TextEditingController fromController = TextEditingController();
//   final TextEditingController toController = TextEditingController();
//   String? selectedPackageWeight;
//   String? selectedPackageItem;

//   final Map<String, String> packageWeightMap = {
//     '0.5-3': '0.5-3 kg',
//     '4-7': '4-7 kg',
//     '8-10': '8-10 kg',
//   };
//   final packageItems = [
//     "Documents",
//     "Clothes",
//     "Electronics",
//     "Gifts",
//     "Food Items",
//     "Medicines",
//     "Others"
//   ];

//   String? tripId;
//   StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? tripSub;

//   Map<String, double>? pickupCoordinates;
//   Map<String, double>? dropCoordinates;

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

//                                     // Recent Requests placeholder (can be wired to _loadRecents if you store them)
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

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Container(
//         color: ColorConstant.color1.withOpacity(.15),
//         child: Stack(
//           children: [
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

//                               SizedBox(
//                                 height: width * .0275,
//                               ),

//                               ////make this sized box belo as return in seperated listblder
//                               SizedBox(
//                                 child: Row(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Column(
//                                       children: [
//                                         // Step 1 Circle
//                                         CircleAvatar(
//                                           radius: width * .035,
//                                           backgroundColor: Colors.black,
//                                           child: Text(
//                                             '1', //index of list
//                                             style: TextStyle(
//                                               color: Colors.white,
//                                               fontSize: width * .035,
//                                             ),
//                                           ),
//                                         ),
//                                         SizedBox(
//                                           height: width * .0125,
//                                         ), // Vertical Line
//                                         Container(
//                                           width: 2,
//                                           height: width * .6125,
//                                           color: Colors.black,
//                                         ),
//                                       ],
//                                     ),
//                                     SizedBox(
//                                       width: width * .025,
//                                     ),
//                                     Container(
//                                       width: width * .75,
//                                       decoration: BoxDecoration(
//                                           // border: Border.all(),
//                                           borderRadius: BorderRadius.circular(
//                                               width * .025),
//                                           color: Colors.black12),
//                                       child: Padding(
//                                         padding: EdgeInsets.symmetric(
//                                             horizontal: width * .025),
//                                         child: Column(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.start,
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               "Starting Point",
//                                               style: TextStyle(
//                                                   fontSize: width * .04),
//                                             ),
//                                             Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment
//                                                       .spaceBetween,
//                                               children: [
//                                                 Container(
//                                                   // width: width * .4,
//                                                   height: width * .1,
//                                                   decoration: BoxDecoration(
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               width * .025),
//                                                       color:
//                                                           ColorConstant.color1),
//                                                   child: Center(
//                                                     child: Padding(
//                                                       padding:
//                                                           EdgeInsets.symmetric(
//                                                               horizontal:
//                                                                   width * .025),
//                                                       child: Text(
//                                                         "Use Current Location",
//                                                         style: TextStyle(
//                                                             color: Colors.white,
//                                                             fontSize:
//                                                                 width * .0325),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 // SizedBox(
//                                                 //   width: width * .028,
//                                                 // ),
//                                                 GestureDetector(
//                                                   onTap: () {
//                                                     openRequestLocationSheet(
//                                                       context,
//                                                       "pickup",
//                                                     );
//                                                   },
//                                                   child: Container(
//                                                     // width: width * .4,
//                                                     height: width * .1,
//                                                     decoration: BoxDecoration(
//                                                         borderRadius:
//                                                             BorderRadius
//                                                                 .circular(
//                                                                     width *
//                                                                         .025),
//                                                         color: ColorConstant
//                                                             .color1),
//                                                     child: Center(
//                                                       child: Padding(
//                                                         padding: EdgeInsets
//                                                             .symmetric(
//                                                                 horizontal:
//                                                                     width *
//                                                                         .025),
//                                                         child: Text(
//                                                           "Request Location",
//                                                           style: TextStyle(
//                                                               color:
//                                                                   Colors.white,
//                                                               fontSize: width *
//                                                                   .0325),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 )
//                                               ],
//                                             ),
//                                             SizedBox(
//                                               height: width * .0275,
//                                             ),
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
//                                                 height: width * .1,
//                                                 width: width * .725,
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
//                                                   ],
//                                                 ),
//                                               ),
//                                             ),
//                                             SizedBox(
//                                               height: width * .0275,
//                                             ),
//                                             Container(
//                                               height: width * .1,
//                                               width: width * .725,
//                                               padding: EdgeInsets.only(
//                                                   left: width * 0.03,
//                                                   right: width * 0.03),
//                                               decoration: BoxDecoration(
//                                                 color: Colors.white,
//                                                 borderRadius:
//                                                     BorderRadius.circular(
//                                                         width * 0.03),
//                                               ),
//                                               alignment: Alignment.center,
//                                               child: TextFormField(
//                                                 // controller: fromController,
//                                                 style: TextStyle(
//                                                   color: Colors.black,
//                                                   fontSize: width * 0.035,
//                                                 ),
//                                                 decoration: InputDecoration(
//                                                   hintText:
//                                                       "Enter the LandMark",
//                                                   hintStyle: TextStyle(
//                                                     color: Colors.black
//                                                         .withOpacity(.5),
//                                                     fontSize: width * 0.035,
//                                                   ),
//                                                   border: InputBorder.none,
//                                                   isCollapsed: true,
//                                                   contentPadding:
//                                                       EdgeInsets.zero,
//                                                 ),
//                                               ),
//                                             ),
//                                             SizedBox(
//                                               height: width * .0275,
//                                             ),
//                                             Container(
//                                               height: width * .1,
//                                               width: width * .725,
//                                               padding: EdgeInsets.only(
//                                                   left: width * 0.03,
//                                                   right: width * 0.03),
//                                               decoration: BoxDecoration(
//                                                 color: Colors.white,
//                                                 borderRadius:
//                                                     BorderRadius.circular(
//                                                         width * 0.03),
//                                               ),
//                                               alignment: Alignment.center,
//                                               child: TextFormField(
//                                                 // controller: fromController,
//                                                 style: TextStyle(
//                                                   color: Colors.black,
//                                                   fontSize: width * 0.035,
//                                                 ),
//                                                 decoration: InputDecoration(
//                                                   hintText: "Phone Number",
//                                                   hintStyle: TextStyle(
//                                                     color: Colors.black
//                                                         .withOpacity(.5),
//                                                     fontSize: width * 0.035,
//                                                   ),
//                                                   border: InputBorder.none,
//                                                   isCollapsed: true,
//                                                   contentPadding:
//                                                       EdgeInsets.zero,
//                                                 ),
//                                               ),
//                                             ),
//                                             SizedBox(
//                                               height: width * .0275,
//                                             ),
//                                             Container(
//                                               height: width * .1,
//                                               width: width * .725,
//                                               padding: EdgeInsets.only(
//                                                   left: width * 0.03,
//                                                   right: width * 0.03),
//                                               decoration: BoxDecoration(
//                                                 color: Colors.white,
//                                                 borderRadius:
//                                                     BorderRadius.circular(
//                                                         width * 0.03),
//                                               ),
//                                               alignment: Alignment.center,
//                                               child: TextFormField(
//                                                 // controller: fromController,
//                                                 style: TextStyle(
//                                                   color: Colors.black,
//                                                   fontSize: width * 0.035,
//                                                 ),
//                                                 decoration: InputDecoration(
//                                                   hintText:
//                                                       "Instruction for Courier",
//                                                   hintStyle: TextStyle(
//                                                     color: Colors.black
//                                                         .withOpacity(.5),
//                                                     fontSize: width * 0.035,
//                                                   ),
//                                                   border: InputBorder.none,
//                                                   isCollapsed: true,
//                                                   contentPadding:
//                                                       EdgeInsets.zero,
//                                                 ),
//                                               ),
//                                             ),
//                                             SizedBox(
//                                               height: width * .0275,
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                     // SizedBox(
//                                     //   // width: width * .065,
//                                     //   width: width * .09,
//                                     // ),
//                                   ],
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: width * .0275,
//                               ),

//                               SizedBox(
//                                 child: Row(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Column(
//                                       children: [
//                                         // Step 1 Circle
//                                         CircleAvatar(
//                                           radius: width * .035,
//                                           backgroundColor: Colors.black,
//                                           child: Text(
//                                             '2', //index of list
//                                             style: TextStyle(
//                                               color: Colors.white,
//                                               fontSize: width * .035,
//                                             ),
//                                           ),
//                                         ),
//                                         SizedBox(
//                                           height: width * .0125,
//                                         ), // Vertical Line
//                                         Container(
//                                           width: 2,
//                                           height: width * .6125,
//                                           color: Colors.black,
//                                         ),
//                                       ],
//                                     ),
//                                     SizedBox(
//                                       width: width * .025,
//                                     ),
//                                     Container(
//                                       width: width * .75,
//                                       decoration: BoxDecoration(
//                                           // border: Border.all(),
//                                           borderRadius: BorderRadius.circular(
//                                               width * .025),
//                                           color: Colors.black12),
//                                       child: Padding(
//                                         padding: EdgeInsets.symmetric(
//                                             horizontal: width * .025),
//                                         child: Column(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.start,
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               "Starting Point",
//                                               style: TextStyle(
//                                                   fontSize: width * .04),
//                                             ),
//                                             Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment
//                                                       .spaceBetween,
//                                               children: [
//                                                 Container(
//                                                   // width: width * .4,
//                                                   height: width * .1,
//                                                   decoration: BoxDecoration(
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               width * .025),
//                                                       color:
//                                                           ColorConstant.color1),
//                                                   child: Center(
//                                                     child: Padding(
//                                                       padding:
//                                                           EdgeInsets.symmetric(
//                                                               horizontal:
//                                                                   width * .025),
//                                                       child: Text(
//                                                         "Use Current Location",
//                                                         style: TextStyle(
//                                                             color: Colors.white,
//                                                             fontSize:
//                                                                 width * .0325),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 // SizedBox(
//                                                 //   width: width * .028,
//                                                 // ),
//                                                 GestureDetector(
//                                                   onTap: () {
//                                                     openRequestLocationSheet(
//                                                       context,
//                                                       "pickup",
//                                                     );
//                                                   },
//                                                   child: Container(
//                                                     // width: width * .4,
//                                                     height: width * .1,
//                                                     decoration: BoxDecoration(
//                                                         borderRadius:
//                                                             BorderRadius
//                                                                 .circular(
//                                                                     width *
//                                                                         .025),
//                                                         color: ColorConstant
//                                                             .color1),
//                                                     child: Center(
//                                                       child: Padding(
//                                                         padding: EdgeInsets
//                                                             .symmetric(
//                                                                 horizontal:
//                                                                     width *
//                                                                         .025),
//                                                         child: Text(
//                                                           "Request Location",
//                                                           style: TextStyle(
//                                                               color:
//                                                                   Colors.white,
//                                                               fontSize: width *
//                                                                   .0325),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 )
//                                               ],
//                                             ),
//                                             SizedBox(
//                                               height: width * .0275,
//                                             ),
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
//                                                 height: width * .1,
//                                                 width: width * .725,
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
//                                                   ],
//                                                 ),
//                                               ),
//                                             ),
//                                             SizedBox(
//                                               height: width * .0275,
//                                             ),
//                                             Container(
//                                               height: width * .1,
//                                               width: width * .725,
//                                               padding: EdgeInsets.only(
//                                                   left: width * 0.03,
//                                                   right: width * 0.03),
//                                               decoration: BoxDecoration(
//                                                 color: Colors.white,
//                                                 borderRadius:
//                                                     BorderRadius.circular(
//                                                         width * 0.03),
//                                               ),
//                                               alignment: Alignment.center,
//                                               child: TextFormField(
//                                                 // controller: fromController,
//                                                 style: TextStyle(
//                                                   color: Colors.black,
//                                                   fontSize: width * 0.035,
//                                                 ),
//                                                 decoration: InputDecoration(
//                                                   hintText:
//                                                       "Enter the LandMark",
//                                                   hintStyle: TextStyle(
//                                                     color: Colors.black
//                                                         .withOpacity(.5),
//                                                     fontSize: width * 0.035,
//                                                   ),
//                                                   border: InputBorder.none,
//                                                   isCollapsed: true,
//                                                   contentPadding:
//                                                       EdgeInsets.zero,
//                                                 ),
//                                               ),
//                                             ),
//                                             SizedBox(
//                                               height: width * .0275,
//                                             ),
//                                             Container(
//                                               height: width * .1,
//                                               width: width * .725,
//                                               padding: EdgeInsets.only(
//                                                   left: width * 0.03,
//                                                   right: width * 0.03),
//                                               decoration: BoxDecoration(
//                                                 color: Colors.white,
//                                                 borderRadius:
//                                                     BorderRadius.circular(
//                                                         width * 0.03),
//                                               ),
//                                               alignment: Alignment.center,
//                                               child: TextFormField(
//                                                 // controller: fromController,
//                                                 style: TextStyle(
//                                                   color: Colors.black,
//                                                   fontSize: width * 0.035,
//                                                 ),
//                                                 decoration: InputDecoration(
//                                                   hintText: "Phone Number",
//                                                   hintStyle: TextStyle(
//                                                     color: Colors.black
//                                                         .withOpacity(.5),
//                                                     fontSize: width * 0.035,
//                                                   ),
//                                                   border: InputBorder.none,
//                                                   isCollapsed: true,
//                                                   contentPadding:
//                                                       EdgeInsets.zero,
//                                                 ),
//                                               ),
//                                             ),
//                                             SizedBox(
//                                               height: width * .0275,
//                                             ),
//                                             Container(
//                                               height: width * .1,
//                                               width: width * .725,
//                                               padding: EdgeInsets.only(
//                                                   left: width * 0.03,
//                                                   right: width * 0.03),
//                                               decoration: BoxDecoration(
//                                                 color: Colors.white,
//                                                 borderRadius:
//                                                     BorderRadius.circular(
//                                                         width * 0.03),
//                                               ),
//                                               alignment: Alignment.center,
//                                               child: TextFormField(
//                                                 // controller: fromController,
//                                                 style: TextStyle(
//                                                   color: Colors.black,
//                                                   fontSize: width * 0.035,
//                                                 ),
//                                                 decoration: InputDecoration(
//                                                   hintText:
//                                                       "Instruction for Courier",
//                                                   hintStyle: TextStyle(
//                                                     color: Colors.black
//                                                         .withOpacity(.5),
//                                                     fontSize: width * 0.035,
//                                                   ),
//                                                   border: InputBorder.none,
//                                                   isCollapsed: true,
//                                                   contentPadding:
//                                                       EdgeInsets.zero,
//                                                 ),
//                                               ),
//                                             ),
//                                             SizedBox(
//                                               height: width * .0275,
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                     // SizedBox(
//                                     //   // width: width * .065,
//                                     //   width: width * .09,
//                                     // ),
//                                   ],
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: width * .0275,
//                               ),
//                               GestureDetector(
//                                 onTap: () {},
//                                 child: Container(
//                                   height: width * .1,
//                                   width: width * .85,
//                                   decoration: BoxDecoration(
//                                     color: Colors.black12,
//                                     borderRadius:
//                                         BorderRadius.circular(width * .025),
//                                   ),
//                                   child: Center(
//                                     child: Padding(
//                                       padding: EdgeInsets.symmetric(
//                                           horizontal: width * .025),
//                                       child: Row(
//                                         children: [
//                                           Icon(Icons.add),
//                                           Text(
//                                             "Add Delivery Point",
//                                             style: TextStyle(
//                                               color: Colors.black,
//                                               fontSize: width * .04,
//                                               fontWeight: FontWeight.bold,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: width * .0275,
//                               ),
//                               GestureDetector(
//                                 onTap: () {},
//                                 child: Container(
//                                   width: width * .85,
//                                   height: width * .1,
//                                   decoration: BoxDecoration(
//                                     color: Colors.black12,
//                                     borderRadius:
//                                         BorderRadius.circular(width * .025),
//                                   ),
//                                   child: Center(
//                                     child: Padding(
//                                       padding: EdgeInsets.symmetric(
//                                           horizontal: width * .025),
//                                       child: Row(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.center,
//                                         children: [
//                                           Icon(Icons.add),
//                                           Text(
//                                             "Re-arrange addresses",
//                                             style: TextStyle(
//                                               color: Colors.black,
//                                               fontSize: width * .04,
//                                               fontWeight: FontWeight.bold,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: width * .05,
//                               ),
//                               Row(
//                                 children: [
//                                   Text("Package",
//                                       style: TextStyle(
//                                         fontSize: width * .04,
//                                         fontWeight: FontWeight.bold,
//                                       )),
//                                 ],
//                               ),
//                               SizedBox(
//                                 height: width * .025,
//                               ),
//                               GestureDetector(
//                                 onTap: () {
//                                   // openPackageTypeSheet(context);
//                                   showModalBottomSheet(
//                                     context: context,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.only(
//                                         topLeft: Radius.circular(width * .05),
//                                         topRight: Radius.circular(width * .05),
//                                       ),
//                                     ),
//                                     builder: (context) {
//                                       return Container(
//                                           height: width * .5,
//                                           child: ListView.builder(
//                                             itemCount: packageWeightMap.length,
//                                             itemBuilder: (context, index) {
//                                               return ListTile(
//                                                 title: Text(packageWeightMap
//                                                     .values
//                                                     .elementAt(index)),
//                                                 onTap: () {
//                                                   setState(() {
//                                                     selectedPackageWeight =
//                                                         packageWeightMap.keys
//                                                             .elementAt(index);
//                                                   });
//                                                   Navigator.pop(context);
//                                                 },
//                                               );
//                                             },
//                                           ));
//                                     },
//                                   );
//                                 },
//                                 child: Container(
//                                   width: width * .85,
//                                   decoration: BoxDecoration(
//                                     color: Colors.black12,
//                                     borderRadius:
//                                         BorderRadius.circular(width * .025),
//                                   ),
//                                   child: Padding(
//                                     padding: EdgeInsets.symmetric(
//                                         horizontal: width * .025,
//                                         vertical: width * .025),
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         if (selectedPackageWeight != null)
//                                           Text(
//                                             packageWeightMap[
//                                                 selectedPackageWeight]!,
//                                             style: TextStyle(
//                                               fontSize: width * .04,
//                                               fontWeight: FontWeight.bold,
//                                             ),
//                                           )
//                                         else
//                                           Text(
//                                             "Select Package Weight",
//                                             style: TextStyle(
//                                               fontSize: width * .04,
//                                               fontWeight: FontWeight.bold,
//                                             ),
//                                           ),
//                                         Icon(Icons.arrow_drop_down)
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               Container(
//                                   width: width * .85,
//                                   child: Column(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.center,
//                                       children: [
//                                         TextFormField(
//                                             // controller:
//                                             //     packageDetailsController,
//                                             decoration: InputDecoration(
//                                                 hintText:
//                                                     "What are you sendiing?",
//                                                 hintStyle: TextStyle(
//                                                     color: Colors.black54),
//                                                 border: UnderlineInputBorder(
//                                                     borderSide: BorderSide(
//                                                         color: Colors.black)))),
//                                         GridView.builder(
//                                             gridDelegate:
//                                                 SliverGridDelegateWithFixedCrossAxisCount(
//                                                     crossAxisCount:
//                                                         packageItems.length),
//                                             itemBuilder: (context, index) {
//                                               return GestureDetector(
//                                                 onTap: () {
//                                                   setState(() {
//                                                     selectedPackageItem =
//                                                         packageItems[index];
//                                                   });
//                                                 },
//                                                 child: Container(
//                                                   margin: EdgeInsets.all(
//                                                       width * .01),
//                                                   padding: EdgeInsets.symmetric(
//                                                       horizontal: width * .02,
//                                                       vertical: width * .01),
//                                                   decoration: BoxDecoration(
//                                                     color:
//                                                         selectedPackageItem ==
//                                                                 packageItems[
//                                                                     index]
//                                                             ? Colors.blue
//                                                             : Colors
//                                                                 .grey.shade300,
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             width * .02),
//                                                   ),
//                                                   child: Center(
//                                                     child: Text(
//                                                       packageItems[index],
//                                                       style: TextStyle(
//                                                         color:
//                                                             selectedPackageItem ==
//                                                                     packageItems[
//                                                                         index]
//                                                                 ? Colors.white
//                                                                 : Colors.black,
//                                                         fontSize: width * .025,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               );
//                                             })
//                                       ])),
//                               SizedBox(
//                                 height: width * .1,
//                               ),
//                               GestureDetector(
//                                 onTap: () {
//                                   // print(same);
//                                   // NextPage();
//                                   D2Dpage02(
//                                       pickupLocation: "pickupLocation",
//                                       dropLocation: "dropLocation");
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

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drivex/core/constants/color_constant.dart';
import 'package:drivex/core/constants/imageConstants.dart';
import 'package:drivex/core/constants/localVariables.dart';
import 'package:drivex/feature/bottomNavigation/pages/D2D/D2D_placeSearchPage.dart';
import 'package:drivex/feature/bottomNavigation/pages/D2DPage_02.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';

class D2d extends StatefulWidget {
  const D2d({super.key});

  @override
  State<D2d> createState() => _D2dState();
}

class _D2dState extends State<D2d> {
  // Base (existing) controllers
  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();

  // Pickup extras
  final TextEditingController pickupLandmarkCtrl = TextEditingController();
  final TextEditingController pickupPhoneCtrl = TextEditingController();
  final TextEditingController pickupNoteCtrl = TextEditingController();

  // Drop extras
  final TextEditingController dropLandmarkCtrl = TextEditingController();
  final TextEditingController dropPhoneCtrl = TextEditingController();
  final TextEditingController dropNoteCtrl = TextEditingController();

  // Dynamic lists for all stops (address + extras per stop)
  late List<TextEditingController> addressCtrls;
  late List<TextEditingController> landmarkCtrls;
  late List<TextEditingController> phoneCtrls;
  late List<TextEditingController> noteCtrls;

  // Max 6 points; default 2 (pickup, drop)
  static const int maxStops = 6;
  int stopCount = 2;

  // Package section
  final TextEditingController packageDescController = TextEditingController();
  String? selectedPackageWeight;
  String? selectedPackageItem;

  final Map<String, String> packageWeightMap = const {
    '0.5-3': '0.5–3 kg',
    '4-7': '4–7 kg',
    '8-10': '8–10 kg',
  };
  final List<String> packageItems = const [
    "Documents",
    "Clothes",
    "Electronics",
    "Gifts",
    "Food Items",
    "Medicines",
    "Others"
  ];

  // Firestore / trip
  String? tripId;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? tripSub;
  Map<String, double>? pickupCoordinates;
  Map<String, double>? dropCoordinates;

  @override
  void initState() {
    super.initState();

    // Seed lists with your original pickup (0) and drop (1) controllers
    addressCtrls = [fromController, toController];
    landmarkCtrls = [pickupLandmarkCtrl, dropLandmarkCtrl];
    phoneCtrls = [pickupPhoneCtrl, dropPhoneCtrl];
    noteCtrls = [pickupNoteCtrl, dropNoteCtrl];

    // Auto-select "Others" when typing a custom package description
    packageDescController.addListener(() {
      final text = packageDescController.text.trim();
      if (text.isNotEmpty && selectedPackageItem != "Others") {
        setState(() => selectedPackageItem = "Others");
      }
    });
  }

  @override
  void dispose() {
    tripSub?.cancel();
    for (final c in [
      ...addressCtrls,
      ...landmarkCtrls,
      ...phoneCtrls,
      ...noteCtrls,
      packageDescController
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _createTripDocument() async {
    final docRef =
        await FirebaseFirestore.instance.collection("locationRequests").add({
      "pickupLocation": null,
      "dropLocation": null,
      "senderName": "Kamal",
      "senderPhone": "9876543210",
      "createdAt": FieldValue.serverTimestamp(),
    });
    tripId = docRef.id;
    _listenToTripUpdates();
  }

  void _listenToTripUpdates() {
    tripSub?.cancel();
    final id = tripId;
    if (id == null) return;
    tripSub = FirebaseFirestore.instance
        .collection("locationRequests")
        .doc(id)
        .snapshots()
        .listen((doc) {
      if (!doc.exists) return;
      final data = doc.data();
      if (data == null) return;

      if (data['pickupLocation'] != null) {
        final coords = Map<String, dynamic>.from(data['pickupLocation']);
        setState(() {
          pickupCoordinates = {
            "lat": (coords['lat'] as num).toDouble(),
            "lng": (coords['lng'] as num).toDouble()
          };
          addressCtrls[0].text =
              "${pickupCoordinates!['lat']}, ${pickupCoordinates!['lng']}";
        });
      }
      if (data['dropLocation'] != null) {
        final coords = Map<String, dynamic>.from(data['dropLocation']);
        setState(() {
          dropCoordinates = {
            "lat": (coords['lat'] as num).toDouble(),
            "lng": (coords['lng'] as num).toDouble()
          };
          addressCtrls[1].text =
              "${dropCoordinates!['lat']}, ${dropCoordinates!['lng']}";
        });
      }
    });
  }

  Future<Map<String, dynamic>> _sendLocationRequest(String type) async {
    if (tripId == null) {
      await _createTripDocument();
    }
    final id = tripId!;
    final shareId = const Uuid().v4();
    final expiresAtDt = DateTime.now().add(const Duration(hours: 24));
    final expiresAtIso = expiresAtDt.toIso8601String();

    final link = "https://drivex-2a34e.web.app/?id=$id&type=$type&sid=$shareId";

    await FirebaseFirestore.instance
        .collection("locationRequests")
        .doc(id)
        .collection("shares")
        .doc(shareId)
        .set({
      "type": type,
      "link": link,
      "status": "sent",
      "createdAt": FieldValue.serverTimestamp(),
      "expiresAt": Timestamp.fromDate(expiresAtDt),
    });

    return {"link": link, "expiresAt": expiresAtIso, "shareId": shareId};
  }

  void openRequestLocationSheet(BuildContext context, String slot) {
    showCupertinoModalPopup(
      context: context,
      barrierColor: Colors.black.withOpacity(.35),
      builder: (ctx) {
        Future<Map<String, dynamic>>? linkFuture;
        return StatefulBuilder(
          builder: (ctx, setSheet) {
            linkFuture ??= _sendLocationRequest(slot);
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
                          top: Radius.circular(width * .05)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: width * .05,
                        vertical: width * .04,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                                child: Icon(CupertinoIcons.xmark,
                                    size: width * .06),
                              ),
                            ],
                          ),
                          SizedBox(height: width * .01),
                          Text(
                            'Share the link below to get the ${slot.toUpperCase()} location.',
                            style: TextStyle(
                                fontSize: width * .0325, color: Colors.black54),
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
                                        Text("Generating secure link…",
                                            style: TextStyle(
                                                fontSize: width * .034,
                                                color: Colors.black54)),
                                      ],
                                    ),
                                  );
                                }
                                if (snap.hasError) {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                          CupertinoIcons
                                              .exclamationmark_triangle,
                                          color: Colors.red,
                                          size: width * .12),
                                      SizedBox(height: width * .02),
                                      Text("Couldn't create link",
                                          style: TextStyle(
                                              fontSize: width * .042,
                                              fontWeight: FontWeight.w600)),
                                      SizedBox(height: width * .02),
                                      Text("${snap.error}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: width * .032,
                                              color: Colors.black54)),
                                      SizedBox(height: width * .04),
                                      CupertinoButton.filled(
                                        onPressed: () => setSheet(() =>
                                            linkFuture =
                                                _sendLocationRequest(slot)),
                                        child: const Text("Try again"),
                                      ),
                                    ],
                                  );
                                }

                                final data = snap.data!;
                                final link = data['link'] as String;
                                final expiresAt = data['expiresAt'] as String?;

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
                                          Text("Share this link",
                                              style: TextStyle(
                                                  fontSize: width * .035,
                                                  color: Colors.black54)),
                                          SizedBox(height: width * .02),
                                          SelectableText(link,
                                              style: TextStyle(
                                                  fontSize: width * .034,
                                                  fontFamily: 'monospace')),
                                          if (expiresAt != null) ...[
                                            SizedBox(height: width * .02),
                                            Text("Expires: $expiresAt",
                                                style: TextStyle(
                                                    fontSize: width * .03,
                                                    color: Colors.black45)),
                                          ],
                                          SizedBox(height: width * .02),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: CupertinoButton(
                                                  color:
                                                      const Color(0xFFE8F3FF),
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: width * .028),
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
                                                              0xFF1976D2)),
                                                      SizedBox(
                                                          width: width * .02),
                                                      Text("Copy link",
                                                          style: TextStyle(
                                                              fontSize:
                                                                  width * .035,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color: const Color(
                                                                  0xFF1976D2))),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: width * .03),
                                              Expanded(
                                                child: CupertinoButton.filled(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: width * .028),
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
                                                      Text("Share",
                                                          style: TextStyle(
                                                              fontSize:
                                                                  width * .035,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700)),
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
                                    Text("Recent Request",
                                        style: TextStyle(
                                            fontSize: width * .036,
                                            fontWeight: FontWeight.w600)),
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
                                            Icon(CupertinoIcons.location_solid,
                                                color: Colors.redAccent,
                                                size: width * .06),
                                            SizedBox(width: width * .03),
                                            Text("No recent Location",
                                                style: TextStyle(
                                                    fontSize: width * .04,
                                                    color: Colors.black54)),
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
                                        child: Text("Done",
                                            style: TextStyle(
                                                fontSize: width * .04,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700)),
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

  void _moveInAllLists(int from, int to) {
    // keep arrays in sync
    final addr = addressCtrls.removeAt(from);
    final land = landmarkCtrls.removeAt(from);
    final phone = phoneCtrls.removeAt(from);
    final note = noteCtrls.removeAt(from);

    addressCtrls.insert(to, addr);
    landmarkCtrls.insert(to, land);
    phoneCtrls.insert(to, phone);
    noteCtrls.insert(to, note);
  }

  void _reorderStops(int oldIndex, int newIndex) {
    // Don't allow moving the Starting Point
    if (oldIndex == 0 || newIndex == 0) return;

    // ReorderableListView quirk: when moving down, newIndex includes the removal gap.
    if (newIndex > oldIndex) newIndex -= 1;

    setState(() => _moveInAllLists(oldIndex, newIndex));
  }

  void _removeStop(int index) {
    if (index < 2) return; // keep Starting & first Destination
    setState(() {
      // dispose controllers for this stop
      addressCtrls[index].dispose();
      landmarkCtrls[index].dispose();
      phoneCtrls[index].dispose();
      noteCtrls[index].dispose();

      // remove them from lists
      addressCtrls.removeAt(index);
      landmarkCtrls.removeAt(index);
      phoneCtrls.removeAt(index);
      noteCtrls.removeAt(index);

      // update count (minimum 2)
      stopCount = addressCtrls.length;
      if (stopCount < 2) stopCount = 2;
    });
  }

  String _stopTitle(int index) {
    if (index == 0) return "Starting Point";
    // when only 2 points, show single "Destination Point"
    if (stopCount == 2) return "Destination Point";
    // when 3+, number the destinations (index 1 -> #1, index 2 -> #2, ...)
    return "Destination Point ${index}";
  }

  String _labelForIndex(int index) {
    if (index == 0) return "Pickup";
    if (stopCount == 2) return "Destination";
    return "Destination ${index}";
  }

  String _slotForIndex(int index) => index == 0 ? "pickup" : "drop";
  Color _accentForIndex(int index) =>
      index == 0 ? Colors.green : (index == 1 ? Colors.redAccent : Colors.blue);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        color: ColorConstant.color1.withOpacity(.15),
        child: Stack(
          children: [
            SizedBox(
              height: height * 1,
              child: SingleChildScrollView(
                child: SafeArea(
                  child: Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * .02),
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: width * .1),
                              SizedBox(height: width * .3),

                              // How-to card
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
                                      Text("How to use ?",
                                          style: TextStyle(
                                              fontSize: width * .03,
                                              fontWeight: FontWeight.w500)),
                                      Text(
                                        'Tap the "Request Location" button and you will get a link\n'
                                        'Share the link and ask the other person to open it and tap "Share Location"',
                                        style:
                                            TextStyle(fontSize: width * .0275),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              SizedBox(height: width * .0275),

                              // ====== DYNAMIC STOPS (ListView.builder) ======
                              ListView.builder(
                                itemCount: stopCount,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  final label = _labelForIndex(index);
                                  final accent = _accentForIndex(index);
                                  final slot = _slotForIndex(index);

                                  // Ensure lists have controllers for this index
                                  while (addressCtrls.length <= index) {
                                    addressCtrls.add(TextEditingController());
                                    landmarkCtrls.add(TextEditingController());
                                    phoneCtrls.add(TextEditingController());
                                    noteCtrls.add(TextEditingController());
                                  }

                                  final addressCtrl = addressCtrls[index];
                                  final landmarkCtrl = landmarkCtrls[index];
                                  final phoneCtrl = phoneCtrls[index];
                                  final noteCtrl = noteCtrls[index];

                                  return Padding(
                                    padding:
                                        EdgeInsets.only(bottom: width * .0275),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Column(
                                          children: [
                                            CircleAvatar(
                                              radius: width * .035,
                                              backgroundColor:
                                                  ColorConstant.color1,
                                              child: Text(
                                                '${index + 1}',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: width * .035),
                                              ),
                                            ),
                                            SizedBox(height: width * .0275),
                                            if (index >= 2)
                                              Container(
                                                width: 2,
                                                // Taller line if last item to visually connect
                                                height: width * .7125,
                                                color: ColorConstant.color1,
                                              )
                                            else
                                              Container(
                                                width: 2,
                                                // Taller line if last item to visually connect
                                                height: width * .625,
                                                color: ColorConstant.color1,
                                              ),
                                          ],
                                        ),
                                        // SizedBox(width: width * .025),
                                        Container(
                                          width: width * .85,
                                          // decoration: BoxDecoration(
                                          //   borderRadius: BorderRadius.circular(
                                          //       width * .025),
                                          //   color: Colors.black12,
                                          // ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // SizedBox(height: width * .02),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      _stopTitle(index),
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize:
                                                              width * .04),
                                                    ),
                                                  ),
                                                  if (index >=
                                                      2) // show delete for 3rd point onward
                                                    IconButton(
                                                      icon: const Icon(
                                                          Icons.delete_outline),
                                                      splashRadius: 20,
                                                      tooltip:
                                                          "Remove this point",
                                                      onPressed: () =>
                                                          _removeStop(index),
                                                    ),
                                                ],
                                              ),
                                              SizedBox(height: width * .01),

                                              // Row with "Use current location" & "Request Location"
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Container(
                                                    height: width * .1,
                                                    width: width * .4,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              width * .025),
                                                      color:
                                                          ColorConstant.color1,
                                                    ),
                                                    child: Center(
                                                      child: Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    width *
                                                                        .025),
                                                        child: Text(
                                                          "Use Current Location",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: width *
                                                                  .0325),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () =>
                                                        openRequestLocationSheet(
                                                            context, slot),
                                                    child: Container(
                                                      width: width * .4,
                                                      height: width * .1,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    width *
                                                                        .025),
                                                        color: ColorConstant
                                                            .color1,
                                                      ),
                                                      child: Center(
                                                        child: Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      width *
                                                                          .025),
                                                          child: Text(
                                                            "Request Location",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize:
                                                                    width *
                                                                        .0325),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              SizedBox(height: width * .0275),

                                              // Address chooser row with arrow icon
                                              GestureDetector(
                                                onTap: () async {
                                                  await Navigator.push(
                                                    context,
                                                    CupertinoPageRoute(
                                                      builder: (_) =>
                                                          D2dPlaceSearchPage(
                                                        controller: addressCtrl,
                                                        accentColor: accent,
                                                        label: label,
                                                      ),
                                                    ),
                                                  );
                                                  setState(() {});
                                                },
                                                child: Container(
                                                  height: width * .1,
                                                  // width: width * .725,
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
                                                          addressCtrl
                                                                  .text.isEmpty
                                                              ? "Enter $label location"
                                                              : addressCtrl
                                                                  .text,
                                                          style: TextStyle(
                                                            color: addressCtrl
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
                                                      const Icon(
                                                        Icons.chevron_right,
                                                        size: 22,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),

                                              SizedBox(height: width * .0275),

                                              // Landmark
                                              Container(
                                                height: width * .1,
                                                // width: width * .725,
                                                padding: EdgeInsets.only(
                                                    left: width * 0.03,
                                                    right: width * 0.03),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          width * 0.03),
                                                ),
                                                alignment: Alignment.center,
                                                child: TextFormField(
                                                  controller: landmarkCtrl,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: width * 0.035,
                                                  ),
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        "Enter the Landmark",
                                                    hintStyle: TextStyle(
                                                      color: Colors.black
                                                          .withOpacity(.5),
                                                      fontSize: width * 0.035,
                                                    ),
                                                    border: InputBorder.none,
                                                    isCollapsed: true,
                                                    contentPadding:
                                                        EdgeInsets.zero,
                                                  ),
                                                ),
                                              ),

                                              SizedBox(height: width * .0275),

                                              // Phone
                                              Container(
                                                height: width * .1,
                                                // width: width * .725,
                                                padding: EdgeInsets.only(
                                                    left: width * 0.03,
                                                    right: width * 0.03),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          width * 0.03),
                                                ),
                                                alignment: Alignment.center,
                                                child: TextFormField(
                                                  controller: phoneCtrl,
                                                  keyboardType:
                                                      TextInputType.phone,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: width * 0.035,
                                                  ),
                                                  decoration: InputDecoration(
                                                    hintText: "Phone Number",
                                                    hintStyle: TextStyle(
                                                      color: Colors.black
                                                          .withOpacity(.5),
                                                      fontSize: width * 0.035,
                                                    ),
                                                    border: InputBorder.none,
                                                    isCollapsed: true,
                                                    contentPadding:
                                                        EdgeInsets.zero,
                                                  ),
                                                ),
                                              ),

                                              SizedBox(height: width * .0275),

                                              // Note
                                              Container(
                                                height: width * .1,
                                                // width: width * .725,
                                                padding: EdgeInsets.only(
                                                    left: width * 0.03,
                                                    right: width * 0.03),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          width * 0.03),
                                                ),
                                                alignment: Alignment.center,
                                                child: TextFormField(
                                                  controller: noteCtrl,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: width * 0.035,
                                                  ),
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        "Instruction for Courier",
                                                    hintStyle: TextStyle(
                                                      color: Colors.black
                                                          .withOpacity(.5),
                                                      fontSize: width * 0.035,
                                                    ),
                                                    border: InputBorder.none,
                                                    isCollapsed: true,
                                                    contentPadding:
                                                        EdgeInsets.zero,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: width * .0275),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),

                              // ====== Add / Re-arrange ======
                              GestureDetector(
                                onTap: () {
                                  if (stopCount >= maxStops) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            "You can add up to 6 points only."),
                                        behavior: SnackBarBehavior.floating,
                                        duration: Duration(seconds: 1),
                                      ),
                                    );
                                    return;
                                  }
                                  setState(() {
                                    stopCount += 1;
                                    // Ensure controller sets exist for the new index (handled in builder too)
                                    addressCtrls.add(TextEditingController());
                                    landmarkCtrls.add(TextEditingController());
                                    phoneCtrls.add(TextEditingController());
                                    noteCtrls.add(TextEditingController());
                                  });
                                },
                                child: Container(
                                  height: width * .1,
                                  width: width * .85,
                                  decoration: BoxDecoration(
                                    color: ColorConstant.color1,
                                    borderRadius:
                                        BorderRadius.circular(width * .025),
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: width * .025),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.add,
                                            color: Colors.white,
                                          ),
                                          SizedBox(width: width * .02),
                                          Text(
                                            "Add Delivery Point",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: width * .04,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: width * .0275),
                              GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(width * .05),
                                        topRight: Radius.circular(width * .05),
                                      ),
                                    ),
                                    builder: (context) {
                                      return StatefulBuilder(
                                        builder: (ctx, setSheet) {
                                          return SafeArea(
                                            top: false,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                bottom: MediaQuery.of(ctx)
                                                    .viewInsets
                                                    .bottom,
                                              ),
                                              child: SizedBox(
                                                height: width * .9,
                                                child: Column(
                                                  children: [
                                                    // Grabber + title
                                                    SizedBox(
                                                        height: width * .03),
                                                    Container(
                                                      width: width * .18,
                                                      height: width * .013,
                                                      decoration: BoxDecoration(
                                                        color: ColorConstant
                                                            .color1,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    width *
                                                                        .01),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                        horizontal: width * .05,
                                                        vertical: width * .03,
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              "Re-arrange addresses",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      width *
                                                                          .045,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ),
                                                          TextButton(
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                    ctx),
                                                            child: const Text(
                                                                "Done"),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal:
                                                                  width * .05),
                                                      child: Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                          horizontal:
                                                              width * .02,
                                                          vertical:
                                                              width * .015,
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors
                                                              .grey.shade300,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      width *
                                                                          .02),
                                                        ),
                                                        child: Text(
                                                          "Drag to re-order. Starting Point is fixed at the top.",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            color:
                                                                Colors.black87,
                                                            fontSize:
                                                                width * .03,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                        height: width * .03),

                                                    // Reorderable list
                                                    Expanded(
                                                      child: ReorderableListView
                                                          .builder(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    width *
                                                                        .04),
                                                        itemCount: stopCount,
                                                        // Reorder logic
                                                        onReorder: (oldIndex,
                                                            newIndex) {
                                                          // lock index 0
                                                          if (oldIndex == 0 ||
                                                              newIndex == 0)
                                                            return;

                                                          // update parent state and also refresh the sheet
                                                          _reorderStops(
                                                              oldIndex,
                                                              newIndex);
                                                          setSheet(
                                                              () {}); // refresh sheet view
                                                        },
                                                        buildDefaultDragHandles:
                                                            false, // custom handles
                                                        itemBuilder:
                                                            (context, index) {
                                                          final title =
                                                              _stopTitle(index);

                                                          return Card(
                                                            key: ValueKey(
                                                                "reorder_item_$index"),
                                                            elevation: 0,
                                                            color: Colors.white,
                                                            margin:
                                                                EdgeInsets.only(
                                                              bottom:
                                                                  width * .02,
                                                            ),
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          width *
                                                                              .025),
                                                              side: BorderSide(
                                                                  color: Colors
                                                                      .black12),
                                                            ),
                                                            child: ListTile(
                                                              contentPadding:
                                                                  EdgeInsets
                                                                      .symmetric(
                                                                horizontal:
                                                                    width * .03,
                                                                vertical:
                                                                    width * .01,
                                                              ),
                                                              leading:
                                                                  CircleAvatar(
                                                                radius: width *
                                                                    .035,
                                                                backgroundColor:
                                                                    Colors
                                                                        .black,
                                                                child: Text(
                                                                  "${index + 1}",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        width *
                                                                            .035,
                                                                  ),
                                                                ),
                                                              ),
                                                              title: Text(
                                                                title,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      width *
                                                                          .0375,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              ),
                                                              subtitle: Text(
                                                                addressCtrls[
                                                                            index]
                                                                        .text
                                                                        .isEmpty
                                                                    ? (index ==
                                                                            0
                                                                        ? "Pickup location not set"
                                                                        : "Destination location not set")
                                                                    : addressCtrls[
                                                                            index]
                                                                        .text,
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                              trailing: index ==
                                                                      0
                                                                  ? const SizedBox
                                                                      .shrink() // lock pickup
                                                                  : ReorderableDragStartListener(
                                                                      index:
                                                                          index,
                                                                      child:
                                                                          const Icon(
                                                                        Icons
                                                                            .drag_handle_rounded,
                                                                      ),
                                                                    ),
                                                            ),
                                                          );
                                                        },
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
                                },
                                child: Container(
                                  width: width * .85,
                                  height: width * .1,
                                  decoration: BoxDecoration(
                                    color: ColorConstant.color1,
                                    borderRadius:
                                        BorderRadius.circular(width * .025),
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: width * .025),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.swap_vert_rounded,
                                            color: Colors.white,
                                          ),
                                          SizedBox(width: width * .02),
                                          Text(
                                            "Re-arrange addresses",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: width * .04,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: width * .05),

                              // ====== Package section ======
                              Row(
                                children: [
                                  Text(
                                    "Package",
                                    style: TextStyle(
                                      fontSize: width * .04,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: width * .025),

                              // Weight picker
                              GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(width * .05),
                                        topRight: Radius.circular(width * .05),
                                      ),
                                    ),
                                    builder: (context) {
                                      return SizedBox(
                                        height: width * .5,
                                        child: ListView.builder(
                                          itemCount: packageWeightMap.length,
                                          itemBuilder: (context, index) {
                                            final key = packageWeightMap.keys
                                                .elementAt(index);
                                            final val = packageWeightMap.values
                                                .elementAt(index);
                                            return ListTile(
                                              title: Text(val),
                                              onTap: () {
                                                setState(() {
                                                  selectedPackageWeight = key;
                                                });
                                                Navigator.pop(context);
                                              },
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  width: width * .85,
                                  decoration: BoxDecoration(
                                    color: ColorConstant.color1,
                                    borderRadius:
                                        BorderRadius.circular(width * .025),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: width * .025,
                                        vertical: width * .025),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          selectedPackageWeight != null
                                              ? packageWeightMap[
                                                  selectedPackageWeight]!
                                              : "Select Package Weight",
                                          style: TextStyle(
                                              fontSize: width * .04,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                        const Icon(Icons.arrow_drop_down),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              // What are you sending + chips grid
                              SizedBox(height: width * .025),
                              SizedBox(
                                width: width * .85,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextFormField(
                                      controller: packageDescController,
                                      decoration: const InputDecoration(
                                        hintText: "What are you sending?",
                                        hintStyle:
                                            TextStyle(color: Colors.black54),
                                        border: UnderlineInputBorder(),
                                      ),
                                    ),
                                    SizedBox(height: width * .02),
                                    GridView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        mainAxisSpacing: 8,
                                        crossAxisSpacing: 8,
                                        childAspectRatio: 3.2,
                                      ),
                                      itemCount: packageItems.length,
                                      itemBuilder: (context, index) {
                                        final item = packageItems[index];
                                        final selected =
                                            selectedPackageItem == item;
                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selectedPackageItem = item;
                                              if (item != "Others") {
                                                packageDescController.clear();
                                              }
                                            });
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: width * .02,
                                                vertical: width * .01),
                                            decoration: BoxDecoration(
                                              color: selected
                                                  ? Colors.blue
                                                  : Colors.grey.shade300,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      width * .02),
                                            ),
                                            child: Center(
                                              child: Text(
                                                item,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: selected
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontSize: width * .03,
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    SizedBox(height: width * .025),
                                    Row(
                                      children: [
                                        Text("Parcel value",
                                            style: TextStyle(
                                              fontSize: width * .035,
                                              // fontWeight: FontWeight.bold,
                                            )),
                                      ],
                                    ),
                                    Container(
                                      height: width * .1,
                                      // width: width * .725,
                                      padding: EdgeInsets.only(
                                          left: width * 0.03,
                                          right: width * 0.03),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(width * 0.03),
                                      ),
                                      alignment: Alignment.center,
                                      child: TextFormField(
                                        keyboardType: TextInputType.phone,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: width * 0.035,
                                        ),
                                        decoration: InputDecoration(
                                          hintText: "Enter the parcel value",
                                          hintStyle: TextStyle(
                                            color: Colors.black.withOpacity(.5),
                                            fontSize: width * 0.035,
                                          ),
                                          border: InputBorder.none,
                                          isCollapsed: true,
                                          contentPadding: EdgeInsets.zero,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "Secure your parcel by entering its real cost (up to 50,000). We'll compensate this sum in verified cases of loss or damage. High value parcels are handled by couriers with extra experience. The fee is R2 + 1% of the declared value.",
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                        fontSize: width * .025,
                                      ),
                                    )
                                  ],
                                ),
                              ),

                              SizedBox(height: width * .1),

                              // Next
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (_) => D2Dpage02(
                                        pickupLocation: addressCtrls[0].text,
                                        dropLocation: addressCtrls.length > 1
                                            ? addressCtrls[1].text
                                            : "",
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: width * .4,
                                  padding: EdgeInsets.symmetric(
                                      vertical: width * .025),
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius:
                                        BorderRadius.circular(width * .025),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: width * .02,
                                        offset:
                                            Offset(width * .01, width * .0125),
                                      )
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

                      // Tip box
                      Align(
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: height * .065, right: width * .06),
                          child: Container(
                            width: width * .5,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(width * .025),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: width * .02,
                                  offset: Offset(width * .01, width * .0125),
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
                        ),
                      ),

                      // Header image
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: height * .09, right: width * .1),
                          child: Image.asset(
                            ImageConstant.deliveryman2,
                            height: width * .25,
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
      // Inside your Scaffold:
      bottomSheet: SafeArea(
        top: false,
        child: Container(
          padding: EdgeInsets.fromLTRB(
            width * .04, // left
            width * .03, // top
            width * .04, // right
            width * .04, // bottom (above iOS gesture bar)
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(width * .06),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.10),
                blurRadius: width * .04,
                offset: Offset(0, -width * .01),
              ),
            ],
          ),
          child: Row(
            children: [
              // Price chip (tap to expand fare details)
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(width * .06),
                      ),
                    ),
                    builder: (ctx) {
                      Widget fareRow(String title, String value,
                          {bool isTotal = false}) {
                        final textStyle = TextStyle(
                          fontSize: width * .04,
                          fontWeight:
                              isTotal ? FontWeight.w700 : FontWeight.w500,
                          color: isTotal
                              ? Colors.black
                              : Colors.black.withOpacity(.75),
                        );

                        return Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: width * .018,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(title, style: textStyle),
                              ),
                              Text(value, style: textStyle),
                            ],
                          ),
                        );
                      }

                      return SafeArea(
                        top: false,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: width * .05,
                            vertical: width * .04,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Container(
                                  width: width * .18,
                                  height: width * .012,
                                  decoration: BoxDecoration(
                                    color: Colors.black12,
                                    borderRadius: BorderRadius.circular(
                                      width * .01,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: width * .035),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Fare breakdown',
                                      style: TextStyle(
                                        fontSize: width * .05,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    visualDensity: VisualDensity.compact,
                                    padding: EdgeInsets.zero,
                                    splashRadius: width * .045,
                                    onPressed: () => Navigator.pop(ctx),
                                    icon: Icon(
                                      Icons.close,
                                      size: width * .06,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: width * .01),
                              Text(
                                'Here is how we calculated your delivery fare.',
                                style: TextStyle(
                                  fontSize: width * .032,
                                  color: Colors.black54,
                                ),
                              ),
                              SizedBox(height: width * .03),
                              fareRow('Base fare', '₹180'),
                              fareRow('Distance (6.4 km)', '₹48'),
                              fareRow('Time guarantee', '₹20'),
                              fareRow('Taxes & fees', '₹6'),
                              Divider(
                                height: width * .08,
                                thickness: 1,
                                color: Colors.black.withOpacity(.08),
                              ),
                              fareRow('Total payable', '₹254', isTotal: true),
                              SizedBox(height: width * .02),
                              SizedBox(
                                width: double.infinity,
                                child: TextButton(
                                  onPressed: () => Navigator.pop(ctx),
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                      vertical: width * .035,
                                    ),
                                  ),
                                  child: Text(
                                    'Got it',
                                    style: TextStyle(
                                      fontSize: width * .042,
                                      fontWeight: FontWeight.w600,
                                      color: ColorConstant.color1,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * .03,
                    vertical: width * .022,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F6FA),
                    borderRadius: BorderRadius.circular(width * .08),
                    border: Border.all(color: const Color(0xFFE6E8EE)),
                  ),
                  child: Row(
                    children: [
                      // Lightning icon circle
                      Container(
                        width: width * .085,
                        height: width * .085,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.currency_rupee_outlined,
                            color: Colors.amber, size: width * .05),
                      ),
                      SizedBox(width: width * .02),
                      Text(
                        "₹254",
                        style: TextStyle(
                          fontSize: width * .05,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0C1322),
                        ),
                      ),
                      SizedBox(width: width * .01),
                      Icon(Icons.expand_less,
                          color: Colors.black.withOpacity(.35),
                          size: width * .06),
                    ],
                  ),
                ),
              ),

              SizedBox(width: width * .035),

              // Create order button
              Expanded(
                child: SizedBox(
                  height: width * .14,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: create order action
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E63FF),
                      shape: const StadiumBorder(),
                      elevation: 0,
                    ),
                    child: Text(
                      "Create order",
                      style: TextStyle(
                        fontSize: width * .045,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
