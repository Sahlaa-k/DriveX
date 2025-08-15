import 'dart:convert';

import 'package:drivex/core/constants/localVariables.dart';
import 'package:drivex/core/widgets/BackGroundTopGradient.dart';
import 'package:drivex/feature/bottomNavigation/pages/D2DPage.dart';
import 'package:drivex/feature/bottomNavigation/pages/DriverHomePage.dart';
import 'package:drivex/feature/bottomNavigation/pages/sample03.dart';
import 'package:drivex/feature/bottomNavigation/pages/sample2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../../../core/constants/color_constant.dart';

class Doortodoorpage extends StatefulWidget {
  const Doortodoorpage({super.key});

  @override
  State<Doortodoorpage> createState() => _DoortodoorpageState();
}

class _DoortodoorpageState extends State<Doortodoorpage> {
  late GoogleMapController? mapController;

  GoogleMapController? _mapController;
  // LatLng pickup = LatLng(10.998, 76.990); // Replace with your pickup
  LatLng pickup = LatLng(10.998, 76.990); // Replace with your pickup
  LatLng drop = LatLng(10.995, 76.995); // Replace with your drop
  Set<Polyline> _polylines = {};

  LatLng startLocation = LatLng(10.0159, 76.3419); // Example: Cochin
  LatLng endLocation = LatLng(10.0889, 76.5276); // Example: Aluva

  final String googleAPIKey = "AIzaSyD1fU_UDudvvy1HEPEoJ4Ify_YOYDlhdEY";

  @override
  void initState() {
    super.initState();
    polylinePoints = PolylinePoints();
    _getDirections();
    setMarkers();
    getRoute();
  }

  Future<void> _getDirections() async {
    final String apiKey = "AIzaSyD1fU_UDudvvy1HEPEoJ4Ify_YOYDlhdEY";

    final String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${pickup.latitude},${pickup.longitude}&destination=${drop.latitude},${drop.longitude}&key=$apiKey";

    final response = await http.get(Uri.parse(url));
    final json = jsonDecode(response.body);

    if (json["routes"].isNotEmpty) {
      final points = json["routes"][0]["overview_polyline"]["points"];
      final polylinePoints = _decodePolyline(points);

      setState(() {
        _polylines.add(Polyline(
          polylineId: PolylineId("route"),
          color: Colors.blue,
          width: 5,
          points: polylinePoints,
        ));
      });
    }

    print(url);
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> polyline = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;

      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dLat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dLat;

      shift = 0;
      result = 0;

      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dLng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dLng;

      polyline.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return polyline;
  }

  void setMarkers() {
    markers.add(Marker(
      markerId: MarkerId("start"),
      position: startLocation,
      infoWindow: InfoWindow(title: "Pickup"),
    ));

    markers.add(Marker(
      markerId: MarkerId("end"),
      position: endLocation,
      infoWindow: InfoWindow(title: "Drop"),
    ));
  }

  Future<void> getRoute() async {
    final url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${startLocation.latitude},${startLocation.longitude}&destination=${endLocation.latitude},${endLocation.longitude}&key=$googleAPIKey";

    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);

    if (data["routes"].isNotEmpty) {
      final points = PolylinePoints().decodePolyline(
        data["routes"][0]["overview_polyline"]["points"],
      );

      if (points.isNotEmpty) {
        setState(() {
          polylineCoordinates =
              points.map((e) => LatLng(e.latitude, e.longitude)).toList();
        });
      }
    }
  }

  Set<Marker> markers = {};
  List<LatLng> polylineCoordinates = [];
  late PolylinePoints polylinePoints;

  final CameraPosition _initialPosition = CameraPosition(
    target: LatLng(10.8505, 76.2711), // Example: Kerala
    zoom: 14.0,
  );
  var details;

  TextEditingController PickUpController = TextEditingController();
  TextEditingController DropOffController = TextEditingController();

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location service is enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    print("-------------------------------");
    print(serviceEnabled);
    print("-------------------------------");
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    // Check permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
          'Location permissions are permanently denied, we cannot request.');
    }

    // Get current position
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<String> getPlaceFromCoordinates(double lat, double lon) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        details = place;

        // Customize this as needed
        String address = [
          place.name,
          place.street,
          place.subLocality,
          place.locality,
          place.administrativeArea,
          place.country,
          place.postalCode
        ].where((part) => part != null && part!.isNotEmpty).join(', ');
        // print("-------------------------------");
        // print(address);
        // print(address.runtimeType);
        // // List details = address.to;
        // print("-------------------------------");

        return address;
      } else {
        return "No place found for the given coordinates.";
      }
    } catch (e) {
      return "Error getting place: ${e.toString()}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.backgroundColor,
      // backgroundColor: Colors.blue,
      body: Backgroundtopgradient(
        child: Container(
          height: height * 1,
          child: SingleChildScrollView(
            // physics: NeverScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.only(
                right: width * .025,
                left: width * .025,
                // bottom: width * .025,
              ),
              child: Column(
                children: [
                  SizedBox(height: width * .025), SizedBox(height: width * .1),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: SizedBox(
                              child: Icon(Icons.arrow_back_ios_rounded))),
                      Text(
                        'Door to Door Delivery',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: width * .06,
                            fontWeight: FontWeight.w500),
                      ),
                      // Wrap(
                      //   children: [
                      //     GestureDetector(
                      //       onTap: () {
                      //         // Navigator.push(
                      //         //     context,
                      //         //     CupertinoPageRoute(
                      //         //       builder: (context) => Driverhomepage(),
                      //         //     ));
                      //         setState(() {
                      //           // searchControl = true;
                      //         });
                      //       },
                      //       child: Container(
                      //         height: width * .1,
                      //         width: width * .1,
                      //         decoration: BoxDecoration(
                      //             // color: Colors.white,
                      //             color: Colors.transparent,
                      //             borderRadius:
                      //                 BorderRadius.circular(width * .02),
                      //             border: Border.all(color: Colors.white)),
                      //         child: Center(
                      //           child: Icon(
                      //             Icons.search,
                      //             // color: Colors.black,
                      //             color: Colors.white,
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //     SizedBox(
                      //       width: width * .025,
                      //     ),
                      //     GestureDetector(
                      //       onTap: () {
                      //         Navigator.push(
                      //             context,
                      //             CupertinoPageRoute(
                      //               builder: (context) => Driverhomepage(),
                      //             ));
                      //       },
                      //       child: Container(
                      //         height: width * .1,
                      //         width: width * .1,
                      //         decoration: BoxDecoration(
                      //             // color: Colors.white,
                      //             color: Colors.transparent,
                      //             borderRadius:
                      //                 BorderRadius.circular(width * .02),
                      //             border: Border.all(color: Colors.white)),
                      //         child: Center(
                      //           child: Icon(
                      //             Icons.notifications,
                      //             // color: Colors.black,
                      //             color: Colors.white,
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // )
                    ],
                  ),

                  SizedBox(height: width * .025), SizedBox(height: width * .1),

                  // Container(
                  //   decoration: BoxDecoration(
                  //     border: Border.all()
                  //   ),
                  //   child: SizedBox(height: width * .05)),

                  Container(
                    width: width * .9,
                    // height: width * .5,
                    decoration: BoxDecoration(
                        color: ColorConstant.backgroundColor,
                        border: Border.all(
                            color: ColorConstant.color1, width: width * .005),
                        borderRadius:
                            BorderRadius.all(Radius.circular(width * .05))),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: height * .01,
                          ),
                          Text(
                            "New Service",
                            style: TextStyle(
                                color: ColorConstant.color1,
                                fontSize: width * .05,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: height * .01,
                          ),
                          Text(
                            "Pickup Location",
                            style: TextStyle(
                              color: ColorConstant.color1,
                            ),
                          ),
                          SizedBox(
                            width: width * .8,
                            child: TextFormField(
                              controller: PickUpController,
                              style: TextStyle(
                                fontSize: width * 0.04,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Enter pickup address',
                                hintStyle: TextStyle(
                                  // color: Colors.white54,
                                  color: ColorConstant.color1.withOpacity(0.5),
                                  fontWeight: FontWeight.w500,
                                ),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: ColorConstant.color1,
                                  size: width * 0.06,
                                ),
                                suffixIcon: GestureDetector(
                                    onTap: () async {
                                      // PickUpController = details.locality;
                                      try {
                                        Position position =
                                            await getCurrentLocation();
                                        String place =
                                            await getPlaceFromCoordinates(
                                                position.latitude,
                                                position.longitude);

                                        print("Latitude: ${position.latitude}");
                                        print(
                                            "Longitude: ${position.longitude}");
                                        // print(object)
                                        print("Place: $place");
                                        PickUpController.text =
                                            "${details.subLocality + ',' + details.locality}";

                                        // Optional: Show in a dialog
                                        showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                            title: Text("Current Location"),
                                            content: Text(
                                                "Lat: ${position.latitude}\nLng: ${position.longitude}\nPlace: $place"),
                                          ),
                                        );
                                      } catch (e) {
                                        print("Error: $e");
                                      }
                                      // PickUpController = details.locality;

                                      // try {
                                      //   Position position =
                                      //       await getCurrentLocation();
                                      //   print(
                                      //       "Latitude: ${position.latitude}, Longitude: ${position.longitude}");
                                      // } catch (e) {
                                      //   print("Error: $e");
                                      // }
                                    },
                                    child: SizedBox(
                                        child: Icon(
                                      Icons.gps_fixed,
                                      color: ColorConstant.color1,
                                    ))),

                                filled: true,
                                // fillColor: Colors.white,
                                fillColor: Colors.transparent,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: width * 0.035,
                                  horizontal: width * 0.04,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(width * 0.035),
                                  borderSide: BorderSide(
                                    color:
                                        ColorConstant.color1.withOpacity(0.5),
                                    width: 2,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(width * 0.035),
                                  borderSide: BorderSide(
                                    color: ColorConstant.color1,
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: height * .0125,
                          ),
                          Text(
                            "Drop-off Location",
                            style: TextStyle(
                              color: ColorConstant.color1,
                            ),
                          ),
                          SizedBox(
                            width: width * .8,
                            child: TextFormField(
                              controller: DropOffController,
                              style: TextStyle(
                                fontSize: width * 0.04,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Enter delivery address',
                                hintStyle: TextStyle(
                                  // color: Colors.white54,
                                  color: ColorConstant.color1.withOpacity(0.5),
                                  fontWeight: FontWeight.w500,
                                ),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: ColorConstant.color1,
                                  size: width * 0.06,
                                ),
                                suffixIcon: GestureDetector(
                                    onTap: () {
                                      DropOffController.text =
                                          "${details.subLocality + ',' + details.locality}";
                                    },
                                    child: SizedBox(
                                        child: Icon(
                                      Icons.gps_fixed,
                                      color: ColorConstant.color1,
                                    ))),
                                filled: true,
                                // fillColor: Colors.white,
                                fillColor: Colors.transparent,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: width * 0.035,
                                  horizontal: width * 0.04,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(width * 0.035),
                                  borderSide: BorderSide(
                                    color:
                                        ColorConstant.color1.withOpacity(0.5),
                                    width: 2,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(width * 0.035),
                                  borderSide: BorderSide(
                                    color: ColorConstant.color1,
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: height * .0125,
                          ),
                          GestureDetector(
                            onTap: () {
                              // print(details.locality);
                              print(mapController);

                              // pickup = LatLng(lat, 76.990)
                              // _getDirections();
                              // details.locality;
                            },
                            child: Container(
                              width: width * .8,
                              height: width * .125,
                              decoration: BoxDecoration(
                                color: ColorConstant.color1,
                                // border: Border.all(
                                //     color: ColorConstant.color1,
                                //     width: width * .005),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(width * .05)),
                              ),
                              child: Center(
                                child: Text(
                                  "Submit",
                                  style: TextStyle(
                                      color: ColorConstant.backgroundColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: height * .0125,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: width * .025,
                  ),
                  Container(
                    width: width * .9,
                    decoration: BoxDecoration(
                        color: ColorConstant.color1.withOpacity(.25),
                        border: Border.all(
                            color: ColorConstant.color1.withOpacity(.5),
                            width: width * .005),
                        borderRadius:
                            BorderRadius.all(Radius.circular(width * .05))),
                    child: Padding(
                      padding: EdgeInsets.all(width * .025),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Note :",
                            style: TextStyle(
                                fontSize: width * .025,
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                              "- Valuable things are better to send at varified pickup man's",
                              style: TextStyle(fontSize: width * .0285)),
                          Text(
                              "- Things like Drug's and Alcohol's are not allowed in parceling",
                              style: TextStyle(fontSize: width * .0285))
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(
                        right: width * .03,
                        left: width * .03,
                        top: width * 0.03),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Hire Driver For You",
                          style: TextStyle(
                            color: ColorConstant.color1,
                            fontSize: width * 0.05,
                            fontWeight: FontWeight.w700,
                          ),
                          // style: commonTextStyle.copyWith(
                          //   color: ColorConstant.color1,
                          //   fontSize: width * 0.05,
                          //   fontWeight: FontWeight.w700,
                          // ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //       builder: (context) => Testingpage(),
                            //     ));
                          },
                          child: SizedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "View all",
                                  style: TextStyle(
                                    color: ColorConstant.color1,
                                    fontSize: width * 0.035,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  // style: commonTextStyle.copyWith(
                                  //   color: ColorConstant.color1,
                                  //   fontSize: width * 0.035,
                                  //   fontWeight: FontWeight.w700,
                                  // ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: ColorConstant.color1,
                                  size: width * 0.04,
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  // SizedBox(height: 20),
                  Container(
                    height: height * .5,
                    width: width * .75,
                    decoration: BoxDecoration(border: Border.all()),
                    // child: GoogleMap(
                    //   initialCameraPosition: _initialPosition,
                    //   onMapCreated: (controller) {
                    //     mapController = controller;
                    //   },
                    //   myLocationEnabled: true,
                    //   myLocationButtonEnabled: true,
                    //   zoomControlsEnabled: false,
                    // ),
                    //////////////////////
                    // child: GoogleMap(
                    //   myLocationEnabled: true,
                    //   initialCameraPosition: CameraPosition(
                    //     target: startLocation,
                    //     zoom: 12,
                    //   ),
                    //   onMapCreated: (controller) =>
                    //       mapController = controller,
                    //   markers: markers,
                    //   polylines: {
                    //     Polyline(
                    //       polylineId: PolylineId("route"),
                    //       points: polylineCoordinates,
                    //       color: Colors.blue,
                    //       width: 5,
                    //     )
                    //   },
                    // )
                    ///////////////////////
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: pickup,
                        zoom: 14,
                      ),
                      onMapCreated: (controller) {
                        _mapController = controller;
                      },
                      polylines: _polylines,
                      markers: {
                        Marker(markerId: MarkerId("pickup"), position: pickup),
                        Marker(markerId: MarkerId("drop"), position: drop),
                      },
                      myLocationEnabled: true,
                    ),
                  ),

                  SizedBox(
                    height: width * .25,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: ColorConstant.secondaryColor,
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.white, width: width * .01),
            ),
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => Sample2(),
                ),
              );
            },
            child: Icon(
              Icons
                  .inventory_2_outlined, // or any icon like Icons.add or Icons.assignment
              color: Colors.white,
              size: width * 0.07,
            ),
            tooltip: 'Request Driver',
          ),
          SizedBox(height: width * 0.025),
          FloatingActionButton(
            backgroundColor: ColorConstant.secondaryColor,
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.white, width: width * .01),
            ),
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => D2Dpage(),
                ),
              );
            },
            child: Icon(
              Icons.add_road, // or any icon like Icons.add or Icons.assignment
              color: Colors.white,
              size: width * 0.07,
            ),
            tooltip: 'Request Driver',
          ),
          SizedBox(height: width * 0.2),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
    );
  }
}
