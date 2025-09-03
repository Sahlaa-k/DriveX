import 'package:drivex/core/constants/color_constant.dart';
import 'package:drivex/core/constants/imageConstants.dart';
import 'package:drivex/core/constants/localVariables.dart';
import 'package:drivex/core/widgets/BackGroundTopGradient.dart';
import 'package:flutter/material.dart';

class Upcomingbookingpage extends StatefulWidget {
  const Upcomingbookingpage({super.key});

  @override
  State<Upcomingbookingpage> createState() => _UpcomingbookingpageState();
}

class _UpcomingbookingpageState extends State<Upcomingbookingpage> {
  final List<Map<String, dynamic>> datas = [
    {
      "title": "D2D Services",
      "items": [
        {
          "image":ImageConstant.d2dServiceEg,
          "price": "\$35",
          "name":"Jenny Wilson",
          "rating":"4.1",
          "vehicle": "",
          "status": "Completed",
          "driver": "Sarah Wilson",
          "from": "Your Location",
          "to": "Shopping District",
          "dateTime": "Dec 20 at 3:45 PM"
        },

      ],
    },

    {
      "title": "Driver Only",
      "items": [
        {
          "image":ImageConstant.d2dServiceEg,
          "price": "\$35",
          "name":"Jenny Wilson",
          "rating":"4.1",
          "vehicle": "Your Vehicle",
          "status": "Completed",
          "driver": "Sarah Wilson",
          "from": "Your Location",
          "to": "Shopping District",
          "dateTime": "Dec 20 at 3:45 PM"
        },

      ],
    },
    {
      "title": "Driver with car",
      "items": [
        {
          "image":ImageConstant.d2dServiceEg,
          "price": "\$35",
          "name":"Jenny Wilson",
          "rating":"4.1",
          "vehicle": "Swift 2012",
          "status": "Completed",
          "driver": "Sarah Wilson",
          "from": "Your Location",
          "to": "Shopping District",
          "dateTime": "Dec 20 at 3:45 PM"
        },

      ],
    },


  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.bgColor,
      body:        ListView.builder(
        itemCount: datas.length,
        itemBuilder: (context, sectionIndex) {
          final section = datas[sectionIndex];
          final title = section['title'] ?? '';
          final items = section['items'] ?? [];

          if (items.isEmpty) return const SizedBox.shrink();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              ListView.builder(
                itemCount: items.length,
                physics: const NeverScrollableScrollPhysics(), // Prevent nested scrolling
                shrinkWrap: true, // Important to avoid infinite height
                itemBuilder: (context, itemIndex) {
                  // Inside the second ListView.builder -> itemBuilder
                  final item = items[itemIndex];
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: ColorConstant.bgColor,
                      borderRadius: BorderRadius.circular(width * 0.02),
                      border: Border.all(color: ColorConstant.thirdColor.withOpacity(0.2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top: Driver Info
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            (title == "Driver with car")
                                ? Stack(
                              children: [
                                SizedBox(
                                  height: width * 0.17,
                                  width: width * 0.2,
                                  child: Container(
                                    height: width * 0.13,
                                    width: width * 0.12,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(width * 0.01),
                                      image: DecorationImage(
                                        image: AssetImage(ImageConstant.profilePic),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: width * 0.04,
                                  left: width * 0.06,
                                  child: Container(
                                    height: width * 0.12,
                                    width: width * 0.13,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(width * 0.01),
                                      image: DecorationImage(
                                        image: AssetImage(item["image"] ?? ImageConstant.carHDRent1),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                                : Container(
                              height: width * 0.15,
                              width: width * 0.15,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(width * 0.01),
                                image: DecorationImage(
                                  image: AssetImage(item["image"] ?? ImageConstant.profilePic),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item["name"] ?? "", style: const TextStyle(fontWeight: FontWeight.bold)),
                                  Text(item["vehicle"] ?? "", style: TextStyle(color: Colors.grey.shade600)),
                                ],
                              ),
                            ),
                            const Icon(Icons.star, color: Colors.orange, size: 18),
                            Text(item["rating"] ?? "", style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // Date & Time
                        Row(
                          children: [
                            const Text("Date & Time", style: TextStyle(color: Colors.grey)),
                            const Spacer(),
                            Text(item["dateTime"] ?? "", style: const TextStyle(fontWeight: FontWeight.w500)),
                          ],
                        ),

                        Divider(color: ColorConstant.thirdColor.withOpacity(0.2)),

                        // From → To
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.my_location_rounded, color: ColorConstant.thirdColor, size: width * 0.06),
                                Container(
                                  width: width * 0.003,
                                  height: width * 0.06,
                                  color: ColorConstant.thirdColor.withOpacity(0.2),
                                ),
                                Icon(Icons.location_on_rounded, color: ColorConstant.color11.withOpacity(0.7), size: width * 0.06),
                              ],
                            ),
                            SizedBox(width: width * 0.03),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item["from"] ?? ""),
                                  SizedBox(height: width * 0.02),
                                  Divider(color: ColorConstant.thirdColor.withOpacity(0.2)),
                                  SizedBox(height: width * 0.02),
                                  Text(item["to"] ?? ""),
                                ],
                              ),
                            ),
                          ],
                        ),

                        Divider(color: ColorConstant.thirdColor.withOpacity(0.2)),

                        // Buttons
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {},
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.black,
                                  side: BorderSide(color: ColorConstant.color11.withOpacity(0.7)),
                                ),
                                child: Text("Cancel", style: TextStyle(color: ColorConstant.color11.withOpacity(0.7))),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorConstant.color11.withOpacity(0.7),
                                ),
                                child: const Text("Reschedule", style: TextStyle(color: ColorConstant.bgColor)),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  );



                },
              ),
            ],
          );
        },
      ),
    );
  }



}

