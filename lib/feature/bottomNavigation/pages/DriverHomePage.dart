import 'package:flutter/material.dart';
import 'package:drivex/core/constants/color_constant.dart';

class Driverhomepage extends StatefulWidget {
  const Driverhomepage({super.key});

  @override
  State<Driverhomepage> createState() => _DriverhomepageState();
}

class _DriverhomepageState extends State<Driverhomepage> {
  bool isOnline = true;

  final List<Map<String, String>> overviewData = [
    {"label": "💰 Earnings Today", "value": "₹1,200"},
    {"label": "⭐ Rating", "value": "4.8"},
    {"label": "🚘 Trips This Week", "value": "5"},
    {"label": "📅 Upcoming Trips", "value": "2"},
  ];

  final List<Map<String, dynamic>> quickAccessItems = [
    {"icon": Icons.route, "label": "My Trips"},
    {"icon": Icons.monetization_on, "label": "Earnings"},
    {"icon": Icons.history, "label": "Trip History"},
    {"icon": Icons.person, "label": "Profile"},
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final font = width * 0.04;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: ColorConstant.primaryColor,
        title: Text("Driver Home",
            style: TextStyle(color: Colors.white, fontSize: font + 2)),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white, size: font + 2),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(width * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("👋 Welcome back, Ravi!",
                style:
                    TextStyle(fontSize: font + 2, fontWeight: FontWeight.bold)),
            SizedBox(height: height * 0.02),

            // Availability Toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Availability:",
                    style:
                        TextStyle(fontSize: font, fontWeight: FontWeight.w500)),
                Switch(
                  value: isOnline,
                  // activeColor: ColorConstant.primaryColor,
                  activeColor: Colors.green,
                  onChanged: (value) => setState(() => isOnline = value),
                ),
                Text(
                  isOnline ? "Online" : "Offline",
                  style: TextStyle(
                    fontSize: font,
                    fontWeight: FontWeight.bold,
                    color: isOnline ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
            SizedBox(height: height * 0.02),

            // Next Trip Card
            Container(
              padding: EdgeInsets.all(width * 0.04),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(width * 0.03),
              ),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("🚗 Next Trip",
                      style: TextStyle(
                          fontSize: font + 1, fontWeight: FontWeight.bold)),
                  SizedBox(height: height * 0.01),
                  Text("🗓 10:00 AM - Trip to Kochi",
                      style: TextStyle(fontSize: font)),
                  Text("📍 Pickup: Palakkad", style: TextStyle(fontSize: font)),
                  Text("👤 Passenger: Mohammed Kamal",
                      style: TextStyle(fontSize: font)),
                  SizedBox(height: height * 0.015),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        child: Text("Start Trip",
                            style:
                                TextStyle(fontSize: font, color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: EdgeInsets.symmetric(
                              vertical: height * 0.012,
                              horizontal: width * 0.08),
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () {},
                        child: Text("Cancel", style: TextStyle(fontSize: font)),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              vertical: height * 0.012,
                              horizontal: width * 0.08),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: height * 0.03),

            // Overview Section
            Text("📊 Overview",
                style:
                    TextStyle(fontSize: font + 1, fontWeight: FontWeight.bold)),
            SizedBox(height: height * 0.015),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: overviewData.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: width * 0.04,
                mainAxisSpacing: height * 0.015,
                childAspectRatio: 2.3,
              ),
              itemBuilder: (context, index) {
                final item = overviewData[index];
                return Container(
                  padding: EdgeInsets.symmetric(
                      vertical: height * 0.015, horizontal: width * 0.03),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(width * 0.03),
                    border: Border.all(
                        color: ColorConstant.primaryColor, width: 1.2),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                          item["label"]!,
                          style: TextStyle(fontSize: font),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      Text(item["value"]!,
                          style: TextStyle(
                              fontSize: font + 1, fontWeight: FontWeight.bold)),
                    ],
                  ),
                );
              },
            ),
            SizedBox(height: height * 0.03),

            // Quick Access
            Text("🔗 Quick Access",
                style:
                    TextStyle(fontSize: font + 1, fontWeight: FontWeight.bold)),
            SizedBox(height: height * 0.015),
            GridView.builder(
              shrinkWrap: true,
              itemCount: quickAccessItems.length,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: width * 0.04,
                mainAxisSpacing: height * 0.015,
                childAspectRatio: 2.6,
              ),
              itemBuilder: (context, index) {
                final item = quickAccessItems[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(width * 0.03),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(item["icon"],
                          color: ColorConstant.primaryColor, size: font + 4),
                      SizedBox(width: width * 0.02),
                      Text(item["label"],
                          style: TextStyle(
                              fontSize: font,
                              fontWeight: FontWeight.w500,
                              color: ColorConstant.primaryColor)),
                    ],
                  ),
                );
              },
            ),
            SizedBox(height: height * 0.05),
          ],
        ),
      ),
    );
  }
}
