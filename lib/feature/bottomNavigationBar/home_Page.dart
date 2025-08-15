import 'package:carousel_slider/carousel_slider.dart';
import 'package:drivex/core/constants/color_constant.dart';
import 'package:drivex/core/constants/icon_Constants.dart';
import 'package:drivex/core/constants/imageConstants.dart';
import 'package:drivex/core/constants/localVariables.dart';
import 'package:drivex/core/widgets/BackGroundTopGradient.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectIndex = 0;
  List upComings = [
    {
      "icon": IconConstants.carRide,
      "heading": "Ride",
    },
    {
      "icon": IconConstants.packageBox,
      "heading": "Package",
    },
    {
      "icon": IconConstants.carKey,
      "heading": "Rent",
    },
  ];

  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.bgColor,
      body: Backgroundtopgradient(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: width * 0.1,
                width: width * 1,
              ),
              Padding(
                padding: EdgeInsets.all(width * 0.03),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Good Day,",
                              style: TextStyle(
                                  color: ColorConstant.color11,
                                  fontWeight: FontWeight.w700,
                                  fontSize: width * 0.055),
                            ),
                            SizedBox(
                              width: width * 0.01,
                            ),
                            Text(
                              "Riya!",
                              style: TextStyle(
                                  color: ColorConstant.color11,
                                  fontWeight: FontWeight.w700,
                                  fontSize: width * 0.05),
                            ),
                          ],
                        ),
                        Text(
                          "What is your destination?",
                          style: TextStyle(
                              color: ColorConstant.color11.withOpacity(0.4),
                              fontWeight: FontWeight.w700,
                              fontSize: width * 0.035),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Column(
                          children: [
                            Text(
                              "Manhttan",
                              style: TextStyle(
                                  color: ColorConstant.color11,
                                  fontWeight: FontWeight.w700,
                                  fontSize: width * 0.035),
                            ),
                            Text(
                              "Tower Road",
                              style: TextStyle(
                                  color: ColorConstant.color11,
                                  fontWeight: FontWeight.w700,
                                  fontSize: width * 0.045),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: width * 0.01,
                        ),
                        Icon(
                          Icons.location_on_rounded,
                          color: ColorConstant.color11,
                          size: width * 0.06,
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(right: width * 0.02, left: width * 0.02),
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
                          prefixIcon: Icon(Icons.search_rounded),
                          prefixIconColor: ColorConstant.color11,
                          hintText: "Search Anything!",
                          hintStyle: TextStyle(
                              color: ColorConstant.color11.withOpacity(0.4),
                              fontSize: width * 0.03),
                          contentPadding:
                              EdgeInsets.symmetric(vertical: width * 0.01),
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: ColorConstant.color11),
                            borderRadius: BorderRadius.circular(width * 0.04),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: ColorConstant.color11),
                            borderRadius: BorderRadius.circular(width * 0.04),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: ColorConstant.color11),
                            borderRadius: BorderRadius.circular(width * 0.04),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: width * 0.02), // Add spacing between icons
                    Icon(
                      Icons.notifications,
                      color: ColorConstant.color11,
                    ),
                    SizedBox(width: width * 0.02),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: width * 0.02),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: width * .28,
                                height: width * .15,
                                decoration: BoxDecoration(
                                    color:
                                        ColorConstant.color11.withOpacity(0.8),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(width * .05),
                                        topRight:
                                            Radius.circular(width * .05))),
                                child: Center(
                                  child: Text(
                                    "Want to Relax?",
                                    //  "Ready to Ride?",
                                    style: TextStyle(
                                        color: ColorConstant.bgColor,
                                        fontWeight: FontWeight.w700,
                                        fontSize: width * 0.03,
                                        decoration: TextDecoration.underline,
                                        decorationColor: ColorConstant.bgColor),
                                  ),
                                ),
                              ),
                              Container(
                                width: width * .15,
                                height: width * .15,
                                decoration: BoxDecoration(
                                    color:
                                        ColorConstant.color11.withOpacity(0.8),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(width * .5),
                                        topRight: Radius.circular(width * .5),
                                        bottomRight:
                                            Radius.circular(width * .5))),
                                child: CircleAvatar(
                                  backgroundColor:
                                      ColorConstant.bgColor.withOpacity(0.9),
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: CircleAvatar(
                                      radius: width * .06,
                                      child: SvgPicture.asset(
                                        IconConstants.arrow_left,
                                        color: ColorConstant.bgColor,
                                      ),
                                      backgroundColor: ColorConstant.color11
                                          .withOpacity(0.8),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: width * .42,
                            height: width * .15,
                            decoration: BoxDecoration(
                                color: ColorConstant.color11.withOpacity(0.8),
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(width * .05),
                                    bottomRight: Radius.circular(width * .05),
                                    topRight: Radius.circular(width * .05))),
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: width * 0.04, bottom: width * 0.05),
                                child: Text(
                                  "Let Our Drivers Take Over",
                                  //  "Hire a Driver for Your Car",
                                  style: TextStyle(
                                      color: ColorConstant.bgColor,
                                      fontWeight: FontWeight.w700,
                                      fontSize: width * 0.038),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              right: width * 0.04, top: width * 0.04),
                          child: SizedBox(
                            width: width * .47,
                            height: width * .35,
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: width * 0.02),
                                  width: width * .47,
                                  height: width * .3,
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black12,
                                            // boxShadow: [BoxShadow(color:Colors.red .withOpacity(0.15)
                                            blurRadius: 4,
                                            spreadRadius: 2,
                                            offset: Offset(0, 1))
                                      ],
                                      // border: Border.all(color: ColorConstant.color11),
                                      gradient: LinearGradient(
                                          colors: [
                                            ColorConstant.color11
                                                .withOpacity(0.8),
                                            ColorConstant.bgColor,
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomLeft,
                                          stops: [
                                            0.1,
                                            0.7,
                                          ]),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(width * 0.04),
                                      )),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: width * 0.03,
                                            top: width * 0.05),
                                        child: Text(
                                          "Need a Lift?",
                                          // "No Wheels? No Worries.",
                                          style: TextStyle(
                                              color: ColorConstant.bgColor,
                                              fontWeight: FontWeight.w700,
                                              fontSize: width * 0.03,
                                              decoration:
                                                  TextDecoration.underline,
                                              decorationColor:
                                                  ColorConstant.bgColor),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: width * 0.03,
                                            top: width * 0.05),
                                        child: Text(
                                          "We Bring the Ride to You",
                                          //  "Get a Driver with a Vehicle",
                                          style: TextStyle(
                                              color: ColorConstant.color11,
                                              fontWeight: FontWeight.w700,
                                              fontSize: width * 0.039),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: width * 0.29,
                          left: width * 0.3,
                          child: SvgPicture.asset(
                            IconConstants.car,
                            height: width * 0.2,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: height * 0.2,
                width: width,
                child: CarouselSlider.builder(
                  itemCount: 3,
                  options: CarouselOptions(
                    autoPlay: true,
                    autoPlayAnimationDuration: Duration(seconds: 1),
                    viewportFraction: 1,
                    aspectRatio: height * 0.00135,
                    onPageChanged: (index, reason) {
                      setState(() {
                        selectIndex = index;
                      });
                    },
                  ),
                  itemBuilder:
                      (BuildContext context, int index, int realIndex) {
                    return Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              right: width * 0.03,
                              top: width * 0.04,
                              left: width * 0.03),
                          child: SizedBox(
                            width: width,
                            height: width * .35,
                            child: Column(
                              children: [
                                Container(
                                  width: width * 1,
                                  height: width * .32,
                                  decoration: BoxDecoration(
                                      color: ColorConstant.color11
                                          .withOpacity(0.8),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 4,
                                            spreadRadius: 2,
                                            offset: Offset(0, 1))
                                      ],
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(width * 0.04),
                                      )),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: width * 0.05,
                                        top: width * 0.02,
                                        bottom: width * 0.02),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: width * .06,
                                          child: SvgPicture.asset(
                                              IconConstants.anouncement,
                                              color: ColorConstant.bgColor,
                                              height: width * 0.04),
                                          backgroundColor: ColorConstant.bgColor
                                              .withOpacity(0.1),
                                        ),
                                        SizedBox(
                                          width: width * 0.03,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "20 % off",
                                              // "No Wheels? No Worries.",
                                              style: TextStyle(
                                                  color: ColorConstant.bgColor,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: width * 0.05,
                                                  decorationColor:
                                                      ColorConstant.color11),
                                            ),
                                            Text(
                                              "on your first booking!",
                                              //  "Get a Driver with a Vehicle",
                                              style: TextStyle(
                                                  color: ColorConstant.bgColor
                                                      .withOpacity(0.5),
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: width * 0.03),
                                            ),
                                            Text(
                                              "Use code:",
                                              // "No Wheels? No Worries.",
                                              style: TextStyle(
                                                  color: ColorConstant.bgColor
                                                      .withOpacity(0.5),
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: width * 0.035,
                                                  decoration:
                                                      TextDecoration.underline,
                                                  decorationColor: ColorConstant
                                                      .bgColor
                                                      .withOpacity(0.5)),
                                            ),
                                            Text(
                                              "BOOKNEW",
                                              // "No Wheels? No Worries.",
                                              style: TextStyle(
                                                color: ColorConstant.bgColor,
                                                fontWeight: FontWeight.w700,
                                                fontSize: width * 0.035,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: width * 0.05,
                          left: width * 0.5,
                          child: SvgPicture.asset(
                            IconConstants.carCarousel,
                            height: width * 0.5,
                          ),
                        )
                      ],
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(width * 0.02),
                child: Container(
                  height: width * 0.18,
                  width: width,
                  decoration: BoxDecoration(
                    color: ColorConstant.bgColor,
                    border: Border.all(color: ColorConstant.redColor),
                    borderRadius: BorderRadius.all(
                      Radius.circular(width * 0.03),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(width * 0.02),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: width * 0.1,
                          width: width * 0.1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SvgPicture.asset(IconConstants.emergency,
                                color: ColorConstant.redColor,
                                height: width * 0.02),
                          ),
                          decoration: BoxDecoration(
                              // color: ColorConstant.redColor.withOpacity(0.1),
                              color: ColorConstant.bgColor,
                              border: Border.all(color: ColorConstant.redColor),
                              shape: BoxShape.circle),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "EMERGENCY",
                              // "No Wheels? No Worries.",
                              style: TextStyle(
                                color: ColorConstant.redColor,
                                fontWeight: FontWeight.w700,
                                fontSize: width * 0.035,
                              ),
                            ),
                            Text(
                              "Urgent assistance for you!",
                              //  "Get a Driver with a Vehicle",
                              style: TextStyle(
                                  color:
                                      ColorConstant.redColor.withOpacity(0.6),
                                  fontWeight: FontWeight.w700,
                                  fontSize: width * 0.03),
                            ),
                          ],
                        ),
                        Container(
                          height: width * 0.1,
                          width: width * 0.1,
                          child: Icon(Icons.arrow_forward,
                              color: ColorConstant.redColor,
                              size: width * 0.04),
                          decoration: BoxDecoration(
                              // color: ColorConstant.redColor.withOpacity(0.1),
                              color: ColorConstant.bgColor,
                              border: Border.all(color: ColorConstant.redColor),
                              shape: BoxShape.circle),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(width * 0.02),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Top Rated Drivers",
                      style: TextStyle(
                          color: ColorConstant.color11,
                          fontWeight: FontWeight.w700,
                          fontSize: width * 0.048),
                    ),
                    Row(
                      children: [
                        Text(
                          "View all",
                          style: TextStyle(
                              color: ColorConstant.color11.withOpacity(0.4),
                              fontWeight: FontWeight.w700,
                              fontSize: width * 0.035),
                        ),
                        SizedBox(
                          width: width * 0.01,
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: width * 0.045,
                          color: ColorConstant.color11,
                        )
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: width * 0.78,
                child: ListView.builder(
                  padding: EdgeInsets.only(
                      right: width * .03, left: width * .03, top: width * 0.03),
                  itemCount: 3,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(bottom: width * 0.03),
                      height: width * 0.22,
                      width: width,
                      decoration: BoxDecoration(
                        color: ColorConstant.bgColor,
                        border: Border.all(
                            color: ColorConstant.textColor2,
                            width: width * 0.002),
                        borderRadius:
                            BorderRadius.all(Radius.circular(width * 0.02)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(width * 0.03),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      height: width * 0.15,
                                      width: width * 0.15,
                                      decoration: BoxDecoration(
                                          color: ColorConstant.color11,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(width * 0.01),
                                          ),
                                          image: DecorationImage(
                                              image: AssetImage(
                                                ImageConstant.profilePic,
                                              ),
                                              fit: BoxFit.cover)),
                                    ),
                                    SizedBox(
                                      width: width * 0.02,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "Budi Susanto",
                                              style: TextStyle(
                                                color: ColorConstant.thirdColor,
                                                fontWeight: FontWeight.w700,
                                                fontSize: width * 0.037,
                                              ),
                                            ),
                                            SizedBox(
                                              width: width * 0.01,
                                            ),
                                            SvgPicture.asset(
                                              IconConstants.verifyDriver,
                                              color: ColorConstant.greenColor,
                                              height: width * 0.04,
                                            )
                                          ],
                                        ),
                                        Text(
                                          "5+ years of experience",
                                          style: TextStyle(
                                              color: ColorConstant.color11
                                                  .withOpacity(0.6),
                                              fontWeight: FontWeight.w700,
                                              fontSize: width * 0.03),
                                        ),
                                        Row(
                                          children: [
                                            Row(
                                              children: List.generate(
                                                4,
                                                (index) => Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                  size: width * 0.045,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: width * 0.01),
                                            Text(
                                              "(12)",
                                              style: TextStyle(
                                                color: ColorConstant.color11
                                                    .withOpacity(0.6),
                                                fontWeight: FontWeight.w700,
                                                fontSize: width * 0.03,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons
                                              .currency_rupee, // Or use Icons.attach_money for dollar
                                          color: ColorConstant.color11,
                                          size: width * 0.032,
                                        ),
                                        Text(
                                          "40.00 ride",
                                          style: TextStyle(
                                            color: ColorConstant.color11,
                                            fontWeight: FontWeight.w700,
                                            fontSize: width * 0.032,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: width * 0.033,
                                    ),
                                    Container(
                                      height: width * 0.07,
                                      width: width * 0.28,
                                      decoration: BoxDecoration(
                                          color: ColorConstant.color11
                                              .withOpacity(0.8),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(width * 0.02))),
                                      child: Center(
                                        child: Text(
                                          "Book Now",
                                          style: TextStyle(
                                            color: ColorConstant.bgColor,
                                            fontSize: width * 0.033,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                                // Icon(
                                //   Icons.arrow_forward_ios,
                                //   size: width * 0.035,
                                //   color: ColorConstant.thirdColor,
                                // )
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(width * 0.02),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Upcomings",
                      style: TextStyle(
                          color: ColorConstant.color11,
                          fontWeight: FontWeight.w700,
                          fontSize: width * 0.048),
                    ),
                    Row(
                      children: [
                        Text(
                          "View History",
                          style: TextStyle(
                              color: ColorConstant.color11.withOpacity(0.4),
                              fontWeight: FontWeight.w700,
                              fontSize: width * 0.035),
                        ),
                        SizedBox(
                          width: width * 0.01,
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: width * 0.045,
                          color: ColorConstant.color11,
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: width * 0.02),
                child: SizedBox(
                  height: width * 0.4,
                  width: width,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: upComings.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: width * 0.04),
                            height: width * 0.35,
                            width: width * 0.6,
                            decoration: BoxDecoration(
                                color: ColorConstant.color11.withOpacity(0.1),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(width * 0.02))),
                            child: Column(
                              children: [],
                            ),
                          ),
                          Positioned(
                            right: width * 0.02,
                            top: width * 0.25,
                            child: SvgPicture.asset(
                              upComings[index]["icon"],
                              height: width * 0.15,
                            ),
                          )
                        ],
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(width * 0.02),
                child: Container(
                  height: width * 0.35,
                  width: width,
                  decoration: BoxDecoration(
                    color: ColorConstant.bgColor,
                    border: Border.all(
                        color: ColorConstant.textColor2, width: width * 0.002),
                    borderRadius:
                        BorderRadius.all(Radius.circular(width * 0.02)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        color: ColorConstant.thirdColor.withOpacity(0.2),
                        size: width * 0.08,
                      ),
                      Text(
                        "No upcomings",
                        style: TextStyle(
                            color: ColorConstant.thirdColor,
                            fontWeight: FontWeight.w600),
                      ),
                      Container(
                        height: width * 0.07,
                        width: width * 0.28,
                        decoration: BoxDecoration(
                            color: ColorConstant.color11.withOpacity(0.8),
                            borderRadius: BorderRadius.all(
                                Radius.circular(width * 0.02))),
                        child: Center(
                          child: Text(
                            "Book Now",
                            style: TextStyle(
                              color: ColorConstant.bgColor,
                              fontSize: width * 0.033,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(width * 0.02),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "D2D Service",
                      style: TextStyle(
                          color: ColorConstant.color11,
                          fontWeight: FontWeight.w700,
                          fontSize: width * 0.048),
                    ),
                    // Row(
                    //   children: [
                    //     Text(
                    //       "View History",
                    //       style: TextStyle(
                    //           color: ColorConstant.color11.withOpacity(0.4),
                    //           fontWeight: FontWeight.w700,
                    //           fontSize: width * 0.035),
                    //     ),
                    //     SizedBox(
                    //       width: width * 0.01,
                    //     ),
                    //     Icon(
                    //       Icons.arrow_forward_ios,
                    //       size: width * 0.045,
                    //       color: ColorConstant.color11,
                    //     )
                    //   ],
                    // ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: width * 0.2,
                    width: width * 0.47,
                    margin: EdgeInsets.only(left: width * 0.02),
                    decoration: BoxDecoration(
                        color: ColorConstant.color11.withOpacity(0.1),
                        borderRadius:
                            BorderRadius.all(Radius.circular(width * 0.02))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: width * 0.01,
                            ),
                            CircleAvatar(
                              radius: width * .04,
                              child: SvgPicture.asset(IconConstants.sendPlane,
                                  color: ColorConstant.color11,
                                  height: width * 0.03),
                              backgroundColor: ColorConstant.bgColor,
                            ),
                            SizedBox(
                              width: width * 0.01,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Quick Send",
                                  style: TextStyle(
                                      color: ColorConstant.color11,
                                      fontWeight: FontWeight.w700,
                                      fontSize: width * 0.035),
                                ),
                                Text(
                                  "Fast & reliable delivery service",
                                  style: TextStyle(
                                      color: ColorConstant.color11
                                          .withOpacity(0.6),
                                      fontWeight: FontWeight.w700,
                                      fontSize: width * 0.02),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          height: width * 0.07,
                          width: width * 0.43,
                          decoration: BoxDecoration(
                              color: ColorConstant.color11.withOpacity(0.8),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(width * 0.02))),
                          child: Center(
                            child: Text(
                              "Send Package Now",
                              style: TextStyle(
                                color: ColorConstant.bgColor,
                                fontSize: width * 0.033,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: width * 0.2,
                    width: width * 0.47,
                    margin: EdgeInsets.only(right: width * 0.02),
                    decoration: BoxDecoration(
                        color: ColorConstant.color11.withOpacity(0.1),
                        borderRadius:
                            BorderRadius.all(Radius.circular(width * 0.02))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: width * 0.01,
                            ),
                            CircleAvatar(
                              radius: width * .04,
                              child: SvgPicture.asset(
                                  IconConstants.receivePlane,
                                  color: ColorConstant.color11,
                                  height: width * 0.03),
                              backgroundColor: ColorConstant.bgColor,
                            ),
                            SizedBox(
                              width: width * 0.01,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Receive Parcel",
                                  style: TextStyle(
                                      color: ColorConstant.color11,
                                      fontWeight: FontWeight.w700,
                                      fontSize: width * 0.035),
                                ),
                                Text(
                                  "Effortless delivery at your doorstep",
                                  style: TextStyle(
                                      color: ColorConstant.color11
                                          .withOpacity(0.6),
                                      fontWeight: FontWeight.w700,
                                      fontSize: width * 0.02),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          height: width * 0.07,
                          width: width * 0.43,
                          decoration: BoxDecoration(
                              color: ColorConstant.color11.withOpacity(0.8),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(width * 0.02))),
                          child: Center(
                            child: Text(
                              "Receive Package Now",
                              style: TextStyle(
                                color: ColorConstant.bgColor,
                                fontSize: width * 0.033,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.all(width * 0.02),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Popular Rental Cars",
                      style: TextStyle(
                          color: ColorConstant.color11,
                          fontWeight: FontWeight.w700,
                          fontSize: width * 0.048),
                    ),
                    Row(
                      children: [
                        Text(
                          "View History",
                          style: TextStyle(
                              color: ColorConstant.color11.withOpacity(0.4),
                              fontWeight: FontWeight.w700,
                              fontSize: width * 0.035),
                        ),
                        SizedBox(
                          width: width * 0.01,
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: width * 0.045,
                          color: ColorConstant.color11,
                        )
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: width,
                height: height * 0.75,
                child: ListView.builder(
                  itemCount: 4,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              bottom: width * 0.03,
                              left: width * 0.02,
                              right: width * 0.02),
                          height: width * 0.35,
                          width: width,
                          decoration: BoxDecoration(
                            color: ColorConstant.bgColor,
                            border: Border.all(
                                color: ColorConstant.textColor2,
                                width: width * 0.002),
                            borderRadius:
                                BorderRadius.all(Radius.circular(width * 0.02)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SvgPicture.asset(IconConstants.car2,
                                  height: width * 0.2),
                              SizedBox(
                                width: width * 0.02,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "BMW M5 Series",
                                    style: TextStyle(
                                      color: ColorConstant.thirdColor,
                                      fontWeight: FontWeight.w700,
                                      fontSize: width * 0.037,
                                    ),
                                  ),
                                  Text(
                                    "2024",
                                    style: TextStyle(
                                      color: ColorConstant.thirdColor,
                                      fontWeight: FontWeight.w700,
                                      fontSize: width * 0.037,
                                    ),
                                  ),
                                  Text(
                                    "Luxury Sedan",
                                    style: TextStyle(
                                        color: ColorConstant.color11
                                            .withOpacity(0.6),
                                        fontWeight: FontWeight.w700,
                                        fontSize: width * 0.03),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        CupertinoIcons.location_solid,
                                        color: ColorConstant.thirdColor,
                                        size: width * 0.04,
                                      ),
                                      Text(
                                        " Dubai Marina",
                                        style: TextStyle(
                                          color: ColorConstant.thirdColor,
                                          fontSize: width * 0.025,
                                        ),
                                      ),
                                      Text(
                                        "  . 1.2 km away",
                                        style: TextStyle(
                                          color: ColorConstant.thirdColor,
                                          fontSize: width * 0.025,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.settings,
                                        color: ColorConstant.thirdColor,
                                        size: width * 0.04,
                                      ),
                                      Text(
                                        "Auto",
                                        style: TextStyle(
                                          color: ColorConstant.thirdColor,
                                          fontSize: width * 0.025,
                                        ),
                                      ),
                                      Text(
                                        "  . Ac",
                                        style: TextStyle(
                                          color: ColorConstant.thirdColor,
                                          fontSize: width * 0.025,
                                        ),
                                      ),
                                      Text(
                                        "  . Sunroof",
                                        style: TextStyle(
                                          color: ColorConstant.thirdColor,
                                          fontSize: width * 0.025,
                                        ),
                                      ),
                                      Text(
                                        "  . Leather",
                                        style: TextStyle(
                                          color: ColorConstant.thirdColor,
                                          fontSize: width * 0.025,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons
                                            .currency_rupee, // Or use Icons.attach_money for dollar
                                        color: ColorConstant.color11,
                                        size: width * 0.032,
                                      ),
                                      Text(
                                        "40.00 ride",
                                        style: TextStyle(
                                          color: ColorConstant.color11,
                                          fontWeight: FontWeight.w700,
                                          fontSize: width * 0.032,
                                        ),
                                      ),
                                      SizedBox(
                                        width: width * 0.2,
                                      ),
                                      Container(
                                        height: width * 0.07,
                                        width: width * 0.28,
                                        decoration: BoxDecoration(
                                            color: ColorConstant.color11
                                                .withOpacity(0.8),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(width * 0.02))),
                                        child: Center(
                                          child: Text(
                                            "Book Now",
                                            style: TextStyle(
                                              color: ColorConstant.bgColor,
                                              fontSize: width * 0.033,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Positioned(
                            right: width * 0.08,
                            top: width * 0.01,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.yellow,
                                  size: width * 0.05,
                                ),
                                // SizedBox(
                                //   width: width * 0.01,
                                // ),
                                Text(
                                  "4.1",
                                  style: TextStyle(
                                      color: ColorConstant.thirdColor,
                                      fontSize: width * 0.03),
                                )
                              ],
                            ))
                      ],
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
