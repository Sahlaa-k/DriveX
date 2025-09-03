import 'dart:io';

import 'package:drivex/core/constants/color_constant.dart';
import 'package:drivex/core/constants/icon_Constants.dart';
import 'package:drivex/core/constants/localVariables.dart';
import 'package:drivex/core/widgets/BackGroundTopGradient.dart';
import 'package:drivex/feature/drivers_page/screens/drivers_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

class DriverBookingPage extends StatefulWidget {
  const DriverBookingPage({super.key});

  @override
  State<DriverBookingPage> createState() => _DriverBookingPageState();
}

class _DriverBookingPageState extends State<DriverBookingPage> {
  bool agreedToTerms = false;
  bool showError = false;
  DateTime? pickupDate;
  DateTime? returnDate;
  TimeOfDay? pickupTime;

  String _formatDate(DateTime? date) {
    if (date == null) return "mm/dd/yyyy";
    return "${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}";
  }

  void pickPickupDate() async {
    final DateTime? dateTime = await showDatePicker(
      context: context,
      initialDate: pickupDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(3000),
    );
    if (dateTime != null) {
      setState(() {
        pickupDate = dateTime;
      });
    }
  }

  void pickPickupTime() async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: pickupTime ?? TimeOfDay.now(),
    );
    if (time != null) {
      setState(() {
        pickupTime = time;
      });
    }
  }

  String selectedMethod = 'Cash';

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController requestController = TextEditingController();
  TextEditingController emergencyPhoneController = TextEditingController();
  String? selectedPassenger;

  final passengerOptions = [
    "1 passenger",
    "2 passengers",
    "3 passengers",
    "4 passengers",
    "5 passengers",
    "6 passengers",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.bgColor,
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(
                bottom: width * 0.15), // Prevent overlap with button
            child: SingleChildScrollView(
              child: Backgroundtopgradient(
                child: Column(
                  children: [
                    SizedBox(height: width * 0.05),
                    Padding(
                      padding: EdgeInsets.all(width * 0.02),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: width * 0.07),
                          Container(
                            height: width * 0.75,
                            width: width,
                            decoration: BoxDecoration(
                              // border: Border.all(
                              //   color: ColorConstant.color11.withOpacity(0.4),
                              // ),
                              color: ColorConstant.bgColor,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(width * 0.02)),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(width * 0.02),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "PickUp Location",
                                    style: TextStyle(
                                      color: ColorConstant.color11
                                          .withOpacity(0.7),
                                      fontSize: width * 0.04,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: width * 0.01),
                                  Container(
                                    height: width * 0.15,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: ColorConstant.color11
                                            .withOpacity(0.3),
                                      ),
                                      color: ColorConstant.bgColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(width * 0.02)),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(width * 0.02),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: width * .11,
                                            width: width * .11,
                                            child: Icon(
                                                CupertinoIcons.location_solid,
                                                color: ColorConstant.color11
                                                    .withOpacity(0.7),
                                                size: width * 0.05),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: ColorConstant.color11
                                                      .withOpacity(0.3)),
                                              color: ColorConstant.bgColor,
                                            ),
                                          ),
                                          SizedBox(
                                            width: width * 0.02,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Perinthalmmanna",
                                                style: TextStyle(
                                                  color:
                                                      ColorConstant.thirdColor,
                                                  fontSize: width * 0.035,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Text(
                                                "Perinthalmmanna, Malappuram",
                                                style: TextStyle(
                                                  color:
                                                      ColorConstant.textColor2,
                                                  fontSize: width * 0.03,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "Drop-off Location",
                                    style: TextStyle(
                                      color: ColorConstant.color11
                                          .withOpacity(0.7),
                                      fontSize: width * 0.04,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: width * 0.01),
                                  Container(
                                    height: width * 0.15,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: ColorConstant.color11
                                            .withOpacity(0.3),
                                      ),
                                      color: ColorConstant.bgColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(width * 0.02)),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(width * 0.02),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: width * .11,
                                            width: width * .11,
                                            child: Icon(
                                                CupertinoIcons.location_solid,
                                                color: ColorConstant.color11
                                                    .withOpacity(0.7),
                                                size: width * 0.05),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: ColorConstant.color11
                                                      .withOpacity(0.3)),
                                              color: ColorConstant.bgColor,
                                            ),
                                          ),
                                          SizedBox(
                                            width: width * 0.02,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Perinthalmmanna",
                                                style: TextStyle(
                                                  color:
                                                      ColorConstant.thirdColor,
                                                  fontSize: width * 0.035,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Text(
                                                "Perinthalmmanna, Malappuram",
                                                style: TextStyle(
                                                  color:
                                                      ColorConstant.textColor2,
                                                  fontSize: width * 0.03,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: width * 0.02),
                                  Text(
                                    "Rental Dates",
                                    style: TextStyle(
                                      color: ColorConstant.color11
                                          .withOpacity(0.7),
                                      fontSize: width * 0.04,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(
                                    height: width * 0.01,
                                  ),
                                  Row(
                                    children: [
                                      // Date Picker
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            pickPickupDate();
                                          },
                                          child: Container(
                                            height: width * 0.15,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: ColorConstant.color11
                                                    .withOpacity(0.3),
                                              ),
                                              color: ColorConstant.bgColor,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      width * 0.02),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: width * 0.03),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "Date",
                                                      style: TextStyle(
                                                        fontSize: width * 0.032,
                                                        color: Colors.grey[600],
                                                      ),
                                                    ),
                                                    Text(
                                                      _formatDate(pickupDate),
                                                      style: TextStyle(
                                                        fontSize: width * 0.036,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: ColorConstant
                                                            .thirdColor,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Icon(
                                                  Icons.calendar_today_outlined,
                                                  size: width * 0.05,
                                                  color: Colors.grey[600],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),

                                      SizedBox(width: width * 0.02),

                                      // Time Picker
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            pickPickupTime();
                                          },
                                          child: Container(
                                            height: width * 0.15,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: ColorConstant.color11
                                                    .withOpacity(0.3),
                                              ),
                                              color: ColorConstant.bgColor,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      width * 0.02),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: width * 0.03),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "Time",
                                                      style: TextStyle(
                                                        fontSize: width * 0.032,
                                                        color: Colors.grey[600],
                                                      ),
                                                    ),
                                                    Text(
                                                      pickupTime != null
                                                          ? pickupTime!
                                                              .format(context)
                                                          : "Select time",
                                                      style: TextStyle(
                                                        fontSize: width * 0.036,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: ColorConstant
                                                            .thirdColor,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Icon(
                                                  Icons.access_time,
                                                  size: width * 0.05,
                                                  color: Colors.grey[600],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: width * 0.02,
                          ),
                          Text(
                            "Number of passengers",
                            style: TextStyle(
                              color: ColorConstant.thirdColor,
                              fontSize: width * 0.038,
                            ),
                          ),
                          DropdownButtonFormField<String>(
                            value: selectedPassenger,
                            decoration: InputDecoration(
                              labelText: "Number of Passengers",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            items: passengerOptions.map((option) {
                              return DropdownMenuItem<String>(
                                value: option,
                                child: Text(option),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedPassenger = value;
                              });
                            },
                          ),
                          Text(
                            "Special Requirements",
                            style: TextStyle(
                              color: ColorConstant.thirdColor,
                              fontSize: width * 0.038,
                            ),
                          ),
                          SizedBox(height: width * 0.02),
                          TextFormField(
                            controller: requestController,
                            maxLines: 3,
                            style: TextStyle(color: ColorConstant.thirdColor),
                            decoration: InputDecoration(
                              hintText:
                                  "Any special requirements? (Child seat, roof rack, delivery instructions, etc.)",
                              hintStyle: TextStyle(
                                color: ColorConstant.color11.withOpacity(0.4),
                                fontSize: width * 0.038,
                              ),
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: ColorConstant.color11),
                                borderRadius:
                                    BorderRadius.circular(width * 0.02),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: ColorConstant.color11),
                                borderRadius:
                                    BorderRadius.circular(width * 0.02),
                              ),
                            ),
                          ),
                          SizedBox(height: width * 0.01),
                          Text(
                            "Optional: Specify any additional needs or instructions",
                            style: TextStyle(
                              fontSize: width * 0.032,
                              color: ColorConstant.color11.withOpacity(0.6),
                            ),
                          ),
                          SizedBox(height: width * 0.02),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Payment Method *",
                                style: TextStyle(
                                  color: ColorConstant.thirdColor,
                                  fontSize: width * 0.038,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: width * 0.025),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.04),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: ColorConstant.color11
                                          .withOpacity(0.5)),
                                  borderRadius:
                                      BorderRadius.circular(width * 0.025),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: selectedMethod,
                                    isExpanded: true,
                                    icon: Icon(Icons.keyboard_arrow_down,
                                        color: ColorConstant.bgColor),
                                    style: TextStyle(
                                      color: ColorConstant.thirdColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: width * 0.04,
                                    ),
                                    items: <String>[
                                      'Cash',
                                      'GPay',
                                      'UPI',
                                      'Card'
                                    ].map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Row(
                                          children: [
                                            Icon(
                                              value == 'Cash'
                                                  ? Icons.money
                                                  : value == 'GPay'
                                                      ? Icons
                                                          .account_balance_wallet
                                                      : value == 'UPI'
                                                          ? Icons
                                                              .qr_code_scanner
                                                          : Icons.credit_card,
                                              color: ColorConstant.bgColor,
                                              size: width * 0.05,
                                            ),
                                            SizedBox(width: width * 0.03),
                                            Text(value),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedMethod = newValue!;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.description,
                                      color: Colors.redAccent),
                                  SizedBox(width: 8),
                                  Text(
                                    "Terms & Conditions *",
                                    style: TextStyle(
                                      fontSize: width * 0.045,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Checkbox(
                                    value: agreedToTerms,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        agreedToTerms = value ?? false;
                                        showError = !agreedToTerms;
                                        if (agreedToTerms) {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: Text("Terms Accepted"),
                                              content: Text(
                                                  "You’ve accepted all terms and policies."),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  child: Text("OK"),
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                      });
                                    },
                                  ),
                                  Expanded(
                                    child: RichText(
                                      text: TextSpan(
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: width * 0.035),
                                        children: [
                                          TextSpan(
                                              text:
                                                  'I have read and agree to the '),
                                          TextSpan(
                                            text: 'Terms and Conditions',
                                            style: TextStyle(
                                                color: Colors.blue,
                                                decoration:
                                                    TextDecoration.underline),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                // Navigate or open link
                                              },
                                          ),
                                          TextSpan(
                                              text:
                                                  ', Privacy Policy, and understand the rental policies including cancellation, damage, and late return charges.'),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  TextButton(
                                    onPressed: () {},
                                    child: Text("View Full Terms"),
                                  ),
                                  Text("•"),
                                  TextButton(
                                    onPressed: () {},
                                    child: Text("Privacy Policy"),
                                  ),
                                  Text("•"),
                                  TextButton(
                                    onPressed: () {},
                                    child: Text("Refund Policy"),
                                  ),
                                ],
                              ),
                              if (showError)
                                Container(
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.only(top: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade50,
                                    border: Border.all(color: Colors.redAccent),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.error_outline,
                                          color: Colors.redAccent),
                                      SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          "Please accept the terms and conditions to proceed with booking",
                                          style: TextStyle(
                                              color: Colors.redAccent),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Booking Summary",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Vehicle",
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 14)),
                                    Text("Honda City",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14)),
                                  ],
                                ),
                                SizedBox(height: 6),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Duration",
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 14)),
                                    Text("Daily",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14)),
                                  ],
                                ),
                                SizedBox(height: 6),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Base Price",
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 14)),
                                    Text("₹1200",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14)),
                                  ],
                                ),
                                SizedBox(height: 6),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("GST (18%)",
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 14)),
                                    Text("₹216",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14)),
                                  ],
                                ),
                                SizedBox(height: 6),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Security Deposit",
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 14)),
                                    Text("₹2000",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14)),
                                  ],
                                ),
                                const Divider(thickness: 1, color: Colors.grey),
                                SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Total Amount",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    Text(
                                      "₹3416",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: Colors.blue,
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
                  ],
                ),
              ),
            ),
          ),

          // Bottom Booking Bar - Fixed
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: width * 0.18,
              padding: EdgeInsets.symmetric(horizontal: width * 0.05),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, -2)),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Price",
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[600])),
                      Text("₹899",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.green,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: ColorConstant.bgColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          title: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                               IconConstants.confirm_booking, // your svg file path
                                height: 60,
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Booking Confirmed ✅",
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          content: Text(
                            "Your booking has been successfully confirmed.",
                            textAlign: TextAlign.center,
                          ),
                          actionsAlignment: MainAxisAlignment.spaceBetween,
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => DriversListTabPage(),));// close dialog
                              },
                              child: Text("OK"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                // Navigate to booking info page
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Container()),
                                );
                              },
                              child: Text("View Info"),
                            ),
                          ],
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "Confirm Booking",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
