import 'package:drivex/core/constants/color_constant.dart';
import 'package:drivex/core/constants/localVariables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CabPage extends StatefulWidget {
  const CabPage({super.key});

  @override
  State<CabPage> createState() => _CabPageState();
}

class _CabPageState extends State<CabPage> {
  TextEditingController searchController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.bgColor,
      body:SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.all(width*0.03),
          child: Column(
            children: [
              SizedBox(height: width * 0.07),
              Row(
                children: [
                  Spacer(),
                  Text(
                    "Find Cab",
                    style: TextStyle(
                      color: ColorConstant.color11,
                      fontWeight: FontWeight.w600,
                      fontSize: width * 0.055,
                    ),
                  ),
                  Spacer(),

                ],
              ),
              SizedBox(height: width * 0.03),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: width * 0.11,

                      child: Expanded(
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
                            fillColor: ColorConstant.color11.withOpacity(0.1),
                            prefixIcon: Icon(CupertinoIcons.search),
                            prefixIconColor:
                            ColorConstant.color11.withOpacity(0.7),
                            hintText: "Search here!",
                            hintStyle: TextStyle(
                                color:
                                ColorConstant.thirdColor.withOpacity(0.4),
                                fontSize: width * 0.03),
                            contentPadding:
                            EdgeInsets.symmetric(vertical: width * 0.01),

                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(width * 0.03),
                              borderSide: BorderSide(color: ColorConstant.bgColor, width: 1),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(width * 0.03),
                              borderSide: BorderSide(color: ColorConstant.bgColor, width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(width * 0.03),
                              borderSide: BorderSide(color: ColorConstant.bgColor, width: 1),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: width * 0.03),

              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: width * 0.2,
                        width: width * 0.2,
                        margin: EdgeInsets.only(
                            right: width * 0.02, bottom: width * 0.01),
                        decoration: BoxDecoration(
                          color: ColorConstant.bgColor,
                          borderRadius: BorderRadius.all(
                            Radius.circular(width * 0.03),
                          ),
                        ),child: Center(
                        child: SvgPicture.asset(
                          "assets/icons/sedan.svg",
                          height: width * 0.13,
                        ),
                      ),

                      ),
                      Text(
                        "Sedan",
                        style: TextStyle(
                          color: ColorConstant.thirdColor.withOpacity(0.7),
                          fontWeight: FontWeight.w600,
                          fontSize: width * 0.032, // reduced font size
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: width * 0.22,
                        width: width * 0.22,
                        margin: EdgeInsets.only(
                            right: width * 0.02, bottom: width * 0.01),
                        decoration: BoxDecoration(
                          color: ColorConstant.bgColor,
                          borderRadius: BorderRadius.all(
                            Radius.circular(width * 0.03),
                          ),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            "assets/icons/auto-rickshaw.svg",
                            height: width * 0.13,
                          ),
                        ),
                      ),
                      Text(
                        "Auto",
                        style: TextStyle(
                          color: ColorConstant.thirdColor.withOpacity(0.7),
                          fontWeight: FontWeight.w600,
                          fontSize: width * 0.032, // reduced font size
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: width * 0.2,
                        width: width * 0.2,
                        margin: EdgeInsets.only(
                            right: width * 0.02, bottom: width * 0.01),
                        decoration: BoxDecoration(
                          color: ColorConstant.bgColor,
                          borderRadius: BorderRadius.all(
                            Radius.circular(width * 0.03),
                          ),
                        ),child: Center(
                        child: SvgPicture.asset(
                          "assets/icons/taxi.svg",
                          height: width * 0.13,
                        ),
                      ),

                      ),
                      Text(
                        "Taxi",
                        style: TextStyle(
                          color: ColorConstant.thirdColor.withOpacity(0.7),
                          fontWeight: FontWeight.w600,
                          fontSize: width * 0.032, // reduced font size
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: width * 0.2,
                        width: width * 0.2,
                        margin: EdgeInsets.only(
                            right: width * 0.02, bottom: width * 0.01),
                        decoration: BoxDecoration(
                          color: ColorConstant.bgColor,
                          borderRadius: BorderRadius.all(
                            Radius.circular(width * 0.03),
                          ),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            "assets/icons/SUV.svg",
                            height: width * 0.13,
                          ),
                        ),
                      ),
                      Text(
                        "SUV",
                        style: TextStyle(
                          color: ColorConstant.thirdColor.withOpacity(0.7),
                          fontWeight: FontWeight.w600,
                          fontSize: width * 0.032, // reduced font size
                        ),
                      ),
                    ],
                  ),

                ],
              )
            ],
          ),
        ),
      ) ,
    );
  }
}
