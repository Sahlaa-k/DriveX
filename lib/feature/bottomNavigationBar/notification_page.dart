import 'package:drivex/core/constants/color_constant.dart';
import 'package:drivex/core/constants/localVariables.dart';
import 'package:drivex/core/widgets/BackGroundTopGradient.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.bgColor,
      body: Backgroundtopgradient(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: width * 0.1,
              ),
              Row(
                children: [
                  SizedBox(width: width * 0.02), // Add spacing between icons

                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      CupertinoIcons.back,
                      color: ColorConstant.bgColor,
                      size: width * 0.05,
                    ),
                  ),
                  SizedBox(width: width * 0.02), // Add spacing between icons

                  Text(
                    "Notifications",
                    style: TextStyle(
                        color: ColorConstant.bgColor,
                        fontWeight: FontWeight.w600,
                        fontSize: width * 0.055),
                  ),
                ],
              ),
              Container(
                height: height*0.9,
                width: width,
                child: Center(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Text(
                    "No Notifications",
                    style: TextStyle(
                        color: ColorConstant.thirdColor,
                        fontWeight: FontWeight.w600,
                        fontSize: width * 0.04),
                  ),
                  Text(
                    "We will notify you once  we have \n        something for you",
                    style: TextStyle(
                        color: ColorConstant.textColor3,
                        fontSize: width * 0.03),
                  ),
                ],),),
              )
              // Padding(
              //   padding:
              //       EdgeInsets.only(right: width * 0.02, left: width * 0.02,top: width*.03),
              //   child: Row(
              //     children: [
              //       Expanded(
              //         child: TextFormField(
              //           controller: searchController,
              //           style: TextStyle(
              //             color: ColorConstant.thirdColor,
              //           ),
              //           textCapitalization: TextCapitalization.none,
              //           keyboardType: TextInputType.emailAddress,
              //           textInputAction: TextInputAction.next,
              //           decoration: InputDecoration(
              //             prefixIcon: Icon(Icons.search_rounded),
              //             prefixIconColor: ColorConstant.color11,
              //             hintText: "Search here!",
              //             hintStyle: TextStyle(
              //                 color: ColorConstant.color11.withOpacity(0.4),
              //                 fontSize: width * 0.03),
              //             contentPadding:
              //                 EdgeInsets.symmetric(vertical: width * 0.01),
              //             border: OutlineInputBorder(
              //               borderSide:
              //                   BorderSide(color: ColorConstant.color11),
              //               borderRadius: BorderRadius.circular(width * 0.02),
              //             ),
              //             enabledBorder: OutlineInputBorder(
              //               borderSide:
              //                   BorderSide(color: ColorConstant.color11),
              //               borderRadius: BorderRadius.circular(width * 0.02),
              //             ),
              //             focusedBorder: OutlineInputBorder(
              //               borderSide:
              //                   BorderSide(color: ColorConstant.color11),
              //               borderRadius: BorderRadius.circular(width * 0.02),
              //             ),
              //           ),
              //         ),
              //       ),
              //       SizedBox(width: width * 0.02), // Add spacing between icons
              //       GestureDetector(
              //         onTap: () {
              //           Navigator.push(
              //               context,
              //               MaterialPageRoute(
              //                 builder: (context) => NotificationPage(),
              //               ));
              //         },
              //         child: Icon(
              //           Icons.notifications,
              //           color: ColorConstant.color11,
              //         ),
              //       ),
              //       SizedBox(width: width * 0.02),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
