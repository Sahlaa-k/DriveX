import 'package:drivex/core/constants/color_constant.dart';
import 'package:drivex/core/constants/localVariables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetailsPageOfHistory extends StatelessWidget {
  const DetailsPageOfHistory({super.key});

  @override
  Widget build(BuildContext context) {
    const String currency = "\$";

    return Scaffold(
      backgroundColor: ColorConstant.bgColor,
      body: Padding(
        padding: EdgeInsets.all(width * 0.04),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: width * 0.07),

              // ===== Title =====
              Row(
                children: [
                  GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        CupertinoIcons.back,
                        color: ColorConstant.thirdColor,
                        size: width * 0.05,
                      )),
                  Spacer(),
                  Text(
                    "Booking Details",
                    style: TextStyle(
                      fontSize: width * 0.05,
                      fontWeight: FontWeight.bold,
                      color: ColorConstant.thirdColor,
                    ),
                  ),
                  Spacer(),
                ],
              ),

              SizedBox(height: width * 0.06),

              // ===== Driver Card =====
              Container(
                padding: EdgeInsets.all(width * 0.04),
                decoration: BoxDecoration(
                  color: ColorConstant.cardColor,
                  borderRadius: BorderRadius.circular(width * 0.04),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(width * 0.02),
                      child: Image.asset(
                        "assets/images/profile_pic.jpg",
                        height: width * 0.18,
                        width: width * 0.18,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: width * 0.04),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Budi Susanto",
                            style: TextStyle(
                              fontSize: width * 0.045,
                              fontWeight: FontWeight.bold,
                              color: ColorConstant.color11,
                            ),
                          ),
                          SizedBox(height: width * 0.01),
                          Text(
                            "5 years experience",
                            style: TextStyle(
                              fontSize: width * 0.035,
                              color: ColorConstant.thirdColor.withOpacity(0.6),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: width * 0.01),
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.orange, size: width * 0.04),
                              SizedBox(width: width * 0.01),
                              Text(
                                "4.8",
                                style: TextStyle(
                                  fontSize: width * 0.035,
                                  fontWeight: FontWeight.w700,
                                  color: ColorConstant.color11,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: width * 0.05),

              // ===== Route Card =====
              Container(
                padding: EdgeInsets.all(width * 0.04),
                decoration: BoxDecoration(
                  color: ColorConstant.cardColor,
                  borderRadius: BorderRadius.circular(width * 0.04),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Route",
                      style: TextStyle(
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.bold,
                        color: ColorConstant.color11.withOpacity(0.8),
                      ),
                    ),
                    SizedBox(height: width * 0.03),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Icon(Icons.my_location, color: Colors.red, size: width * 0.045),
                            Container(
                              width: width * 0.003,
                              height: width * 0.05,
                              color: ColorConstant.thirdColor.withOpacity(0.3),
                            ),
                            Icon(Icons.location_on, color: Colors.green, size: width * 0.05),
                          ],
                        ),
                        SizedBox(width: width * 0.03),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Kozhikkode Bypass",
                                style: TextStyle(
                                  fontSize: width * 0.035,
                                  fontWeight: FontWeight.w600,
                                  color: ColorConstant.color11,
                                ),
                              ),
                              SizedBox(height: width * 0.025),
                              Text(
                                "Aryambvu, Juma Masjid",
                                style: TextStyle(
                                  fontSize: width * 0.035,
                                  fontWeight: FontWeight.w600,
                                  color: ColorConstant.color11,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: width * 0.05),

              // ===== Date & Time =====
              Container(
                padding: EdgeInsets.all(width * 0.04),
                decoration: BoxDecoration(
                  color: ColorConstant.cardColor,
                  borderRadius: BorderRadius.circular(width * 0.04),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today, color: ColorConstant.color11),
                    SizedBox(width: width * 0.03),
                    Text(
                      "07 Oct 2025, 10:30 AM",
                      style: TextStyle(
                        fontSize: width * 0.038,
                        fontWeight: FontWeight.w600,
                        color: ColorConstant.color11,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: width * 0.05),

              // ===== Payment & Status =====
              Container(
                padding: EdgeInsets.all(width * 0.04),
                decoration: BoxDecoration(
                  color: ColorConstant.cardColor,
                  borderRadius: BorderRadius.circular(width * 0.04),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Payment",
                          style: TextStyle(
                            fontSize: width * 0.038,
                            fontWeight: FontWeight.w600,
                            color: ColorConstant.color11.withOpacity(0.7),
                          ),
                        ),
                        Spacer(),
                        Text(
                          "Card - ${currency}19.50",
                          style: TextStyle(
                            fontSize: width * 0.038,
                            fontWeight: FontWeight.bold,
                            color: ColorConstant.color11,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: width * 0.03),
                    Row(
                      children: [
                        Text(
                          "Booking Status",
                          style: TextStyle(
                            fontSize: width * 0.038,
                            fontWeight: FontWeight.w600,
                            color: ColorConstant.color11.withOpacity(0.7),
                          ),
                        ),
                        Spacer(),
                        Text(
                          "Completed",
                          style: TextStyle(
                            fontSize: width * 0.038,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: width * 0.05),

              // ===== Vehicle Details =====
              Container(
                padding: EdgeInsets.all(width * 0.04),
                decoration: BoxDecoration(
                  color: ColorConstant.cardColor,
                  borderRadius: BorderRadius.circular(width * 0.04),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Vehicle Details",
                      style: TextStyle(
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.bold,
                        color: ColorConstant.color11.withOpacity(0.8),
                      ),
                    ),
                    SizedBox(height: width * 0.03),
                    Row(
                      children: [
                        Text(
                          "Car Model: ",
                          style: TextStyle(fontSize: width * 0.035, color: ColorConstant.color11),
                        ),
                        Spacer(),
                        Text(
                          "Toyota Prius",
                          style: TextStyle(fontSize: width * 0.035, color: ColorConstant.color11),
                        ),
                      ],
                    ),
                    SizedBox(height: width * 0.01),
                    Row(
                      children: [
                        Text(
                          "Transmission: ",
                          style: TextStyle(fontSize: width * 0.035, color: ColorConstant.color11),
                        ),Spacer(),
                        Text(
                          "Automatic",
                          style: TextStyle(fontSize: width * 0.035, color: ColorConstant.color11),
                        ),
                      ],
                    ),
                    SizedBox(height: width * 0.01),
                    Row(
                      children: [
                        Text(
                          "AC: ",
                          style: TextStyle(fontSize: width * 0.035, color: ColorConstant.color11),
                        ),
                        Spacer(),
                        Text(
                          "Available ",
                          style: TextStyle(fontSize: width * 0.035, color: ColorConstant.color11),
                        ),
                      ],
                    ),
                    SizedBox(height: width * 0.01),
                    Row(
                      children: [
                        Text(
                          "Passengers: ",
                          style: TextStyle(fontSize: width * 0.035, color: ColorConstant.color11),
                        ),
                        Spacer(),
                        Text(
                          "4",
                          style: TextStyle(fontSize: width * 0.035, color: ColorConstant.color11),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: width * 0.06),
            ],
          ),
        ),
      ),

    );
  }
}
