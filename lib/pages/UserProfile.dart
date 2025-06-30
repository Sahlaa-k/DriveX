import 'package:drivex/core/constants/color_constant.dart';
import 'package:drivex/core/widgets/BackGroundTopGradient.dart';
import 'package:drivex/pages/AddDriver.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  bool isDarkMode = true;
  String accountType = "Normal";

  void _showAccountTypeChangeDialog() {
    showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: Text("Change Account Type"),
        content: Text(
          "Do you want to switch to ${accountType == "Normal" ? "Professional/Driver" : "Normal"} account?",
        ),
        actions: [
          CupertinoDialogAction(
            child: Text("No"),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            child: Text("Yes"),
            onPressed: () {
              setState(() {
                accountType =
                    accountType == "Normal" ? "Professional/Driver" : "Normal";
              });
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  // void _showEditProfileDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (_) => AlertDialog(
  //       title: Text("Edit Profile"),
  //       content: Text("You can now edit your profile details."),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context),
  //           child: Text("OK"),
  //         )
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      // backgroundColor: Colors.grey.shade100,
      backgroundColor: ColorConstant.backgroundColor,
      // appBar: AppBar(
      //   backgroundColor: ColorConstant.primaryColor,
      //   // leading: GestureDetector(
      //   //   onTap: () {
      //   //     Navigator.pop(context);
      //   //   },
      //   //   child: SizedBox(
      //   //     child: Icon(
      //   //       Icons.arrow_back_ios_new_rounded,
      //   //       color: Colors.white,
      //   //     ),
      //   //   ),
      //   // ),
      //   title: Text(
      //     "My Profile",
      //     style: TextStyle(color: Colors.white),
      //   ),
      //   centerTitle: true,
      // ),
      body: Backgroundtopgradient(
        // padding: EdgeInsets.all(width * 0.05),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(width * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: width * 0.04),
                Container(
                  padding: EdgeInsets.all(width * 0.04),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(width * 0.05),
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 4)
                    ],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: width * 0.1,
                        backgroundColor: Colors.grey.shade300,
                        child: Icon(Icons.person, size: width * 0.12),
                      ),
                      SizedBox(width: width * 0.04),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Kamal Sha",
                              style: TextStyle(
                                  fontSize: width * 0.05,
                                  fontWeight: FontWeight.bold)),
                          Text("+91 9876543210",
                              style: TextStyle(color: Colors.grey)),
                          Text(accountType,
                              style: TextStyle(
                                  fontSize: width * 0.035,
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                      Spacer(),
                      Icon(Icons.copy, color: Colors.black.withOpacity(.5)),
                    ],
                  ),
                ),
                SizedBox(height: width * 0.05),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "Edit Profile",
                    style: TextStyle(
                        fontSize: width * 0.045,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.edit, color: Colors.blueAccent),
                  title: Text("Edit Profile",
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text("Kozhikode, Kerala"),
                  trailing: GestureDetector(
                    onTap: () {
                      showCupertinoDialog(
                        context: context,
                        builder: (_) => CupertinoAlertDialog(
                          title: Text("Edit Profile"),
                          content: Text(
                            "Do You Want To Edit The Profile ?",
                          ),
                          actions: [
                            CupertinoDialogAction(
                              child: Text("No"),
                              onPressed: () => Navigator.pop(context),
                            ),
                            CupertinoDialogAction(
                              child: Text("Yes"),
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) => AddDriverPage(),
                                    ));
                              },
                            ),
                          ],
                        ),
                      );
                    },
                    child: Container(
                      height: width * .1,
                      width: width * .2,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: ColorConstant.primaryColor.withOpacity(.5),
                              width: width * .005),
                          borderRadius:
                              BorderRadius.all(Radius.circular(width * .025))),
                      child: Center(
                        child: Text(
                          "Edit",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black.withOpacity(.6)),
                        ),
                      ),
                    ),
                  ),
                ),
                // Divider(),
                ListTile(
                  leading: Icon(Icons.swap_horiz, color: Colors.blueAccent),
                  title: Text("Account Type",
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(accountType),
                  trailing: SizedBox(
                    height: width * .1,
                    width: width * .2,

                    child: GestureDetector(
                      onTap: () {
                        showCupertinoDialog(
                          context: context,
                          builder: (_) => CupertinoAlertDialog(
                            title: Text("Change Account Type"),
                            content: Text(
                              "Do you want to switch to ${accountType == "Normal" ? "Professional/Driver" : "Normal"} account?",
                            ),
                            actions: [
                              CupertinoDialogAction(
                                child: Text("No"),
                                onPressed: () => Navigator.pop(context),
                              ),
                              CupertinoDialogAction(
                                child: Text("Yes"),
                                onPressed: () {
                                  setState(() {
                                    accountType = accountType == "Normal"
                                        ? "Professional/Driver"
                                        : "Normal";
                                  });
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                      child: Container(
                        height: width * .1,
                        width: width * .2,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color:
                                    ColorConstant.primaryColor.withOpacity(.5),
                                width: width * .005),
                            borderRadius: BorderRadius.all(
                                Radius.circular(width * .025))),
                        child: Center(
                          child: Text(
                            "Switch",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black.withOpacity(.6)),
                          ),
                        ),
                      ),
                    ),
                    // child: ElevatedButton(
                    //   onPressed: _showAccountTypeChangeDialog,
                    //   style: ElevatedButton.styleFrom(
                    //       backgroundColor: Colors.blueAccent),
                    //   child: Text(
                    //     "Switch",
                    //     style: TextStyle(
                    //         fontSize: width * .03,
                    //         fontWeight: FontWeight.bold,
                    //         color: Colors.white.withOpacity(.6)),
                    //   ),
                    // ),
                  ),
                ),
                SizedBox(height: width * 0.05),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "Preferences",
                    style: TextStyle(
                        fontSize: width * 0.045,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.language, color: Colors.blueAccent),
                  title: Text("Preferred Language",
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text("English, Malayalam"),
                ),
                ListTile(
                  leading: Icon(Icons.dark_mode, color: Colors.blueAccent),
                  title: Text("Dark Mode",
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(isDarkMode ? "Enabled" : "Disabled"),
                  trailing: Switch(
                    value: isDarkMode,
                    onChanged: (value) {
                      setState(() {
                        isDarkMode = value;
                      });
                    },
                  ),
                ),
                SizedBox(height: width * 0.05),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "Security",
                    style: TextStyle(
                        fontSize: width * 0.045,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.lock, color: Colors.blueAccent),
                  title: Text("Change Password",
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text("••••••••"),
                ),
                ListTile(
                  leading: Icon(Icons.fingerprint, color: Colors.blueAccent),
                  title: Text("Fingerprint Login",
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text("Enabled"),
                ),
                SizedBox(height: width * 0.05),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "App Settings",
                    style: TextStyle(
                        fontSize: width * 0.045,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.info, color: Colors.blueAccent),
                  title: Text("Version",
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text("v1.0.0"),
                ),
                ListTile(
                  leading: Icon(Icons.privacy_tip, color: Colors.blueAccent),
                  title: Text("Privacy Policy",
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text("View"),
                ),
                SizedBox(height: width * 0.1),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.logout, color: Colors.red),
                  label: Text("Logout", style: TextStyle(color: Colors.red)),
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size(width * 0.4, 50),
                    side: BorderSide(color: Colors.red),
                  ),
                ),
                SizedBox(height: width * 0.25),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
