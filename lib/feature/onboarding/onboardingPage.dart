import 'package:drivex/core/constants/localVariables.dart';
import 'package:drivex/feature/auth/screens/login.dart';
import 'package:drivex/feature/onboarding/onboarding1.dart';
import 'package:drivex/feature/onboarding/onboarding2.dart';
import 'package:drivex/feature/onboarding/onboarding3.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../core/constants/color_constant.dart';
import '../../main.dart';

class OnboardingPages extends StatefulWidget {
  const OnboardingPages({super.key});

  @override
  State<OnboardingPages> createState() => _OnboardingPagesState();
}

class _OnboardingPagesState extends State<OnboardingPages> {
  PageController pageController = PageController();
  ValueNotifier<int> currentIndex = ValueNotifier<int>(0);

  List<Map<String, dynamic>> onBoardingData = [
    {"page": Onboarding1()},
    {"page": Onboarding2()},
    {"page": Onboarding3()},
  ];

  @override
  void dispose() {
    pageController.dispose();
    currentIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: pageController,
            itemCount: onBoardingData.length,
            onPageChanged: (value) {
              currentIndex.value = value;
            },
            itemBuilder: (context, index) {
              return Column(
                children: [
                  SizedBox(
                    child: SizedBox(
                      height: height * 1,
                      width: width * 1,
                      child: onBoardingData[index]["page"],
                    ),
                  ),
                ],
              );
            },
          ),
          Positioned(
            left: width * 0.4,
            top: height * 0.65,
            child: SmoothPageIndicator(
              controller: pageController,
              count: onBoardingData.length,
              effect: WormEffect(
                activeDotColor: ColorConstant.secondaryColor,
                dotColor: ColorConstant.primaryColor,
                dotHeight: width * 0.01,
                dotWidth: width * 0.04,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ValueListenableBuilder<int>(
                    valueListenable: currentIndex,
                    builder: (context, index, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // if (index != onBoardingData.length - 1)
                          //   GestureDetector(
                          //     onTap: () {
                          //       pageController.animateToPage(
                          //         onBoardingData.length - 1,
                          //         duration: const Duration(milliseconds: 500),
                          //         curve: Curves.ease,
                          //       );
                          //     },
                          //     child: Text(
                          //       "Skip Now",
                          //       style: TextStyle(
                          //           color: ColorConstant.primaryColor,
                          //           fontSize: width * 0.04,
                          //           fontWeight: FontWeight.w700),
                          //     ),
                          //   ),

                          // Next / Done Button
                          GestureDetector(
                            onTap: () {
                              if (index == onBoardingData.length - 1) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()),
                                );
                              } else {
                                pageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              }
                            },
                            child: index == onBoardingData.length - 1
                                ? Container(
                                    height: height * 0.06,
                                    width: width * 0.83,
                                    margin: EdgeInsets.all(width * 0.03),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(width * 0.02),
                                      ),
                                      color: ColorConstant.primaryColor,
                                    ),
                                    child: Center(
                                      child: Text(
                                        " Get Started",
                                        style: TextStyle(
                                            color:
                                                ColorConstant.backgroundColor,
                                            fontSize: width * 0.04,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  )
                                : Padding(
                                    padding:
                                        EdgeInsets.only(left: width * 0.35),
                                    child: CircleAvatar(
                                      radius: width * 0.08,
                                      backgroundColor:
                                          ColorConstant.primaryColor,
                                      child: Icon(
                                        Icons.arrow_forward,
                                        color: ColorConstant.backgroundColor,
                                        size: width * 0.07,
                                      ),
                                    ),
                                  ),
                          ),
                        ],
                      );
                    },
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
