import 'package:drivex/core/constants/color_constant.dart';
import 'package:drivex/core/constants/imageConstants.dart';
import 'package:drivex/core/constants/localVariables.dart';
import 'package:drivex/feature/bottomNavigation/pages/D2D/D2D_page01.dart';
import 'package:drivex/feature/bottomNavigation/pages/D2D/addressBookPage.dart';
// import 'package:drivex/feature/bottomNavigation/pages/D2D/D2D_HistoryPage.dart';
// import 'package:drivex/feature/bottomNavigation/pages/D2D/D2D_page04.dart';
import 'package:drivex/feature/bottomNavigation/pages/D2D/d2d.dart';
// import 'package:drivex/feature/bottomNavigation/pages/D2DPage_03.dart';
// import 'package:drivex/feature/bottomNavigation/pages/D2D_page01.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class D2DMainpage extends StatefulWidget {
  const D2DMainpage({super.key});

  @override
  State<D2DMainpage> createState() => _D2DMainpageState();
}

class _D2DMainpageState extends State<D2DMainpage> {
  // final List<Map<String, dynamic>> actionItems = [
  //   {
  //     'label': 'Book\nNow',
  //     'icon': Icons.event_available_rounded,
  //     'color': const Color(0xFF2F80FF),
  //     'action': 'book',
  //   },
  //   {
  //     'label': 'Track\nOrder',
  //     'icon': Icons.location_on_rounded,
  //     'color': const Color(0xFF16C65B),
  //     'action': 'track',
  //   },
  //   {
  //     'label': 'Support',
  //     'icon': Icons.support_agent_rounded,
  //     'color': const Color(0xFF8B5CF6),
  //     'action': 'support',
  //   },
  //   {
  //     'label': 'History',
  //     'icon': Icons.history_rounded,
  //     'color': const Color(0xFFFF7A21),
  //     'action': 'history',
  //   },
  // ];

  final List<Map<String, dynamic>> actionItems = [
    {
      'label': 'Schedule Service',
      'icon': Icons.event_available_rounded,
      'color': const Color(0xFF2F80FF),
      // 'page': D2DPage03()
    },
    {
      'label': 'Track Order',
      'icon': Icons.location_on_rounded,
      'color': const Color(0xFF16C65B),
      // 'page': D2DPage04()
    },
    {
      'label': 'Support',
      'icon': Icons.support_agent_rounded,
      'color': const Color(0xFF8B5CF6),
      'page': D2DPage01()
    },
    {
      'label': 'History',
      'icon': Icons.history_rounded,
      'color': const Color(0xFFFF7A21),
      // 'page': D2DHistorypage()
    },
    {
      'label': 'Saved Address',
      'icon': Icons.book_outlined,
      'color': const Color(0xFFFF2D55),
      'page': Addressbookpage()
    },
    {
      'label': 'Wallet',
      'icon': Icons.account_balance_wallet_rounded,
      'color': const Color(0xFF9B51E0),
      // 'page': D2DHistorypage()
    },
    {
      'label': 'Settings',
      'icon': Icons.settings_rounded,
      'color': const Color(0xFF56CCF2),
      // 'page': D2DHistorypage()
    },
    {
      'label': 'Feedback',
      'icon': Icons.feedback_rounded,
      'color': const Color(0xFFFFC107),
      // 'page': D2DHistorypage()
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                // 'assets/images/pzerson-doing-delivery-activities-pack.png',
                // 'assets/images/DeliveryMan.png',
                ImageConstant.deliveryman1,
                width: width * .6,
                // width: width * .75,

                // height: 100,
              ),
              SizedBox(
                height: height * .025,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) =>
                            /////
                            // D2d(),
                            D2DPage01(),
                        // D2DPage03(),
                      ));
                },
                child: Container(
                  width: width * .4,
                  padding: EdgeInsets.symmetric(vertical: width * .025),
                  decoration: BoxDecoration(
                    color: ColorConstant.color1,
                    borderRadius: BorderRadius.circular(width * .025),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: width * .02,
                        offset: Offset(width * .01, width * .0125),
                      )
                    ],
                  ),
                  child: Center(
                    child: Text(
                      "Book Service",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: width * .04,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height * .05,
              ),
              Center(
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.04, vertical: width * 0.02),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: width * 0.035,
                    mainAxisSpacing: width * 0.035,
                    childAspectRatio:
                        0.75, // adjust height/width ratio of each card
                  ),
                  itemCount: actionItems.length,
                  itemBuilder: (context, index) {
                    final item = actionItems[index];
                    return Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(width * 0.05),
                      elevation: 3,
                      shadowColor: Colors.black.withOpacity(0.5),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(width * 0.05),
                        // onTap: () => debugPrint("Tapped on ${item['label']}"),
                        onTap: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => item['page'] as Widget,
                              ));
                        },
                        child: Container(
                          // decoration: BoxDecoration(border: Border.all()),
                          padding: EdgeInsets.symmetric(
                            vertical: width * 0.025,
                            horizontal: width * 0.02,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: width * 0.1,
                                height: width * 0.1,
                                decoration: BoxDecoration(
                                  color: item['color'] as Color,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  item['icon'] as IconData,
                                  color: Colors.white,
                                  size: width * 0.055,
                                ),
                              ),
                              SizedBox(height: width * 0.02),
                              Text(
                                item['label'] as String,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: width * 0.032,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF2D2D2D),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ));
  }
}
