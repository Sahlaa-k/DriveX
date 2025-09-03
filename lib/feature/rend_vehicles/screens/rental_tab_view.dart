import 'package:drivex/core/constants/color_constant.dart';
import 'package:drivex/core/constants/imageConstants.dart';
import 'package:drivex/core/constants/localVariables.dart';
import 'package:drivex/feature/rend_vehicles/screens/rental_item_view_page.dart';
import 'package:flutter/material.dart';

class RentalTabView extends StatefulWidget {
  final int selectedIndex;

  const RentalTabView({super.key, required this.selectedIndex});

  @override
  State<RentalTabView> createState() => _RentalTabViewState();
}

class _RentalTabViewState extends State<RentalTabView> {

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

Widget buildTabContent(int index) {
  switch (index) {
    case 0:
      return buildCarGrid("All");
    case 1:
      return buildCarGrid("BMW");
    case 2:
      return buildCarGrid("Thar");
    case 3:
      return buildCarGrid("Porsche");
    case 4:
      return buildCarGrid("MINI Cooper");
    default:
      return buildCarGrid("All");
  }
}


Widget buildCarGrid(String label) {
  // Filter rentalVehicle list based on selected tab
  List<Map<String, dynamic>> filteredList;

  if (label == "All") {
    filteredList = rentalVehicle;
  } else {
    filteredList = rentalVehicle
        .where((car) => car["name"].toString().toLowerCase().contains(label.toLowerCase()))
        .toList();
  }

  return filteredList.isEmpty
      ? SizedBox(
    height: width * 0.8,
    child: Center(
      child: Text(
        "No vehicles available",
        style: TextStyle(
          color: ColorConstant.thirdColor,
          fontSize: width * 0.04,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  )
      : Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: filteredList.length,
        padding: EdgeInsets.all(0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: width * 0.03,
          crossAxisSpacing: width * 0.03,
          childAspectRatio: 0.8,
        ),
        itemBuilder: (BuildContext context, int index) {
          return Container(
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
                            image: AssetImage(filteredList[index]["image"]),
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
                                       filteredList[index]["isFavorite"] =
                                       !filteredList[index]["isFavorite"];
                                     });
                                   },
                                   icon: Icon(
                                     filteredList[index]["isFavorite"] == true
                                         ? Icons.favorite
                                         : Icons.favorite_border,
                                     color: filteredList[index]["isFavorite"] == true
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
                    filteredList[index]["name"],
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
                        (filteredList[index]["reviewStar"] as num).toDouble().toStringAsFixed(1),
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
                          Text(filteredList[index]["price"], style: TextStyle(color: ColorConstant.thirdColor, fontWeight: FontWeight.w700, fontSize: width * 0.032)),
                        ],
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CombinedCarDetailPage(
                                vehicle: filteredList[index],
                                onFavoriteToggle: () {
                                  setState(() {
                                    filteredList[index]["isFavorite"] = !filteredList[index]["isFavorite"];
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
          );

        },
      ),
    ],
  );

}


@override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(width * 0.02),
      child: buildTabContent(widget.selectedIndex),
    );
  }
}
