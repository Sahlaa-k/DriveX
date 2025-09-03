import 'package:drivex/core/constants/color_constant.dart';
import 'package:drivex/core/constants/localVariables.dart';
import 'package:drivex/feature/bookings/screens/cancelpage.dart';
import 'package:drivex/feature/bookings/screens/historyBookingPage.dart';
import 'package:drivex/feature/bookings/screens/upcomingBookingPage.dart';
import 'package:flutter/material.dart';

class BookingPagee extends StatefulWidget {
  const BookingPagee({super.key});

  @override
  State<BookingPagee> createState() => _BookingPageeState();
}

class _BookingPageeState extends State<BookingPagee> {
  List<Map<String, dynamic>> tabs = [

    {
      "title": "Upcomings",
      "screen": const Upcomingbookingpage(),
    },
    {
      "title": "Completed",
      "screen": const Historybookingpage(),
    },
    {
      "title": "Cancelled",
      "screen": const CancelPage(),
    },
  ];

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.bgColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: width * 0.04),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.03),
              child: Row(
                children: [
                  Text(
                    "Bookings",
                    style: TextStyle(
                      color: ColorConstant.color11,
                      fontWeight: FontWeight.w600,
                      fontSize: width * 0.055,
                    ),
                  ),
                  Spacer(),
                  Icon(Icons.search,color: ColorConstant.color11,)
                ],
              ),
            ),
            SizedBox(height: width * 0.04),

            // Custom Tab Bar
            Container(
              height: width * 0.12,
              padding: EdgeInsets.symmetric(horizontal: width * 0.03),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: NeverScrollableScrollPhysics(),
                itemCount: tabs.length,
                itemBuilder: (context, index) {
                  final isSelected = index == selectedIndex;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.06),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            tabs[index]["title"],
                            style: TextStyle(
                              fontSize: width * 0.04,
                              fontWeight: FontWeight.bold,
                              color: isSelected
                                  ? ColorConstant.color11
                                  : ColorConstant.color11.withOpacity(0.4),
                            ),
                          ),
                          SizedBox(height: 4),
                          if (isSelected)
                            Container(
                              height: 3,
                              width: 40,
                              decoration: BoxDecoration(
                                color: ColorConstant.color11,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),

                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
Divider(color: ColorConstant.color11.withOpacity(0.2),),
            SizedBox(height: width * 0.03),

            // Display the selected screen here
            Expanded(
              child: tabs[selectedIndex]["screen"],
            ),
          ],
        ),
      ),
    );
  }
}


// Container(
//   height: height*0.9,
//   width: width,
//   child: Center(child: Column(
//     crossAxisAlignment: CrossAxisAlignment.center,
//     mainAxisAlignment: MainAxisAlignment.center,
//     children: [
//       Text(
//         "You have no booking rides",
//         style: TextStyle(
//             color: ColorConstant.textColor3,
//             fontSize: width * 0.035),
//       ),
//     ],),),
// )
