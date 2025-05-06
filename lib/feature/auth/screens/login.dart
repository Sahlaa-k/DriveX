import 'package:drivex/core/constants/color_constant.dart';
import 'package:drivex/core/constants/localVariables.dart';
import 'package:drivex/feature/onboarding/animatedLogo2.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.primaryColor,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              height: height * 1,
              width: width * 1,
              decoration: BoxDecoration(
                color: ColorConstant.backgroundColor,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(width*0.4)),

              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: height * 0.43,
              width: width * 1,
              decoration: BoxDecoration(
                  color: ColorConstant.primaryColor,
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(width*0.4),topRight:  Radius.circular(width*0.4)),

              ),
              child: Center(
                child: Container(
                  height: height * 0.43,
                  width: width*1,
                  child: Center(
                    child: AnimatedLogo2(
                      fontSize: height * 0.05,
                      animateLetters: true,
                       ),
                  ),
                  decoration: BoxDecoration(
                    // color: ColorConstant.secondaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(width*0.4),topRight:  Radius.circular(width*0.4),bottomRight:Radius.circular(width*0.4),topLeft: Radius.circular(width*0.4) ),
                      gradient: LinearGradient(
                          colors:[
                            ColorConstant.primaryColor,
                            ColorConstant.secondaryColor,


                          ],
                          begin:Alignment.topLeft,

                          end:Alignment.bottomRight,
                          stops: [
                            0.4,0.8
                          ]
                      )
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
