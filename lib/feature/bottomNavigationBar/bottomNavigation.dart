import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:drivex/core/constants/color_constant.dart';
import 'package:drivex/feature/bottomNavigation/pages/home.dart';
import 'package:drivex/feature/bottomNavigation/pages/sample.dart';
import 'package:drivex/feature/bottomNavigation/profilepage.dart';
import 'package:drivex/feature/bottomNavigationBar/bookingPage.dart';
import 'package:drivex/feature/bottomNavigationBar/home_Page.dart';
import 'package:flutter/material.dart';

class BottomNavDemo extends StatefulWidget {
  @override
  State<BottomNavDemo> createState() => _BottomNavDemoState();
}

class _BottomNavDemoState extends State<BottomNavDemo> {
  int _bottomNavIndex = 0;

  final List<IconData> iconList = [
    Icons.home,
    Icons.local_taxi, // Booking
    Icons.directions_car_outlined, // Vehicle
    Icons.person, // Profile
  ];

  final List<String> labels = [
    "Home",
    "Booking",
    "Vehicle",
    "Profile",
  ];

  final List<Widget> _pages = [
    HomePage(),
    BookingPagee(),
    HomePage(), // 🔧 Create this file instead of `Container()`
    Home(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _pages[_bottomNavIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 2,
              offset: Offset(0, -3),
            ),
          ],
        ),
        child: AnimatedBottomNavigationBar.builder(
          itemCount: iconList.length,
          tabBuilder: (int index, bool isActive) {
            final color = isActive
                ? ColorConstant.color11
                : ColorConstant.color11.withOpacity(0.4);
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(iconList[index], size: 26, color: color),
                const SizedBox(height: 4),
                Text(
                  labels[index],
                  style: TextStyle(color: color, fontSize: 12),
                ),
              ],
            );
          },
          backgroundColor: Colors.white,
          activeIndex: _bottomNavIndex,
          gapLocation: GapLocation.none,
          height: 60,
          notchSmoothness: NotchSmoothness.sharpEdge,
          scaleFactor: 1.0,
          splashColor: Colors.transparent,
          splashSpeedInMilliseconds: 1,
          onTap: (index) {
            setState(() {
              _bottomNavIndex = index;
            });
          },
        ),
      ),
    );
  }
}
