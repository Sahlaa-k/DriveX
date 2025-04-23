import 'package:drivex/pages/home.dart';
import 'package:flutter/material.dart';

import 'dart:async';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with TickerProviderStateMixin {
  List<String> letters = ['r', 'i', 'v', 'e'];
  List<Widget> fadedLetters = [];

  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  late double height;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeOutBack,
    );

    _scaleController.forward();

    Future.delayed(const Duration(milliseconds: 800), () {
      _addLettersOneByOne();
    });
  }

  void _addLettersOneByOne() async {
    for (int i = 0; i < letters.length; i++) {
      AnimationController fadeController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 200),
      );
      Animation<double> fadeAnimation =
          CurvedAnimation(parent: fadeController, curve: Curves.easeIn);

      fadeController.forward();

      setState(() {
        fadedLetters.add(
          FadeTransition(
            opacity: fadeAnimation,
            child: Text(
              letters[i],
              style: TextStyle(
                color: Colors.blueAccent,
                fontSize: height * 0.05,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      });

      await Future.delayed(const Duration(milliseconds: 400));
    }

    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Home(),), (route) => false,);
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: height * 0.05,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2,
              ),
              children: [
                const TextSpan(text: 'D'),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: fadedLetters,
                  ),
                ),
                const TextSpan(text: 'X'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
