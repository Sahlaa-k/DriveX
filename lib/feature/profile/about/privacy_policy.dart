import 'package:drivex/core/constants/color_constant.dart';
import 'package:drivex/core/constants/localVariables.dart';
import 'package:drivex/core/widgets/BackGroundTopGradient.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

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
                      "Privacy Policy",
                      style: TextStyle(
                        fontSize: width * 0.06,
                        fontWeight: FontWeight.w700,
                        color: ColorConstant.thirdColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: width * 0.04),

                _sectionCard(
                  title: "Introduction",
                  body:
                  "We value your privacy. This policy explains what data we collect, why we collect it, and how we handle it across DriveX services.",
                ),
                _gap(),
                _sectionCard(
                  title: "Information We Collect",
                  bulletPoints: const [
                    "Account info (name, phone, email).",
                    "Location data for pickups, drops, and nearby drivers.",
                    "Device identifiers and logs for fraud prevention and diagnostics.",
                    "Payment metadata (handled via PCI-compliant partners).",
                  ],
                ),
                _gap(),
                _sectionCard(
                  title: "How We Use Information",
                  bulletPoints: const [
                    "Provide and improve bookings, routing, and delivery.",
                    "Customer support and safety features.",
                    "Analytics and service improvements.",
                    "Legal compliance and dispute resolution.",
                  ],
                ),
                _gap(),
                _sectionCard(
                  title: "Data Sharing",
                  body:
                  "We do not sell your data. We may share limited data with service providers (e.g., payments, mapping, analytics) strictly for operating DriveX features.",
                ),
                _gap(),
                _sectionCard(
                  title: "Your Choices",
                  bulletPoints: const [
                    "Access, update, or delete your account data.",
                    "Control location permissions in system settings.",
                    "Opt-out of non-essential notifications.",
                  ],
                ),
                _gap(),
                _sectionCard(
                  title: "Contact",
                  body: "Questions? Reach us at support@drivex.app.",
                ),
                SizedBox(height: width * 0.06),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _gap() => SizedBox(height: width * 0.035);

  Widget _sectionCard({
    required String title,
    String? body,
    List<String>? bulletPoints,
  }) {
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
        SizedBox(height: width * 0.02),
        if (body != null)
          Text(
            body,
            style: TextStyle(
              fontSize: width * 0.035,
              color: ColorConstant.thirdColor.withOpacity(.85),
              height: 1.35,
            ),
          ),
        if (bulletPoints != null)
          Column(
            children: bulletPoints
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
      ]),
    );
  }
}
