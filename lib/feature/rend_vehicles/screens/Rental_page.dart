import 'package:drivex/core/constants/color_constant.dart';
import 'package:drivex/core/constants/localVariables.dart';
import 'package:drivex/core/widgets/BackGroundTopGradient.dart';
import 'package:drivex/feature/bottomNavigationBar/notification_page.dart';
import 'package:drivex/feature/rend_vehicles/screens/rental_tab_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class RentalPage extends StatefulWidget {
  const RentalPage({super.key});

  @override
  State<RentalPage> createState() => _RentalPageState();
}

class _RentalPageState extends State<RentalPage> {
  final List<String> tabs = [
    'All',
    'BMW',
    'Mahindra',
    'Porsche',
    'MINI Cooper',
    'Maruthi',
    'TATA'
  ];
  int selectedIndex = 0;
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.bgColor,
      body: Backgroundtopgradient(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: width * 0.06,
              ),
              Padding(
                padding: EdgeInsets.all(width * 0.03),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: width * 0.003,
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                "assets/icons/location-pin (1).svg",
                                color: ColorConstant.color11.withOpacity(0.7),
                                height: width * 0.05,
                              ),
                              SizedBox(
                                width: width * 0.01,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Your Location",
                                    style: TextStyle(
                                        color: ColorConstant.color11
                                            .withOpacity(0.7),
                                        fontWeight: FontWeight.w600,
                                        fontSize: width * 0.03),
                                  ),
                                  Text(
                                    "Tower Road, Manhttan",
                                    style: TextStyle(
                                        color: ColorConstant.thirdColor,
                                        fontWeight: FontWeight.w700,
                                        fontSize: width * 0.035),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),

                  ],
                ),
              ),
              SizedBox(
                height: width * 0.02,
              ),
              Container(
                height: width * 0.11,
                width: width,
                child: Padding(
                  padding:
                  EdgeInsets.only(right: width * 0.03, left: width * 0.03),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: searchController,
                          style: TextStyle(
                            color: ColorConstant.thirdColor,
                          ),
                          textCapitalization: TextCapitalization.none,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: ColorConstant.bgColor,
                            prefixIcon: Icon(CupertinoIcons.search),
                            prefixIconColor:
                            ColorConstant.thirdColor.withOpacity(0.4),
                            hintText: "Search here!",
                            hintStyle: TextStyle(
                                color:
                                ColorConstant.thirdColor.withOpacity(0.4),
                                fontSize: width * 0.03),
                            contentPadding:
                            EdgeInsets.symmetric(vertical: width * 0.01),
                            // border: OutlineInputBorder(
                            //   borderSide: BorderSide(
                            //       color: ColorConstant.color11.withOpacity(0.4),
                            //       width: width * 0.002),
                            //   borderRadius: BorderRadius.circular(width * 0.06),
                            // ),
                            // enabledBorder: OutlineInputBorder(
                            //   borderSide: BorderSide(
                            //       color: ColorConstant.color11.withOpacity(0.4),
                            //       width: width * 0.002),
                            //   borderRadius: BorderRadius.circular(width * 0.06),
                            // ),
                            // focusedBorder: OutlineInputBorder(
                            //   borderSide: BorderSide(
                            //       color: ColorConstant.color11.withOpacity(0.4),
                            //       width: width * 0.002),
                            //   borderRadius: BorderRadius.circular(width * 0.06),
                            // ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                          width: width * 0.02), // Add spacing between icons
                      Container(
                        height: width * 0.1,
                        width: width * 0.1,
                        decoration: BoxDecoration(
                            color: ColorConstant.bgColor,
                            shape: BoxShape.circle),
                        child: Center(
                            child: Icon(
                              Icons.favorite_border,
                              color: ColorConstant.thirdColor.withOpacity(0.6),
                              size: width * 0.052,
                            )),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: width * 0.02,
              ),
              // Custom TabBar
              Container(
                height: width * 0.12, // slightly increased to fit underline
                padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
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
                        padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              tabs[index],
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
              RentalTabView(selectedIndex: selectedIndex),
            ],
          ),
        ),
      ),
    );
  }
}
