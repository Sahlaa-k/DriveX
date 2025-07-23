import 'package:drivex/core/constants/color_constant.dart';
import 'package:flutter/material.dart';

class BookingPages extends StatefulWidget {
  const BookingPages({super.key});

  @override
  State<BookingPages> createState() => _BookingPagesState();
}

class _BookingPagesState extends State<BookingPages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.backgroundColor,
      appBar: AppBar(
        title: Center(
          child: Text("Bookings",style: TextStyle(color: ColorConstant.thirdColor,fontWeight: FontWeight.w700),
          ),
        ),
        backgroundColor: ColorConstant.backgroundColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            
          ],
        ),
      ),
    );
  }
}
