import 'package:drivex/core/constants/color_constant.dart';
import 'package:drivex/core/constants/imageConstants.dart';
import 'package:drivex/core/constants/localVariables.dart';
import 'package:flutter/material.dart';

class Onboarding1 extends StatefulWidget {
  const Onboarding1({super.key});

  @override
  State<Onboarding1> createState() => _Onboarding1State();
}

class _Onboarding1State extends State<Onboarding1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
backgroundColor: ColorConstant.backgroundColor,

      body: Padding(
        padding:  EdgeInsets.only(top: width*0.2,),
        child: Column(
          children: [
            SizedBox(
              height: height*0.5,
              width: width*1,
              child: Row(
                children: [
                  Container(
                    height: height*0.5,
                    width: width*0.4,
                    margin: EdgeInsets.only(left: width*0.08),
                    decoration: BoxDecoration(
                      color: ColorConstant.primaryColor,
                      borderRadius: BorderRadius.circular(width*0.04),
                      image: DecorationImage(image: AssetImage(ImageConstant.findDriver2),fit: BoxFit.fill),
                                               border: Border.all(color: ColorConstant.primaryColor.withOpacity(0.1))

              ),
                  ),
                  Column(
                    children: [
                      Container(
                        height: height*0.285,
                        width: width*0.4,
                        margin: EdgeInsets.only(left:width*0.03,right: width*0.03,bottom: width*0.03),
                        decoration: BoxDecoration(

                            color: ColorConstant.primaryColor,
                            borderRadius: BorderRadius.circular(width*0.04),
                            image: DecorationImage(image: AssetImage(ImageConstant.findDriver1),fit: BoxFit.cover)
,                          border: Border.all(color: ColorConstant.primaryColor.withOpacity(0.1))

                        ),
                      ),
                      Container(
                        height: height*0.2,
                        width: width*0.4,
                        decoration: BoxDecoration(
                            color: ColorConstant.primaryColor,
                            borderRadius: BorderRadius.circular(width*0.04),
                            image: DecorationImage(image: AssetImage(ImageConstant.findDriver3),fit: BoxFit.cover),
                          border: Border.all(color: ColorConstant.primaryColor.withOpacity(0.1))

                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: height*0.13,
            ),
            Text("Find a Driver Anytime",style: TextStyle(color: ColorConstant.thirdColor,fontWeight: FontWeight.w900,fontSize: width*0.06),),
            SizedBox(
              height: height*0.01,
            ),Padding(
              padding:  EdgeInsets.only(left:width*0.06,right: width*0.06),
              child: Text("Looking for a reliable driver at any hour?Get instant access to verified drivers near you—day or night.",style: TextStyle(color: ColorConstant.thirdColor,fontWeight: FontWeight.w500),),
            )
          ],
        ),
      ),
    );
  }
}
