import 'package:drivex/core/constants/color_constant.dart';
import 'package:drivex/core/constants/imageConstants.dart';
import 'package:drivex/core/constants/localVariables.dart';
import 'package:flutter/material.dart';

class Onboarding2 extends StatefulWidget {
  const Onboarding2({super.key});

  @override
  State<Onboarding2> createState() => _Onboarding2State();
}

class _Onboarding2State extends State<Onboarding2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.backgroundColor,
      body: Padding(
        padding: EdgeInsets.only(
          top: width * 0.2,
        ),
        child: Column(
          children: [
            SizedBox(
              height: height * 0.5,
              width: width * 1,
              child: Column(
                children: [
                  Container(
                    height: height * 0.2,
                    width: width * 0.9,
                    margin: EdgeInsets.all(width * 0.03),
                    decoration: BoxDecoration(
                        color: ColorConstant.primaryColor,
                        borderRadius: BorderRadius.circular(width * 0.04),
                        image: DecorationImage(
                            image: AssetImage(ImageConstant.safety1),
                            fit: BoxFit.cover),
                        border: Border.all(
                            color:
                                ColorConstant.primaryColor.withOpacity(0.1))),
                  ),
                  Row(
                    children: [
                      Container(
                        height: height * 0.2,
                        width: width * 0.4,
                        margin: EdgeInsets.only(
                          left: width * 0.042,
                          right: width * 0.03,
                        ),
                        decoration: BoxDecoration(
                            color: ColorConstant.primaryColor,
                            borderRadius: BorderRadius.circular(width * 0.04),
                            image: DecorationImage(
                                image: AssetImage(ImageConstant.safety2),
                                fit: BoxFit.cover),
                            border: Border.all(
                                color: ColorConstant.primaryColor
                                    .withOpacity(0.1))),
                      ),
                      Container(
                        height: height * 0.2,
                        width: width * 0.475,
                        decoration: BoxDecoration(
                            color: ColorConstant.primaryColor,
                            borderRadius: BorderRadius.circular(width * 0.04),
                            image: DecorationImage(
                                image: AssetImage(ImageConstant.safety3),
                                fit: BoxFit.fill),
                            border: Border.all(
                                color: ColorConstant.primaryColor
                                    .withOpacity(0.1))),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: height * 0.13,
            ),
            Text(
              "Safety in Every Mile",
              style: TextStyle(
                  color: ColorConstant.thirdColor,
                  fontWeight: FontWeight.w900,
                  fontSize: width * 0.06),
            ),
            SizedBox(
              height: height * 0.01,
            ),
            Padding(
              padding: EdgeInsets.only(left: width * 0.06, right: width * 0.06),
              child: Text(
                "All our drivers are background-checked and rated by users.Your safety is our top priority from pickup to drop-off.",
                style: TextStyle(
                    color: ColorConstant.thirdColor,
                    fontWeight: FontWeight.w500),
              ),
            )
          ],
        ),
      ),
    );
  }
}
