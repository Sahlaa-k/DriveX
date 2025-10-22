import 'package:drivex/core/constants/color_constant.dart';
import 'package:drivex/core/constants/localVariables.dart';
import 'package:drivex/core/widgets/BackGroundTopGradient.dart';
import 'package:drivex/feature/drivers_page/screens/driver_booking.dart';
import 'package:drivex/feature/drivers_page/screens/driver_location_setting.dart';
import 'package:drivex/feature/drivers_page/screens/driver_review.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DriverProfilePage extends StatefulWidget {
  final Map<String, dynamic> driverData;

  const DriverProfilePage({super.key, required this.driverData});

  @override
  State<DriverProfilePage> createState() => _DriverProfilePageState();
}

class _DriverProfilePageState extends State<DriverProfilePage> {
  bool isExpanded = false;

  final List<Map<String, dynamic>> driverStats = [
    {
      "icon": "assets/icons/car-family-vacation.svg",
      "label": "Customer",
      "value": "7,500+",
      "page":"",
    },
    {
      "icon": "assets/icons/number-blocks.svg",
      "label": "Years Exp.",
      "value": "10+",
      "page":"",
    },

    {
      "icon": "assets/icons/review-customer.svg",
      "label": "Rating",
      "value": "4.5",
      "page":ReviewsPage()
    },
  ];

  final List<Map<String, dynamic>> reviews = [
    {
      "name": "Ayesha M",
      "rating": 4,
      "timeAgo": "1 week ago",
      "review":
          "Very knowledgeable and on time. The clinic was clean and staff were polite.",
    },
    {
      "name": "Sarah K",
      "rating": 5,
      "timeAgo": "2 weeks ago",
      "review":
          "Dr. Laila is incredible. She explained everything clearly and supported me during my first pregnancy.",
    },
    {
      "name": "Mohammed R",
      "rating": 5,
      "timeAgo": "3 weeks ago",
      "review":
          "Excellent service and very professional doctor. Highly recommend!",
    },
  ];

  List gradientColor = [
    Colors.blue.withOpacity(0.2),
    Colors.greenAccent.withOpacity(0.2),
    Colors.redAccent.withOpacity(0.2),
    Colors.brown.withOpacity(0.2),
  ];
  int _priceMode = 0; // 0 = Per Day, 1 = Transport

// demo numbers – swap with your real values
  final int _dayRate = 2000;          // ₹/day (8 hr)
  final int _overtimePerHour = 300;   // ₹/hr after 8 hr
  final bool _nightApplied = false;   // if you need to toggle
  final double _nightPct = 0.10;      // +10%

  final int _baseFare = 200;          // transport base
  final int _freeKm = 10;             // free km
  final int _perKm = 12;              // ₹/km after free
  final int _estKm = 41;              // example distance

  num get _perDayTotal {
    final base = _dayRate + _overtimePerHour; // add overtime demo
    final nightAdd = _nightApplied ? base * _nightPct : 0;
    return base + nightAdd;
  }

  num get _tripTotal {
    final extra = _estKm > _freeKm ? (_estKm - _freeKm) * _perKm : 0;
    return _baseFare + extra;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.bgColor,
      body: SingleChildScrollView(
        child: Backgroundtopgradient(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                        child: Text("Driver Details",
                            style: TextStyle(
                                fontSize: width * 0.048,
                                fontWeight: FontWeight.w600,
                                color:
                                    ColorConstant.thirdColor.withOpacity(0.7))),
                      ),
                    ),
                    SizedBox(width: width * 0.045), // balance space
                  ],
                ),
              ),

              SizedBox(height: width * 0.05),

              /// DRIVER IMAGE + NAME + LOCATION
              Column(
                children: [
                  Container(
                    width: width * 0.25,
                    height: width * 0.25,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage(widget.driverData["image"]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: width * 0.02),
                  Text(widget.driverData["name"],
                      style: TextStyle(
                          fontSize: width * 0.045,
                          fontWeight: FontWeight.bold,
                          color: ColorConstant.thirdColor.withOpacity(0.7))),
                  SizedBox(height: width * 0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                    CircleAvatar(
                      radius: width*0.015,
                      backgroundColor:  Color(0xFF14A86A),
                    ),
                      SizedBox(width: width * 0.01),
                      Text("Available Now",
                          style: TextStyle(color: ColorConstant.textColor3)),

                    ],
                  ),
                  SizedBox(height: width * 0.01),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/icons/location-pin (1).svg",
                        height: width * 0.03,
                        color: ColorConstant.color11.withOpacity(0.7),
                      ),
                      SizedBox(width: width * 0.01),
                      Text(widget.driverData["location"] ?? "Perinthalmanna, kerala",
                          style: TextStyle(color: ColorConstant.textColor3)),
                    ],
                  ),
                ],
              ),

              SizedBox(
                height: width * 0.05,
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: width * 0.03, right: width * 0.03, top: width * 0.03),
                child: SizedBox(
                  width: width,

                  child: GridView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsetsGeometry.all(0),
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: driverStats.length,
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: width * 0.4, // each tile can be ~48% of width
                      crossAxisSpacing: width * 0.02,
                      mainAxisSpacing: width * 0.02,
                      childAspectRatio: 1.8,            // makes them wider than tall
                    ),

                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => driverStats[index]["page"],));
                        },
                        child: Container(

                          decoration: BoxDecoration(
                            border: Border.all(
                              color: ColorConstant.thirdColor.withOpacity(0.2),
                            ),
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(width * 0.02),
                          ),
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.all(width * 0.02),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(width: width*0.04),

                                      SvgPicture.asset(
                                        driverStats[index]["icon"],
                                        color: ColorConstant.color11.withOpacity(0.9),
                                        height: width * 0.06,
                                      ),
                                      SizedBox(width: width*0.03),

                                      Text(
                                        driverStats[index]["value"],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: width * 0.03,
                                          overflow: TextOverflow
                                              .ellipsis, // Prevents overflow
                                        ),
                                        maxLines: 1,
                                      ),
                                    ],
                                  ),


                                  SizedBox(height: 2),
                                  Text(
                                    driverStats[index]["label"],
                                    style: TextStyle(

                                      fontSize: width * 0.032,
                                      overflow: TextOverflow
                                          .ellipsis, // Prevents overflow
                                    ),
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: width*0.03),



              /// ABOUT SECTION
              Padding(
                padding:
                    EdgeInsets.only(left: width * 0.03, right: width * 0.03),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "About",
                      style: TextStyle(
                          color: ColorConstant.color11,
                          fontWeight: FontWeight.w600,
                          fontSize: width * 0.044),
                    ),),
              ),
              SizedBox(height: 6),
              Padding(
                padding:
                    EdgeInsets.only(left: width * 0.03, right: width * 0.03),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Over 10 years of professional driving experience across multiple cities",
                      maxLines: isExpanded ? null : 1,
                      overflow: isExpanded
                          ? TextOverflow.visible
                          : TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: width * 0.035,
                        color: ColorConstant.textColor3,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isExpanded = !isExpanded;
                        });
                      },
                      child: Text(
                        isExpanded ? "View less" : "View more",
                        style: TextStyle(
                          color:  Color(0xFF14A86A),
                          fontSize: width * 0.035,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),






              SizedBox(height: width * 0.03),

              Padding(
                padding:
                EdgeInsets.only(left: width * 0.03, right: width * 0.03),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Languages",
                    style: TextStyle(
                        color: ColorConstant.color11,
                        fontWeight: FontWeight.w600,
                        fontSize: width * 0.044),
                  ),),
              ),
              SizedBox(height: 6),
              Padding(
                padding: EdgeInsets.only(left: width * 0.03, right: width * 0.03),
                child: Row(
                  children: [
                    // English (ticked)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.04,
                        vertical: width * 0.01,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(width * 0.01),
                        border: Border.all(color: const Color(0xFF000000).withOpacity(0.1), width: 1.2),
                      ),
                      child: Center(
                        child: Text(
                          "English",
                          style: TextStyle(
                            fontSize: width * 0.035,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF0E1726),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: width * 0.03),

                    // Malayalam (ticked)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.04,
                        vertical: width * 0.01,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(width * 0.01),
                        border: Border.all(color: const Color(0xFF000000).withOpacity(0.1), width: 1.2),
                      ),
                      child: Center(
                        child: Text(
                          "Malayalam",
                          style: TextStyle(
                            fontSize: width * 0.035,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF0E1726),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
,
              SizedBox(height: width * 0.03),
              Padding(
                padding:
                EdgeInsets.only(left: width * 0.03, right: width * 0.03),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Price Details",
                    style: TextStyle(
                        color: ColorConstant.color11,
                        fontWeight: FontWeight.w600,
                        fontSize: width * 0.044),
                  ),),
              ),

              // Mode selector (Per Day / Transport)
              Padding(
                padding: EdgeInsets.only(left: width * 0.03, right: width * 0.03, top: width * 0.02),
                child: Container(
                  padding: EdgeInsets.all(width * .01),
                  decoration: BoxDecoration(
                    //color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(width * .03),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => setState(() => _priceMode = 0),
                          borderRadius: BorderRadius.circular(width * .03),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: width * .028),
                            decoration: BoxDecoration(
                              color: _priceMode == 0 ? Colors.white : Colors.transparent,
                              borderRadius: BorderRadius.circular(width * .03),
                              border: Border.all(
                                color: _priceMode == 0 ? const Color(0xFF14A86A) : Colors.transparent,
                                width: 1.2,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "Per Day",
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: width * .036,
                                color: _priceMode == 0 ? const Color(0xFF14A86A) : const Color(0xFF6B7280),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: width * .02),
                      Expanded(
                        child: InkWell(
                          onTap: () => setState(() => _priceMode = 1),
                          borderRadius: BorderRadius.circular(width * .03),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: width * .028),
                            decoration: BoxDecoration(
                              color: _priceMode == 1 ? Colors.white : Colors.transparent,
                              borderRadius: BorderRadius.circular(width * .03),
                              border: Border.all(
                                color: _priceMode == 1 ? const Color(0xFF14A86A) : Colors.transparent,
                                width: 1.2,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "Transport",
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: width * .036,
                                color: _priceMode == 1 ? const Color(0xFF14A86A) : const Color(0xFF6B7280),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: width * 0.03, right: width * 0.03, top: width * 0.02),
                child: Container(
                  padding: EdgeInsets.all(width * 0.04),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(width * 0.04),
                    border: Border.all(color: const Color(0xFFEAECEE)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.04),
                        blurRadius: width * 0.04,
                        offset: Offset(0, width * 0.01),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        children: [
                          Text(
                            "Price Details",
                            style: TextStyle(
                              fontSize: width * 0.035,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF0E1726),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            "Estimated fare",
                            style: TextStyle(
                              fontSize: width * 0.034,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF14A86A),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: width * 0.03),


                      SizedBox(height: width * 0.03),

                      // ===== PER DAY CONTENT =====
                      if (_priceMode == 0) ...[
                        Row(
                          children: [
                            Expanded(
                              child: Text("Day rate ",
                                  style: TextStyle(fontSize: width * 0.038, color: const Color(0xFF111827))),
                            ),
                            Text("₹$_dayRate",
                                style: TextStyle(fontSize: width * 0.038, fontWeight: FontWeight.w600, color: const Color(0xFF111827))),
                          ],
                        ),
                        SizedBox(height: width * 0.02),
                        Divider(color: const Color(0xFFE5E7EB), height: width * 0.02),

                        Row(
                          children: [
                            Expanded(
                              child: Text("Overtime",
                                  style: TextStyle(fontSize: width * 0.038, color: const Color(0xFF111827))),
                            ),
                            Text("₹$_overtimePerHour / hr",
                                style: TextStyle(fontSize: width * 0.038, fontWeight: FontWeight.w600, color: const Color(0xFF111827))),
                          ],
                        ),
                        SizedBox(height: width * 0.02),
                        Divider(color: const Color(0xFFE5E7EB), height: width * 0.02),

                        Row(
                          children: [
                            Expanded(
                              child: Text("Night charge",
                                  style: TextStyle(fontSize: width * 0.038, color: const Color(0xFF111827))),
                            ),
                            Text(_nightApplied ? "+${(_nightPct * 100).toStringAsFixed(0)}%" : "—",
                                style: TextStyle(fontSize: width * 0.038, fontWeight: FontWeight.w600, color: const Color(0xFF111827))),
                          ],
                        ),
                        SizedBox(height: width * 0.02),
                        Divider(color: const Color(0xFFE5E7EB), height: width * 0.02),

                        Row(
                          children: [
                            Expanded(
                              child: Text("Total today",
                                  style: TextStyle(fontSize: width * 0.042, fontWeight: FontWeight.w800, color: const Color(0xFF0E1726))),
                            ),
                            Text("₹${_perDayTotal.toStringAsFixed(0)}",
                                style: TextStyle(fontSize: width * 0.05, fontWeight: FontWeight.w900, color: const Color(0xFF0E1726))),
                          ],
                        ),
                      ],

                      // ===== TRANSPORT CONTENT =====
                      if (_priceMode == 1) ...[
                        Row(
                          children: [
                            Expanded(
                              child: Text("Base fare",
                                  style: TextStyle(fontSize: width * 0.038, color: const Color(0xFF111827))),
                            ),
                            Text("₹$_baseFare",
                                style: TextStyle(fontSize: width * 0.038, fontWeight: FontWeight.w600, color: const Color(0xFF111827))),
                          ],
                        ),
                        SizedBox(height: width * 0.02),
                        Divider(color: const Color(0xFFE5E7EB), height: width * 0.02),

                        Row(
                          children: [
                            Expanded(
                              child: Text("Free km",
                                  style: TextStyle(fontSize: width * 0.038, color: const Color(0xFF111827))),
                            ),
                            Text("$_freeKm km",
                                style: TextStyle(fontSize: width * 0.038, fontWeight: FontWeight.w600, color: const Color(0xFF111827))),
                          ],
                        ),
                        SizedBox(height: width * 0.02),
                        Divider(color: const Color(0xFFE5E7EB), height: width * 0.02),

                        Row(
                          children: [
                            Expanded(
                              child: Text("₹$_perKm/km after $_freeKm km",
                                  style: TextStyle(fontSize: width * 0.038, color: const Color(0xFF111827))),
                            ),
                            Text("$_estKm km est.",
                                style: TextStyle(fontSize: width * 0.038, fontWeight: FontWeight.w600, color: const Color(0xFF6B7280))),
                          ],
                        ),
                        SizedBox(height: width * 0.02),
                        Divider(color: const Color(0xFFE5E7EB), height: width * 0.02),

                        Row(
                          children: [
                            Expanded(
                              child: Text("Estimated total",
                                  style: TextStyle(fontSize: width * 0.042, fontWeight: FontWeight.w800, color: const Color(0xFF0E1726))),
                            ),
                            Text("₹${_tripTotal.toStringAsFixed(0)}",
                                style: TextStyle(fontSize: width * 0.05, fontWeight: FontWeight.w900, color: const Color(0xFF0E1726))),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              )

              ,
              SizedBox(height: width * 0.1),
            ],
          ),
        ),
      ),

      /// BOTTOM ACTION BAR
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              height: width * 0.15,
              width: width * 0.29,
              decoration: BoxDecoration(
                  color: ColorConstant.bgColor,
                  borderRadius: BorderRadius.all(Radius.circular(width * 0.02)),
                  border: Border.all(  color:  Color(0xFF14A86A),)),
              child: Center(
                child: Row(
                  children: [
                    SizedBox(
                      width: width * 0.05,
                    ),
                    Icon(
                      CupertinoIcons.chat_bubble_text,
                      color:  Color(0xFF14A86A),
                      size: width * 0.04,
                    ),
                    SizedBox(
                      width: width * 0.02,
                    ),
                    Text(
                      "Chat",
                      style: TextStyle(
                          color:  Color(0xFF14A86A), fontSize: width * 0.04),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              width: width * 0.02,
            ),
            Container(
              height: width * 0.15,
              width: width * 0.29,
              decoration: BoxDecoration(
                color:  Color(0xFF14A86A),
                borderRadius: BorderRadius.all(Radius.circular(width * 0.02)),
              ),
              child: Center(
                child: Row(
                  children: [
                    SizedBox(
                      width: width * 0.05,
                    ),
                    Icon(
                      Icons.call_outlined,
                      color: ColorConstant.bgColor,
                      size: width * 0.045,
                    ),
                    SizedBox(
                      width: width * 0.02,
                    ),
                    Text(
                      "Call",
                      style: TextStyle(
                          color: ColorConstant.bgColor, fontSize: width * 0.04),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              width: width * 0.02,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DriverLocationSetting(),
                    ));
              },
              child: Container(
                height: width * 0.15,
                width: width * 0.29,
                decoration: BoxDecoration(
                    color: ColorConstant.bgColor,
                    borderRadius:
                        BorderRadius.all(Radius.circular(width * 0.02)),
                    border: Border.all(  color:  Color(0xFF14A86A),)),
                child: Center(
                  child: Row(
                    children: [
                      SizedBox(
                        width: width * 0.04,
                      ),
                      Icon(
                        CupertinoIcons.time,
                        color:  Color(0xFF14A86A),
                        size: width * 0.04,
                      ),
                      SizedBox(
                        width: width * 0.02,
                      ),
                      Text(
                        "Book ",
                        style: TextStyle(
                            color:  Color(0xFF14A86A), fontSize: width * 0.04),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
