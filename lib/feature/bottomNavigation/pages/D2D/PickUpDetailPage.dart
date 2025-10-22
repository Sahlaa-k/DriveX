import 'dart:convert';

import 'package:drivex/core/constants/color_constant.dart';
import 'package:drivex/core/constants/localVariables.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class Pickupdetailpage extends StatefulWidget {
  const Pickupdetailpage({super.key});

  @override
  State<Pickupdetailpage> createState() => _PickupdetailpageState();
}

class _PickupdetailpageState extends State<Pickupdetailpage> {
  final TextEditingController toController = TextEditingController();

  final FocusNode toFocus = FocusNode();
  final String apiKey = "AIzaSyDwD1BJXVxky_Cy6xzyQh_5A2PW9cTOO0I";
  List<dynamic> suggestions = [];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: ColorConstant.color1.withOpacity(.15),
        child: Stack(
          children: [
            Container(
              height: height * 1,
              child: SingleChildScrollView(
                child: SafeArea(
                    child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * .02),
                  child: Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: width * .1,
                        ),
                        Image.asset(
                          'assets/images/DeliveryMan.png',
                          width: width * .6,

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
                                  border: Border.all(
                                      width: width * .005,
                                      color: Colors.black.withOpacity(.1)),
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
                                            color:
                                                Colors.black.withOpacity(.25)),
                                        color:
                                            Colors.red, // Change for "To" field
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
                                              color:
                                                  Colors.black.withOpacity(.75),
                                              fontSize: width * 0.035,
                                            ),
                                          ),
                                          // hintText:
                                          //     "Al Shifa Hospital Rd, Valiyangadi...",
                                          hintStyle: TextStyle(
                                              fontSize: width * .035,
                                              color:
                                                  Colors.black.withOpacity(.5)),
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
                        )
                      ],
                    ),
                  ),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
