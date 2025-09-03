import 'dart:io';
import 'package:drivex/core/constants/color_constant.dart';
import 'package:drivex/core/constants/localVariables.dart';
import 'package:drivex/core/widgets/BackGroundTopGradient.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ConfirmRent extends StatefulWidget {
  const ConfirmRent({super.key});

  @override
  State<ConfirmRent> createState() => _ConfirmRentState();
}

class _ConfirmRentState extends State<ConfirmRent> {
  DateTime? pickupDate;
  DateTime? returnDate;
  bool agreedToTerms = false;
  bool showError = false;

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

  void pickReturnDate() async {
    final DateTime? dateTime = await showDatePicker(
      context: context,
      initialDate: returnDate ?? DateTime.now(),
      firstDate: pickupDate ?? DateTime.now(),
      lastDate: DateTime(3000),
    );
    if (dateTime != null) {
      setState(() {
        returnDate = dateTime;
      });
    }
  }

  String selectedMethod = 'Cash';

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController requestController = TextEditingController();
  TextEditingController emergencyPhoneController = TextEditingController();
  File? _selectedImage;

  final ImagePicker _picker = ImagePicker();

  Future<void> _showPhotoOptions() async {
    showModalBottomSheet(
      backgroundColor: ColorConstant.bgColor,
      context: context,
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(
                  Icons.photo_camera,
                  color: ColorConstant.color11.withOpacity(0.7),
                ),
                title: Text(
                  'Take Photo',
                  style:
                      TextStyle(color: ColorConstant.color11.withOpacity(0.7)),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  final pickedFile =
                      await _picker.pickImage(source: ImageSource.camera);
                  if (pickedFile != null) {
                    setState(() {
                      _selectedImage = File(pickedFile.path);
                    });
                  }
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.photo_library,
                  color: ColorConstant.color11.withOpacity(0.7),
                ),
                title: Text(
                  'Choose from Gallery',
                  style:
                      TextStyle(color: ColorConstant.color11.withOpacity(0.7)),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  final pickedFile =
                      await _picker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    setState(() {
                      _selectedImage = File(pickedFile.path);
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

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
                          Padding(
                            padding: EdgeInsets.only(
                                right: width * 0.1,
                                left: width * 0.1,
                                top: width * 0.03,
                                bottom: width * 0.02),
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: _showPhotoOptions,
                                  child: Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.all(width * 0.04),
                                    decoration: BoxDecoration(
                                      color: ColorConstant.bgColor,
                                      border: Border.all(
                                          color: ColorConstant.color11
                                              .withOpacity(0.1)),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: ColorConstant.color11
                                              .withOpacity(0.1),
                                          blurRadius: 6,
                                          offset: const Offset(0, 2),
                                        )
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        /// Title
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Driving License Upload",
                                              style: TextStyle(
                                                  color:
                                                      ColorConstant.thirdColor,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: width * 0.04),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16),

                                        /// Image or Placeholder
                                        _selectedImage != null
                                            ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Image.file(
                                                  _selectedImage!,
                                                  width: width * 0.4,
                                                  height: width * 0.4,
                                                  fit: BoxFit.cover,
                                                ),
                                              )
                                            : Column(
                                                children: [
                                                  Icon(Icons.cloud_upload,
                                                      size: width * 0.15,
                                                      color: ColorConstant
                                                          .color11
                                                          .withOpacity(0.7)),
                                                  const SizedBox(height: 10),
                                                  const Text(
                                                    "Upload a clear photo of your valid\n"
                                                    "driving license",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: ColorConstant
                                                            .textColor2),
                                                  ),
                                                ],
                                              ),
                                        const SizedBox(height: 16),

                                        /// Buttons
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            ElevatedButton.icon(
                                              onPressed: () async {
                                                final pickedFile =
                                                    await _picker.pickImage(
                                                        source:
                                                            ImageSource.camera);
                                                if (pickedFile != null) {
                                                  setState(() {
                                                    _selectedImage =
                                                        File(pickedFile.path);
                                                  });
                                                }
                                              },
                                              icon: Icon(
                                                Icons.camera_alt,
                                                color: ColorConstant.bgColor,
                                              ),
                                              label: Text(
                                                "Camera",
                                                style: TextStyle(
                                                    color: ColorConstant
                                                        .bgColor), // Text color
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: ColorConstant
                                                    .color11
                                                    .withOpacity(0.7),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16,
                                                        vertical: 10),
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            ElevatedButton.icon(
                                              onPressed: () async {
                                                final pickedFile =
                                                    await _picker.pickImage(
                                                        source: ImageSource
                                                            .gallery);
                                                if (pickedFile != null) {
                                                  setState(() {
                                                    _selectedImage =
                                                        File(pickedFile.path);
                                                  });
                                                }
                                              },
                                              icon: Icon(
                                                Icons.photo_library,
                                                color: ColorConstant.color11
                                                    .withOpacity(0.7),
                                              ),
                                              label: Text(
                                                "Gallery",
                                                style: TextStyle(
                                                    color: ColorConstant.color11
                                                        .withOpacity(0.7)),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    ColorConstant.bgColor,
                                                foregroundColor:
                                                    ColorConstant.thirdColor,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16,
                                                        vertical: 10),
                                              ),
                                            ),
                                          ],
                                        ),

                                        SizedBox(height: width * 0.03),

                                        /// Footer
                                        const Text(
                                          "Keep your valid license visible",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: ColorConstant.textColor2),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: width * 0.02),
                          Container(
                            height: width * 0.52,
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
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            pickPickupDate();
                                          },
                                          child: Container(
                                            height: width * 0.17,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: ColorConstant.color11
                                                    .withOpacity(0.3),
                                              ),
                                              color: ColorConstant.bgColor,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                      width * 0.02)),
                                            ),
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.all(width * 0.01),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    height: width * .12,
                                                    width: width * .12,
                                                    child: Icon(
                                                        CupertinoIcons
                                                            .car_detailed,
                                                        color: ColorConstant
                                                            .color11
                                                            .withOpacity(0.7),
                                                        size: width * 0.06),
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                          color: ColorConstant
                                                              .color11
                                                              .withOpacity(
                                                                  0.3)),
                                                      color:
                                                          ColorConstant.bgColor,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: width * 0.02,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            "Pickup Date",
                                                            style: TextStyle(
                                                              color: ColorConstant
                                                                  .color11
                                                                  .withOpacity(
                                                                      0.7),
                                                              fontSize:
                                                                  width * 0.038,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width:
                                                                width * 0.025,
                                                          ),
                                                          Icon(
                                                            Icons
                                                                .calendar_month,
                                                            color: ColorConstant
                                                                .color11
                                                                .withOpacity(
                                                                    0.7),
                                                            size: width * 0.045,
                                                          ),
                                                        ],
                                                      ),
                                                      Text(
                                                        _formatDate(pickupDate),
                                                        style: TextStyle(
                                                          fontSize:
                                                              width * 0.035,
                                                          color: ColorConstant
                                                              .thirdColor,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: width * 0.02),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            pickReturnDate();
                                          },
                                          child: Container(
                                            height: width * 0.17,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: ColorConstant.color11
                                                    .withOpacity(0.3),
                                              ),
                                              color: ColorConstant.bgColor,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                      width * 0.02)),
                                            ),
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.all(width * 0.01),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Container(
                                                    height: width * .12,
                                                    width: width * .12,
                                                    child: Icon(
                                                        CupertinoIcons
                                                            .car_detailed,
                                                        color: ColorConstant
                                                            .color11
                                                            .withOpacity(0.7),
                                                        size: width * 0.06),
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                          color: ColorConstant
                                                              .color11
                                                              .withOpacity(
                                                                  0.3)),
                                                      color:
                                                          ColorConstant.bgColor,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: width * 0.02,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            "Return Date",
                                                            style: TextStyle(
                                                              color: ColorConstant
                                                                  .color11
                                                                  .withOpacity(
                                                                      0.7),
                                                              fontSize:
                                                                  width * 0.038,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: width * 0.02,
                                                          ),
                                                          Icon(
                                                            Icons
                                                                .calendar_month,
                                                            color: ColorConstant
                                                                .color11
                                                                .withOpacity(
                                                                    0.7),
                                                            size: width * 0.045,
                                                          ),
                                                        ],
                                                      ),
                                                      Text(
                                                        _formatDate(returnDate),
                                                        style: TextStyle(
                                                          fontSize:
                                                              width * 0.035,
                                                          color: ColorConstant
                                                              .thirdColor,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
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
                          // Contact Info Title
                          Text(
                            "Contact Information *",
                            style: TextStyle(
                              color: ColorConstant.color11,
                              fontWeight: FontWeight.w600,
                              fontSize: width * 0.045,
                            ),
                          ),
                          SizedBox(height: width * 0.04),

                         // Full Name
                          Text(
                            "Full Name *",
                            style: TextStyle(
                              color: ColorConstant.thirdColor,
                              fontSize: width * 0.038,
                            ),
                          ),
                          SizedBox(height: width * 0.02),
                        Container(
                          height:width*0.1,
                          child: TextFormField(
                            controller: nameController,
                            style: TextStyle(
                              color: ColorConstant.thirdColor,
                            ),
                            textCapitalization: TextCapitalization.none,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              hintText: "Full name",

                              hintStyle: TextStyle(
                                  color: ColorConstant.color11.withOpacity(0.4),
                                  fontSize: width * 0.04),
                              contentPadding:
                              EdgeInsets.only(top: width * 0.01,right: width*0.04),
                              border: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: ColorConstant.color11.withOpacity(0.7)),
                                borderRadius: BorderRadius.circular(width * 0.02),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: ColorConstant.color11.withOpacity(0.7)),
                                borderRadius: BorderRadius.circular(width * 0.02),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: ColorConstant.color11.withOpacity(0.7)),
                                borderRadius: BorderRadius.circular(width * 0.02),
                              ),
                            ),
                          ),
                        ),
                          SizedBox(height: width * 0.04),

                          // Phone Number
                          Text(
                            "Phone Number *",
                            style: TextStyle(
                              color: ColorConstant.thirdColor,
                              fontSize: width * 0.038,
                            ),
                          ),
                          SizedBox(height: width * 0.02),
                          TextFormField(
                            controller: phoneController,
                            keyboardType: TextInputType.phone,
                            style: TextStyle(color: ColorConstant.thirdColor),
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.phone,
                                  color: ColorConstant.bgColor),
                              hintText: "+91 98765 43210",
                              hintStyle: TextStyle(
                                color: ColorConstant.color11.withOpacity(0.4),
                                fontSize: width * 0.04,
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
                          SizedBox(height: width * 0.04),

// Email Address
                          Text(
                            "Email Address *",
                            style: TextStyle(
                              color: ColorConstant.thirdColor,
                              fontSize: width * 0.038,
                            ),
                          ),
                          SizedBox(height: width * 0.02),
                          TextFormField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(color: ColorConstant.thirdColor),
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.email,
                                  color: ColorConstant.bgColor),
                              hintText: "sarah.johnson@email.com",
                              hintStyle: TextStyle(
                                color: ColorConstant.color11.withOpacity(0.4),
                                fontSize: width * 0.04,
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
                          SizedBox(height: width * 0.04),

// Emergency Contact
                          Text(
                            "Emergency Contact Number *",
                            style: TextStyle(
                              color: ColorConstant.thirdColor,
                              fontSize: width * 0.038,
                            ),
                          ),
                          SizedBox(height: width * 0.02),
                          TextFormField(
                            controller: emergencyPhoneController,
                            keyboardType: TextInputType.phone,
                            style: TextStyle(color: ColorConstant.thirdColor),
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.phone_android,
                                  color: ColorConstant.bgColor),
                              hintText: "+91 87654 32109",
                              hintStyle: TextStyle(
                                color: ColorConstant.color11.withOpacity(0.4),
                                fontSize: width * 0.04,
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
                            "This contact will be notified in case of emergency during rental",
                            style: TextStyle(
                              fontSize: width * 0.032,
                              color: ColorConstant.color11.withOpacity(0.6),
                            ),
                          ),
                          SizedBox(height: width * 0.04),

// Special Requirements
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

                          // Row(
                          //   crossAxisAlignment: CrossAxisAlignment.end,
                          //   children: [
                          //     Container(
                          //       height: width * .12,
                          //       width: width * .12,
                          //       child: Icon(CupertinoIcons.location_solid,
                          //           color:
                          //               ColorConstant.color11.withOpacity(0.7),
                          //           size: width * 0.05),
                          //       decoration: BoxDecoration(
                          //         shape: BoxShape.circle,
                          //         border: Border.all(
                          //             color: ColorConstant.color11
                          //                 .withOpacity(0.3)),
                          //         color: ColorConstant.bgColor,
                          //       ),
                          //     ),
                          //     SizedBox(
                          //       width: width * 0.02,
                          //     ),
                          //     Column(
                          //       crossAxisAlignment: CrossAxisAlignment.start,
                          //       children: [
                          //         Text(
                          //           "Perinthalmmanna",
                          //           style: TextStyle(
                          //             color: ColorConstant.thirdColor,
                          //             fontSize: width * 0.04,
                          //             fontWeight: FontWeight.w500,
                          //           ),
                          //         ),
                          //         Text(
                          //           "Perinthalmmanna, Malappuram",
                          //           style: TextStyle(
                          //             color: ColorConstant.textColor2,
                          //             fontSize: width * 0.035,
                          //             fontWeight: FontWeight.w500,
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          //   ],
                          // ),
                          // SizedBox(height: width * 0.3),
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
                      // Confirm booking logic
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text("Confirm Booking",
                        style: TextStyle(color: Colors.white)),
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
