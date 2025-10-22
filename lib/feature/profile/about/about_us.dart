import 'package:drivex/core/constants/color_constant.dart';
import 'package:drivex/core/constants/localVariables.dart';
import 'package:drivex/core/widgets/BackGroundTopGradient.dart';
import 'package:drivex/feature/profile/about/privacy_policy.dart';
import 'package:drivex/feature/profile/about/terms_conditions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  String _appName = 'DriveX';
  String _version = '';
  String _buildNumber = '';

  // TODO: Replace these with your real links/contact
  static const String _privacyUrl = 'https://example.com/privacy';
  static const String _termsUrl   = 'https://example.com/terms';
  static const String _websiteUrl = 'https://example.com';
  static const String _supportEmail = 'support@drivex.app';
  static const String _supportPhone = '+919999999999';
  static const String _whatsAppNumber = '+919999999999'; // must include country code

  @override
  void initState() {
    super.initState();
    _loadPackageInfo();
  }

  Future<void> _loadPackageInfo() async {
    try {
      final info = await PackageInfo.fromPlatform();
      setState(() {
        _appName = info.appName.isEmpty ? 'DriveX' : info.appName;
        _version = info.version;
        _buildNumber = info.buildNumber;
      });
    } catch (_) {
      // leave defaults
    }
  }

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
                // Header
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
                      "About Us",
                      style: TextStyle(
                        fontSize: width * 0.06,
                        fontWeight: FontWeight.w700,
                        color: ColorConstant.thirdColor,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: width * 0.04),

                // App card
                Container(
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
                  child: Row(
                    children: [
                      Container(
                        height: width * 0.18,
                        width: width * 0.18,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ColorConstant.color11.withOpacity(.1),
                        ),
                        child: Icon(Icons.local_taxi, size: width * 0.10, color: ColorConstant.color11),
                      ),
                      SizedBox(width: width * 0.04),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_appName,
                                style: TextStyle(
                                  fontSize: width * 0.05,
                                  fontWeight: FontWeight.w700,
                                  color: ColorConstant.thirdColor,
                                )),
                            SizedBox(height: width * 0.01),
                            Text(
                              "Your all-in-one mobility & driver companion.",
                              style: TextStyle(
                                fontSize: width * 0.034,
                                color: ColorConstant.thirdColor.withOpacity(.7),
                                height: 1.25,
                              ),
                            ),
                            SizedBox(height: width * 0.02),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: width * 0.025, vertical: width * 0.012),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(width * 0.2),
                                    color: ColorConstant.color11.withOpacity(.08),
                                    border: Border.all(color: ColorConstant.color11.withOpacity(.25)),
                                  ),
                                  child: Text(
                                    _version.isEmpty ? "Version —" : "v$_version",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: width * 0.032,
                                      color: ColorConstant.color11,
                                    ),
                                  ),
                                ),
                                SizedBox(width: width * 0.02),
                                if (_buildNumber.isNotEmpty)
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: width * 0.025, vertical: width * 0.012),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(width * 0.2),
                                      color: Colors.black.withOpacity(.05),
                                    ),
                                    child: Text(
                                      "Build $_buildNumber",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: width * 0.032,
                                        color: ColorConstant.thirdColor.withOpacity(.7),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: width * 0.04),

                // Mission
                Container(
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionTitle("Our Mission"),
                      SizedBox(height: width * 0.02),
                      Text(
                        "DriveX simplifies local mobility: hire vetted drivers, book cabs, schedule rentals, and send door-to-door deliveries — all with transparent pricing and reliable support.",
                        style: TextStyle(
                          fontSize: width * 0.035,
                          color: ColorConstant.thirdColor.withOpacity(.8),
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: width * 0.04),

                // What we offer
                Container(
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionTitle("What we offer"),
                      SizedBox(height: width * 0.02),
                      Wrap(
                        spacing: width * 0.02,
                        runSpacing: width * 0.02,
                        children: [
                          _featureChip(Icons.two_wheeler, "Driver on Demand"),
                          _featureChip(Icons.local_taxi_outlined, "Cab Booking"),
                          _featureChip(Icons.inventory_2_outlined, "Door-to-Door Delivery"),
                          _featureChip(Icons.time_to_leave, "Hourly Rentals"),
                          _featureChip(Icons.verified_user_outlined, "Verified Partners"),
                          _featureChip(Icons.support_agent, "24×7 Support"),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: width * 0.04),

                // Contact & Support
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(width * 0.02),
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
                  child: Column(
                    children: [
                      ListTile(
                        leading: _roundedIcon(Icons.language_outlined),
                        title: const Text("Website"),
                        subtitle: Text(_websiteUrl, maxLines: 1, overflow: TextOverflow.ellipsis),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          final uri = Uri.parse(_websiteUrl);
                          launchUrl(uri, mode: LaunchMode.externalApplication);
                        },
                      ),
                      _divider(),
                      ListTile(
                        leading: _roundedIcon(Icons.email_outlined),
                        title: const Text("Email Support"),
                        subtitle: Text(_supportEmail),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          final uri = Uri(
                            scheme: 'mailto',
                            path: _supportEmail,
                            query: Uri.encodeQueryComponent('subject=DriveX Support&body=Hi DriveX Team,'),
                          );
                          launchUrl(uri, mode: LaunchMode.externalApplication);
                        },
                      ),
                      _divider(),
                      ListTile(
                        leading: _roundedIcon(Icons.phone_outlined),
                        title: const Text("Call Us"),
                        subtitle: Text(_supportPhone),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          final uri = Uri(scheme: 'tel', path: _supportPhone);
                          launchUrl(uri, mode: LaunchMode.externalApplication);
                        },
                      ),
                      _divider(),
                      ListTile(
                        leading: _roundedIcon(Icons.chat_outlined),
                        title: const Text("WhatsApp"),
                        subtitle: const Text("Chat with support"),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          final uri = Uri.parse("https://wa.me/${_whatsAppNumber.replaceAll('+', '')}");
                          launchUrl(uri, mode: LaunchMode.externalApplication);
                        },
                      ),
                    ],
                  ),
                ),

                SizedBox(height: width * 0.04),

                // Legal & Policies
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(width * 0.02),
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
                  child: Column(
                    children: [
                      // 1) Privacy Policy
                      ListTile(
                        leading: _roundedIcon(Icons.privacy_tip_outlined),
                        title: const Text("Privacy Policy"),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const PrivacyPolicyPage()),
                          );
                        },
                      ),

// 2) Terms & Conditions
                      ListTile(
                        leading: _roundedIcon(Icons.article_outlined),
                        title: const Text("Terms & Conditions"),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const TermsConditionsPage()),
                          );
                        },
                      ),

                    ],
                  ),
                ),

                SizedBox(height: width * 0.06),

                // Footer
                Center(
                  child: Text(
                    "© ${DateTime.now().year} DriveX. All rights reserved.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: width * 0.032,
                      color: ColorConstant.thirdColor.withOpacity(.5),
                    ),
                  ),
                ),
                SizedBox(height: width * 0.02),
                Center(
                  child: Text(
                    "Built with ❤️ in Kerala",
                    style: TextStyle(
                      fontSize: width * 0.032,
                      color: ColorConstant.thirdColor.withOpacity(.45),
                    ),
                  ),
                ),
                SizedBox(height: width * 0.06),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Small visual helpers (kept inline & simple)
  Widget _sectionTitle(String title) {
    return Row(
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
            fontSize: width * 0.042,
            fontWeight: FontWeight.w700,
            color: ColorConstant.thirdColor,
          ),
        ),
      ],
    );
  }

  Widget _featureChip(IconData icon, String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width * 0.03, vertical: width * 0.022),
      decoration: BoxDecoration(
        color: ColorConstant.color11.withOpacity(.06),
        border: Border.all(color: ColorConstant.color11.withOpacity(.18)),
        borderRadius: BorderRadius.circular(width * 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: width * 0.045, color: ColorConstant.color11.withOpacity(.9)),
          SizedBox(width: width * 0.02),
          Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: width * 0.034,
              color: ColorConstant.thirdColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _roundedIcon(IconData icon) {
    return Container(
      height: width * 0.12,
      width: width * 0.12,
      decoration: BoxDecoration(
        color: ColorConstant.color11.withOpacity(.08),
        shape: BoxShape.circle,
        border: Border.all(color: ColorConstant.color11.withOpacity(.2)),
      ),
      child: Icon(icon, color: ColorConstant.color11.withOpacity(.9), size: width * 0.06),
    );
  }

  Widget _divider() => Padding(
    padding: EdgeInsets.symmetric(horizontal: width * 0.02),
    child: Divider(height: 1, color: Colors.grey.shade300),
  );
}
