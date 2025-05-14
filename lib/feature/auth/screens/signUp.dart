import 'package:drivex/core/constants/color_constant.dart';
import 'package:drivex/core/constants/localVariables.dart';
import 'package:drivex/feature/auth/screens/login.dart';
import 'package:drivex/pages/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController nameController=TextEditingController();
  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();
  TextEditingController rePasswordController=TextEditingController();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: ColorConstant.primaryColor,
body: Column(children: [
  Container(
    height: height*1,
    width: width*1,
    decoration: BoxDecoration(
      color: ColorConstant.backgroundColor,
      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(width * 0.6),topRight: Radius.circular(width * 0.6))
    ),
    child: Padding(
      padding:  EdgeInsets.only(top: width*0.5,right: width*0.1,left: width*0.1),
      child: Column(children: [
        SizedBox(
          height: height*.06,
          child: TextFormField(
            controller: nameController,
            style: TextStyle(
              color: ColorConstant.thirdColor,
            ),
            textCapitalization: TextCapitalization.words,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              fillColor: ColorConstant.secondaryColor.withOpacity(0.3),
              filled: true,
              labelText: "User Name",
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
        SizedBox(height: width*0.03,),
        SizedBox(
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
        ),
        SizedBox(height: width*0.03,),
        SizedBox(
          height: height*.06,
          child: TextFormField(
            controller: passwordController,
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
        SizedBox(height: width*0.03,),
        SizedBox(
          height: height*.06,
          child: TextFormField(
            controller: rePasswordController,
            style: TextStyle(
              color: ColorConstant.thirdColor,
            ),
            textCapitalization: TextCapitalization.words,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              fillColor: ColorConstant.secondaryColor.withOpacity(0.3),
              filled: true,
              labelText: "Confirm password",
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

        SizedBox(height: height*0.15,),
        GestureDetector(
          onTap: () {
            Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (context) => Home(),), (route) => false,);
          },
          child: Container(
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
                " Sign-Up",
                style: TextStyle(
                    color:
                    ColorConstant.backgroundColor,
                    fontSize: width * 0.04,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ),
        SizedBox(height: height*0.16,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "Already have an account",
              style: TextStyle(
                color: ColorConstant.thirdColor,
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ),
                        (route) => false);
              },
              child: Text(
                " Login?",
                style: TextStyle(
                    color: ColorConstant.primaryColor,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ],),
    ),
  )
],),
    );
  }
}
