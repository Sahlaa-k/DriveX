import 'package:carousel_slider/carousel_slider.dart';
import 'package:drivex/core/constants/color_constant.dart';
import 'package:drivex/core/constants/icon_Constants.dart';
import 'package:drivex/core/constants/imageConstants.dart';
import 'package:drivex/core/constants/localVariables.dart';
import 'package:drivex/core/widgets/BackGroundTopGradient.dart';
import 'package:drivex/feature/bookings/screens/cancel_page.dart';
import 'package:drivex/feature/bookings/screens/details_page.dart';
import 'package:drivex/feature/bookings/screens/reschedule.dart';
import 'package:drivex/feature/bottomNavigationBar/notification_page.dart';
import 'package:drivex/feature/cab/screens/cab_page.dart';
import 'package:drivex/feature/drivers_page/screens/drivers_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool favorite = false;
  int selectIndex = 0;
  final List<Map<String, dynamic>> upComings = [
    {
      "type": "Driver",
      "from": "190 Blacker Ctr.beach",
      "to": "402 Banglour road",
      "dateTime": "16 Jul 2026 - 3:45 PM",
      "driver": "Budi Susanto",
      "payment": "Cash",
      "image": "assets/images/profile_pic.jpg",
    },
    {
      "type": "D2D",
      "from": "Warehouse 12A",
      "to": "Shopping District",
      "dateTime": "18 Jul 2026, 9:00 AM",
      "parcel": "Grocery",
      "image": "assets/images/pexels-israr-ahmrd-152664845-10568559.jpg",
      "payment": "UPI",
      "price": "₹149",
    },
    {
      "type": "Cab",
      "from": "Airport T2",
      "to": "City Center Mall",
      "dateTime": "21 Jul 2026, 5:30 PM",
      "driver": "Rahul Dev",
      "car": "Toyota Etios",
      "plate": "KL 15 AB 4321",
      "seats": "4 seats",
      "payment": "Card",
      "fare": "₹820",
      "image": "assets/images/rentalcar2.jpg",
    },
  ];

  List rentalCarImage = [
    ImageConstant.carHDRent1,
    ImageConstant.carHDRent2,
    ImageConstant.carHDRent3,
    ImageConstant.carHDRent4
  ];
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: ColorConstant.bgColor,
      body: SingleChildScrollView(
        child: Backgroundtopgradient(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: width * 0.06,
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
                        SizedBox(
                          height: width * 0.003,
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                "assets/icons/location-pin (1).svg",
                                color: ColorConstant.color11.withOpacity(0.7),
                                height: width * 0.05,
                              ),
                              SizedBox(
                                width: width * 0.01,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Your Location",
                                    style: TextStyle(
                                        color: ColorConstant.color11
                                            .withOpacity(0.7),
                                        fontWeight: FontWeight.w600,
                                        fontSize: width * 0.03),
                                  ),
                                  Text(
                                    "Tower Road, Manhttan",
                                    style: TextStyle(
                                        color: ColorConstant.thirdColor,
                                        fontWeight: FontWeight.w700,
                                        fontSize: width * 0.035),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NotificationPage()),
                        );
                      },
                      child: Container(
                        height: width * 0.1,
                        width: width * 0.1,
                        decoration: BoxDecoration(
                            color: ColorConstant.bgColor,
                            shape: BoxShape.circle),
                        child: Center(
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              SvgPicture.asset(
                                "assets/icons/notification-10.svg",
                                color:
                                    ColorConstant.thirdColor.withOpacity(0.7),
                                height: width * 0.075,
                              ),
                              Positioned(
                                left: width * 0.035,
                                bottom: width * 0.03,
                                child: Container(
                                  padding: EdgeInsets.all(width * 0.009),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  constraints: BoxConstraints(
                                    minWidth: width * 0.032,
                                    minHeight: width * 0.032,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '3', // Your dynamic notification count
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: width * 0.02,
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
                  ],
                ),
              ),
              SizedBox(
                height: width * 0.02,
              ),
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
                            hintText: "Search here!",
                            hintStyle: TextStyle(
                                color:
                                    ColorConstant.thirdColor.withOpacity(0.4),
                                fontSize: width * 0.03),
                            contentPadding:
                                EdgeInsets.symmetric(vertical: width * 0.01),

                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(width*0.03),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(width*0.03),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(width*0.03),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                          width: width * 0.02), // Add spacing between icons
                      Container(
                        height: width * 0.1,
                        width: width * 0.1,
                        decoration: BoxDecoration(
                            color: ColorConstant.bgColor,
                            shape: BoxShape.circle),
                        child: Center(
                            child: Icon(
                          Icons.favorite_border,
                          color: ColorConstant.thirdColor.withOpacity(0.6),
                          size: width * 0.052,
                        )),
                      ),
                    ],
                  ),
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
                                          .withOpacity(0.4),
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
                padding:
                    EdgeInsets.only(left: width * 0.03, right: width * 0.03),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Services",
                      style: TextStyle(
                          color: ColorConstant.color11,
                          fontWeight: FontWeight.w600,
                          fontSize: width * 0.048),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: width * 0.03,
                    top: width * 0.03,
                    bottom: width * 0.02,
                    right: width * 0.01),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => CabPage(),));
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: width * 0.16,
                            width: width * 0.16,
                            margin: EdgeInsets.only(
                                right: width * 0.02, bottom: width * 0.01),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.2),
                              borderRadius: BorderRadius.all(
                                Radius.circular(width * 0.03),
                              ),
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                "assets/icons/oncoming-automobile.svg",
                                height: width * 0.13,
                              ),
                            ),
                          ),
                          Text(
                            "Find Cab",
                            style: TextStyle(
                              color: ColorConstant.thirdColor.withOpacity(0.7),
                              fontWeight: FontWeight.w600,
                              fontSize: width * 0.032, // reduced font size
                            ),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: width * 0.16,
                          width: width * 0.16,
                          margin: EdgeInsets.only(
                              right: width * 0.02, bottom: width * 0.01),
                          decoration: BoxDecoration(
                            color: Colors.greenAccent.withOpacity(0.3),
                            borderRadius: BorderRadius.all(
                              Radius.circular(width * 0.03),
                            ),
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              "assets/icons/delivery-package.svg",
                              height: width * 0.13,
                            ),
                          ),
                        ),
                        Text(
                          "D2D Service",
                          style: TextStyle(
                            color: ColorConstant.thirdColor.withOpacity(0.7),
                            fontWeight: FontWeight.w600,
                            fontSize: width * 0.032, // reduced font size
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: width * 0.16,
                          width: width * 0.16,
                          margin: EdgeInsets.only(
                              right: width * 0.02, bottom: width * 0.01),
                          decoration: BoxDecoration(
                            color: Colors.redAccent.withOpacity(0.2),
                            borderRadius: BorderRadius.all(
                              Radius.circular(width * 0.03),
                            ),
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              "assets/icons/rent-a-car (1).svg",
                              height: width * 0.13,
                            ),
                          ),
                        ),
                        Text(
                          "Rent Vehicle",
                          style: TextStyle(
                            color: ColorConstant.thirdColor.withOpacity(0.7),
                            fontWeight: FontWeight.w600,
                            fontSize: width * 0.032, // reduced font size
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: width * 0.16,
                          width: width * 0.16,
                          margin: EdgeInsets.only(
                              right: width * 0.02, bottom: width * 0.01),
                          decoration: BoxDecoration(
                            color: Colors.brown.withOpacity(0.2),
                            borderRadius: BorderRadius.all(
                              Radius.circular(width * 0.03),
                            ),
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              "assets/icons/taxi-driver.svg",
                              height: width * 0.13,
                            ),
                          ),
                        ),
                        Text(
                          "Find Driver",
                          style: TextStyle(
                            color: ColorConstant.thirdColor.withOpacity(0.7),
                            fontWeight: FontWeight.w600,
                            fontSize: width * 0.032, // reduced font size
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.only(
                    top: width * 0.03,
                    left: width * 0.03,
                    right: width * 0.03,
                    bottom: width * 0.01),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Top Rated Drivers",
                      style: TextStyle(
                          color: ColorConstant.color11,
                          fontWeight: FontWeight.w600,
                          fontSize: width * 0.044),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DriversListTabPage(),
                            ));
                      },
                      child: Row(
                        children: [
                          Text(
                            "View all",
                            style: TextStyle(
                                color:
                                    ColorConstant.thirdColor.withOpacity(0.4),
                                fontWeight: FontWeight.w500,
                                fontSize: width * 0.03),
                          ),
                          SizedBox(
                            width: width * 0.01,
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: width * 0.04,
                            color: ColorConstant.color11.withOpacity(0.7),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: width * 0.65,
                child: ListView.builder(
                  padding: EdgeInsets.only(
                      right: width * .03, left: width * .03, top: width * 0.03),
                  itemCount: 3,
                  physics: AlwaysScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(
                          bottom: width * 0.03, right: width * 0.03),
                      height: width * 0.16,
                      width: width * 0.45,
                      decoration: BoxDecoration(
                        color: ColorConstant.bgColor,
                        // border: Border.all(
                        //     color: ColorConstant.textColor2,
                        //     width: width * 0.002),
                        borderRadius:
                            BorderRadius.all(Radius.circular(width * 0.03)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1), // soft shadow
                            blurRadius: 6, // how soft the shadow is
                            offset: Offset(0, 3), // X, Y position of shadow
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(width * 0.03),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: width * 0.2,
                                  width: width * 0.2,
                                  decoration: BoxDecoration(
                                      color: ColorConstant.color11,
                                      // shape: BoxShape.circle,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(width * 0.03)),
                                      image: DecorationImage(
                                          image: AssetImage(
                                            ImageConstant.profilePic,
                                          ),
                                          fit: BoxFit.cover)),
                                ),
                                SizedBox(
                                  width: width * 0.02,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                      color: Colors.blue,
                                      height: width * 0.04,
                                    )
                                  ],
                                ),
                                Text(
                                  "5+ years of experience",
                                  style: TextStyle(
                                      color: ColorConstant.thirdColor
                                          .withOpacity(0.4),
                                      fontWeight: FontWeight.w700,
                                      fontSize: width * 0.03),
                                ),
                                Divider(
                                  color:
                                      ColorConstant.thirdColor.withOpacity(0.2),
                                ),
                                IntrinsicHeight(
                                  // makes children take equal height
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.currency_rupee,
                                                color: ColorConstant.color11,
                                                size: width * 0.032,
                                              ),
                                              Text(
                                                "40.00 ",
                                                style: TextStyle(
                                                  color:
                                                      ColorConstant.thirdColor,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: width * 0.032,
                                                ),
                                              ),
                                            ],
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

                                      // vertical divider
                                      VerticalDivider(
                                        color: ColorConstant.thirdColor
                                            .withOpacity(0.2),
                                        thickness: 1,
                                        width: 20, // spacing between items
                                      ),
                                      SizedBox(
                                        width: width * 0.02,
                                      ),
                                      Icon(
                                        Icons.call_outlined,
                                        color: Colors.green,
                                        size: width * 0.055,
                                      ),
                                    ],
                                  ),
                                )

                                // Container(
                                //   height: width * 0.072,
                                //   width: width * 0.3,
                                //   decoration: BoxDecoration(
                                //       color: ColorConstant.color11
                                //           .withOpacity(0.8),
                                //       borderRadius: BorderRadius.all(
                                //           Radius.circular(width * 0.04))),
                                //   child: Center(
                                //     child: Text(
                                //       "Book Now",
                                //       style: TextStyle(
                                //         color: ColorConstant.bgColor,
                                //         fontSize: width * 0.033,
                                //         fontWeight: FontWeight.w700,
                                //       ),
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: width * 0.01,
                            right: width * 0.01,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  favorite = !favorite; // toggle
                                });
                              },
                              child: Icon(
                                favorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: favorite
                                    ? Colors.red
                                    : ColorConstant.thirdColor.withOpacity(0.1),
                                size: width * 0.045,
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: width * 0.03,
                    left: width * 0.03,
                    right: width * 0.03,
                    bottom: width * 0.01),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Popular Rental Cars",
                      style: TextStyle(
                          color: ColorConstant.color11,
                          fontWeight: FontWeight.w600,
                          fontSize: width * 0.044),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DriversListTabPage(),
                            ));
                      },
                      child: Row(
                        children: [
                          Text(
                            "View all",
                            style: TextStyle(
                                color:
                                    ColorConstant.thirdColor.withOpacity(0.4),
                                fontWeight: FontWeight.w500,
                                fontSize: width * 0.03),
                          ),
                          SizedBox(
                            width: width * 0.01,
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: width * 0.04,
                            color: ColorConstant.color11.withOpacity(0.7),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: width,
                height: height * 0.65,
                child: ListView.builder(
                  itemCount: rentalCarImage.length,
                  padding: EdgeInsets.only(top: width * .02),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(
                          bottom: width * 0.03,
                          left: width * 0.03,
                          right: width * 0.03),
                      height: width * 0.32,
                      width: width,
                      decoration: BoxDecoration(
                        color: ColorConstant.bgColor,
                        border: Border.all(
                            color: Colors.grey.withOpacity(0.2),
                            width: width * 0.002),
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: Colors.black.withOpacity(0.1), // soft shadow
                        //     blurRadius: 6, // how soft the shadow is
                        //     offset: Offset(0, 3), // X, Y position of shadow
                        //   ),
                        // ],
                        borderRadius:
                            BorderRadius.all(Radius.circular(width * 0.03)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(width * 0.02),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: width * 0.35,
                              width: width * 0.48,
                              decoration: BoxDecoration(
                                  color: ColorConstant.thirdColor,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(width * 0.03)),
                                  image: DecorationImage(
                                      image: AssetImage(rentalCarImage[index]),
                                      fit: BoxFit.cover)),
                            ),
                            SizedBox(
                              width: width * 0.02,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "BMW M5 Series",
                                  style: TextStyle(
                                    color: ColorConstant.thirdColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: width * 0.037,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons
                                          .currency_rupee, // Or use Icons.attach_money for dollar
                                      color: ColorConstant.thirdColor,
                                      size: width * 0.032,
                                    ),
                                    Text(
                                      "400.00 ",
                                      style: TextStyle(
                                        color: ColorConstant.thirdColor,
                                        fontWeight: FontWeight.w700,
                                        fontSize: width * 0.032,
                                      ),
                                    ),
                                    Text(
                                      "/Per Day",
                                      style: TextStyle(
                                        color: ColorConstant.textColor3,
                                        fontSize: width * 0.032,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: Colors.yellow,
                                      size: width * 0.05,
                                    ),
                                    SizedBox(
                                      width: width * 0.01,
                                    ),
                                    Text(
                                      "4.1",
                                      style: TextStyle(
                                          color: ColorConstant.textColor3,
                                          fontSize: width * 0.03),
                                    ),
                                    SizedBox(
                                      width: width * 0.03,
                                    ),
                                    Icon(
                                      CupertinoIcons.person_2,
                                      color: ColorConstant.textColor3,
                                      size: width * 0.04,
                                    ),
                                    SizedBox(
                                      width: width * 0.01,
                                    ),
                                    Text(
                                      "2-4",
                                      style: TextStyle(
                                          color: ColorConstant.textColor3,
                                          fontSize: width * 0.03),
                                    ),
                                  ],
                                ),
                                IntrinsicHeight(
                                  // makes children take equal height
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      SizedBox(
                                        width: width * 0.02,
                                      ),

                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            favorite = !favorite; // toggle
                                          });
                                        },
                                        child: Icon(
                                          favorite
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: favorite
                                              ? Colors.red
                                              : ColorConstant.thirdColor
                                                  .withOpacity(0.1),
                                          size: width * 0.05,
                                        ),
                                      ),
                                      SizedBox(
                                        width: width * 0.04,
                                      ),
                                      // vertical divider
                                      VerticalDivider(
                                        color: ColorConstant.thirdColor
                                            .withOpacity(0.2),
                                        thickness: 1,
                                        width: 20, // spacing between items
                                      ),
                                      SizedBox(
                                        width: width * 0.04,
                                      ),
                                      Icon(
                                        Icons.call_outlined,
                                        color: Colors.green,
                                        size: width * 0.055,
                                      ),
                                    ],
                                  ),
                                )
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
                padding: EdgeInsets.only(
                    top: width * 0.03,
                    left: width * 0.03,
                    right: width * 0.03,
                    bottom: width * 0.01),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Upcomings",
                      style: TextStyle(
                          color: ColorConstant.color11,
                          fontWeight: FontWeight.w600,
                          fontSize: width * 0.044),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DriversListTabPage(),
                            ));
                      },
                      child: Row(
                        children: [
                          Text(
                            "View History",
                            style: TextStyle(
                                color:
                                    ColorConstant.thirdColor.withOpacity(0.4),
                                fontWeight: FontWeight.w500,
                                fontSize: width * 0.03),
                          ),
                          SizedBox(
                            width: width * 0.01,
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: width * 0.04,
                            color: ColorConstant.color11.withOpacity(0.7),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                  height: width * 0.55,
                  width: width,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: upComings.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final item = upComings[index];
                      final String type = (item["type"] ?? "Driver") as String;

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsPageOfHistory(),));
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                              right: width * 0.03,
                              left: width*0.03,
                              top: width * 0.03,
                              bottom: width * 0.03),
                          height: width * 0.45,
                          width: width * 0.65,
                          decoration: BoxDecoration(
                            color: ColorConstant.bgColor,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                            borderRadius:
                                BorderRadius.all(Radius.circular(width * 0.03)),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(width * 0.02),
                            // ===================== INLINE SWITCH =====================
                              child: (type == "D2D")
                                // -------- D2D CONTAINER (parcel) --------
                                ? Column(
                                    children: [
                                      Row(
                                        children: [
                                          Spacer(),
                                          Container(
                                            height: width * 0.06,
                                            width: width * 0.2,
                                            decoration: BoxDecoration(
                                                color: Colors.yellow
                                                    .withOpacity(0.4),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(
                                                        width * 0.03))),
                                            child: Center(
                                              child: Text(
                                                item["type"],
                                                style: TextStyle(
                                                    color:
                                                        ColorConstant.thirdColor,
                                                    fontSize: width * 0.03,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "16 Jul 2026 - 3:45 PM",
                                            style: TextStyle(
                                                color: ColorConstant.thirdColor,
                                                fontSize: width * 0.03),
                                          ),
                                          Spacer(),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            color: ColorConstant.thirdColor
                                                .withOpacity(0.3),
                                            size: width * 0.035,
                                          )
                                        ],
                                      ),
                                      SizedBox(height: width * 0.03),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // LEFT: avatar
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                width * 0.03),
                                            child: Image.asset(
                                              item["image"] ?? "",
                                              width: width * 0.20,
                                              height: width * 0.20,
                                              fit: BoxFit.cover,
                                            ),
                                          ),

                                          SizedBox(width: width * 0.02),

                                          // RIGHT: name + from/to
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // name (standalone)
                                                Text(
                                                  item["parcel"] ?? "-",
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color:
                                                        ColorConstant.thirdColor,
                                                    fontSize: width * 0.038,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),

                                                SizedBox(height: width * 0.016),

                                                // from/to row: connector + addresses
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    // connector column
                                                    SizedBox(
                                                      height: width *
                                                          0.11, // shorter than avatar so name fits above
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Icon(
                                                              Icons
                                                                  .my_location_outlined,
                                                              size: width * 0.038,
                                                              color: Colors.red),
                                                          Container(
                                                            width: width * 0.003,
                                                            height: width * 0.025,
                                                            color: ColorConstant
                                                                .thirdColor
                                                                .withOpacity(0.2),
                                                          ),
                                                          Icon(
                                                              CupertinoIcons
                                                                  .location_north_line,
                                                              size: width * 0.045,
                                                              color:
                                                                  Colors.green),
                                                        ],
                                                      ),
                                                    ),

                                                    SizedBox(width: width * 0.02),

                                                    // from/to column (no name here)
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            item["from"] ?? "-",
                                                            maxLines: 1,
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                            style: TextStyle(
                                                              color: ColorConstant
                                                                  .thirdColor,
                                                              fontSize:
                                                                  width * 0.03,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: width * 0.03,
                                                          ),
                                                          Text(
                                                            item["to"] ?? "-",
                                                            maxLines: 1,
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                            style: TextStyle(
                                                              color: ColorConstant
                                                                  .thirdColor,
                                                              fontSize:
                                                                  width * 0.03,
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
                                        ],
                                      ),
                                      SizedBox(height: width * 0.03),
                                      Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              showCancelDialog(context);                                          },
                                            child: Container(
                                              height: width * 0.08,
                                              width: width * 0.291,
                                              decoration: BoxDecoration(
                                                color: ColorConstant.color11
                                                    .withOpacity(0.1),
                                                // border: Border.all(
                                                //     color: ColorConstant.color11
                                                //         .withOpacity(0.8)),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(width * 0.03)),
                                              ),
                                              alignment: Alignment.center,
                                              child: Text("Cancel",
                                                  style: TextStyle(
                                                      color: ColorConstant.color11,
                                                      fontSize: width * 0.033,
                                                      fontWeight: FontWeight.w700)),
                                            ),
                                          ),
                                          const Spacer(),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(context, MaterialPageRoute(builder: (context) => ReschedulePage(),));
                                            },
                                            child: Container(
                                              height: width * 0.08,
                                              width: width * 0.29,
                                              decoration: BoxDecoration(
                                                color: ColorConstant.color11
                                                    .withOpacity(0.9),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(width * 0.03)),
                                              ),
                                              alignment: Alignment.center,
                                              child: Text("Reschedule",
                                                  style: TextStyle(
                                                      color: ColorConstant.bgColor,
                                                      fontSize: width * 0.033,
                                                      fontWeight: FontWeight.w700)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                // -------- CAB CONTAINER --------item["image"] ??
                                //                                                     "assets/images/profile_pic.jpg"
                                : (type == "Cab")
                                    ? Column(
                                        children: [
                                          Row(
                                            children: [
                                              Spacer(),
                                              Container(
                                                height: width * 0.06,
                                                width: width * 0.2,
                                                decoration: BoxDecoration(
                                                    color: Colors.yellow
                                                        .withOpacity(0.4),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                width * 0.03))),
                                                child: Center(
                                                  child: Text(
                                                    item["type"],
                                                    style: TextStyle(
                                                        color: ColorConstant
                                                            .thirdColor,
                                                        fontSize: width * 0.03,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "16 Jul 2026 - 3:45 PM",
                                                style: TextStyle(
                                                    color:
                                                        ColorConstant.thirdColor,
                                                    fontSize: width * 0.03),
                                              ),
                                              Spacer(),
                                              Icon(
                                                Icons.arrow_forward_ios,
                                                color: ColorConstant.thirdColor
                                                    .withOpacity(0.3),
                                                size: width * 0.035,
                                              )
                                            ],
                                          ),
                                          SizedBox(height: width * 0.03),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // LEFT: avatar
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        width * 0.03),
                                                child: Image.asset(
                                                  item["image"] ??
                                                      "assets/images/rentalcar2.jpg",
                                                  width: width * 0.20,
                                                  height: width * 0.20,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),

                                              SizedBox(width: width * 0.02),

                                              // RIGHT: name + from/to
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    // name (standalone)
                                                    Text(
                                                      item["car"] ?? "-",
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: ColorConstant
                                                            .thirdColor,
                                                        fontSize: width * 0.038,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),

                                                    SizedBox(
                                                        height: width * 0.016),

                                                    // from/to row: connector + addresses
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        // connector column
                                                        SizedBox(
                                                          height: width *
                                                              0.11, // shorter than avatar so name fits above
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Icon(
                                                                  Icons
                                                                      .my_location_outlined,
                                                                  size: width *
                                                                      0.038,
                                                                  color:
                                                                      Colors.red),
                                                              Container(
                                                                width:
                                                                    width * 0.003,
                                                                height:
                                                                    width * 0.025,
                                                                color: ColorConstant
                                                                    .thirdColor
                                                                    .withOpacity(
                                                                        0.2),
                                                              ),
                                                              Icon(
                                                                  CupertinoIcons
                                                                      .location_north_line,
                                                                  size: width *
                                                                      0.045,
                                                                  color: Colors
                                                                      .green),
                                                            ],
                                                          ),
                                                        ),

                                                        SizedBox(
                                                            width: width * 0.02),

                                                        // from/to column (no name here)
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                item["from"] ??
                                                                    "-",
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: TextStyle(
                                                                  color: ColorConstant
                                                                      .thirdColor,
                                                                  fontSize:
                                                                      width *
                                                                          0.03,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height:
                                                                    width * 0.03,
                                                              ),
                                                              Text(
                                                                item["to"] ?? "-",
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: TextStyle(
                                                                  color: ColorConstant
                                                                      .thirdColor,
                                                                  fontSize:
                                                                      width *
                                                                          0.03,
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
                                            ],
                                          ),
                                          SizedBox(height: width * 0.03),
                                          Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  showCancelDialog(context);                                              },
                                                child: Container(
                                                  height: width * 0.08,
                                                  width: width * 0.291,
                                                  decoration: BoxDecoration(
                                                    color: ColorConstant.color11
                                                        .withOpacity(0.1),
                                                    // border: Border.all(
                                                    //     color: ColorConstant.color11
                                                    //         .withOpacity(0.8)),
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(
                                                            width * 0.03)),
                                                  ),
                                                  alignment: Alignment.center,
                                                  child: Text("Cancel",
                                                      style: TextStyle(
                                                          color:
                                                              ColorConstant.color11,
                                                          fontSize: width * 0.033,
                                                          fontWeight:
                                                              FontWeight.w700)),
                                                ),
                                              ),
                                              const Spacer(),
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ReschedulePage(),));
                                                },
                                                child: Container(
                                                  height: width * 0.08,
                                                  width: width * 0.29,
                                                  decoration: BoxDecoration(
                                                    color: ColorConstant.color11
                                                        .withOpacity(0.9),
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(
                                                            width * 0.03)),
                                                  ),
                                                  alignment: Alignment.center,
                                                  child: Text("Reschedule",
                                                      style: TextStyle(
                                                          color:
                                                              ColorConstant.bgColor,
                                                          fontSize: width * 0.033,
                                                          fontWeight:
                                                              FontWeight.w700)),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    // -------- DRIVER CONTAINER (default) --------
                                    : Column(
                                        children: [
                                          Row(
                                            children: [
                                              Spacer(),
                                              Container(
                                                height: width * 0.06,
                                                width: width * 0.2,
                                                decoration: BoxDecoration(
                                                    color: Colors.yellow
                                                        .withOpacity(0.4),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                width * 0.03))),
                                                child: Center(
                                                  child: Text(
                                                    item["type"],
                                                    style: TextStyle(
                                                        color: ColorConstant
                                                            .thirdColor,
                                                        fontSize: width * 0.03,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "16 Jul 2026 - 3:45 PM",
                                                style: TextStyle(
                                                    color:
                                                        ColorConstant.thirdColor,
                                                    fontSize: width * 0.03),
                                              ),
                                              Spacer(),
                                              Icon(
                                                Icons.arrow_forward_ios,
                                                color: ColorConstant.thirdColor
                                                    .withOpacity(0.3),
                                                size: width * 0.035,
                                              )
                                            ],
                                          ),
                                          SizedBox(height: width * 0.03),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // LEFT: avatar
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        width * 0.03),
                                                child: Image.asset(
                                                  item["image"] ??
                                                      "assets/images/profile_pic.jpg",
                                                  width: width * 0.20,
                                                  height: width * 0.20,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),

                                              SizedBox(width: width * 0.02),

                                              // RIGHT: name + from/to
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    // name (standalone)
                                                    Text(
                                                      item["driver"] ?? "-",
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        color: ColorConstant
                                                            .thirdColor,
                                                        fontSize: width * 0.038,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),

                                                    SizedBox(
                                                        height: width * 0.016),

                                                    // from/to row: connector + addresses
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        // connector column
                                                        SizedBox(
                                                          height: width *
                                                              0.11, // shorter than avatar so name fits above
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Icon(
                                                                  Icons
                                                                      .my_location_outlined,
                                                                  size: width *
                                                                      0.038,
                                                                  color:
                                                                      Colors.red),
                                                              Container(
                                                                width:
                                                                    width * 0.003,
                                                                height:
                                                                    width * 0.025,
                                                                color: ColorConstant
                                                                    .thirdColor
                                                                    .withOpacity(
                                                                        0.2),
                                                              ),
                                                              Icon(
                                                                  CupertinoIcons
                                                                      .location_north_line,
                                                                  size: width *
                                                                      0.045,
                                                                  color: Colors
                                                                      .green),
                                                            ],
                                                          ),
                                                        ),

                                                        SizedBox(
                                                            width: width * 0.02),

                                                        // from/to column (no name here)
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                item["from"] ??
                                                                    "-",
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: TextStyle(
                                                                  color: ColorConstant
                                                                      .thirdColor,
                                                                  fontSize:
                                                                      width *
                                                                          0.03,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height:
                                                                    width * 0.03,
                                                              ),
                                                              Text(
                                                                item["to"] ?? "-",
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: TextStyle(
                                                                  color: ColorConstant
                                                                      .thirdColor,
                                                                  fontSize:
                                                                      width *
                                                                          0.03,
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
                                            ],
                                          ),
                                          SizedBox(height: width * 0.03),
                                          Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  showCancelDialog(context);                                              },
                                                child: Container(
                                                  height: width * 0.08,
                                                  width: width * 0.291,
                                                  decoration: BoxDecoration(
                                                    color: ColorConstant.color11
                                                        .withOpacity(0.1),
                                                    // border: Border.all(
                                                    //     color: ColorConstant.color11
                                                    //         .withOpacity(0.8)),
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(
                                                            width * 0.03)),
                                                  ),
                                                  alignment: Alignment.center,
                                                  child: Text("Cancel",
                                                      style: TextStyle(
                                                          color:
                                                              ColorConstant.color11,
                                                          fontSize: width * 0.033,
                                                          fontWeight:
                                                              FontWeight.w700)),
                                                ),
                                              ),
                                              const Spacer(),
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ReschedulePage(),));
                                                },
                                                child: Container(
                                                  height: width * 0.08,
                                                  width: width * 0.29,
                                                  decoration: BoxDecoration(
                                                    color: ColorConstant.color11
                                                        .withOpacity(0.9),
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(
                                                            width * 0.03)),
                                                  ),
                                                  alignment: Alignment.center,
                                                  child: Text("Reschedule",
                                                      style: TextStyle(
                                                          color:
                                                              ColorConstant.bgColor,
                                                          fontSize: width * 0.033,
                                                          fontWeight:
                                                              FontWeight.w700)),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                            // =================== END INLINE SWITCH ===================
                          ),
                        ),
                      );
                    },
                  ),
                ),


              Padding(
                padding: EdgeInsets.all(width * 0.03),
                child: Container(
                  height: width * 0.4,
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
                                Radius.circular(width * 0.03))),
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
            ],
          ),
        ),
      ),
    );
  }
}
