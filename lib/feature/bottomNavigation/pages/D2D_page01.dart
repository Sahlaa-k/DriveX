import 'dart:convert';
import 'package:drivex/core/constants/color_constant.dart';
import 'package:drivex/core/constants/localVariables.dart';
import 'package:drivex/feature/bottomNavigation/pages/D2D/PickUpDetailPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:flutter_google_places_hoc081098/google_maps_webservice_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';
// import 'share';

const String googleApiKey = "AIzaSyD1fU_UDudvvy1HEPEoJ4Ify_YOYDlhdEY";

class D2DPage01 extends StatefulWidget {
  const D2DPage01({super.key});

  @override
  State<D2DPage01> createState() => _D2DPage01State();
}

class _D2DPage01State extends State<D2DPage01> {
  bool isFieldEnabled = true;
  GoogleMapController? _mapController;
  LatLng pickup = LatLng(10.998, 76.990);
  LatLng drop = LatLng(10.995, 76.995);

  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();
  final FocusNode fromFocus = FocusNode();
  final FocusNode toFocus = FocusNode();

  bool isFieldActive = false;
  String activeField = "";
  List<dynamic> suggestions = [];

  final String apiKey = "AIzaSyD1fU_UDudvvy1HEPEoJ4Ify_YOYDlhdEY";

  @override
  void initState() {
    super.initState();

    // fromFocus.addListener(() {
    //   if (fromFocus.hasFocus) {
    //     setState(() {
    //       isFieldActive = true;
    //       activeField = "from";
    //     });
    //     _showCurrentLocationSheet(context); // 👈 added
    //   }
    // });

    // toFocus.addListener(() {
    //   if (toFocus.hasFocus) {
    //     setState(() {
    //       isFieldActive = true;
    //       activeField = "to";
    //     });
    //     _showCurrentLocationSheet(context); // 👈 added
    //   }
    // });

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
  }

  /////////////////////////////
  ///
  double? pickupLat;
  double? pickupLng;
  String? pickupAddress;

  double? dropLat;
  double? dropLng;
  String? dropAddress;

  String? generatedLink;
  final GoogleMapsPlaces _places =
      GoogleMapsPlaces(apiKey: "AIzaSyD1fU_UDudvvy1HEPEoJ4Ify_YOYDlhdEY");
  Future<void> _searchLocation(bool isPickup) async {
    Prediction? p = await PlacesAutocomplete.show(
      context: context,
      apiKey: googleApiKey,
      mode: Mode.overlay,
      language: "en",
      components: [Component(Component.country, "in")], // limit to India
    );

    if (p != null) {
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId!);
      final lat = detail.result.geometry!.location.lat;
      final lng = detail.result.geometry!.location.lng;
      final address = detail.result.formattedAddress ?? p.description!;

      setState(() {
        if (isPickup) {
          pickupLat = lat;
          pickupLng = lng;
          pickupAddress = address;
        } else {
          dropLat = lat;
          dropLng = lng;
          dropAddress = address;
        }
      });
    }
  }

  void generateLink() {
    if (pickupLat != null &&
        pickupLng != null &&
        dropLat != null &&
        dropLng != null) {
      generatedLink =
          "https://www.google.com/maps/dir/$pickupLat,$pickupLng/$dropLat,$dropLng";
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please set both pickup and drop locations")),
      );
    }
  }

  ////////////////////////////

  Future<void> getPlaceSuggestions(String input) async {
    if (input.isEmpty) {
      setState(() => suggestions = []);
      return;
    }

    final sessionToken = Uuid().v4();
    final url =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$apiKey&sessiontoken=$sessionToken&components=country:in";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      if (body['status'] == 'OK') {
        setState(() {
          suggestions = body['predictions'];
        });
      } else {
        setState(() => suggestions = []);
      }
    }
  }

  Future<void> getCurrentLocationAndSetField() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    final latLng = LatLng(position.latitude, position.longitude);

    final url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$apiKey";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      String address = "Current location";
      if (body['status'] == 'OK') {
        address = body['results'][0]['formatted_address'];
      }

      setState(() {
        if (activeField == "from") {
          pickup = latLng;
          fromController.text = address;
          _mapController?.animateCamera(CameraUpdate.newLatLng(pickup));
        } else if (activeField == "to") {
          drop = latLng;
          toController.text = address;
          _mapController?.animateCamera(CameraUpdate.newLatLng(drop));
        }
        isFieldActive = false;
        suggestions.clear();
      });
    }
  }

  void selectSuggestion(String placeId) async {
    final url =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body)['result'];
      final lat = result['geometry']['location']['lat'];
      final lng = result['geometry']['location']['lng'];
      final address = result['formatted_address'];

      setState(() {
        if (activeField == "from") {
          pickup = LatLng(lat, lng);
          fromController.text = address;
          _mapController?.animateCamera(CameraUpdate.newLatLng(pickup));
        } else if (activeField == "to") {
          drop = LatLng(lat, lng);
          toController.text = address;
          _mapController?.animateCamera(CameraUpdate.newLatLng(drop));
        }
        isFieldActive = false;
        suggestions.clear();
      });
    }
  }

  void _showCurrentLocationSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  getCurrentLocationAndSetField(); // your existing function
                },
                child: Row(
                  children: [
                    Icon(Icons.my_location, color: Colors.blue),
                    SizedBox(width: 12),
                    Text(
                      "Use Current Location",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        color: ColorConstant.color1.withOpacity(.15),
        child: Stack(
          children: [
            // Column(children: [],),

            Container(
              height: height * 1,
              // color: ColorConstant.backgroundColor,
              child: SingleChildScrollView(
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * .02),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: width * .1,
                          ),
                          Image.asset(
                            // 'assets/images/pzerson-doing-delivery-activities-pack.png',
                            'assets/images/DeliveryMan.png',
                            width: width * .6,
                            // width: width * .75,

                            // height: 100,
                          ),
                          SizedBox(
                            width: width * .825,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SizedBox(
                                  height: width * .1,
                                ),

                                Row(
                                  children: [
                                    Text("Enter PickUp Details",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: width * .035))
                                  ],
                                ),
                                SizedBox(
                                  height: width * .02,
                                ),
                                Container(
                                  width: width * .825,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: width * 0.03),
                                  decoration: BoxDecoration(
                                    // border: Border.all(
                                    //     width: width * .005,
                                    //     color: Colors.black.withOpacity(.1)),
                                    // color: Color(0xFF3A3A3A).withOpacity(.25),
                                    color: Colors.white,
                                    // border: Border.all(
                                    //     width: 2, color: Colors.black.withOpacity(.5)),
                                    borderRadius:
                                        BorderRadius.circular(width * 0.03),
                                    // boxShadow: [
                                    //   BoxShadow(
                                    //     color: Colors.black.withOpacity(0.3),
                                    //     blurRadius: width * 0.02,
                                    //     offset: Offset(0, width * 0.01),
                                    //   ),
                                    // ],
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: width * 0.04,
                                        height: width * 0.04,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: width * .005,
                                              color: Colors.black
                                                  .withOpacity(.25)),
                                          color: Colors
                                              .green, // Change for "To" field
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Container(
                                              width: width * 0.04 / 2,
                                              height: width * 0.04 / 2,
                                              decoration: BoxDecoration(
                                                color: Colors.black.withOpacity(
                                                    0.5), // Change for "To" field
                                                shape: BoxShape.circle,
                                              )),
                                        ),
                                      ),
                                      SizedBox(width: width * 0.03),
                                      Expanded(
                                        child: TextFormField(
                                          focusNode: fromFocus,
                                          controller: fromController,
                                          onChanged: getPlaceSuggestions,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: width * 0.04,
                                          ),
                                          decoration: InputDecoration(
                                            // prefix: Padding(
                                            //   padding: EdgeInsets.symmetric(
                                            //       horizontal: width * .02),
                                            //   child: Container(
                                            //     width: width * 0.035,
                                            //     height: width * 0.035,
                                            //     decoration: BoxDecoration(
                                            //       color: Colors
                                            //           .green, // Change for "To" field
                                            //       shape: BoxShape.circle,
                                            //     ),
                                            //     child: Center(
                                            //       child: Container(
                                            //           width: width * 0.035 / 2,
                                            //           height: width * 0.035 / 2,
                                            //           decoration: BoxDecoration(
                                            //             color: Colors.black.withOpacity(
                                            //                 0.5), // Change for "To" field
                                            //             shape: BoxShape.circle,
                                            //           )),
                                            //     ),
                                            //   ),
                                            // ),
                                            // contentPadding: EdgeInsets.only(bottom: width*.02),

                                            isDense: true,
                                            // prefixIcon: Padding(
                                            //   padding: EdgeInsets.symmetric(
                                            //       vertical: width * .045),
                                            //   child: Container(
                                            //     width: width * 0.035,
                                            //     height: width * 0.035,
                                            //     decoration: BoxDecoration(
                                            //       color: Colors
                                            //           .green, // Change for "To" field
                                            //       shape: BoxShape.circle,
                                            //     ),
                                            //     child: Center(
                                            //       child: Container(
                                            //           width: width * 0.035 / 2,
                                            //           height: width * 0.035 / 2,
                                            //           decoration: BoxDecoration(
                                            //             color: Colors.black.withOpacity(
                                            //                 0.5), // Change for "To" field
                                            //             shape: BoxShape.circle,
                                            //           )),
                                            //     ),
                                            //   ),
                                            // ),

                                            hintText: "Enter PickUp location",
                                            label: Text(
                                              "From",
                                              style: TextStyle(
                                                color: Colors.black
                                                    .withOpacity(.75),
                                                fontSize: width * 0.035,
                                              ),
                                            ),
                                            // hintText:
                                            //     "Al Shifa Hospital Rd, Valiyangadi...",
                                            hintStyle: TextStyle(
                                                fontSize: width * .035,
                                                color: Colors.black
                                                    .withOpacity(.5)),
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: width * .02,
                                ),
                                Container(
                                  height: width * .1,
                                  width: width * .75,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.circular(width * 0.02),
                                    // boxShadow: [
                                    //   BoxShadow(
                                    //     color: Colors.black.withOpacity(0.05),
                                    //     blurRadius: width * 0.02,
                                    //     offset: Offset(0, width * 0.01),
                                    //   ),
                                    // ],
                                  ),
                                  child: TextFormField(
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: width * 0.04,
                                    ),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: width * 0.04,
                                        vertical: width *
                                            0.02, // reduced from 0.035 to 0.02
                                      ),
                                      hintText: "Address",
                                      hintStyle: TextStyle(
                                        color: Colors.black.withOpacity(0.5),
                                        fontSize: width * .035,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(width * 0.03),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: width * .02,
                                ),
                                Container(
                                  height: width * .1,
                                  width: width * .75,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.circular(width * 0.02),
                                    // boxShadow: [
                                    //   BoxShadow(
                                    //     color: Colors.black.withOpacity(0.05),
                                    //     blurRadius: width * 0.02,
                                    //     offset: Offset(0, width * 0.01),
                                    //   ),
                                    // ],
                                  ),
                                  child: TextFormField(
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: width * 0.04,
                                    ),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: width * 0.04,
                                        vertical: width *
                                            0.02, // reduced from 0.035 to 0.02
                                      ),
                                      hintText: "LandMark",
                                      hintStyle: TextStyle(
                                        color: Colors.black.withOpacity(0.5),
                                        fontSize: width * .035,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(width * 0.03),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: width * 0.02),
                                Row(
                                  children: [
                                    Text(
                                      "Enter Drop Details",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: width * .035),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: width * .02,
                                ),
                                Container(
                                  width: width * .825,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: width * 0.03),
                                  decoration: BoxDecoration(
                                    // border: Border.all(
                                    //     width: width * .005,
                                    //     color: Colors.black.withOpacity(.1)),
                                    // color: Color(0xFF3A3A3A).withOpacity(.5),
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.circular(width * 0.03),
                                    // boxShadow: [
                                    //   BoxShadow(
                                    //     color: Colors.black.withOpacity(0.3),
                                    //     blurRadius: width * 0.02,
                                    //     offset: Offset(0, width * 0.01),
                                    //   ),
                                    // ],
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: width * 0.04,
                                        height: width * 0.04,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: width * .005,
                                              color: Colors.black
                                                  .withOpacity(.25)),
                                          color: Colors
                                              .red, // Change for "To" field
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Container(
                                              width: width * 0.04 / 2,
                                              height: width * 0.04 / 2,
                                              decoration: BoxDecoration(
                                                color: Colors.black.withOpacity(
                                                    0.5), // Change for "To" field
                                                shape: BoxShape.circle,
                                              )),
                                        ),
                                      ),
                                      SizedBox(width: width * 0.03),
                                      Expanded(
                                        child: TextFormField(
                                          focusNode: toFocus,
                                          controller: toController,
                                          // onChanged: (value) {
                                          // },
                                          onChanged: getPlaceSuggestions,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: width * 0.04,
                                          ),
                                          decoration: InputDecoration(
                                            isDense: true,
                                            hintText: "Enter Drop location",
                                            label: Text(
                                              "To",
                                              style: TextStyle(
                                                color: Colors.black
                                                    .withOpacity(.75),
                                                fontSize: width * 0.035,
                                              ),
                                            ),
                                            // hintText:
                                            //     "Al Shifa Hospital Rd, Valiyangadi...",
                                            hintStyle: TextStyle(
                                                fontSize: width * .035,
                                                color: Colors.black
                                                    .withOpacity(.5)),
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // if (isFieldActive)
                                //   GestureDetector(
                                //     onTap: getCurrentLocationAndSetField,
                                //     child: Container(
                                //       margin: EdgeInsets.only(top: width * 0.03),
                                //       padding: EdgeInsets.all(width * 0.03),
                                //       decoration: BoxDecoration(
                                //         border: Border.all(
                                //             color: ColorConstant.color1,
                                //             width: width * .006),
                                //         color: Colors.white,
                                //         borderRadius:
                                //             BorderRadius.circular(width * 0.02),
                                //       ),
                                //       child: Row(
                                //         children: [
                                //           Icon(Icons.my_location,
                                //               color: Colors.black),
                                //           SizedBox(width: width * 0.03),
                                //           Text(
                                //             "Use Current Location",
                                //             style: TextStyle(color: Colors.black),
                                //           ),
                                //         ],
                                //       ),
                                //     ),
                                //   ),
                                // if (isFieldActive && suggestions.isNotEmpty)
                                //   Expanded(
                                //     child: ListView.builder(
                                //       itemCount: suggestions.length,
                                //       // itemCount: 5,
                                //       itemBuilder: (context, index) {
                                //         return Container(
                                //           color: Colors.white,
                                //           child: ListTile(
                                //             tileColor: Colors.white,
                                //             title: Text(
                                //                 "suggestions[index]['description']"),
                                //             onTap: () => selectSuggestion(
                                //                 "suggestions[index]['place_id']"),
                                //           ),
                                //         );
                                //       },
                                //     ),
                                //   ),
                                SizedBox(
                                  height: width * .02,
                                ),
                                Container(
                                  height: width * .1,
                                  width: width * .75,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.circular(width * 0.02),
                                    // boxShadow: [
                                    //   BoxShadow(
                                    //     color: Colors.black.withOpacity(0.05),
                                    //     blurRadius: width * 0.02,
                                    //     offset: Offset(0, width * 0.01),
                                    //   ),
                                    // ],
                                  ),
                                  child: TextFormField(
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: width * 0.04,
                                    ),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: width * 0.04,
                                        vertical: width *
                                            0.02, // reduced from 0.035 to 0.02
                                      ),
                                      hintText: "Address",
                                      hintStyle: TextStyle(
                                        color: Colors.black.withOpacity(0.5),
                                        fontSize: width * .035,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(width * 0.03),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: width * .02,
                                ),
                                Container(
                                  height: width * .1,
                                  width: width * .75,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.circular(width * 0.02),
                                    // boxShadow: [
                                    //   BoxShadow(
                                    //     color: Colors.black.withOpacity(0.05),
                                    //     blurRadius: width * 0.02,
                                    //     offset: Offset(0, width * 0.01),
                                    //   ),
                                    // ],
                                  ),
                                  child: TextFormField(
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: width * 0.04,
                                    ),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: width * 0.04,
                                        vertical: width *
                                            0.02, // reduced from 0.035 to 0.02
                                      ),
                                      hintText: "LandMark",
                                      hintStyle: TextStyle(
                                        color: Colors.black.withOpacity(0.5),
                                        fontSize: width * .035,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(width * 0.03),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: width * .1,
                          ),
                          GestureDetector(
                            onTap: () {
                              // print("Next button tapped!");
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Pickupdetailpage(),
                                  ));
                            },
                            child: Container(
                              width: width * .4,
                              padding:
                                  EdgeInsets.symmetric(vertical: width * .025),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius:
                                    BorderRadius.circular(width * .025),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: width * .02,
                                    offset: Offset(width * .01, width * .0125),
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
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (isFieldActive)
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.all(width * .02),
                  child: GestureDetector(
                    onTap: () {
                      getCurrentLocationAndSetField();
                    },
                    child: Container(
                      height: width * .125,
                      width: width * .75,
                      decoration: BoxDecoration(
                          color: ColorConstant.bgColor,
                          border: Border.all(
                              width: width * .005,
                              color: Colors.black.withOpacity(.25)),
                          borderRadius:
                              BorderRadius.all(Radius.circular(width * .25))),
                      // padding: EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.my_location, color: Colors.blue),
                          SizedBox(width: width * .02),
                          Text(
                            "Use Current Location",
                            style: TextStyle(
                                fontSize: width * .04,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            if (isFieldActive && suggestions.isNotEmpty)
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.all(width * .02),
                  child: GestureDetector(
                    onTap: () {
                      getCurrentLocationAndSetField();
                      // getCurrentLocationAndSetField();
                      // Navigator.pop(context); // your existing function
                    },
                    child: Container(
                      height: width * .125,
                      width: width * .75,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              width: width * .005,
                              color: Colors.black.withOpacity(.25)),
                          borderRadius:
                              BorderRadius.all(Radius.circular(width * .25))),
                      // padding: EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.my_location, color: Colors.blue),
                          SizedBox(width: width * .02),
                          Text(
                            "Use Current Location",
                            style: TextStyle(
                                fontSize: width * .04,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget CustomTextFormField({
    String hintText = "",
    TextEditingController? controller,
    FocusNode? focusNode,
    required BuildContext context,
  }) {
    final width = MediaQuery.of(context).size.width;

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(width * 0.03),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: width * 0.02,
              offset: Offset(0, width * 0.01),
            ),
          ],
        ),
        child: TextFormField(
          focusNode: focusNode,
          controller: controller,
          style: TextStyle(
            color: Colors.black,
            fontSize: width * 0.04,
          ),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              horizontal: width * 0.04,
              vertical: width * 0.035,
            ),
            hintText: hintText,
            hintStyle: TextStyle(
              color: Colors.black.withOpacity(0.5),
              fontSize: width * .035,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(width * 0.03),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }
}
