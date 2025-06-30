import 'package:drivex/core/constants/color_constant.dart';
import 'package:drivex/core/constants/localVariables.dart';
import 'package:drivex/core/widgets/BackGroundTopGradient.dart';
import 'package:drivex/feature/bottomNavigation/pages/DriverHomePage.dart';
import 'package:drivex/feature/bottomNavigation/pages/DriverProfile.dart';
import 'package:drivex/feature/bottomNavigation/pages/RequestPage.dart';
import 'package:drivex/pages/AddDriver.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Map<String, dynamic>> drivers = [
    {
      'name': 'Ravi Kumar',
      'rating': 4.8,
      'location': '1.2 km',
      'bio': '5+ yrs experience, knows city well',
      'image': 'https://i.pravatar.cc/150?img=1',
    },
    {
      'name': 'Amit Verma',
      'rating': 4.6,
      'location': '2.5 km',
      'bio': 'Punctual & polite, 3+ yrs driving',
      'image': 'https://i.pravatar.cc/150?img=2',
    },
    {
      'name': 'Suresh Menon',
      'rating': 4.9,
      'location': '900 m',
      'bio': 'Expert in hill driving, 10+ yrs exp.',
      'image': 'https://i.pravatar.cc/150?img=3',
    },
    {
      'name': 'Kiran Joshi',
      'rating': 4.7,
      'location': '3.1 km',
      'bio': 'Good with long-distance trips, 7 yrs exp.',
      'image': 'https://i.pravatar.cc/150?img=4',
    },
    {
      'name': 'Neeraj Yadav',
      'rating': 4.5,
      'location': '1.8 km',
      'bio': 'Speaks Hindi, English, and Malayalam',
      'image': 'https://i.pravatar.cc/150?img=5',
    },
    {
      'name': 'Meena Rathi',
      'rating': 4.9,
      'location': '500 m',
      'bio': 'First-aid trained, 8 yrs exp., safe driver',
      'image': 'https://i.pravatar.cc/150?img=6',
    },
    {
      'name': 'Vikram Shah',
      'rating': 4.4,
      'location': '2.2 km',
      'bio': 'Knows shortcuts, tech-savvy, 6 yrs exp.',
      'image': 'https://i.pravatar.cc/150?img=7',
    },
    {
      'name': 'Anjali Desai',
      'rating': 4.8,
      'location': '700 m',
      'bio': 'Calm driver, good with senior citizens',
      'image': 'https://i.pravatar.cc/150?img=8',
    },
    {
      'name': 'Mohammed Irfan',
      'rating': 4.6,
      'location': '3.4 km',
      'bio': 'Experienced with both manual & automatic',
      'image': 'https://i.pravatar.cc/150?img=9',
    },
    {
      'name': 'Divya Narayan',
      'rating': 4.7,
      'location': '1.1 km',
      'bio': 'Friendly, family-safe, 4 yrs exp.',
      'image': 'https://i.pravatar.cc/150?img=10',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.backgroundColor,
      // backgroundColor: Colors.blue,
      body: Backgroundtopgradient(
        child: Padding(
          padding: EdgeInsets.only(
            right: width * .025,
            left: width * .025,
            // bottom: width * .025,
          ),
          child: Column(
            children: [
              SizedBox(height: width * .025), SizedBox(height: width * .1),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [],
              ),

              // Container(
              //   decoration: BoxDecoration(
              //     border: Border.all()
              //   ),
              //   child: SizedBox(height: width * .05)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'DriveX',
                    style: GoogleFonts.inika(
                        color: Colors.white,
                        fontSize: width * .06,
                        fontWeight: FontWeight.w500),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => Driverhomepage(),
                          ));
                    },
                    child: Container(
                      height: width * .1,
                      width: width * .1,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(width * .02),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.notifications,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: width * .1),
              SizedBox(
                child: TextFormField(
                  style: TextStyle(
                    fontSize: width * 0.04,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search drivers...',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: ColorConstant.secondaryColor,
                      size: width * 0.06,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: width * 0.035,
                      horizontal: width * 0.04,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(width * 0.035),
                      borderSide: BorderSide(
                        color: ColorConstant.secondaryColor.withOpacity(0.2),
                        width: 1.2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(width * 0.035),
                      borderSide: BorderSide(
                        color: ColorConstant.secondaryColor,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(
                    right: width * .03, left: width * .03, top: width * 0.03),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Hire Driver For You",
                      style: TextStyle(
                        color: ColorConstant.thirdColor,
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
                      onTap: () {},
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
              ListView.builder(
                itemCount: drivers.length,
                padding:
                    EdgeInsets.only(bottom: width * 0.025, top: width * 0.025),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final driver = drivers[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) =>
                              DriverProfilePage(driver: driver),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: width * 0.035),
                      padding: EdgeInsets.all(width * 0.035),
                      decoration: BoxDecoration(
                        // color: ColorConstant.primaryColor.withOpacity(0.08),
                        color: ColorConstant.textColor1,
                        borderRadius: BorderRadius.circular(width * 0.03),
                        border: Border.all(
                            color: ColorConstant.primaryColor.withOpacity(0.2)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: width * 0.075,
                            backgroundImage:
                                NetworkImage(driver['image'].toString()),
                          ),
                          SizedBox(width: width * 0.04),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  driver['name'].toString(),
                                  style: TextStyle(
                                    fontSize: width * 0.045,
                                    fontWeight: FontWeight.w600,
                                    color: ColorConstant.thirdColor,
                                  ),
                                ),
                                SizedBox(height: width * 0.01),
                                Text(
                                  driver['bio'].toString(),
                                  style: TextStyle(
                                    fontSize: width * 0.033,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: width * 0.025),
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: width * 0.02,
                                          vertical: width * 0.01),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                            width * 0.015),
                                        border: Border.all(
                                            color: Colors.grey.shade300),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(Icons.star,
                                              size: width * 0.035,
                                              color: Colors.orange),
                                          SizedBox(width: width * 0.01),
                                          Text(
                                            driver['rating'].toString(),
                                            style: TextStyle(
                                                fontSize: width * 0.03),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: width * 0.015),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: width * 0.02,
                                          vertical: width * 0.01),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                            width * 0.015),
                                        border: Border.all(
                                            color: Colors.grey.shade300),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(Icons.location_on,
                                              size: width * 0.035,
                                              color: Colors.blueAccent),
                                          SizedBox(width: width * 0.01),
                                          Text(
                                            driver['location'].toString(),
                                            style: TextStyle(
                                                fontSize: width * 0.03),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: width * 0.015),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: width * 0.02,
                                          vertical: width * 0.01),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                            width * 0.015),
                                        border: Border.all(
                                            color: Colors.grey.shade300),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(Icons.circle,
                                              size: width * 0.025,
                                              color: Colors.green),
                                          SizedBox(width: width * 0.01),
                                          Text(
                                            'Available',
                                            style: TextStyle(
                                                fontSize: width * 0.03),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: width * 0.015),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: width * 0.045,
                            color: ColorConstant.secondaryColor,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              SizedBox(
                height: width * .25,
              )
            ],
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
                  builder: (context) => RequestPage(),
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
