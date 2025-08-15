import 'dart:io';

import 'package:drivex/core/constants/color_constant.dart';
import 'package:drivex/core/constants/localVariables.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class D2Dpage02 extends StatefulWidget {
  final String pickupLocation;
  final String dropLocation;
  const D2Dpage02({
    super.key,
    required this.pickupLocation,
    required this.dropLocation,
  });

  @override
  State<D2Dpage02> createState() => _D2Dpage02State();
}

class _D2Dpage02State extends State<D2Dpage02> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  final int totalSteps = 3;

  TextEditingController _valueController = TextEditingController(text: '0');
  final TextEditingController otherTypeController = TextEditingController();
  bool get showOtherField => selectedKey == 'other';

  bool isFormValid() {
    // Package type must be selected
    final isPackageTypeValid = selectedKey != null &&
        (!showOtherField || otherTypeController.text.trim().isNotEmpty);

    // Weight must be selected
    final isWeightValid = selectedWeightKey != null;

    // Checkbox must be ticked
    final isCheckboxValid = _isChecked;

    return isPackageTypeValid && isWeightValid && isCheckboxValid;
  }

  // bool _isChecked = false;

  String? selectedKey;
  String? selectedWeightKey;
  bool _isChecked = false;

  /////////////////
  List<String> primaryKeys = [
    'documents',
    'food_items',
    'electronics',
    'clothing',
    'fragile_items',
    'medical_items',
    'other'
  ];
  List<String> extraKeys = ['groceries', 'furniture', 'liquids', 'jewellery'];
  List<String> visibleKeys = [];

  void showOtherDialog() async {
    String? selectedExtra = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Select a Package Type"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: extraKeys.map((key) {
              final item = packageTypeMap[key]!;
              return ListTile(
                leading: Icon(
                  item['icon'],
                  color: item['restricted'] ? Colors.orange : Colors.black,
                ),
                title: Text(item['label']),
                onTap: () => Navigator.pop(context, key),
              );
            }).toList(),
          ),
        );
      },
    );

    if (selectedExtra != null) {
      setState(() {
        visibleKeys.removeWhere((key) => key == selectedExtra);
        visibleKeys.insert(visibleKeys.length - 1, selectedExtra);

        // ✅ This is what was missing:
        selectedKey = selectedExtra;

        // Optional: clean up if too many keys visible
        if (visibleKeys.length > 8) {
          visibleKeys.removeAt(visibleKeys.indexOf('medical_items'));
        }
      });
    }
  }

  /////////////////

  final Map<String, Map<String, dynamic>> packageTypeMap = {
    'document': {
      'label': 'Document',
      'icon': Icons.description,
    },
    'box': {
      'label': 'Box',
      'icon': Icons.inbox,
    },
    'food': {
      'label': 'Food',
      'icon': Icons.fastfood,
    },
    'gift': {
      'label': 'Gift',
      'icon': Icons.card_giftcard,
    },
    'electronics': {
      'label': 'Electronics',
      'icon': Icons.devices_other,
    },
    'clothes': {
      'label': 'Clothes',
      'icon': Icons.checkroom,
    },
    'fragile': {
      'label': 'Fragile',
      'icon': Icons.emoji_objects,
    },
    'other': {
      'label': 'Other',
      'icon': Icons.more_horiz,
    },
  };

  bool isOtherSelected = false;
  final TextEditingController otherController = TextEditingController();

  final Map<String, String> paymentTypeMap = {
    'cod': 'Cash on Delivery',
    'upi': 'UPI Payment',
  };

  String? selectedPaymentKey;

  ////////Photo picker
//   Future<void> requestPermissions() async {
//   final statuses = await [
//     Permission.camera,
//     Permission.storage,
//     Permission.photos,
//     Permission.mediaLibrary,
//   ].request();

//   if (statuses[Permission.camera]!.isDenied ||
//       statuses[Permission.storage]!.isDenied) {
//     // Show dialog: You need to allow permissions
//   }
// }

  File? _selectedImage;

  final ImagePicker _picker = ImagePicker();

  Future<void> _showPhotoOptions() async {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Take Photo'),
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
                leading: Icon(Icons.photo_library),
                title: Text('Choose from Gallery'),
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
  ////////Photo picker

  // double _packageValue = 50;
  final Map<String, String> packageWeightMap = {
    '0.5-3': '0.5-3 kg',
    '4-7': '4-7 kg',
    '8-10': '8-10 kg',
  };
  void _nextPage() {
    if (_currentStep < totalSteps - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _prevPage() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Widget _buildStepIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (index) {
        bool isDone = index < _currentStep;
        bool isCurrent = index == _currentStep;

        return Row(
          children: [
            CircleAvatar(
              radius: width * .025,
              backgroundColor:
                  isDone || isCurrent ? Colors.blue : Colors.grey[300],
              child: Icon(
                isDone
                    ? Icons.check
                    : (isCurrent ? Icons.circle : Icons.circle_outlined),
                color: Colors.white,
                size: width * .025,
              ),
            ),
            if (index != totalSteps - 1)
              Container(
                width: width * .1,
                height: width * .01,
                color: index < _currentStep ? Colors.blue : Colors.grey[300],
              )
          ],
        );
      }),
    );
  }

  @override
  void initState() {
    super.initState();

    otherTypeController.addListener(() {
      // Only rebuild if 'Other' is selected to avoid unnecessary rebuilds
      if (showOtherField) {
        setState(() {});
      }
    });

    _valueController.addListener(() {
      setState(() {}); // rebuilds the widget when value changes
    });

    _pageController.addListener(() {
      int newPage = _pageController.page!.round();
      if (_currentStep != newPage) {
        setState(() {
          _currentStep = newPage;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget buildPageContent(Widget content) {
    return Column(
      children: [
        // SizedBox(height: 20),
        // Text(title,
        //     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(height: width * .05),
        Expanded(child: content),
        Padding(
          padding: EdgeInsets.all(width * .02),
          child: Row(
            children: [
              if (_currentStep > 0)
                ElevatedButton(
                  onPressed: _prevPage,
                  child: Text("Back"),
                ),
              Spacer(),
              if (_currentStep < totalSteps - 1)
                ElevatedButton(
                  onPressed: _nextPage,
                  child: Text("Next"),
                ),
              if (_currentStep == totalSteps - 1)
                ElevatedButton(
                  onPressed: () {
                    // Final step action
                  },
                  child: Text("Confirm Secure Booking"),
                ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String> weightKeys = packageWeightMap.keys.toList();
    final List<String> packageTypeKeys = packageTypeMap.keys.toList();
    final List<String> paymentKeys = paymentTypeMap.keys.toList();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Secure Door-to-Door Delivery",
          style: TextStyle(
            fontSize: width * .05,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(height: width * .025),
          _buildStepIndicator(),
          SizedBox(height: width * .025),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                SingleChildScrollView(
                  child: Padding(
                      padding: EdgeInsets.only(
                          right: width * .02, left: width * .02),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: width * .05),
                          // Title
                          // Text(
                          //   "Contact Information",
                          //   style: TextStyle(
                          //     fontSize: width * 0.05,
                          //     fontWeight: FontWeight.w600,
                          //   ),
                          // ),
                          // SizedBox(height: width * .03),

                          // Sender Name
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: _showPhotoOptions,
                                child: Container(
                                  width: width * 0.25,
                                  height: width * 0.25,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius:
                                        BorderRadius.circular(width * 0.04),
                                    color: Colors.grey.shade100,
                                  ),
                                  child: _selectedImage != null
                                      ? Container(
                                          width: width * 0.25,
                                          height: width * 0.25,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                width * 0.04),
                                            image: DecorationImage(
                                              image: FileImage(_selectedImage!),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        )
                                      // ?  ClipRRect(
                                      //     borderRadius:
                                      //         BorderRadius.circular(width * 0.04),
                                      //     child: Image.file(
                                      //       _selectedImage!,
                                      //       width: width * 0.4,
                                      //       height: width * 0.4,
                                      //       fit: BoxFit.cover,
                                      //     ),
                                      //   )

                                      : Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.camera_alt,
                                                size: width * 0.08,
                                                color: Colors.grey),
                                            SizedBox(height: width * 0.01),
                                            Text(
                                              "Add Photo",
                                              style: TextStyle(
                                                  fontSize: width * 0.035,
                                                  color: Colors.grey),
                                            ),
                                          ],
                                        ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: width * .03),
                          Text(
                            "Sender Information",
                            style: TextStyle(
                              fontSize: width * 0.05,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: width * .03),
                          Text(
                            "Sender Name",
                            style: TextStyle(
                              fontSize: width * 0.035,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          SizedBox(
                            height: width * .1125,
                            child: TextFormField(
                              enabled:
                                  true, // or false, depending on your logic
                              decoration: InputDecoration(
                                hintText: "Enter sender's name",
                                hintStyle: TextStyle(
                                  fontSize: width * 0.038,
                                  color: Colors.grey[600],
                                ),
                                prefixIcon: Icon(Icons.person_outline,
                                    size: width * 0.06),
                                filled: true,
                                fillColor: Colors.white,
                                //  fillColor: Colors.white,

                                // Normal enabled border
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(width * .025),
                                  borderSide: BorderSide(
                                      color: ColorConstant.color1,
                                      width: width * .0025 // use main color
                                      ),
                                ),

                                // Focused border
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(width * .025),
                                  borderSide: BorderSide(
                                    color: ColorConstant.color1,
                                    width: width * .0025,
                                  ),
                                ),

                                // Disabled border
                                disabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(width * .025),
                                  borderSide: BorderSide(
                                    color:
                                        ColorConstant.color1.withOpacity(0.5),
                                    width: width * .0025,
                                  ),
                                ),

                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: width * 0.04,
                                  vertical: width * 0.025,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: width * .02),

                          // Sender Phone
                          Text(
                            "Sender's Phone Number",
                            style: TextStyle(
                              fontSize: width * 0.035,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          // SizedBox(height: width * 0.04),
                          // TextFormField(
                          //   keyboardType: TextInputType.phone,
                          //   decoration: InputDecoration(
                          //     hintText: "Enter sender's phone number",
                          //     border: OutlineInputBorder(
                          //       borderRadius: BorderRadius.circular(12),
                          //     ),
                          //     contentPadding: EdgeInsets.symmetric(
                          //       horizontal: width * 0.04,
                          //       vertical: width * 0.04,
                          //     ),
                          //   ),
                          // ),
                          SizedBox(
                            height: width * .1125,
                            child: TextFormField(
                              keyboardType: TextInputType.phone,
                              maxLength: 10, // optional: restrict to 10 digits
                              decoration: InputDecoration(
                                counterText: "", // hides the character count
                                hintText: "Enter sender's phone",
                                hintStyle: TextStyle(
                                  fontSize: width * 0.038,
                                  color: Colors.grey[600],
                                ),
                                prefixIcon: Icon(Icons.phone_outlined,
                                    size: width * 0.06),
                                filled: true,
                                fillColor: Colors.white,

                                // Enabled border
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(width * .025),
                                  borderSide: BorderSide(
                                    color: ColorConstant.color1,
                                    width: width * 0.0025,
                                  ),
                                ),

                                // Focused border
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(width * .025),
                                  borderSide: BorderSide(
                                    color: ColorConstant.color1,
                                    width: width * 0.0025,
                                  ),
                                ),

                                // Disabled border
                                disabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(width * .025),
                                  borderSide: BorderSide(
                                    color:
                                        ColorConstant.color1.withOpacity(0.5),
                                    width: width * .0025,
                                  ),
                                ),

                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: width * 0.04,
                                  vertical: width * 0.025,
                                ),
                              ),
                            ),
                          ),

                          // SizedBox(height: width * 0.04),
                          SizedBox(height: width * .05),
                          // Receiver Title
                          Text(
                            "Receiver Information",
                            style: TextStyle(
                              fontSize: width * 0.05,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: width * 0.03),

                          // Receiver Name
                          Text(
                            "Receiver Name",
                            style: TextStyle(
                              fontSize: width * 0.035,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          SizedBox(
                            height: width * .1125,
                            child: TextFormField(
                              enabled:
                                  true, // or false, depending on your logic
                              decoration: InputDecoration(
                                hintText: "Enter reciever's name",
                                hintStyle: TextStyle(
                                  fontSize: width * 0.038,
                                  color: Colors.grey[600],
                                ),
                                prefixIcon: Icon(Icons.person_outline,
                                    size: width * 0.06),
                                filled: true,
                                fillColor: Colors.white,

                                // Normal enabled border
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(width * .025),
                                  borderSide: BorderSide(
                                      color: ColorConstant.color1,
                                      width: width * .0025 // use main color
                                      ),
                                ),

                                // Focused border
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(width * .025),
                                  borderSide: BorderSide(
                                    color: ColorConstant.color1,
                                    width: width * .0025,
                                  ),
                                ),

                                // Disabled border
                                disabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(width * .025),
                                  borderSide: BorderSide(
                                    color:
                                        ColorConstant.color1.withOpacity(0.5),
                                    width: width * .0025,
                                  ),
                                ),

                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: width * 0.04,
                                  vertical: width * 0.025,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: width * .02),

                          // Receiver Phone
                          Text(
                            "Receiver's Phone Number",
                            style: TextStyle(
                              fontSize: width * 0.035,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          // SizedBox(height: width * 0.04),
                          SizedBox(
                            height: width * .1125,
                            child: TextFormField(
                              keyboardType: TextInputType.phone,
                              maxLength: 10, // optional: restrict to 10 digits
                              decoration: InputDecoration(
                                counterText: "", // hides the character count
                                hintText: "Enter reciever's phone",
                                hintStyle: TextStyle(
                                  fontSize: width * 0.038,
                                  color: Colors.grey[600],
                                ),
                                prefixIcon: Icon(Icons.phone_outlined,
                                    size: width * 0.06),
                                filled: true,
                                fillColor: Colors.white,

                                // Enabled border
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(width * .025),
                                  borderSide: BorderSide(
                                    color: ColorConstant.color1,
                                    width: width * 0.0025,
                                  ),
                                ),

                                // Focused border
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(width * .025),
                                  borderSide: BorderSide(
                                    color: ColorConstant.color1,
                                    width: width * 0.0025,
                                  ),
                                ),

                                // Disabled border
                                disabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(width * .025),
                                  borderSide: BorderSide(
                                    color:
                                        ColorConstant.color1.withOpacity(0.5),
                                    width: width * .0025,
                                  ),
                                ),

                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: width * 0.04,
                                  vertical: width * 0.025,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: width * .02),
                          Container(
                            // height: width * .2,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              // border: Border.all(),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(width * .02)),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(width * .02),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Delivery Route",
                                    style: TextStyle(
                                      fontSize: width * 0.04,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Row(
                                    // crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      // Icons column
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Wrap(
                                            crossAxisAlignment:
                                                WrapCrossAlignment.center,
                                            children: [
                                              Icon(Icons.circle_outlined,
                                                  color: Colors.blue,
                                                  size: width * 0.05),
                                              SizedBox(width: width * 0.03),
                                              Text("${widget.pickupLocation}"),
                                              // Text("(10.9865183,76.2234233)")
                                            ],
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: width * .0225),
                                            child: Container(
                                              width: width * 0.005,
                                              height: width * 0.075,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          Wrap(
                                            crossAxisAlignment:
                                                WrapCrossAlignment.center,
                                            children: [
                                              Icon(Icons.circle_outlined,
                                                  color: Colors.red,
                                                  size: width * 0.05),
                                              SizedBox(width: width * 0.03),
                                              // Text(
                                              //   "X6PF+55R, X6PF+55R, Valiyangadi, Perinthalmanna, Kerala, India, 679322",
                                              //   style: TextStyle(fontSize: 8.5),
                                              // ),
                                              Text("${widget.dropLocation}")
                                            ],
                                          ),
                                        ],
                                      ),
                                      // SizedBox(width: width * 0.03),
                                      // Text fields column
                                      // Expanded(
                                      //   child: Column(
                                      //     children: [
                                      //       SizedBox(
                                      //         height: width * 0.1,
                                      //         child: TextFormField(
                                      //           // controller:
                                      //           //     receivePickupController,
                                      //           style: TextStyle(
                                      //               fontSize: width * 0.035),
                                      //           decoration: InputDecoration(
                                      //             hintText: 'Pickup Location',
                                      //             hintStyle: TextStyle(
                                      //                 fontSize: width * 0.035),
                                      //             // suffixIcon: Padding(
                                      //             //     padding: EdgeInsets.all(width * 0.025),
                                      //             //     child: Icon(Icons.my_location_rounded)),
                                      //             filled: true,
                                      //             fillColor: Colors.grey
                                      //                 .withOpacity(0.25),
                                      //             contentPadding:
                                      //                 EdgeInsets.symmetric(
                                      //               vertical: width * 0.015,
                                      //               horizontal: width * 0.03,
                                      //             ),
                                      //             border: OutlineInputBorder(
                                      //               borderRadius:
                                      //                   BorderRadius.circular(
                                      //                       width * 0.03),
                                      //               borderSide: BorderSide.none,
                                      //             ),
                                      //           ),
                                      //         ),
                                      //       ),
                                      //       SizedBox(height: width * 0.03),
                                      //       SizedBox(
                                      //         height: width * 0.1,
                                      //         child: TextFormField(
                                      //           // controller:
                                      //           //     receiveDropController,
                                      //           style: TextStyle(
                                      //               fontSize: width * 0.035),
                                      //           decoration: InputDecoration(
                                      //             hintText: 'Drop-off Location',
                                      //             hintStyle: TextStyle(
                                      //                 fontSize: width * 0.035),
                                      //             suffixIcon: Padding(
                                      //                 padding: EdgeInsets.only(
                                      //                     bottom: width * 0.005),
                                      //                 child: Icon(Icons
                                      //                     .my_location_rounded)),
                                      //             filled: true,
                                      //             fillColor: Colors.grey
                                      //                 .withOpacity(0.25),
                                      //             contentPadding:
                                      //                 EdgeInsets.symmetric(
                                      //               vertical: width * 0.015,
                                      //               horizontal: width * 0.03,
                                      //             ),
                                      //             border: OutlineInputBorder(
                                      //               borderRadius:
                                      //                   BorderRadius.circular(
                                      //                       width * 0.03),
                                      //               borderSide: BorderSide.none,
                                      //             ),
                                      //           ),
                                      //         ),
                                      //       ),
                                      //     ],
                                      //   ),
                                      // ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: width * .05),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _nextPage();
                                },
                                child: Container(
                                  width: width * .25,
                                  height: width * .125,
                                  decoration: BoxDecoration(
                                      color: Colors.blue,
                                      // border: Border.all(),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(width * .02))),
                                  child: Center(
                                    child: Text(
                                      "NEXT",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      )),
                ),
                //////////////////////////////////////////////////////
                // buildPageContent(
                //     // "Package Details & Verification",
                //     Center(child: Text("Step 1 UI here"))),
                SingleChildScrollView(
                  child: Padding(
                      padding: EdgeInsets.only(
                          right: width * .02, left: width * .02),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: width * .05),
                          // Title
                          Text(
                            "Package Details & Verification",
                            style: TextStyle(
                              fontSize: width * 0.05,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          SizedBox(height: width * .05),
                          Text(
                            "Package Type",
                            style: TextStyle(
                              fontSize: width * 0.038,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          // GridView.builder(
                          //   shrinkWrap: true,
                          //   itemCount: 8,
                          //   gridDelegate:
                          //       SliverGridDelegateWithFixedCrossAxisCount(
                          //           crossAxisCount: 4),
                          //   itemBuilder: (context, index) {
                          //     return Padding(
                          //       padding: EdgeInsets.all(4),
                          //       child: Container(
                          //         decoration: BoxDecoration(
                          //             border: Border.all(
                          //                 color: Colors.black.withOpacity(.25)),
                          //             borderRadius: BorderRadius.all(
                          //                 Radius.circular(width * .025))),
                          //         child: Center(
                          //           child: Column(
                          //             mainAxisSize: MainAxisSize.min,
                          //             children: [
                          //               Icon(Icons.abc_outlined),
                          //               Text("data")
                          //             ],
                          //           ),
                          //         ),
                          //       ),
                          //     );
                          //   },
                          // ),

                          // final List<String> keys = packageTypeMap.keys.toList();
                          GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: packageTypeKeys.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              mainAxisSpacing: width * 0.02,
                              crossAxisSpacing: width * 0.02,
                              childAspectRatio: 1,
                            ),
                            itemBuilder: (context, index) {
                              final key = packageTypeKeys[index];
                              final item = packageTypeMap[key]!;
                              final isSelected = selectedKey == key;

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedKey = key;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Colors.blue.withOpacity(0.05)
                                        : null,
                                    border: Border.all(
                                      color: isSelected
                                          ? Colors.blue
                                          : Colors.black.withOpacity(0.25),
                                      width: isSelected
                                          ? width * 0.005
                                          : width * 0.003,
                                    ),
                                    borderRadius:
                                        BorderRadius.circular(width * 0.025),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      vertical: width * 0.02),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        item['icon'],
                                        color: isSelected
                                            ? Colors.blue
                                            : Colors.black,
                                        size: width * 0.07,
                                      ),
                                      SizedBox(height: width * 0.015),
                                      Text(
                                        item['label'],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: width * 0.025,
                                          color: isSelected
                                              ? Colors.blue
                                              : Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          if (showOtherField)
                            Padding(
                              padding: EdgeInsets.only(top: width * 0.03),
                              child: TextFormField(
                                controller: otherTypeController,
                                decoration: InputDecoration(
                                  labelText: "Enter package type",
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (showOtherField &&
                                      (value == null || value.trim().isEmpty)) {
                                    return 'Please enter package type';
                                  }
                                  return null;
                                },
                              ),
                            ),

                          // GridView.builder(
                          //   shrinkWrap: true,
                          //   physics: NeverScrollableScrollPhysics(),
                          //   itemCount: visibleKeys.length,
                          //   gridDelegate:
                          //       SliverGridDelegateWithFixedCrossAxisCount(
                          //     crossAxisCount: 4,
                          //   ),
                          //   itemBuilder: (context, index) {
                          //     final key = visibleKeys[index];
                          //     final item = packageTypeMap[key]!;
                          //     final isSelected = selectedKey == key;

                          //     return GestureDetector(
                          //       onTap: () {
                          //         setState(() {
                          //           selectedKey = key;
                          //           isOtherSelected = key == 'other';
                          //         });
                          //       },
                          //       child: Padding(
                          //         padding: EdgeInsets.all(width * .01),
                          //         child: Container(
                          //           decoration: BoxDecoration(
                          //             color: isSelected
                          //                 ? Colors.blue.withOpacity(0.1)
                          //                 : null,
                          //             border: Border.all(
                          //               color: isSelected
                          //                   ? Colors.blue
                          //                   : Colors.black.withOpacity(.25),
                          //               width: isSelected
                          //                   ? width * .0075
                          //                   : width * .004,
                          //             ),
                          //             borderRadius:
                          //                 BorderRadius.circular(width * .025),
                          //           ),
                          //           child: Center(
                          //             child: Column(
                          //               mainAxisSize: MainAxisSize.min,
                          //               children: [
                          //                 Icon(
                          //                   item['icon'],
                          //                   color: isSelected
                          //                       ? Colors.blue
                          //                       : Colors.black,
                          //                 ),
                          //                 SizedBox(height: width * .01),
                          //                 Text(
                          //                   item['label'],
                          //                   textAlign: TextAlign.center,
                          //                   style: TextStyle(
                          //                     fontSize: width * .025,
                          //                     color: isSelected
                          //                         ? Colors.blue
                          //                         : Colors.black,
                          //                   ),
                          //                 ),
                          //               ],
                          //             ),
                          //           ),
                          //         ),
                          //       ),
                          //     );
                          //   },
                          // ),

                          // // ✅ Show TextFormField when "other" is selected
                          // if (isOtherSelected)
                          //   Padding(
                          //     padding: const EdgeInsets.symmetric(vertical: 12),
                          //     child: TextFormField(
                          //       controller: otherController,
                          //       decoration: InputDecoration(
                          //         labelText: 'Enter package type',
                          //         border: OutlineInputBorder(),
                          //       ),
                          //     ),
                          //   ),

                          // GridView.builder(
                          //   shrinkWrap: true,
                          //   physics: NeverScrollableScrollPhysics(),
                          //   itemCount: packageTypeMap.length,
                          //   gridDelegate:
                          //       SliverGridDelegateWithFixedCrossAxisCount(
                          //     crossAxisCount: 4,
                          //   ),
                          //   itemBuilder: (context, index) {
                          //     final key = keys[index];
                          //     final item = packageTypeMap[key]!;

                          //     final bool isSelected = key == selectedKey;

                          //     return GestureDetector(
                          //       onTap: () {
                          //         setState(() {
                          //           selectedKey = key;
                          //         });
                          //       },
                          //       child: Padding(
                          //         padding: EdgeInsets.all(width * .01),
                          //         child: Container(
                          //           decoration: BoxDecoration(
                          //             color: isSelected
                          //                 ? Colors.blue.withOpacity(0.1)
                          //                 : null,
                          //             border: Border.all(
                          //               color: isSelected
                          //                   ? Colors.blue
                          //                   : item['restricted']
                          //                       ? Colors.orange
                          //                       : Colors.black.withOpacity(.25),
                          //               width: isSelected
                          //                   ? width * .0075
                          //                   : width * .004,
                          //             ),
                          //             borderRadius:
                          //                 BorderRadius.circular(width * .025),
                          //           ),
                          //           child: Center(
                          //             child: Column(
                          //               mainAxisSize: MainAxisSize.min,
                          //               children: [
                          //                 if (item['icon'] != null)
                          //                   Icon(
                          //                     item['icon'],
                          //                     color: item['restricted']
                          //                         ? Colors.orange
                          //                         : isSelected
                          //                             ? Colors.blue
                          //                             : Colors.black,
                          //                   ),
                          //                 SizedBox(height: width * .01),
                          //                 Text(
                          //                   item['label'],
                          //                   textAlign: TextAlign.center,
                          //                   style: TextStyle(
                          //                     fontSize: width * .025,
                          //                     color: item['restricted']
                          //                         ? Colors.orange
                          //                         : isSelected
                          //                             ? Colors.blue
                          //                             : Colors.black,
                          //                   ),
                          //                 ),
                          //               ],
                          //             ),
                          //           ),
                          //         ),
                          //       ),
                          //     );
                          //   },
                          // ),

                          SizedBox(height: width * .05),
                          Text(
                            "Package Weight",
                            style: TextStyle(
                              fontSize: width * 0.038,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          // SizedBox(height: width * .025),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: packageWeightMap.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                              childAspectRatio: 3.5, // Adjust height
                            ),
                            itemBuilder: (context, index) {
                              final key = weightKeys[index];
                              final value = packageWeightMap[key]!;
                              final bool isSelected = key == selectedWeightKey;

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedWeightKey = key;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Colors.blue.withOpacity(0.05)
                                        : null,
                                    border: Border.all(
                                      color: isSelected
                                          ? Colors.blue
                                          : Colors.black.withOpacity(0.25),
                                      width: isSelected ? 2 : 1,
                                    ),
                                    borderRadius:
                                        BorderRadius.circular(width * .025),
                                  ),
                                  child: Center(
                                    child: Text(
                                      value,
                                      style: TextStyle(
                                        fontSize: width * 0.04,
                                        color: isSelected
                                            ? Colors.blue
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          // Slider(
                          //   value: _packageValue,
                          //   min: 0,
                          //   max: 50000,
                          //   divisions: 50,
                          //   label: "\$${_packageValue.round()}",
                          //   onChanged: (value) {
                          //     setState(() {
                          //       _packageValue = value;
                          //     });
                          //   },
                          // ),
                          // Text("Estimated Value: \$${_packageValue.round()}"),
                          SizedBox(height: width * .05),
                          // Row(
                          //   children: [
                          //     Text(
                          //       "Package Estimated Value : ",
                          //       style: TextStyle(
                          //         fontSize: width * 0.038,
                          //         fontWeight: FontWeight.w500,
                          //       ),
                          //     ),
                          //     Expanded(
                          //       child: Container(
                          //         height: width * .1125,
                          //         // height: width * .075,
                          //         decoration: BoxDecoration(
                          //           border: Border.all(color: Colors.grey),
                          //           borderRadius:
                          //               BorderRadius.circular(width * .025),
                          //         ),
                          //         child: Row(
                          //           children: [
                          //             IconButton(
                          //               icon: Icon(Icons.remove),
                          //               onPressed: () {
                          //                 setState(() {
                          //                   int currentValue = int.tryParse(
                          //                           _valueController.text) ??
                          //                       0;
                          //                   currentValue -= 10;
                          //                   if (currentValue < 0)
                          //                     currentValue = 0;
                          //                   _valueController.text =
                          //                       currentValue.toString();
                          //                 });
                          //               },
                          //             ),
                          //             Expanded(
                          //               child: TextFormField(
                          //                 controller: _valueController,
                          //                 textAlign: TextAlign.center,
                          //                 keyboardType: TextInputType.number,
                          //                 decoration: InputDecoration(
                          //                   // hintText: "Enter value of package",
                          //                   // hintStyle: TextStyle(
                          //                   //     fontSize: width * .02),
                          //                   border: InputBorder.none,
                          //                   isDense: true,
                          //                   contentPadding: EdgeInsets.zero,
                          //                 ),
                          //                 onChanged: (value) {
                          //                   // Optional: Clean invalid input
                          //                   final parsed = int.tryParse(value);
                          //                   if (parsed == null &&
                          //                       value.isNotEmpty) {
                          //                     _valueController.text = '0';
                          //                     _valueController.selection =
                          //                         TextSelection.fromPosition(
                          //                             TextPosition(
                          //                                 offset:
                          //                                     _valueController
                          //                                         .text
                          //                                         .length));
                          //                   }
                          //                 },
                          //               ),
                          //             ),
                          //             IconButton(
                          //               icon: Icon(Icons.add),
                          //               onPressed: () {
                          //                 setState(() {
                          //                   int currentValue = int.tryParse(
                          //                           _valueController.text) ??
                          //                       0;
                          //                   currentValue += 50;
                          //                   _valueController.text =
                          //                       currentValue.toString();
                          //                 });
                          //               },
                          //             ),
                          //           ],
                          //         ),
                          //       ),
                          //     )
                          //   ],
                          // ),

                          // Container(
                          //   padding: EdgeInsets.symmetric(
                          //     horizontal: width * .025,
                          //     vertical: width * .01,
                          //   ),
                          //   decoration: BoxDecoration(
                          //     border: Border.all(color: Colors.grey),
                          //     borderRadius: BorderRadius.circular(width * .025),
                          //   ),
                          //   child: Row(
                          //     children: [
                          //       // - Button (Decrease by 10)
                          //       IconButton(
                          //         icon: Icon(Icons.remove),
                          //         onPressed: () {
                          //           setState(() {
                          //             int currentValue =
                          //                 int.tryParse(_valueController.text) ??
                          //                     0;
                          //             currentValue -= 10;
                          //             if (currentValue < 0) currentValue = 0;
                          //             _valueController.text =
                          //                 currentValue.toString();
                          //           });
                          //         },
                          //       ),

                          //       // Editable Text Field
                          //       Expanded(
                          //         child: TextFormField(
                          //           controller: _valueController,
                          //           textAlign: TextAlign.center,
                          //           keyboardType: TextInputType.number,
                          //           decoration: InputDecoration(
                          //             hintText: "Enter value of your package",
                          //             border: InputBorder.none,
                          //             isDense: true,
                          //             contentPadding: EdgeInsets.zero,
                          //           ),
                          //           onChanged: (value) {
                          //             // Optional: Clean invalid input
                          //             final parsed = int.tryParse(value);
                          //             if (parsed == null && value.isNotEmpty) {
                          //               _valueController.text = '0';
                          //               _valueController.selection =
                          //                   TextSelection.fromPosition(
                          //                       TextPosition(
                          //                           offset: _valueController
                          //                               .text.length));
                          //             }
                          //           },
                          //         ),
                          //       ),

                          //       // + Button (Increase by 50)
                          //       IconButton(
                          //         icon: Icon(Icons.add),
                          //         onPressed: () {
                          //           setState(() {
                          //             int currentValue =
                          //                 int.tryParse(_valueController.text) ??
                          //                     0;
                          //             currentValue += 50;
                          //             _valueController.text =
                          //                 currentValue.toString();
                          //           });
                          //         },
                          //       ),
                          //     ],
                          //   ),
                          // ),

                          // SizedBox(
                          //   height: width * .025,
                          // ),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(width * 0.025),
                            // margin: EdgeInsets.symmetric(
                            //   horizontal: width * 0.02,
                            //   vertical: width * 0.02,
                            // ),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.05),
                              border: Border.all(color: Colors.red.shade200),
                              borderRadius: BorderRadius.circular(width * 0.03),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Headline
                                Text(
                                  '🚫 Prohibited Items',
                                  style: TextStyle(
                                    fontSize: width * 0.035,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red.shade700,
                                  ),
                                ),
                                // SizedBox(height: width * 0.005),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: width * 0.01),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "• ",
                                        style:
                                            TextStyle(fontSize: width * 0.035),
                                      ),
                                      Expanded(
                                        child: Text(
                                          '''explosives, flammable liquids, and toxic chemicals Weapons, narcotics, perishable foods, and live animals are strictly not allowed. Illegal goods, counterfeit items, and valuable documents should not be sent''',
                                          style:
                                              TextStyle(fontSize: width * 0.03),
                                          textAlign: TextAlign.justify,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Bullet items
                                // _bulletItem(
                                //     "Explosives or flammable materials (e.g. fireworks, gasoline)",
                                //     width * .85),
                                // _bulletItem(
                                //     "Toxic chemicals or corrosives (e.g. acids, pesticides)",
                                //     width * .85),
                                // _bulletItem(
                                //     "Weapons, ammunition, or replicas (e.g. guns, knives)",
                                //     width * .85),
                                // _bulletItem(
                                //     "Illegal drugs or controlled substances",
                                //     width * .85),
                                // _bulletItem(
                                //     "Unpackaged perishable food (meat, seafood, dairy)",
                                //     width * .85),
                                // _bulletItem(
                                //     "Live animals or insects", width * .85),
                                // _bulletItem(
                                //     "Hazardous or radioactive materials",
                                //     width * .85),
                                // _bulletItem("Counterfeit or pirated goods",
                                //     width * .85),
                                // _bulletItem("Oversized or overweight packages",
                                //     width * .85),
                                // _bulletItem(
                                //     "Confidential documents without seal",
                                //     width * .85),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: width * .025,
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                top: width * 0.02, bottom: width * 0.02),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(width * 0.03),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Checkbox(
                                  value: _isChecked,
                                  onChanged: (value) {
                                    setState(() {
                                      _isChecked = value ?? false;
                                    });
                                  },
                                  activeColor: Colors.blue,
                                ),
                                Expanded(
                                  child: Text(
                                    "I agree to the Terms and Conditions and Privacy Policy.",
                                    style: TextStyle(fontSize: width * 0.035),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: width * .05),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _prevPage();
                                },
                                child: Container(
                                  width: width * .25,
                                  height: width * .125,
                                  decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      // border: Border.all(),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(width * .02))),
                                  child: Center(
                                    child: Text(
                                      "PREV",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87),
                                    ),
                                  ),
                                ),
                              ),
                              // GestureDetector(
                              //   onTap: () {
                              //     final estimatedValue =
                              //         int.tryParse(_valueController.text) ?? 0;

                              //     if (selectedKey == null) {
                              //       ScaffoldMessenger.of(context).showSnackBar(
                              //         SnackBar(
                              //             content: Text(
                              //                 "Please select a package type.")),
                              //       );
                              //       return;
                              //     }

                              //     if (selectedWeightKey == null) {
                              //       ScaffoldMessenger.of(context).showSnackBar(
                              //         SnackBar(
                              //             content: Text(
                              //                 "Please select a package weight.")),
                              //       );
                              //       return;
                              //     }

                              //     if (estimatedValue <= 0) {
                              //       ScaffoldMessenger.of(context).showSnackBar(
                              //         SnackBar(
                              //             content: Text(
                              //                 "Please enter a valid estimated value.")),
                              //       );
                              //       return;
                              //     }

                              //     // If all conditions are valid, proceed
                              //     _nextPage();
                              //   },
                              //   child: Container(
                              //     width: width * .25,
                              //     height: width * .125,
                              //     decoration: BoxDecoration(
                              //         color: Colors.blue,
                              //         // border: Border.all(),
                              //         borderRadius: BorderRadius.all(
                              //             Radius.circular(width * .02))),
                              //     child: Center(
                              //       child: Text(
                              //         "NEXT",
                              //         style: TextStyle(
                              //             fontWeight: FontWeight.w600,
                              //             color: Colors.white),
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              GestureDetector(
                                onTap: () {
                                  if (isFormValid()) {
                                    _nextPage();
                                  } else {
                                    // You can also show a snackbar or message here
                                  }
                                },
                                child: Container(
                                  width: width * .25,
                                  height: width * .125,
                                  decoration: BoxDecoration(
                                    color: isFormValid()
                                        ? Colors.blue
                                        : Colors.grey, // visual feedback
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(width * .02),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "NEXT",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      )),
                ),
                SingleChildScrollView(
                  child: Padding(
                    padding:
                        EdgeInsets.only(right: width * .02, left: width * .02),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: width * .05),
                        Text(
                          "Payment & Confirmation",
                          style: TextStyle(
                            fontSize: width * 0.05,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          // height: width * .125,
                          decoration: BoxDecoration(
                              color: Colors.grey[300],
                              // border: Border.all(),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(width * .02))),
                          child: Padding(
                            padding: EdgeInsets.all(width * .02),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Sender Name",
                                  style: TextStyle(
                                    fontSize: width * 0.04,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Service",
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: width * 0.035,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Text(
                                      "Standard Delivery",
                                      style: TextStyle(
                                        fontSize: width * 0.035,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Base Price",
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: width * 0.035,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Text(
                                      "15",
                                      style: TextStyle(
                                        fontSize: width * 0.035,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Total",
                                      style: TextStyle(
                                        fontSize: width * 0.04,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      "15",
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: width * 0.04,
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
                          "Payment Method",
                          style: TextStyle(
                            fontSize: width * 0.04,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: paymentTypeMap.length,
                          itemBuilder: (context, index) {
                            final key = paymentKeys[index];
                            final value = paymentTypeMap[key]!;
                            final bool isSelected = key == selectedPaymentKey;

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedPaymentKey = key;
                                });
                              },
                              child: Container(
                                width: double.infinity,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.blue.withOpacity(0.05)
                                      : null,
                                  border: Border.all(
                                    color: isSelected
                                        ? Colors.blue
                                        : Colors.black.withOpacity(0.25),
                                    width: isSelected ? 2 : 1,
                                  ),
                                  borderRadius:
                                      BorderRadius.circular(width * 0.025),
                                ),
                                child: Center(
                                  child: Text(
                                    value,
                                    style: TextStyle(
                                      fontSize: width * 0.04,
                                      color: isSelected
                                          ? Colors.blue
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                _prevPage();
                              },
                              child: Container(
                                width: width * .25,
                                height: width * .125,
                                decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    // border: Border.all(),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(width * .02))),
                                child: Center(
                                  child: Text(
                                    "PREV",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _nextPage();
                              }, // disables tap if not valid
                              child: Container(
                                width: width * .25,
                                height: width * .125,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(width * .02)),
                                ),
                                child: Center(
                                  child: Text(
                                    "Confirm",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
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

                // buildPageContent(
                //     // "Final Step",
                //     Center(child: Text("Step 4 UI here"))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget _bulletItem(String text, double width) {
  //   return Padding(
  //     padding: EdgeInsets.symmetric(vertical: width * 0.01),
  //     child: Row(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           "• ",
  //           style: TextStyle(fontSize: width * 0.035),
  //         ),
  //         Expanded(
  //           child: Text(
  //             text,
  //             style: TextStyle(fontSize: width * 0.035),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
