import 'package:drivex/core/constants/color_constant.dart';
import 'package:drivex/core/constants/imageConstants.dart';
import 'package:drivex/core/constants/localVariables.dart';
import 'package:flutter/material.dart';

class Onboarding3 extends StatefulWidget {
  const Onboarding3({super.key});

  @override
  State<Onboarding3> createState() => _Onboarding3State();
}

class _Onboarding3State extends State<Onboarding3> {
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
                        image: DecorationImage(image: AssetImage(ImageConstant.booking1),fit: BoxFit.fill),
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
                            image: DecorationImage(image: AssetImage(ImageConstant.booking2),fit: BoxFit.fill),
                            border: Border.all(color: ColorConstant.primaryColor.withOpacity(0.1))
                        ),
                      ),
                      Container(
                        height: height*0.2,
                        width: width*0.4,
                        decoration: BoxDecoration(
                            color: ColorConstant.primaryColor,
                            borderRadius: BorderRadius.circular(width*0.04),
                            image: DecorationImage(image: AssetImage(ImageConstant.booking3),fit: BoxFit.fill),
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
            Text("Flexible Booking Options",style: TextStyle(color: ColorConstant.thirdColor,fontWeight: FontWeight.w900,fontSize: width*0.06),),
            SizedBox(
              height: height*0.01,
            ),Padding(
              padding:  EdgeInsets.only(left:width*0.06,right: width*0.06),
              child: Text("Book for now, later, hourly or daily — it’s your call.Get a driver whenever and however you need.",style: TextStyle(color: ColorConstant.thirdColor,fontWeight: FontWeight.w500),),
            )
          ],
        ),
      ),
    );
  }
}
