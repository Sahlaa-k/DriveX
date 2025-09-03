import 'package:drivex/core/constants/color_constant.dart';
import 'package:drivex/core/constants/imageConstants.dart';
import 'package:drivex/core/constants/localVariables.dart';
import 'package:drivex/core/widgets/BackGroundTopGradient.dart';
import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumController = TextEditingController();
  TextEditingController mailController = TextEditingController();
  TextEditingController discriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Backgroundtopgradient(
          child: Padding(
        padding: EdgeInsets.all(width * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: width * 0.07),
            Row(
              children: [
                Icon(
                  Icons.arrow_back_ios,
                  color: ColorConstant.color11.withOpacity(0.7),
                ),
                SizedBox(width: width * 0.03),
                Text(
                  "Edit Profile",
                  style: TextStyle(
                    fontSize: width * 0.055,
                    fontWeight: FontWeight.w600,
                    color: ColorConstant.color11.withOpacity(0.7),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.center,
              child: CircleAvatar(
                radius: width * 0.14,
                backgroundImage: AssetImage(ImageConstant.profilePic),
              ),
            ),
            SizedBox(height: width * 0.03),
// Full Name
            Text(
              "Full Name *",
              style: TextStyle(
                color: ColorConstant.thirdColor,
                fontSize: width * 0.038,
              ),
            ),
            SizedBox(height: width * 0.02),
            Container(
              height: width * 0.1,
              child: TextFormField(
                controller: nameController,
                style: TextStyle(
                  color: ColorConstant.thirdColor,
                ),
                textCapitalization: TextCapitalization.none,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: "Full name",
                  hintStyle: TextStyle(
                      color: ColorConstant.color11.withOpacity(0.4),
                      fontSize: width * 0.04),
                  contentPadding:
                      EdgeInsets.only(top: width * 0.01, right: width * 0.04),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: ColorConstant.color11.withOpacity(0.7)),
                    borderRadius: BorderRadius.circular(width * 0.02),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: ColorConstant.color11.withOpacity(0.7)),
                    borderRadius: BorderRadius.circular(width * 0.02),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: ColorConstant.color11.withOpacity(0.7)),
                    borderRadius: BorderRadius.circular(width * 0.02),
                  ),
                ),
              ),
            ),
            SizedBox(height: width * 0.04),

            // Phone Number
            Text(
              "Phone Number *",
              style: TextStyle(
                color: ColorConstant.thirdColor,
                fontSize: width * 0.038,
              ),
            ),
            SizedBox(height: width * 0.02),
            TextFormField(
              controller: phoneNumController,
              keyboardType: TextInputType.phone,
              style: TextStyle(color: ColorConstant.thirdColor),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.phone, color: ColorConstant.bgColor),
                hintText: "+91 98765 43210",
                hintStyle: TextStyle(
                  color: ColorConstant.color11.withOpacity(0.4),
                  fontSize: width * 0.04,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: ColorConstant.color11),
                  borderRadius: BorderRadius.circular(width * 0.02),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: ColorConstant.color11),
                  borderRadius: BorderRadius.circular(width * 0.02),
                ),
              ),
            ),
            SizedBox(height: width * 0.04),

            // Email Address
            Text(
              "Email Address *",
              style: TextStyle(
                color: ColorConstant.thirdColor,
                fontSize: width * 0.038,
              ),
            ),
            SizedBox(height: width * 0.02),
            TextFormField(
              controller: mailController,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(color: ColorConstant.thirdColor),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email, color: ColorConstant.bgColor),
                hintText: "sarah.johnson@email.com",
                hintStyle: TextStyle(
                  color: ColorConstant.color11.withOpacity(0.4),
                  fontSize: width * 0.04,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: ColorConstant.color11),
                  borderRadius: BorderRadius.circular(width * 0.02),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: ColorConstant.color11),
                  borderRadius: BorderRadius.circular(width * 0.02),
                ),
              ),
            ),
            SizedBox(height: width * 0.04),
            // Email Address
            Text(
              "Email Address *",
              style: TextStyle(
                color: ColorConstant.thirdColor,
                fontSize: width * 0.038,
              ),
            ),
            SizedBox(height: width * 0.02),
            TextFormField(
              controller: discriptionController,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(color: ColorConstant.thirdColor),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email, color: ColorConstant.bgColor),
                hintText: "tell us yourself",
                hintStyle: TextStyle(
                  color: ColorConstant.color11.withOpacity(0.4),
                  fontSize: width * 0.04,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: ColorConstant.color11),
                  borderRadius: BorderRadius.circular(width * 0.02),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: ColorConstant.color11),
                  borderRadius: BorderRadius.circular(width * 0.02),
                ),
              ),
            ),
  ElevatedButton(
    onPressed: () {},
    style: ElevatedButton.styleFrom(
      backgroundColor: ColorConstant.color11.withOpacity(0.7),
    ),
    child: const Text("Edit Profile", style: TextStyle(color: ColorConstant.bgColor)),
  ),
          ],
        ),
      )),
    );
  }
}
