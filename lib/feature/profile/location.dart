import 'package:drivex/core/constants/color_constant.dart';
import 'package:drivex/core/constants/localVariables.dart';
import 'package:drivex/core/widgets/BackGroundTopGradient.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Backgroundtopgradient(
          child: Column(
        children: [
          SizedBox(height: width * 0.07),

          /// HEADER
          Padding(
            padding: EdgeInsets.all(width * 0.03),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.arrow_back_ios,
                      color: ColorConstant.thirdColor.withOpacity(0.7),
                      size: width * 0.045),
                ),
                Expanded(
                  child: Center(
                    child: Text("Location",
                        style: TextStyle(
                            fontSize: width * 0.05,
                            fontWeight: FontWeight.w600,
                            color: ColorConstant.thirdColor.withOpacity(0.7))),
                  ),
                ),
                SizedBox(width: width * 0.045), // balance space
              ],
            ),
          ),
          Row(
            children: [
              Container(
                height: width * 0.11,
                width: width,
                child: Padding(
                  padding:
                      EdgeInsets.only(right: width * 0.03, left: width * 0.03),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: searchController,
                          style: TextStyle(
                            color: ColorConstant.thirdColor,
                          ),
                          textCapitalization: TextCapitalization.none,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: ColorConstant.bgColor,
                            prefixIcon: Icon(CupertinoIcons.search),
                            prefixIconColor:
                                ColorConstant.thirdColor.withOpacity(0.4),
                            hintText: "Search Location",
                            hintStyle: TextStyle(
                                color:
                                    ColorConstant.thirdColor.withOpacity(0.4),
                                fontSize: width * 0.03),
                            contentPadding:
                                EdgeInsets.symmetric(vertical: width * 0.01),
                            // border: OutlineInputBorder(
                            //   borderSide: BorderSide(
                            //       color: ColorConstant.color11.withOpacity(0.4),
                            //       width: width * 0.002),
                            //   borderRadius: BorderRadius.circular(width * 0.06),
                            // ),
                            // enabledBorder: OutlineInputBorder(
                            //   borderSide: BorderSide(
                            //       color: ColorConstant.color11.withOpacity(0.4),
                            //       width: width * 0.002),
                            //   borderRadius: BorderRadius.circular(width * 0.06),
                            // ),
                            // focusedBorder: OutlineInputBorder(
                            //   borderSide: BorderSide(
                            //       color: ColorConstant.color11.withOpacity(0.4),
                            //       width: width * 0.002),
                            //   borderRadius: BorderRadius.circular(width * 0.06),
                            // ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(30),
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
          SizedBox(height: width*0.03,),
          Padding(
            padding: EdgeInsets.all(width * 0.035),
            child: Row(
              children: [
                Icon(
                  Icons.location_searching,
                  color: ColorConstant.color11.withOpacity(0.7),
                  size: width * 0.052,
                ),
                SizedBox(
                  width: width * 0.03,
                ),
                Text(
                  "Use Current Location",
                  style: TextStyle(
                      color: ColorConstant.thirdColor, fontSize: width * 0.043,fontWeight: FontWeight.w500),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(width * 0.035),
            child: Row(
              children: [
                Icon(
                  CupertinoIcons.location,
                  color: ColorConstant.color11.withOpacity(0.7),
                  size: width * 0.052,
                ),
                SizedBox(
                  width: width * 0.03,
                ),
                Text(
                  "Choose from Map",
                  style: TextStyle(
                      color: ColorConstant.thirdColor, fontSize: width * 0.043,fontWeight: FontWeight.w500),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: width * 0.03, right: width * 0.03, top: width * 0.03),
            child: Row(
              children: [
                Text("Saved Locations",
                    style: TextStyle(
                        fontSize: width * 0.048,
                        fontWeight: FontWeight.w600,
                        color: ColorConstant.thirdColor.withOpacity(0.7))),
              Spacer(),
              Icon(CupertinoIcons.add,color: ColorConstant.color11.withOpacity(0.7),
            size: width * 0.045,)],
            ),
          ),
          ListView.builder(
            itemCount: 3,
            shrinkWrap: true,
            padding: EdgeInsets.all(width * 0.03),
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(bottom: width * 0.03),
                child: Container(
                  height: width * 0.2,
                  width: width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(width * 0.03),
                    ),
                    color:
                        Colors.white, // optional, background needed for shadow
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1), // shadow color
                        blurRadius: width * 0.04, // soft blur
                        spreadRadius: width * 0.005, // how much it spreads
                        offset: Offset(0, 0), // keeps shadow equal on all sides
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(width * 0.03),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              CupertinoIcons.home,
                              color: ColorConstant.color11.withOpacity(0.7),
                              size: width * 0.045,
                            ),
                            SizedBox(
                              width: width * 0.03,
                            ),
                            Text(
                              "Home",
                              style: TextStyle(
                                  color: ColorConstant.thirdColor,
                                  fontSize: width * 0.04),
                            ),
                            Spacer(),
                            Icon(
                              Icons.mode_edit_outline_outlined,
                              color: ColorConstant.color11.withOpacity(0.7),
                              size: width * 0.045,
                            ),
                            SizedBox(
                              width: width * 0.02,
                            ),
                            Icon(
                              CupertinoIcons.delete,
                              color: ColorConstant.color11.withOpacity(0.7),
                              size: width * 0.05,
                            ),
                          ],
                        ),
                        SizedBox(height: width*0.02,)
,                       Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Samar pally road,203987 , SA pally, Krishpoooram,Malappuram",
                                overflow: TextOverflow.ellipsis, // adds "..."
                                maxLines: 1, // keeps text in one line
                                style: TextStyle(
                                  fontSize: width * 0.035, // optional
                                  color: Colors.black54, // optional
                                ),
                              ),
                            ),
                          ],
                        )

                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      )),
    );
  }
}
