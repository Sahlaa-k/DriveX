import 'package:drivex/core/constants/color_constant.dart';
import 'package:drivex/core/constants/localVariables.dart';
import 'package:drivex/core/widgets/BackGroundTopGradient.dart';
import 'package:drivex/feature/drivers_page/screens/driver_booking.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DriverProfilePage extends StatefulWidget {
  final Map<String, dynamic> driverData;

  const DriverProfilePage({super.key, required this.driverData});

  @override
  State<DriverProfilePage> createState() => _DriverProfilePageState();
}

class _DriverProfilePageState extends State<DriverProfilePage> {
  bool isExpanded = false;
  final List<Map<String, dynamic>> driverStats = [
    {
      "icon": "assets/icons/car-family-vacation.svg", // Customer icon
      "label": "Customer",
      "value": "7,500+"
    },
    {
      "icon": "assets/icons/number-blocks.svg", // Years Exp icon
      "label": "Years Exp.",
      "value": "10+"
    },
    {
      "icon": "assets/icons/achievement-rating-review.svg", // Rating icon
      "label": "Rating",
      "value": "4.8"
    },
    {
      "icon": "assets/icons/review-customer.svg", // Review icon
      "label": "Review",
      "value": "4,956"
    },
  ];
  final List<Map<String, dynamic>> reviews = [
    {
      "name": "Ayesha M",
      "rating": 4,
      "timeAgo": "1 week ago",
      "review":
          "Very knowledgeable and on time. The clinic was clean and staff were polite.",
    },
    {
      "name": "Sarah K",
      "rating": 5,
      "timeAgo": "2 weeks ago",
      "review":
          "Dr. Laila is incredible. She explained everything clearly and supported me during my first pregnancy.",
    },
    {
      "name": "Mohammed R",
      "rating": 5,
      "timeAgo": "3 weeks ago",
      "review":
          "Excellent service and very professional doctor. Highly recommend!",
    },
  ];
  List gradientColor = [
    Colors.blue.withOpacity(0.2),
    Colors.greenAccent.withOpacity(0.2),
    Colors.redAccent.withOpacity(0.2),
    Colors.brown.withOpacity(0.2)
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.bgColor,
      body: SingleChildScrollView(
        child: Backgroundtopgradient(
          child: Padding(
            padding: EdgeInsets.all(width * 0.03),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: width * 0.07),
                Row(
                  children: [
                    Icon(
                      Icons.arrow_back_ios,
                      color: ColorConstant.thirdColor.withOpacity(0.7),
                      size: width * 0.045,
                    ),
                    SizedBox(width: width * 0.3),
                    Text(
                      "Driver Details",
                      style: TextStyle(
                        fontSize: width * 0.045,
                        fontWeight: FontWeight.w600,
                        color: ColorConstant.thirdColor.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: width * 0.05),
                Column(
                  children: [
                    Container(
                      width: width * 0.23,
                      height: width * 0.23,
                      decoration: BoxDecoration(
                          color: ColorConstant.color11.withOpacity(0.1),
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: AssetImage(widget.driverData["image"]),
                              fit: BoxFit.cover)),
                    ),
                    SizedBox(
                      height: width * 0.02,
                    ),
                    Text(
                      widget.driverData["name"],
                      style: TextStyle(
                          color: ColorConstant.thirdColor,
                          fontWeight: FontWeight.w600,
                          fontSize: width * 0.045),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          "assets/icons/location-pin (1).svg",
                          color: ColorConstant.color11.withOpacity(0.7),
                          height: width * 0.04,
                        ),
                        SizedBox(
                          width: width * 0.01,
                        ),
                        Text(
                          widget.driverData["location"] ?? "Unknown Location",
                          style: TextStyle(color: ColorConstant.textColor3),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  width: width,
                  height: width * 0.3,
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: driverStats.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,

                      // childAspectRatio: 1.9,
                      crossAxisSpacing: width * 0.02,
                    ),
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: ColorConstant.thirdColor.withOpacity(0.2),
                          ),
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(width * 0.02),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(width * 0.02),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                              SvgPicture.asset(
                                driverStats[index]["icon"],
                                color: ColorConstant.color11.withOpacity(0.9),
                                height: width * 0.07,
                              ),
                              SizedBox(height: 6),
                              Text(
                                driverStats[index]["value"],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: width * 0.025,
                                  overflow: TextOverflow
                                      .ellipsis, // Prevents overflow
                                ),
                                maxLines: 1,
                              ),
                              SizedBox(height: 2),
                              Text(
                                driverStats[index]["label"],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: width * 0.03,
                                  overflow: TextOverflow
                                      .ellipsis, // Prevents overflow
                                ),
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: width * 0.02),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "About",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Over 10 years of professional driving experience across multiple cities",
                      maxLines: isExpanded ? null : 1,
                      overflow: isExpanded
                          ? TextOverflow.visible
                          : TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: width * 0.035,
                        color: ColorConstant.textColor3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isExpanded = !isExpanded;
                        });
                      },
                      child: Text(
                        isExpanded ? "View less" : "View more",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: width * 0.035,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: width * 0.03),
                Divider(
                  color: ColorConstant.thirdColor.withOpacity(0.1),
                ),

                Row(
                  children: [
                    Text(
                      "What Customers Say",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    Text(
                      "View All",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // // Rating row
                // Row(
                //   children: const [
                //     Icon(Icons.star, color: Colors.blue, size: 20),
                //     SizedBox(width: 6),
                //     Expanded(
                //       child: Text(
                //         "Rated 4.8 by 2600+ patients for expert, caring service",
                //         style: TextStyle(fontSize: 14, color: Colors.black87),
                //       ),
                //     ),
                //   ],
                // ),
                // const SizedBox(height: 6),
                //
                // // Verified reviews row
                // Row(
                //   children: const [
                //     Icon(Icons.verified, color: Colors.blue, size: 20),
                //     SizedBox(width: 6),
                //     Expanded(
                //       child: Text(
                //         "Verified reviews from real Healine bookings",
                //         style: TextStyle(fontSize: 14, color: Colors.black87),
                //       ),
                //     ),
                //   ],
                // ),
                //const SizedBox(height: 16),

                // ListView.builder for reviews
                SizedBox(
                  height: 160,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: reviews.length,
                    itemBuilder: (context, index) {
                      final item = reviews[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Container(
                          width: 250,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: gradientColor[index],
                            border: Border.all(
                                color: ColorConstant.color11.withOpacity(0.1)),
                            borderRadius: BorderRadius.circular(12),
                            // gradient:  LinearGradient(
                            //   begin: Alignment.topLeft,
                            //   end: Alignment.bottomRight,
                            //   colors: [
                            //     gradientColor[index], // bluish top-left
                            //     Color(0xFFFFFFFF),
                            //     Color(
                            //         0xFFFFFFFF), // very light teal-white in middle
                            //     gradientColor[index], // almost white bottom-right
                            //   ],
                            //   stops: [
                            //     0.0,
                            //     0.2,
                            //     0.9,
                            //     1.4
                            //   ], // smoother transition
                            // ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.grey.shade200,
                                    child: Icon(Icons.person,
                                        color: ColorConstant.color11
                                            .withOpacity(0.7)),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(item["name"],
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14)),
                                        Row(
                                          children: List.generate(
                                            5,
                                            (starIndex) => Icon(
                                              starIndex < item["rating"]
                                                  ? Icons.star
                                                  : Icons.star_border,
                                              color: Colors.orange,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(item["timeAgo"],
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey.shade600)),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                item["review"],
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.black87),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: width * 0.03),
                Divider(
                  color: ColorConstant.thirdColor.withOpacity(0.1),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Car Details",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: width * 0.01),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Car Model",
                        style: TextStyle(color: Colors.black45, fontSize: 14)),
                    Text("Hyundai Verna",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 14)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Seating Capacity",
                        style: TextStyle(color: Colors.black45, fontSize: 14)),
                    Text("4",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 14)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("AC Availability",
                        style: TextStyle(color: Colors.black45, fontSize: 14)),
                    Text("Yes",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 14)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              height: width * 0.1,
              width: width * 0.29,
              decoration: BoxDecoration(
                  color: ColorConstant.bgColor,
                  borderRadius: BorderRadius.all(Radius.circular(width * 0.02)),
                  border: Border.all(color: Colors.green)),
              child: Center(
                child: Row(
                  children: [
                    SizedBox(
                      width: width * 0.05,
                    ),
                    Icon(
                      CupertinoIcons.chat_bubble_text,
                      color: Colors.green,
                      size: width * 0.04,
                    ),
                    SizedBox(
                      width: width * 0.02,
                    ),
                    Text(
                      "Chat",
                      style: TextStyle(
                          color: Colors.green, fontSize: width * 0.04),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              width: width * 0.02,
            ),
            Container(
              height: width * 0.1,
              width: width * 0.29,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.all(Radius.circular(width * 0.02)),
              ),
              child: Center(
                child: Row(
                  children: [
                    SizedBox(
                      width: width * 0.05,
                    ),
                    Icon(
                      Icons.call_outlined,
                      color: ColorConstant.bgColor,
                      size: width * 0.045,
                    ),
                    SizedBox(
                      width: width * 0.02,
                    ),
                    Text(
                      "Call",
                      style: TextStyle(
                          color: ColorConstant.bgColor, fontSize: width * 0.04),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              width: width * 0.02,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DriverBookingPage(),
                    ));
              },
              child: Container(
                height: width * 0.1,
                width: width * 0.29,
                decoration: BoxDecoration(
                    color: ColorConstant.bgColor,
                    borderRadius:
                        BorderRadius.all(Radius.circular(width * 0.02)),
                    border: Border.all(color: Colors.green)),
                child: Center(
                  child: Row(
                    children: [
                      SizedBox(
                        width: width * 0.04,
                      ),
                      Icon(
                        CupertinoIcons.time,
                        color: Colors.green,
                        size: width * 0.04,
                      ),
                      SizedBox(
                        width: width * 0.02,
                      ),
                      Text(
                        "Book ",
                        style: TextStyle(
                            color: Colors.green, fontSize: width * 0.04),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
