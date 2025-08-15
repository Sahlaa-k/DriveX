import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:drivex/core/constants/localVariables.dart';
import 'package:drivex/feature/bottomNavigation/bookingpage.dart';
import 'package:drivex/feature/bottomNavigation/pages/DriverProfile.dart';
import 'package:drivex/feature/bottomNavigation/pages/home.dart';
import 'package:drivex/feature/bottomNavigation/profilepage.dart';
import 'package:drivex/pages/UserProfile.dart';
import 'package:flutter/material.dart';

import '../../core/constants/color_constant.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int selectIndex = 0;
  List pages = [
    Home(),
    BookingPages(),
    UserProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Ensures the navigation bar overlaps the body
      bottomNavigationBar: CurvedNavigationBar(
        index: selectIndex,
        items: [
          Icon(
            Icons.home_filled,
            size: width * 0.09,
            color: selectIndex == 0
                ? ColorConstant.backgroundColor // Pink for selected
                : ColorConstant.backgroundColor,
          ),
          Icon(
            Icons.list_outlined,
            size: width * 0.09,
            color: selectIndex == 1
                ? ColorConstant.backgroundColor // Pink for selected
                : ColorConstant.backgroundColor,
          ),
          Icon(
            Icons.person,
            size: width * 0.09,
            color: selectIndex == 2
                ? ColorConstant.backgroundColor // Pink for selected
                : ColorConstant.backgroundColor,
          ),
        ],
        color: ColorConstant.color1, // No fixed color for navigation bar
        buttonBackgroundColor: ColorConstant.color1, // Matches page background
        backgroundColor: Colors.transparent, // Makes the navigation bar float
        animationCurve: Curves.easeInOut,

        animationDuration: const Duration(milliseconds: 600),
        onTap: (value) {
          setState(() {
            selectIndex = value;
          });
        },
        letIndexChange: (index) => true,
      ),
      body: pages[selectIndex],
    );
  }
}
