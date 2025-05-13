import 'package:drivex/core/constants/localVariables.dart';
import 'package:drivex/feature/auth/screens/login.dart';
import 'package:drivex/feature/onboarding/onboardingPage.dart';
import 'package:drivex/feature/onboarding/splash.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(const DriveXApp());
}
class DriveXApp extends StatelessWidget {
  const DriveXApp({super.key});
  @override
  Widget build(BuildContext context) {
        width = MediaQuery.of(context).size.width;
        height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child:
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home:  Splash(),
      ),
    );
  }
}