import 'dart:ui';

import 'package:drivex/core/constants/color_constant.dart';
import 'package:drivex/core/constants/icon_Constants.dart';
import 'package:drivex/core/constants/imageConstants.dart';
import 'package:drivex/core/constants/localVariables.dart';
import 'package:drivex/feature/bottomNavigation/pages/DriverProfile.dart';
import 'package:drivex/feature/drivers_page/screens/driver_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DriversListTabPage extends StatefulWidget {
  const DriversListTabPage({super.key});

  @override
  State<DriversListTabPage> createState() => _DriversListTabPageState();
}

class _DriversListTabPageState extends State<DriversListTabPage> {
  List<String> tabs = ["All", "Top-Rated", "Available", "Near-By"];
  int selectedIndex = 0;
bool isFavorite=false;

  List<Map<String, dynamic>> drivers = [
    {
      "name": "Budi Susanto",
      "experience": "5+ years of experience",
      "rating": 4,
      "rides": 12,
      "price": "40.00 ",
      "available": true,
      "nearby": false,
      "image": ImageConstant.profilePic,
      "service": "Premium Driver"
    },

    {
      "name": "Ravi Kumar",
      "experience": "3 years of experience",
      "rating": 5,
      "rides": 20,
      "price": "50.00 ",
      "available": false,
      "nearby": true,
      "image": ImageConstant.profilePic,
      "service": "Premium Driver"
    },
    {
      "name": "John Doe",
      "experience": "2 years of experience",
      "rating": 4,
      "rides": 9,
      "price": "35.00 ",
      "available": true,
      "nearby": true,
      "image": ImageConstant.profilePic,
      "service": "Premium Driver"
    },
    {
      "name": "Budi Susanto",
      "experience": "5+ years of experience",
      "rating": 4,
      "rides": 12,
      "price": "40.00 ",
      "available": true,
      "nearby": false,
      "image": ImageConstant.profilePic,
      "service": "Premium Driver"
    },


  ];

  List<Map<String, dynamic>> get filteredDrivers {
    if (selectedIndex == 0) return drivers;
    if (selectedIndex == 1) {
      return drivers.where((d) => d["rating"] >= 5).toList();
    }
    if (selectedIndex == 2) {
      return drivers.where((d) => d["available"] == true).toList();
    }
    if (selectedIndex == 3) {
      return drivers.where((d) => d["nearby"] == true).toList();
    }
    return drivers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.bgColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: width * 0.04),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.03),
              child: Row(
                children: [
                  Text(
                    "Drivers",
                    style: TextStyle(
                      color: ColorConstant.color11,
                      fontWeight: FontWeight.w600,
                      fontSize: width * 0.055,
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.search, color: ColorConstant.color11)
                ],
              ),
            ),
            SizedBox(height: width * 0.04),

            // Tab Bar
            Container(
              height: width * 0.12,
              padding: EdgeInsets.symmetric(horizontal: width * 0.03),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: tabs.length,
                itemBuilder: (context, index) {
                  final isSelected = index == selectedIndex;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            tabs[index],
                            style: TextStyle(
                              fontSize: width * 0.04,
                              fontWeight: FontWeight.bold,
                              color: isSelected
                                  ? ColorConstant.color11
                                  : ColorConstant.color11.withOpacity(0.4),
                            ),
                          ),
                          SizedBox(height: 4),
                          if (isSelected)
                            Container(
                              height: 3,
                              width: 40,
                              decoration: BoxDecoration(
                                color: ColorConstant.color11,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Divider(color: ColorConstant.color11.withOpacity(0.2)),
            SizedBox(height: width * 0.03),

            // Driver List
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                itemCount: filteredDrivers.length,

shrinkWrap: true,
                itemBuilder: (context, index) {
                  final driver = filteredDrivers[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => DriverProfilePage(driverData: drivers[index],),));
                    },
                    child: 

                      Container(

                        height: width * 0.32,

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
                                                  driver["price"],
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
                                                    driver["rating"],
                                                        (index) => Icon(
                                                      Icons.star,
                                                      color: Colors.amber,
                                                      size: width * 0.04,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: width * 0.01),
                                                Text(
                                                  "(${driver["rides"].toString()})",
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

                                ],
                              ),
                            ),
                            Positioned(
                              top: width * 0.01,
                              right: width * 0.01,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isFavorite = !isFavorite; // toggle
                                  });
                                },
                                child: Icon(
                                  isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isFavorite
                                      ? Colors.red
                                      : ColorConstant.thirdColor.withOpacity(0.1),
                                  size: width * 0.045,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                  );
                },
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: width * 0.03,  // spacing between columns
                  mainAxisSpacing: width * 0.03,
                  childAspectRatio: width / (height * 0.55), // tweak until it looks perfect
                ),

              ),
            ),
          ],
        ),
      ),
    );
  }
}
