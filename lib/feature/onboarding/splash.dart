
import 'package:drivex/core/constants/localVariables.dart';
import 'package:drivex/feature/onboarding/animatedLogo.dart';
import 'package:drivex/feature/onboarding/onboardingPage.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with TickerProviderStateMixin {


  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 3000), () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => OnboardingPages()),
            (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: AnimatedLogo(
          fontSize: height * 0.05,
          animateLetters: true,
        ),
      ),
    );
  }
}
