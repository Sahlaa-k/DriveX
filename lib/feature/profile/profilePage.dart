import 'package:drivex/core/constants/color_constant.dart';
import 'package:drivex/core/constants/icon_Constants.dart';
import 'package:drivex/core/constants/imageConstants.dart';
import 'package:drivex/core/constants/localVariables.dart';
import 'package:drivex/core/widgets/BackGroundTopGradient.dart';
import 'package:drivex/feature/bookings/screens/bookingPage.dart';
import 'package:drivex/feature/bottomNavigationBar/notification_page.dart';
import 'package:drivex/feature/profile/customer_support.dart';
import 'package:drivex/feature/profile/delete_account.dart';
import 'package:drivex/feature/profile/edit_profile.dart';
import 'package:drivex/feature/profile/favorites_page.dart';
import 'package:drivex/feature/profile/language_page.dart';
import 'package:drivex/feature/profile/location.dart';
import 'package:drivex/feature/profile/logout.dart';
import 'package:drivex/feature/profile/rate_us.dart';

import 'package:drivex/feature/profile/sendfeedback_page.dart';
import 'package:drivex/feature/profile/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places_hoc081098/google_maps_webservice_places.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final List<Map<String, dynamic>> accountSections = [
    {
      "title": "Set Preference",
      "icon":Icons.settings,
      "items": [
        {
          "icon": Icons.location_on_outlined,
          "text": "Saved Addresses",
          "subtext": "Add & edit your frequently used locations",
          "page": LocationPage(), // Example page
        },
        {
          "icon": Icons.favorite_border,
          "text": "Favorites",
          "subtext": "Your saved drivers and rental cars",
          "page": FavoritesPage(),
        },
        {
          "icon": Icons.notifications_active_outlined,
          "text": "Notification Settings",
          "subtext": "Customize your alerts and notifications",
          "page": NotificationPage(),
        },
      ],
    },
    {
      "title": "Bookings & Transactions",
      "icon":Icons.settings,
      "items": [
        {
          "icon": Icons.calendar_today_outlined,
          "text": "My Bookings",
          "subtext": "View and manage all your current and past bookings",
          "page": BookingPagee(),
        },
        // {
        //   "icon": Icons.payments_outlined,
        //   "text": "Payment Methods",
        //   "subtext": "Manage your cards, UPI and other payment options",
        //   "page": PaymentHistory(),
        // },
        // {
        //   "icon": Icons.account_balance_wallet_outlined,
        //   "text": "Wallet & History",
        //   "subtext": "Check wallet balance and payment history",
        //   "page": WalletPage(),
        // },
      ],
    },
    {
      "title": "Help & Support",
      "icon":Icons.settings,
      "items": [
        {
          "icon": Icons.support_agent,
          "text": "Customer Support",
          "subtext": "Contact, FAQs & Help Center",
          "page": CustomerSupport(),
        },

      ],
    },
    {
      "title": "Account Settings",
      "icon":Icons.settings,
      "items": [


      ],
    },
    {
      "title": "App Settings",
      "icon":Icons.settings,
      "items": [
        {
          "icon": Icons.language_outlined,
          "text": "Language",
          "subtext": "Select your preferred language",
          "page": LanguagePage(),
        },
        {
          "icon": Icons.brightness_6_outlined,
          "text": "Theme",
          "subtext": "Switch between light and dark mode",
          "page": ThemePage(),
        },
      ],
    },
    {
      "title": "More Options",
      "icon":Icons.settings,
      "items": [
        {
          "icon": Icons.feedback_outlined,
          "text": "Send Feedback",
          "subtext": "Share your experience with us",
          "page": SendFeedBackPage(),
        },
        {
          "icon": Icons.star_border,
          "text": "Rate Us",
          "subtext": "Give feedback on Play Store or App Store",
          "page": RateUsPage(),
        },
        {
          "icon": Icons.logout,
          "text": "Logout",
          "subtext": "Sign out from this account",
          "page": LogoutPage(),
        },
        {
          "icon": Icons.delete_forever,
          "text": "Delete Account",
          "subtext": "Permanently remove your profile",
          "page": DeleteAccountPage(),
        },
      ],
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.bgColor,
      body: SingleChildScrollView(
        child: Backgroundtopgradient(
          child: Padding(
            padding: EdgeInsets.all(width * 0.02),
            child: Column(
              children: [
                SizedBox(
                  height: width * 0.07,
                ),


                    Text(
                      "Profile",
                      style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                          fontSize: width * 0.055),
                    ),



                SizedBox(
                  height: width * 0.03,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfilePage(),
                        ));
                  },
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: width * 0.03, right: width * 0.03),
                    child: Column(children: [
                      SizedBox(  width: width * 0.25,
                        height: width * 0.25,
                        child: Stack(
                          children: [
                            Column(
                              children: [

                                Container(
                                  width: width * 0.23,
                                  height: width * 0.23,
                                  decoration: BoxDecoration(
                                      color: ColorConstant.color11.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: AssetImage(ImageConstant.profilePic),
                                          fit: BoxFit.cover)),
                                ),
                              ],
                            ),
                            Positioned(
                              bottom: width*0.03,
                              right: width*0.02,
                              child: Container(
                                height: width * 0.075,
                                width: width * 0.075,
                                decoration: BoxDecoration(
                                    color: ColorConstant.color11,
                                    border: Border.all(
                                        color: ColorConstant.bgColor.withOpacity(0.8)),
                                    shape: BoxShape.circle),
                                child: Center(
                                    child: Icon(
                                      Icons.mode_edit_outline_outlined,
                                      color: ColorConstant.bgColor.withOpacity(0.8),
                                      size: width * 0.045,
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: width * 0.02,
                      ),
                      Text(
                        "Budi Susanto",
                        style: TextStyle(
                            color: ColorConstant.thirdColor,
                            fontWeight: FontWeight.w600,
                            fontSize: width * 0.045),
                      ),
                      Text(
                        "+91 8921580599",
                        style: TextStyle(
                            color: ColorConstant.thirdColor.withOpacity(0.4),
                            fontWeight: FontWeight.w500,
                            fontSize: width * 0.035),
                      ),
                    ]),
                  ),
                ),
                SizedBox(
                  height: width * 0.03,
                ),
                SizedBox(
                  width: width,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 1),
                    itemCount: accountSections.length,
                    itemBuilder: (context, sectionIndex) {
                      final section = accountSections[sectionIndex];
                      final items = section['items'] as List;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                spreadRadius: 1,
                                blurRadius: 8,
                                offset: Offset(0, 0),
                              ),
                            ],
                          ),
                          child: Theme(
                            data: Theme.of(context)
                                .copyWith(dividerColor: Colors.transparent),

                            child: ExpansionTile(
                              backgroundColor: Colors.transparent,
                              tilePadding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              trailing: Icon(
                                Icons.expand_more,
                                color: ColorConstant.color11.withOpacity(0.7),
                              ),
                              title: Row(
                                children: [
                                 // Icon( Icons.settings,color: ColorConstant.color11.withOpacity(0.7),),
                                  SizedBox(width: width*0.02,),
                                  Text(
                                    section['title'],
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      color: ColorConstant.thirdColor,
                                    ),
                                  ),
                                ],
                              ),
                              children:
                                  List.generate(items.length, (itemIndex) {
                                final item = items[itemIndex];
                                return Column(
                                  children: [
                                    ListTile(
                                      leading: Icon(
                                        item['icon'],
                                        color: ColorConstant.color11
                                            .withOpacity(0.7),
                                      ),
                                      title: Text(
                                        item['text'],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14.5,
                                        ),
                                      ),
                                      subtitle: Text(
                                        item['subtext'],
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                      trailing: const Icon(Icons.chevron_right,
                                          size: 20),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  item['page']),
                                        );
                                      },
                                    ),
                                    if (itemIndex != items.length - 1)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                        child: Divider(
                                            height: 1, color: Colors.grey[300]),
                                      ),
                                  ],
                                );
                              }),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
