import 'package:drivex/feature/bottomNavigation/bookingpage.dart';
import 'package:drivex/feature/bottomNavigation/pages/home.dart';
import 'package:drivex/feature/bottomNavigation/profilepage.dart';
import 'package:flutter/material.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}
 
class _BottomNavigationState extends State<BottomNavigation> {
  int _bottomNavIndex = 0;

  final List<Widget> _screens = [
    Home(),
    BookingPages(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_bottomNavIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomNavIndex,
        onTap: (index) => setState(() => _bottomNavIndex = index),
        items: const [
          BottomNavigationBarItem(label: 'Home', icon: SizedBox.shrink()),
          BottomNavigationBarItem(label: 'Profile', icon: SizedBox.shrink()),
          BottomNavigationBarItem(label: 'Settings', icon: SizedBox.shrink()),
        ],
      ),
    );
  }
}
