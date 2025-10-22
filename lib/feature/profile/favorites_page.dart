import 'package:drivex/core/constants/color_constant.dart';
import 'package:drivex/core/constants/icon_Constants.dart';
import 'package:drivex/core/constants/imageConstants.dart';
import 'package:drivex/core/constants/localVariables.dart';
import 'package:drivex/core/widgets/BackGroundTopGradient.dart';
import 'package:drivex/feature/rend_vehicles/screens/rental_item_view_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<Map<String, dynamic>> rentalVehicle = [
    {
      "name": "BMW M4 Series",
      "price": "300.00",
      "image": ImageConstant.carHDRent2,
      "reviewStar": 4,
      "isFavorite": false,
      "year":"2010"
    },
    {
      "name": "Mahindra Thar",
      "price": "600.00",
      "image": ImageConstant.carHDRent4,
      "reviewStar": 2,
      "isFavorite": false,
      "year":"2010"

    },
    {
      "name": "Porsche 911",
      "price": "900.00",
      "image": ImageConstant.carHDRent1,
      "reviewStar": 5,
      "isFavorite": false,
      "year":"2010"

    },
    {
      "name": "MINI Cooper",
      "price": "1000.00",
      "image": ImageConstant.carHDRent3,
      "reviewStar": 3,
      "isFavorite": false,
      "year":"2000"

    },
    {
      "name": "BMW M4 Series",
      "price": "300.00",
      "image": ImageConstant.carHDRent2,
      "reviewStar": 4,
      "isFavorite": false,
      "year":"2010"

    },
    {
      "name": "Mahindra Thar",
      "price": "600.00",
      "image": ImageConstant.carHDRent4,
      "reviewStar": 2,
      "isFavorite": false,
      "year":"2018"

    },
    {
      "name": "Porsche 911",
      "price": "900.00",
      "image": ImageConstant.carHDRent1,
      "reviewStar": 5,
      "isFavorite": false,
      "year":"2019"

    },
    {
      "name": "MINI Cooper",
      "price": "1000.00",
      "image": ImageConstant.carHDRent3,
      "reviewStar": 3,
      "isFavorite": false,
      "year":"2020"

    },
  ];
  bool favorite = false;
  TextEditingController searchController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Backgroundtopgradient(child: Column(children: [
        SizedBox(height: width * 0.07),

        /// HEADER
        Padding(
          padding: EdgeInsets.all(width * 0.03),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Icon(Icons.arrow_back_ios,
                    color: ColorConstant.thirdColor.withOpacity(0.7),
                    size: width * 0.045),
              ),
              Expanded(
                child: Center(
                  child: Text("Favorites",
                      style: TextStyle(
                          fontSize: width * 0.05,
                          fontWeight: FontWeight.w600,
                          color: ColorConstant.thirdColor.withOpacity(0.7))),
                ),
              ),
              SizedBox(width: width * 0.045), // balance space
            ],
          ),
        ),
        Row(
          children: [
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
                          hintText: "Search your Favorites",
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
                  ],
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(
              top: width * 0.03,
              left: width * 0.03,
              right: width * 0.03,
              bottom: width * 0.01),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Favorite Drivers",
                style: TextStyle(
                    color: ColorConstant.color11,
                    fontWeight: FontWeight.w600,
                    fontSize: width * 0.044),
              ),
              GestureDetector(
                onTap: () {

                },
                child: Row(
                  children: [
                    Text(
                      "View all",
                      style: TextStyle(
                          color:
                          ColorConstant.thirdColor.withOpacity(0.4),
                          fontWeight: FontWeight.w500,
                          fontSize: width * 0.03),
                    ),
                    SizedBox(
                      width: width * 0.01,
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: width * 0.04,
                      color: ColorConstant.color11.withOpacity(0.7),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: width * 0.65,
          child: ListView.builder(
            padding: EdgeInsets.only(
                right: width * .03, left: width * .03, top: width * 0.03),
            itemCount: 3,
            physics: AlwaysScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(
                    bottom: width * 0.03, right: width * 0.03),
                height: width * 0.16,
                width: width * 0.45,
                decoration: BoxDecoration(
                  color: ColorConstant.bgColor,
                  // border: Border.all(
                  //     color: ColorConstant.textColor2,
                  //     width: width * 0.002),
                  borderRadius:
                  BorderRadius.all(Radius.circular(width * 0.03)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1), // soft shadow
                      blurRadius: 6, // how soft the shadow is
                      offset: Offset(0, 3), // X, Y position of shadow
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(width * 0.03),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: width * 0.2,
                            width: width * 0.2,
                            decoration: BoxDecoration(
                                color: ColorConstant.color11,
                                // shape: BoxShape.circle,
                                borderRadius: BorderRadius.all(
                                    Radius.circular(width * 0.03)),
                                image: DecorationImage(
                                    image: AssetImage(
                                      ImageConstant.profilePic,
                                    ),
                                    fit: BoxFit.cover)),
                          ),
                          SizedBox(
                            width: width * 0.02,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Budi Susanto",
                                style: TextStyle(
                                  color: ColorConstant.thirdColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: width * 0.037,
                                ),
                              ),
                              SizedBox(
                                width: width * 0.01,
                              ),
                              SvgPicture.asset(
                                IconConstants.verifyDriver,
                                color: Colors.blue,
                                height: width * 0.04,
                              )
                            ],
                          ),
                          Text(
                            "5+ years of experience",
                            style: TextStyle(
                                color: ColorConstant.thirdColor
                                    .withOpacity(0.4),
                                fontWeight: FontWeight.w700,
                                fontSize: width * 0.03),
                          ),
                          Divider(
                            color:
                            ColorConstant.thirdColor.withOpacity(0.2),
                          ),
                          IntrinsicHeight(
                            // makes children take equal height
                            child: Row(
                              crossAxisAlignment:
                              CrossAxisAlignment.stretch,
                              children: [
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                  MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.currency_rupee,
                                          color: ColorConstant.color11,
                                          size: width * 0.032,
                                        ),
                                        Text(
                                          "40.00 ",
                                          style: TextStyle(
                                            color:
                                            ColorConstant.thirdColor,
                                            fontWeight: FontWeight.w700,
                                            fontSize: width * 0.032,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Row(
                                          children: List.generate(
                                            4,
                                                (index) => Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                              size: width * 0.045,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: width * 0.01),
                                        Text(
                                          "(12)",
                                          style: TextStyle(
                                            color: ColorConstant.color11
                                                .withOpacity(0.6),
                                            fontWeight: FontWeight.w700,
                                            fontSize: width * 0.03,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                // vertical divider
                                VerticalDivider(
                                  color: ColorConstant.thirdColor
                                      .withOpacity(0.2),
                                  thickness: 1,
                                  width: 20, // spacing between items
                                ),
                                SizedBox(
                                  width: width * 0.02,
                                ),
                                Icon(
                                  Icons.call_outlined,
                                  color: Colors.green,
                                  size: width * 0.055,
                                ),
                              ],
                            ),
                          )

                          // Container(
                          //   height: width * 0.072,
                          //   width: width * 0.3,
                          //   decoration: BoxDecoration(
                          //       color: ColorConstant.color11
                          //           .withOpacity(0.8),
                          //       borderRadius: BorderRadius.all(
                          //           Radius.circular(width * 0.04))),
                          //   child: Center(
                          //     child: Text(
                          //       "Book Now",
                          //       style: TextStyle(
                          //         color: ColorConstant.bgColor,
                          //         fontSize: width * 0.033,
                          //         fontWeight: FontWeight.w700,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: width * 0.01,
                      right: width * 0.01,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            favorite = !favorite; // toggle
                          });
                        },
                        child: Icon(
                          favorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: favorite
                              ? Colors.red
                              : ColorConstant.thirdColor.withOpacity(0.1),
                          size: width * 0.045,
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              top: width * 0.03,
              left: width * 0.03,
              right: width * 0.03,
              bottom: width * 0.01),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Favorite Rentals",
                style: TextStyle(
                    color: ColorConstant.color11,
                    fontWeight: FontWeight.w600,
                    fontSize: width * 0.044),
              ),
              GestureDetector(
                onTap: () {

                },
                child: Row(
                  children: [
                    Text(
                      "View all",
                      style: TextStyle(
                          color:
                          ColorConstant.thirdColor.withOpacity(0.4),
                          fontWeight: FontWeight.w500,
                          fontSize: width * 0.03),
                    ),
                    SizedBox(
                      width: width * 0.01,
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: width * 0.04,
                      color: ColorConstant.color11.withOpacity(0.7),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: width ,
          height: width * 0.65,
          child: ListView.builder(
            shrinkWrap: true,
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: rentalVehicle.length,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.all(0),
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding:  EdgeInsets.only(left: width*0.03,top: width*0.03),
                child: Container(
                  height: width * 0.5,
                  width: width * 0.45,
                  decoration: BoxDecoration(
                    color: ColorConstant.bgColor,
                    borderRadius: BorderRadius.all(Radius.circular(width * 0.02)),
                    border: Border.all(color: ColorConstant.color11.withOpacity(0.3)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(width * 0.02),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min, // Fixes overflow
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: width * 0.45,
                              height: width * 0.3,
                              decoration: BoxDecoration(
                                color: ColorConstant.textColor3,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(width * 0.02),
                                  topRight: Radius.circular(width * 0.02),
                                ),
                                image: DecorationImage(
                                  image: AssetImage(rentalVehicle[index]["image"]),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding:  EdgeInsets.all(width*0.01),
                                child: CircleAvatar(
                                  radius: width*0.04,
                                  backgroundColor: ColorConstant.thirdColor.withOpacity(0.3),
                                  child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        rentalVehicle[index]["isFavorite"] =
                                        !rentalVehicle[index]["isFavorite"];
                                      });
                                    },
                                    icon: Icon(
                                      rentalVehicle[index]["isFavorite"] == true
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: rentalVehicle[index]["isFavorite"] == true
                                          ? ColorConstant.bgColor
                                          : ColorConstant.bgColor,
                                      size: width * 0.04,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                          ],
                        ),
                        SizedBox(height: width * 0.015), // add spacing instead of spaceEvenly
                        Text(
                          rentalVehicle[index]["name"],
                          style: TextStyle(
                            color: ColorConstant.thirdColor,
                            fontWeight: FontWeight.w700,
                            fontSize: width * 0.037,
                          ),
                        ),
                        SizedBox(height: width * 0.01),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: width * 0.045),
                            SizedBox(width: width*0.01,),
                            Text(
                              (rentalVehicle[index]["reviewStar"] as num).toDouble().toStringAsFixed(1),
                              style: TextStyle(
                                color: ColorConstant.thirdColor,
                                fontSize: width * 0.03,
                              ),
                            ),

                          ],
                        ),
                        SizedBox(height: width * 0.01),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Per Day", style: TextStyle(color: ColorConstant.color11.withOpacity(0.5), fontSize: width * 0.032)),
                                Text(rentalVehicle[index]["price"], style: TextStyle(color: ColorConstant.thirdColor, fontWeight: FontWeight.w700, fontSize: width * 0.032)),
                              ],
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CombinedCarDetailPage(
                                      vehicle: rentalVehicle[index],
                                      onFavoriteToggle: () {
                                        setState(() {
                                          rentalVehicle[index]["isFavorite"] = !rentalVehicle[index]["isFavorite"];
                                        });
                                      },
                                    ),
                                  ),
                                );
                              },

                              child: Container(
                                height: width * 0.07,
                                width: width * 0.15,
                                decoration: BoxDecoration(
                                  color: ColorConstant.color11.withOpacity(0.8),
                                  borderRadius: BorderRadius.all(Radius.circular(width * 0.02)),
                                ),
                                child: Center(
                                  child: Text("View", style: TextStyle(color: ColorConstant.bgColor, fontSize: width * 0.033, fontWeight: FontWeight.w700)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );

            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              top: width * 0.03,
              left: width * 0.03,
              right: width * 0.03,
              bottom: width * 0.01),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Favorite Cabs",
                style: TextStyle(
                    color: ColorConstant.color11,
                    fontWeight: FontWeight.w600,
                    fontSize: width * 0.044),
              ),
              GestureDetector(
                onTap: () {

                },
                child: Row(
                  children: [
                    Text(
                      "View all",
                      style: TextStyle(
                          color:
                          ColorConstant.thirdColor.withOpacity(0.4),
                          fontWeight: FontWeight.w500,
                          fontSize: width * 0.03),
                    ),
                    SizedBox(
                      width: width * 0.01,
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: width * 0.04,
                      color: ColorConstant.color11.withOpacity(0.7),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],)),
    );
  }
}
