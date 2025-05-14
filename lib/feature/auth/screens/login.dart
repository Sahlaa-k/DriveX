import 'package:drivex/core/constants/color_constant.dart';
import 'package:drivex/core/constants/localVariables.dart';
import 'package:drivex/feature/auth/screens/signUp.dart';
import 'package:drivex/feature/onboarding/animatedLogo2.dart';
import 'package:flutter/material.dart';
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
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                height: height * 1,
                width: width * 1,
                decoration: BoxDecoration(
                  color: ColorConstant.backgroundColor,
                  borderRadius:
                      BorderRadius.only(bottomLeft: Radius.circular(width * 0.4)),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  Center(
                    child: Container(
                      height: width * 1,
                      width: width * 1,
                      child: Center(
                        child: AnimatedLogo2(
                          fontSize: height * 0.05,
                          animateLetters: true,
                        ),
                      ),
                      decoration: BoxDecoration(
                          // color: ColorConstant.secondaryColor.withOpacity(0.2),
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(width * 0.5),
                              topRight: Radius.circular(width * 0.5),
                              // bottomRight: Radius.circular(width * 0.4),
                              // topLeft: Radius.circular(width * 0.4),
                              ),
                          // shape: BoxShape.circle,
                          gradient: LinearGradient(
                              colors: [
                                // ColorConstant.secondaryColor,
                                ColorConstant.primaryColor,
                                ColorConstant.secondaryColor,
                                
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              stops: [0.4, 0.8]
                              ),
                              ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.04,
                  ),
                  Text(
                    "Welcome",
                    style: GoogleFonts.benne(
                        color: ColorConstant.primaryColor,
                        fontSize: width * 0.08,
                        fontWeight: FontWeight.w700),
                  ),
                  // Text(
                  //   "Log into your account to continue",
                  //   style: GoogleFonts.montserrat(
                  //     color: ColorConstant.thirdColor,
                  //     fontWeight: FontWeight.w300,
                  //   ),
                  // ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(right: width * 0.1, left: width * 0.1),
                    child: SizedBox(
                      height: height*.06,
                      child: TextFormField(
                        controller: emailController,
                        style: TextStyle(
                          color: ColorConstant.thirdColor,
                        ),
                        textCapitalization: TextCapitalization.words,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          fillColor: ColorConstant.secondaryColor.withOpacity(0.3),
                          filled: true,
                          labelText: "E-mail",
                          labelStyle: GoogleFonts.montserrat(
                            color: ColorConstant.thirdColor,
                            fontWeight: FontWeight.w400,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(
                              width * 0.025,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(width * 0.025),
                          ),
                        ),
                      ),
                    )
                  ),
                  SizedBox(
                    height: height * 0.03,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(right: width * 0.1, left: width * 0.1),
                    child: SizedBox(
                      height: height*.06,
                      child: TextFormField(
                        controller: emailController,
                        style: TextStyle(
                          color: ColorConstant.thirdColor,
                        ),
                        textCapitalization: TextCapitalization.words,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          fillColor: ColorConstant.secondaryColor.withOpacity(0.3),
                          filled: true,
                          labelText: "Password",
                          labelStyle: GoogleFonts.montserrat(
                            color: ColorConstant.thirdColor,
                            fontWeight: FontWeight.w400,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(
                              width * 0.025,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(width * 0.025),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.05,
                  ),
                  Container(
                    height: height * 0.05,
                    width: width * 0.42,
                    margin: EdgeInsets.all(width * 0.03),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(width * 0.025),
                      ),
                      color: ColorConstant.primaryColor,
                    ),
                    child: Center(
                      child: Text(
                        " Login",
                        style: TextStyle(
                            color: ColorConstant.backgroundColor,
                            fontSize: width * 0.04,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.05,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Don't you have an account ",
                        style: TextStyle(
                          color: ColorConstant.thirdColor,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignUpPage(),
                              ),
                              (route) => false);
                        },
                        child: Text(
                          " Sign-Up?",
                          style: TextStyle(
                              color: ColorConstant.primaryColor,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
