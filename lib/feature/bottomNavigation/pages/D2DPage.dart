import 'dart:math';

import 'package:drivex/core/constants/color_constant.dart';
import 'package:drivex/core/constants/localVariables.dart';
import 'package:drivex/core/widgets/BackGroundTopGradient.dart';
import 'package:drivex/feature/bottomNavigation/pages/D2DPage_02.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class D2Dpage extends StatefulWidget {
  const D2Dpage({super.key});
  // const D2Dpage(
  //     {super.key, required this.pickUpLocation, required this.dropOffLocation});

  @override
  State<D2Dpage> createState() => _D2DpageState();
}

class _D2DpageState extends State<D2Dpage> with TickerProviderStateMixin {
  late TabController tabController;

  // For Sent Package tab
  final TextEditingController sendPickupController = TextEditingController();
  final TextEditingController sendDropController = TextEditingController();

// For Receive Package tab
  final TextEditingController receivePickupController = TextEditingController();
  final TextEditingController receiveDropController = TextEditingController();

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  ////////////get location
  Placemark? details;

  @override
  void initState() {
    super.initState();
    setCurrentLocationToControllers();
  }

  Future<void> setCurrentLocationToControllers() async {
    try {
      Position position = await getCurrentLocation();
      String place =
          await getPlaceFromCoordinates(position.latitude, position.longitude);

      print("Lat: ${position.latitude}, Lng: ${position.longitude}");
      print("Place: $place");

      if (details != null) {
        String shortLocation = "${details!.subLocality}, ${details!.locality}";
        sendPickupController.text = shortLocation;
        receiveDropController.text = shortLocation;
      }
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) throw Exception('Location services are disabled.');

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }

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

        String address = [
          place.name,
          place.street,
          place.subLocality,
          place.locality,
          place.administrativeArea,
          place.country,
          place.postalCode
        ].where((part) => part != null && part!.isNotEmpty).join(', ');

        return address;
      } else {
        return "No place found for the given coordinates.";
      }
    } catch (e) {
      return "Error getting place: ${e.toString()}";
    }
  }

  //////////get location

  void SentPackage() {
    final pickup = sendPickupController.text.trim();
    final drop = sendDropController.text.trim();

    if (pickup.isEmpty || drop.isEmpty) {
      _showSnackBar("Please fill both Pick-Up and Drop-Off Locations.");
      return;
    }

    _showSnackBar("Driver requested successfully!");

    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => D2Dpage02(
          pickupLocation: pickup,
          dropLocation: drop,
        ),
      ),
    );
  }

  void RecievePackage() {
    final pickup = receivePickupController.text.trim();
    final drop = receiveDropController.text.trim();

    if (pickup.isEmpty || drop.isEmpty) {
      _showSnackBar("Please fill both Pick-Up and Drop-Off Locations.");
      return;
    }

    _showSnackBar("Driver requested successfully!");

    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => D2Dpage02(
          pickupLocation: pickup,
          dropLocation: drop,
        ),
      ),
    );
  }

  // void _showSnackBar(String message) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text(message)),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Backgroundtopgradient(
          child: Container(
            height: height * 1,
            child: SafeArea(
              child: Padding(
                padding:
                    EdgeInsets.only(left: width * 0.02, right: width * 0.02),
                child: Column(
                  children: [
                    // Custom Header
                    Container(
                      // height: 60,
                      // decoration: BoxDecoration(border: Border.all()),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: SizedBox(
                                width: width * .1,
                                child: Icon(Icons.arrow_back_ios_rounded)),
                          ),
                          Text(
                            'Door to Door Delivery',
                            style: TextStyle(
                              fontSize: width * .05,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // TabBar and TabBarView inside a container
                    Container(
                      height: width * 0.9,
                      // height: width * .8,
                      decoration: BoxDecoration(
                        // border: Border.all(),
                        color: Colors.grey[100],
                        // color: Colors.white,
                        borderRadius: BorderRadius.circular(width * .025),
                      ),
                      margin: EdgeInsets.symmetric(
                          horizontal: width * .065, vertical: height * 0.02),
                      child: Column(
                        children: [
                          // Styled TabBar
                          TabBar(
                            padding: EdgeInsets.all(width * .015),
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicator: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(width * .02)),
                            ),
                            labelColor: Colors.white,
                            dividerColor: Colors.transparent,
                            unselectedLabelColor: Colors.black,
                            tabs: const [
                              Tab(text: 'Send Package'),
                              Tab(text: 'Recieve Package'),
                            ],
                          ),
                          // SizedBox(height: height * 0.015),

                          // TabBarView content
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  bottom: width * .015,
                                  right: width * .015,
                                  left: width * .015),
                              child: SizedBox(
                                // decoration: BoxDecoration(
                                //   border: Border.all(color: Colors.grey.shade300),
                                //   borderRadius: BorderRadius.circular(width * .02),
                                // ),
                                child: TabBarView(
                                  children: [
                                    // sendPackage(),

                                    Builder(
                                      builder: (context) {
                                        double width =
                                            MediaQuery.of(context).size.width;
                                        return Container(
                                          decoration: BoxDecoration(
                                            // color: Colors.lightBlue
                                            //     .withOpacity(.175),
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(width * .02)),
                                          ),
                                          child: Padding(
                                            padding:
                                                EdgeInsets.all(width * .02),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      width: width * 0.12,
                                                      height: width * 0.12,
                                                      decoration: BoxDecoration(
                                                        // color: Colors.white
                                                        //     .withOpacity(0.4),
                                                        color: ColorConstant
                                                            .color1
                                                            .withOpacity(.25),
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Center(
                                                        child: SvgPicture.asset(
                                                          "assets/icons/paper-plane-svgrepo-com.svg",
                                                          height: width * .05,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                        width: width * 0.05),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          "Quick Send",
                                                          style: TextStyle(
                                                              fontSize:
                                                                  width * 0.045,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              // color: Colors.black,
                                                              color: ColorConstant
                                                                  .color11
                                                                  .withOpacity(
                                                                      .7)),
                                                        ),
                                                        Text(
                                                          "Fast & reliable delivery service",
                                                          style: TextStyle(
                                                              fontSize:
                                                                  width * 0.032,
                                                              // color: Colors.black,
                                                              color: ColorConstant
                                                                  .textColor3),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  // width: width * 0.7,
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    // border: Border.all(),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                width * 0.02)),
                                                  ),
                                                  child: Padding(
                                                    padding: EdgeInsets.all(
                                                        width * .0125),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceEvenly,
                                                              children: [
                                                                Icon(
                                                                    Icons
                                                                        .circle_outlined,
                                                                    color: Colors
                                                                        .blue,
                                                                    size: width *
                                                                        0.05),
                                                                Container(
                                                                  width: width *
                                                                      0.005,
                                                                  height:
                                                                      width *
                                                                          0.075,
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                                Icon(
                                                                    Icons
                                                                        .circle_outlined,
                                                                    color: Colors
                                                                        .red,
                                                                    size: width *
                                                                        0.05),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                                width: width *
                                                                    0.03),
                                                            Expanded(
                                                              child: Column(
                                                                children: [
                                                                  SizedBox(
                                                                    height:
                                                                        width *
                                                                            0.1,
                                                                    child:
                                                                        TextFormField(
                                                                      controller:
                                                                          sendPickupController,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              width * 0.035),
                                                                      decoration:
                                                                          InputDecoration(
                                                                        hintText:
                                                                            'Pickup Location',
                                                                        hintStyle:
                                                                            TextStyle(fontSize: width * 0.035),
                                                                        suffixIcon:
                                                                            GestureDetector(
                                                                          onTap:
                                                                              () {},
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                EdgeInsets.only(bottom: width * 0.005),
                                                                            child:
                                                                                Icon(Icons.my_location_rounded),
                                                                          ),
                                                                        ),
                                                                        filled:
                                                                            true,
                                                                        fillColor: Colors
                                                                            .grey
                                                                            .withOpacity(0.25),
                                                                        contentPadding:
                                                                            EdgeInsets.symmetric(
                                                                          vertical:
                                                                              width * 0.015,
                                                                          horizontal:
                                                                              width * 0.03,
                                                                        ),
                                                                        border:
                                                                            OutlineInputBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(width * 0.03),
                                                                          borderSide:
                                                                              BorderSide.none,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                      height: width *
                                                                          0.03),
                                                                  SizedBox(
                                                                    height:
                                                                        width *
                                                                            0.1,
                                                                    child:
                                                                        TextFormField(
                                                                      controller:
                                                                          sendDropController,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              width * 0.035),
                                                                      decoration:
                                                                          InputDecoration(
                                                                        hintText:
                                                                            'Drop-off Location',
                                                                        hintStyle:
                                                                            TextStyle(fontSize: width * 0.035),
                                                                        filled:
                                                                            true,
                                                                        fillColor: Colors
                                                                            .grey
                                                                            .withOpacity(0.25),
                                                                        contentPadding:
                                                                            EdgeInsets.symmetric(
                                                                          vertical:
                                                                              width * 0.015,
                                                                          horizontal:
                                                                              width * 0.03,
                                                                        ),
                                                                        border:
                                                                            OutlineInputBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(width * 0.03),
                                                                          borderSide:
                                                                              BorderSide.none,
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
                                                Container(
                                                  width: width * 0.7,
                                                  // width: double.infinity,
                                                  // height: 10,
                                                  decoration: BoxDecoration(
                                                    // color: Colors.white,

                                                    color: ColorConstant.color1
                                                        .withOpacity(.125),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                width * 0.02)),
                                                  ),
                                                  child: Center(
                                                      child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SizedBox(
                                                        height: width * .0125,
                                                      ),
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .info_outline_rounded,
                                                            color: Colors.blue,
                                                            size: width * .045,
                                                          ),
                                                          SizedBox(
                                                            width:
                                                                width * .0125,
                                                          ),
                                                          Text(
                                                            "Package Verification Required",
                                                            style: TextStyle(
                                                                fontSize:
                                                                    width *
                                                                        .0325),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: width * .0125,
                                                      ),
                                                      Text(
                                                        "All packages will be scanned and verified for \nsafety before pickup",
                                                        style: TextStyle(
                                                            fontSize:
                                                                width * .025),
                                                      ),
                                                      SizedBox(
                                                        height: width * .0125,
                                                      ),
                                                    ],
                                                  )),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    SentPackage();
                                                    // checkAndPrintLocationFields(); // Handle submit
                                                  },
                                                  child: Container(
                                                    width: width * .7,
                                                    height: width * .1,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          ColorConstant.color1,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  width * .02)),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        "NEXT",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),

                                    Builder(
                                      builder: (context) {
                                        double width =
                                            MediaQuery.of(context).size.width;
                                        return Container(
                                          decoration: BoxDecoration(
                                            // color: Colors.lightBlue
                                            //     .withOpacity(.175),
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(width * .02)),
                                          ),
                                          child: Padding(
                                            padding:
                                                EdgeInsets.all(width * .02),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    // Circular icon
                                                    Container(
                                                      width: width * 0.12,
                                                      height: width * 0.12,
                                                      decoration: BoxDecoration(
                                                        // color: Colors.white
                                                        //     .withOpacity(0.4),
                                                        color: ColorConstant
                                                            .color1
                                                            .withOpacity(.25),
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Center(
                                                        child: Transform.rotate(
                                                          angle:
                                                              pi, // 180 degrees in radians
                                                          child:
                                                              SvgPicture.asset(
                                                            "assets/icons/paper-plane-svgrepo-com.svg",
                                                            height:
                                                                width * 0.05,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                        width: width * 0.05),

                                                    // Texts
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          "Quick Recieve",
                                                          style: TextStyle(
                                                              fontSize:
                                                                  width * 0.045,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              // color: Colors.black,
                                                              color: ColorConstant
                                                                  .color11
                                                                  .withOpacity(
                                                                      .7)),
                                                        ),
                                                        Text(
                                                          "Fast & reliable delivery service",
                                                          style: TextStyle(
                                                              fontSize:
                                                                  width * 0.032,
                                                              // color: Colors.black,
                                                              color:
                                                                  ColorConstant
                                                                      .textColor3
                                                              // .withOpacity(
                                                              //     .5)
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                // SizedBox(
                                                //   height: width * .025,
                                                // ),
                                                Container(
                                                  // width: width * 0.7,
                                                  width: double.infinity,

                                                  // padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                width * 0.02)),
                                                  ),
                                                  child: Padding(
                                                    padding: EdgeInsets.all(
                                                        width * .0125),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        // Row: Icons and Text Fields
                                                        Row(
                                                          // crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            // Icons column
                                                            Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceEvenly,
                                                              // crossAxisAlignment: CrossAxisAlignment.center,
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                Icon(
                                                                    Icons
                                                                        .circle_outlined,
                                                                    color: Colors
                                                                        .blue,
                                                                    size: width *
                                                                        0.05),
                                                                Container(
                                                                  width: width *
                                                                      0.005,
                                                                  height:
                                                                      width *
                                                                          0.075,
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                                Icon(
                                                                    Icons
                                                                        .circle_outlined,
                                                                    color: Colors
                                                                        .red,
                                                                    size: width *
                                                                        0.05),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                                width: width *
                                                                    0.03),
                                                            // Text fields column
                                                            Expanded(
                                                              child: Column(
                                                                children: [
                                                                  SizedBox(
                                                                    height:
                                                                        width *
                                                                            0.1,
                                                                    child:
                                                                        TextFormField(
                                                                      controller:
                                                                          receivePickupController,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              width * 0.035),
                                                                      decoration:
                                                                          InputDecoration(
                                                                        hintText:
                                                                            'Pickup Location',
                                                                        hintStyle:
                                                                            TextStyle(fontSize: width * 0.035),
                                                                        // suffixIcon: Padding(
                                                                        //     padding: EdgeInsets.all(width * 0.025),
                                                                        //     child: Icon(Icons.my_location_rounded)),
                                                                        filled:
                                                                            true,
                                                                        fillColor: Colors
                                                                            .grey
                                                                            .withOpacity(0.25),
                                                                        contentPadding:
                                                                            EdgeInsets.symmetric(
                                                                          vertical:
                                                                              width * 0.015,
                                                                          horizontal:
                                                                              width * 0.03,
                                                                        ),
                                                                        border:
                                                                            OutlineInputBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(width * 0.03),
                                                                          borderSide:
                                                                              BorderSide.none,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                      height: width *
                                                                          0.03),
                                                                  SizedBox(
                                                                    height:
                                                                        width *
                                                                            0.1,
                                                                    child:
                                                                        TextFormField(
                                                                      controller:
                                                                          receiveDropController,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              width * 0.035),
                                                                      decoration:
                                                                          InputDecoration(
                                                                        hintText:
                                                                            'Drop-off Location',
                                                                        hintStyle:
                                                                            TextStyle(fontSize: width * 0.035),
                                                                        suffixIcon: Padding(
                                                                            padding:
                                                                                EdgeInsets.only(bottom: width * 0.005),
                                                                            child: Icon(Icons.my_location_rounded)),
                                                                        filled:
                                                                            true,
                                                                        fillColor: Colors
                                                                            .grey
                                                                            .withOpacity(0.25),
                                                                        contentPadding:
                                                                            EdgeInsets.symmetric(
                                                                          vertical:
                                                                              width * 0.015,
                                                                          horizontal:
                                                                              width * 0.03,
                                                                        ),
                                                                        border:
                                                                            OutlineInputBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(width * 0.03),
                                                                          borderSide:
                                                                              BorderSide.none,
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
                                                Container(
                                                  width: width * 0.7,
                                                  // height: 10,
                                                  decoration: BoxDecoration(
                                                    // color: Colors.white,

                                                    color: ColorConstant.color1
                                                        .withOpacity(.125),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                width * 0.02)),
                                                  ),
                                                  child: Center(
                                                      child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SizedBox(
                                                        height: width * .0125,
                                                      ),
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .info_outline_rounded,
                                                            color: Colors.blue,
                                                            size: width * .045,
                                                          ),
                                                          Text(
                                                            "Package Verification Required",
                                                            style: TextStyle(
                                                                fontSize:
                                                                    width *
                                                                        .0325),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: width * .0125,
                                                      ),
                                                      Text(
                                                        "All packages will be scanned and verified for \nsafety before pickup",
                                                        style: TextStyle(
                                                            fontSize:
                                                                width * .025),
                                                      ),
                                                      SizedBox(
                                                        height: width * .0125,
                                                      ),
                                                    ],
                                                  )),
                                                ),
                                                // SizedBox(
                                                //   height: width * .025,
                                                // ),
                                                GestureDetector(
                                                  onTap: () {
                                                    RecievePackage(); // checkAndPrintLocationFields();
                                                  },
                                                  child: Container(
                                                    width: width * .7,
                                                    height: width * .1,
                                                    decoration: BoxDecoration(
                                                        color: ColorConstant
                                                            .color1,
                                                        // color: Colors.blue,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    width *
                                                                        .02))),
                                                    child: Center(
                                                      child: Text(
                                                        "NEXT",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      },
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// class sendPackage extends StatefulWidget {
//   const sendPackage({super.key});

//   @override
//   State<sendPackage> createState() => _sendPackageState();
// }

// class _sendPackageState extends State<sendPackage> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//           color: Colors.lightBlue.withOpacity(.175),
//           // color: ColorConstant.color1.withOpacity(.25),
//           borderRadius: BorderRadius.all(Radius.circular(width * .02))),
//       child: Padding(
//         padding: EdgeInsets.all(width * .02),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 // Circular icon
//                 Container(
//                   width: width * 0.12,
//                   height: width * 0.12,
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.4),
//                     shape: BoxShape.circle,
//                   ),
//                   child: Center(
//                     child: SvgPicture.asset(
//                       "assets/icons/paper-plane-svgrepo-com.svg",
//                       height: width * .05,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: width * 0.05),

//                 // Texts
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Text(
//                       "Quick Send",
//                       style: TextStyle(
//                         fontSize: width * 0.045,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black,
//                       ),
//                     ),
//                     Text(
//                       "Fast & reliable delivery service",
//                       style: TextStyle(
//                         fontSize: width * 0.032,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             // SizedBox(
//             //   height: width * .025,
//             // ),
//             Container(
//               width: width * 0.7,

//               // padding: EdgeInsets.symmetric(horizontal: width * 0.03),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.all(Radius.circular(width * 0.02)),
//               ),
//               child: Padding(
//                 padding: EdgeInsets.all(width * .0125),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     // Row: Icons and Text Fields
//                     Row(
//                       // crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         // Icons column
//                         Column(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           // crossAxisAlignment: CrossAxisAlignment.center,
//                           mainAxisSize: MainAxisSize.max,
//                           children: [
//                             Icon(Icons.circle_outlined,
//                                 color: Colors.blue, size: width * 0.05),
//                             Container(
//                               width: width * 0.005,
//                               height: width * 0.075,
//                               color: Colors.grey,
//                             ),
//                             Icon(Icons.circle_outlined,
//                                 color: Colors.red, size: width * 0.05),
//                           ],
//                         ),
//                         SizedBox(width: width * 0.03),
//                         // Text fields column
//                         Expanded(
//                           child: Column(
//                             children: [
//                               SizedBox(
//                                 height: width * 0.1,
//                                 child: TextFormField(
//                                   // controller: pickUpLocation.text,
//                                   style: TextStyle(fontSize: width * 0.035),
//                                   decoration: InputDecoration(
//                                     hintText: 'Pickup Location',
//                                     hintStyle:
//                                         TextStyle(fontSize: width * 0.035),
//                                     suffixIcon: Padding(
//                                         padding: EdgeInsets.only(
//                                             bottom: width * 0.005),
//                                         child: Icon(Icons.my_location_rounded)),
//                                     filled: true,
//                                     fillColor: Colors.grey.withOpacity(0.25),
//                                     contentPadding: EdgeInsets.symmetric(
//                                       vertical: width * 0.015,
//                                       horizontal: width * 0.03,
//                                     ),
//                                     border: OutlineInputBorder(
//                                       borderRadius:
//                                           BorderRadius.circular(width * 0.03),
//                                       borderSide: BorderSide.none,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(height: width * 0.03),
//                               SizedBox(
//                                 height: width * 0.1,
//                                 child: TextFormField(
//                                   style: TextStyle(fontSize: width * 0.035),
//                                   decoration: InputDecoration(
//                                     hintText: 'Drop-off Location',
//                                     hintStyle:
//                                         TextStyle(fontSize: width * 0.035),
//                                     // suffixIcon: Padding(
//                                     //   padding: EdgeInsets.all(width * 0.025),
//                                     //   child: Container(
//                                     //     width: width * 0.025,
//                                     //     height: width * 0.025,
//                                     //     decoration: BoxDecoration(
//                                     //       color: Colors.red,
//                                     //       shape: BoxShape.circle,
//                                     //     ),
//                                     //   ),
//                                     // ),
//                                     filled: true,
//                                     fillColor: Colors.grey.withOpacity(0.25),
//                                     contentPadding: EdgeInsets.symmetric(
//                                       vertical: width * 0.015,
//                                       horizontal: width * 0.03,
//                                     ),
//                                     border: OutlineInputBorder(
//                                       borderRadius:
//                                           BorderRadius.circular(width * 0.03),
//                                       borderSide: BorderSide.none,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             // SizedBox(
//             //   height: width * .025,
//             // ),
//             GestureDetector(
//               onTap: () {
//                 // submitrequest(
//                 //   pickUpLocation.text.trim(),
//                 //   dropOffLocation.text.trim(),
//                 // );
//               },
//               child: Container(
//                 width: width * .7,
//                 height: width * .1,
//                 decoration: BoxDecoration(
//                     // color: ColorConstant.color1,
//                     color: Colors.blue,
//                     borderRadius:
//                         BorderRadius.all(Radius.circular(width * .02))),
//                 child: Center(
//                   child: Text(
//                     "NEXT",
//                     style: TextStyle(
//                         fontWeight: FontWeight.bold, color: Colors.white),
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

// class recievePackage extends StatefulWidget {
//   const recievePackage({super.key});

//   @override
//   State<recievePackage> createState() => _recievePackageState();
// }

// class _recievePackageState extends State<recievePackage> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//           // color: Colors.lightBlue.withOpacity(.175),
//           color: ColorConstant.color1,
//           borderRadius: BorderRadius.all(Radius.circular(width * .02))),
//       child: Padding(
//         padding: EdgeInsets.all(width * .02),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 // Circular icon
//                 Container(
//                   width: width * 0.12,
//                   height: width * 0.12,
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.4),
//                     shape: BoxShape.circle,
//                   ),
//                   child: Center(
//                     child: Transform.rotate(
//                       angle: pi, // 180 degrees in radians
//                       child: SvgPicture.asset(
//                         "assets/icons/paper-plane-svgrepo-com.svg",
//                         height: width * 0.05,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: width * 0.05),

//                 // Texts
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Text(
//                       "Quick Recieve",
//                       style: TextStyle(
//                         fontSize: width * 0.045,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                     Text(
//                       "Fast & reliable delivery service",
//                       style: TextStyle(
//                         fontSize: width * 0.032,
//                         color: Colors.white70,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             // SizedBox(
//             //   height: width * .025,
//             // ),
//             Container(
//               width: width * 0.7,

//               // padding: EdgeInsets.symmetric(horizontal: width * 0.03),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.all(Radius.circular(width * 0.02)),
//               ),
//               child: Padding(
//                 padding: EdgeInsets.all(width * .0125),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     // Row: Icons and Text Fields
//                     Row(
//                       // crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         // Icons column
//                         Column(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           // crossAxisAlignment: CrossAxisAlignment.center,
//                           mainAxisSize: MainAxisSize.max,
//                           children: [
//                             Icon(Icons.circle_outlined,
//                                 color: Colors.blue, size: width * 0.05),
//                             Container(
//                               width: width * 0.005,
//                               height: width * 0.075,
//                               color: Colors.grey,
//                             ),
//                             Icon(Icons.circle_outlined,
//                                 color: Colors.red, size: width * 0.05),
//                           ],
//                         ),
//                         SizedBox(width: width * 0.03),
//                         // Text fields column
//                         Expanded(
//                           child: Column(
//                             children: [
//                               SizedBox(
//                                 height: width * 0.1,
//                                 child: TextFormField(
//                                   style: TextStyle(fontSize: width * 0.035),
//                                   decoration: InputDecoration(
//                                     hintText: 'Pickup Location',
//                                     hintStyle:
//                                         TextStyle(fontSize: width * 0.035),
//                                     // suffixIcon: Padding(
//                                     //     padding: EdgeInsets.all(width * 0.025),
//                                     //     child: Icon(Icons.my_location_rounded)),
//                                     filled: true,
//                                     fillColor: Colors.grey.withOpacity(0.25),
//                                     contentPadding: EdgeInsets.symmetric(
//                                       vertical: width * 0.015,
//                                       horizontal: width * 0.03,
//                                     ),
//                                     border: OutlineInputBorder(
//                                       borderRadius:
//                                           BorderRadius.circular(width * 0.03),
//                                       borderSide: BorderSide.none,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(height: width * 0.03),
//                               SizedBox(
//                                 height: width * 0.1,
//                                 child: TextFormField(
//                                   style: TextStyle(fontSize: width * 0.035),
//                                   decoration: InputDecoration(
//                                     hintText: 'Drop-off Location',
//                                     hintStyle:
//                                         TextStyle(fontSize: width * 0.035),
//                                     suffixIcon: Padding(
//                                         padding: EdgeInsets.only(
//                                             bottom: width * 0.005),
//                                         child: Icon(Icons.my_location_rounded)),
//                                     filled: true,
//                                     fillColor: Colors.grey.withOpacity(0.25),
//                                     contentPadding: EdgeInsets.symmetric(
//                                       vertical: width * 0.015,
//                                       horizontal: width * 0.03,
//                                     ),
//                                     border: OutlineInputBorder(
//                                       borderRadius:
//                                           BorderRadius.circular(width * 0.03),
//                                       borderSide: BorderSide.none,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             // SizedBox(
//             //   height: width * .025,
//             // ),
//             Container(
//               width: width * .7,
//               height: width * .1,
//               decoration: BoxDecoration(
//                   // color: ColorConstant.color1,
//                   color: Colors.blue,
//                   borderRadius: BorderRadius.all(Radius.circular(width * .02))),
//               child: Center(
//                 child: Text(
//                   "NEXT",
//                   style: TextStyle(
//                       fontWeight: FontWeight.bold, color: Colors.white),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
