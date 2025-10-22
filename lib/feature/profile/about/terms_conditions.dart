import 'package:drivex/core/constants/color_constant.dart';
import 'package:drivex/core/constants/localVariables.dart';
import 'package:drivex/core/widgets/BackGroundTopGradient.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TermsConditionsPage extends StatelessWidget {
  const TermsConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.bgColor,
      body: SafeArea(
        child: Backgroundtopgradient(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: width * 0.04, vertical: width * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      minSize: width * 0.1,
                      onPressed: () => Navigator.pop(context),
                      child: Icon(Icons.arrow_back, color: ColorConstant.thirdColor, size: width * 0.065),
                    ),
                    SizedBox(width: width * 0.02),
                    Text(
                      "Terms & Conditions",
                      style: TextStyle(
                        fontSize: width * 0.055,
                        fontWeight: FontWeight.w700,
                        color: ColorConstant.thirdColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: width * 0.04),

                _section("Acceptance of Terms",
                    "By using DriveX, you agree to these Terms and our Privacy Policy. If you do not agree, please discontinue use."),
                _gap(),
                _section("Services",
                    "We provide driver hiring, cab booking, rentals, and delivery facilitation. Availability may vary by region."),
                _gap(),
                _section("User Responsibilities", null, bullets: const [
                  "Provide accurate information and maintain your account security.",
                  "Use the app for lawful purposes only.",
                  "Comply with local traffic, transport, and safety regulations.",
                ]),
                _gap(),
                _section("Payments & Fees",
                    "Fares, fees, and taxes are shown before confirmation. Third-party payment processors handle transactions securely."),
                _gap(),
                _section("Cancellations & Refunds",
                    "Policies vary by service type and time. Check the booking screen for the policy applicable to your order."),
                _gap(),
                _section("Limitations",
                    "DriveX is not liable for indirect losses or events beyond our control. Statutory consumer rights remain unaffected."),
                _gap(),
                _section("Updates to Terms",
                    "We may update these Terms periodically. Continued use after updates constitutes acceptance."),
                _gap(),
                _section("Contact",
                    "For questions regarding these Terms, contact support@drivex.app."),
                SizedBox(height: width * 0.06),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _gap() => SizedBox(height: width * 0.035);

  Widget _section(String title, String? body, {List<String>? bullets}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(width * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(width * 0.035),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: width * 0.04,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: [
            Container(
              height: width * 0.028,
              width: width * 0.028,
              decoration: BoxDecoration(
                color: ColorConstant.color11.withOpacity(.15),
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: width * 0.02),
            Text(
              title,
              style: TextStyle(
                fontSize: width * 0.045,
                fontWeight: FontWeight.w700,
                color: ColorConstant.thirdColor,
              ),
            ),
          ],
        ),
        if (body != null) ...[
          SizedBox(height: width * 0.02),
          Text(
            body,
            style: TextStyle(
              fontSize: width * 0.035,
              color: ColorConstant.thirdColor.withOpacity(.85),
              height: 1.35,
            ),
          ),
        ],
        if (bullets != null) ...[
          SizedBox(height: width * 0.02),
          Column(
            children: bullets
                .map((e) => Padding(
              padding: EdgeInsets.only(top: width * 0.018),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("•  ",
                      style: TextStyle(
                        fontSize: width * 0.04,
                        color: ColorConstant.thirdColor,
                      )),
                  Expanded(
                    child: Text(
                      e,
                      style: TextStyle(
                        fontSize: width * 0.035,
                        color: ColorConstant.thirdColor.withOpacity(.85),
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ))
                .toList(),
          ),
        ],
      ]),
    );
  }
}
