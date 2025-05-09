import 'package:drivex/core/constants/color_constant.dart';
import 'package:drivex/core/constants/icon_Constants.dart';
import 'package:drivex/core/constants/localVariables.dart';
import 'package:drivex/feature/auth/screens/signUp.dart';
import 'package:drivex/feature/onboarding/animatedLogo2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.primaryColor,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                color: ColorConstant.backgroundColor,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(width * 0.4)),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: height * 0.43,
                    width: width,
                    decoration: BoxDecoration(
                      color: ColorConstant.primaryColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(width * 0.4),
                        topRight: Radius.circular(width * 0.4),
                      ),
                    ),
                    child: Center(
                      child: Container(
                        height: height * 0.43,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(width * 0.4),
                          gradient: LinearGradient(
                            colors: [
                              ColorConstant.primaryColor,
                              ColorConstant.secondaryColor,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            stops: [0.4, 0.8],
                          ),
                        ),
                        child: Center(
                          child: AnimatedLogo2(
                            fontSize: height * 0.05,
                            animateLetters: true,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.04),
                  Text(
                    "Welcome",
                    style: GoogleFonts.benne(
                      color: ColorConstant.primaryColor,
                      fontSize: width * 0.08,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    "Log into your account to continue",
                    style: GoogleFonts.montserrat(
                      color: ColorConstant.thirdColor,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(height: height * 0.04),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                    child: TextFormField(
                      controller: emailController,
                      style: TextStyle(color: ColorConstant.thirdColor),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        fillColor:
                        ColorConstant.secondaryColor.withOpacity(0.3),
                        filled: true,
                        labelText: "E-mail",
                        labelStyle: GoogleFonts.montserrat(
                          color: ColorConstant.thirdColor,
                          fontWeight: FontWeight.w400,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(width * 0.3),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(width * 0.3),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.03),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                    child: TextFormField(
                      controller: passwordController,
                      style: TextStyle(color: ColorConstant.thirdColor),
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        fillColor:
                        ColorConstant.secondaryColor.withOpacity(0.3),
                        filled: true,
                        labelText: "Password",
                        labelStyle: GoogleFonts.montserrat(
                          color: ColorConstant.thirdColor,
                          fontWeight: FontWeight.w400,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(width * 0.3),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(width * 0.3),
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding:
                    EdgeInsets.symmetric(horizontal: width * 0.03),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: ColorConstant.thirdColor,
                            thickness: 1,
                            endIndent: 10,
                          ),
                        ),
                        Text(
                          'or',
                          style: TextStyle(
                            color: ColorConstant.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: ColorConstant.thirdColor,
                            thickness: 1,
                            indent: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: height * 0.01),
                  GestureDetector(
                    onTap: () {
                      // TODO: Add Google sign-in logic here
                    },
                    child: SvgPicture.asset(
                      IconConstants.google,
                      width: width * 0.08,
                    ),
                  ),
                  SizedBox(height: height * 0.06),
                  GestureDetector(
                    onTap: () {
                      // TODO: Add login logic here
                    },
                    child: Container(
                      height: height * 0.05,
                      width: width * 0.42,
                      margin: EdgeInsets.all(width * 0.03),
                      decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(width * 0.05),
                        color: ColorConstant.primaryColor,
                      ),
                      child: Center(
                        child: Text(
                          "Login",
                          style: TextStyle(
                            color: ColorConstant.backgroundColor,
                            fontSize: width * 0.04,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: TextStyle(
                          color: ColorConstant.thirdColor,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUpPage(),
                            ),
                                (route) => false,
                          );
                        },
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                            color: ColorConstant.primaryColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.03),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
