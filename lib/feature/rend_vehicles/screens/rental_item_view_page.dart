import 'package:drivex/core/constants/localVariables.dart';
import 'package:drivex/feature/rend_vehicles/screens/confirm_rent.dart';
import 'package:flutter/material.dart';
import 'package:drivex/core/constants/color_constant.dart';

class CombinedCarDetailPage extends StatefulWidget {
  final Map<String, dynamic> vehicle;
  final VoidCallback onFavoriteToggle;

  const CombinedCarDetailPage({
    super.key,
    required this.vehicle,
    required this.onFavoriteToggle,
  });

  @override
  State<CombinedCarDetailPage> createState() => _CombinedCarDetailPageState();
}

class _CombinedCarDetailPageState extends State<CombinedCarDetailPage> {
  List<Map<String, dynamic>> infoList = [
    {
      "icon": Icons.event_seat,
      "text": "Total Capacity",
      "subtext": "6 Seater",
    },
    {
      "icon": Icons.ac_unit,
      "text": "Cooling Type",
      "subtext": "A/C",
    },
    {
      "icon": Icons.directions_car_filled_sharp,
      "text": "Car Type",
      "subtext": "Sedan",
    },
    {
      "icon": Icons.settings,
      "text": "Transmission",
      "subtext": "Automatic",
    },
    {
      "icon": Icons.local_gas_station,
      "text": "Fuel Type",
      "subtext": "Diesel",
    },
    {
      "icon": Icons.speed,
      "text": "Mileage",
      "subtext": "21 km/l",
    },
    {
      "icon": Icons.all_inclusive,
      "text": "Drive Type",
      "subtext": "AWD",
    },
    {
      "icon": Icons.emoji_transportation,
      "text": "Boot Space",
      "subtext": "510L",
    },
  ];

  bool isExpanded = false;
  int selectPriceIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Top Image
          Container(
            height: width * 1,
            width: width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(widget.vehicle["image"]),
                fit: BoxFit.cover,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: width * 0.04, vertical: width * 0.03),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: width * 0.045,
                          backgroundColor:
                              ColorConstant.thirdColor.withOpacity(0.4),
                          child: Center(
                            child: IconButton(
                              icon: Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                                size: width * 0.045,
                              ),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                        ),
                        const Spacer(),
                        CircleAvatar(
                          radius: width * 0.045,
                          backgroundColor:
                              ColorConstant.thirdColor.withOpacity(0.3),
                          child: IconButton(
                            icon: Icon(
                              widget.vehicle["isFavorite"]
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: widget.vehicle["isFavorite"]
                                  ? ColorConstant.bgColor
                                  : ColorConstant.bgColor,
                              size: width * 0.045,
                            ),
                            onPressed: () {
                              widget.onFavoriteToggle();
                              setState(() {});
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom Sheet
          DraggableScrollableSheet(
            initialChildSize: isExpanded ? 0.65 : 0.6,
            minChildSize: isExpanded ? 0.65 : 0.6,
            maxChildSize: isExpanded ? 0.65 : 0.6,
            expand: true,
            builder: (_, controller) {
              return Container(
                padding: EdgeInsets.all(width * 0.05),
                decoration: BoxDecoration(
                  color: ColorConstant.bgColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(width * 0.07),
                    topRight: Radius.circular(width * 0.07),
                  ),
                ),
                child: SingleChildScrollView(
                  controller: controller,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: width * 0.1,
                          height: width * 0.01,
                          margin: EdgeInsets.only(bottom: width * 0.04),
                          decoration: BoxDecoration(
                            color: ColorConstant.color11.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(width * 0.04),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            widget.vehicle["name"],
                            style: TextStyle(
                                fontSize: width * 0.05,
                                fontWeight: FontWeight.w700,
                                color: ColorConstant.thirdColor),
                          ),
                          SizedBox(
                            width: width * 0.01,
                          ),
                          const Spacer(),
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: width * 0.045,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "(${widget.vehicle["reviewStar"].toStringAsFixed(1)})",
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: ColorConstant.textColor3),
                          ),
                        ],
                      ),
                      Text(
                        "${widget.vehicle["year"]} model",
                        style: TextStyle(
                            fontSize: width * 0.035,
                            fontWeight: FontWeight.w600,
                            color: ColorConstant.textColor3),
                      ),
                      SizedBox(height: width * 0.02),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.vehicle["description"] ??
                                "The BMW M4 Series blends aggressive performance with luxurious styling, delivering a true driver’s car experience.",
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
                                color: Colors.blue,
                                fontSize: width * 0.035,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: width * 0.03),


                      Text("Features",
                          style: TextStyle(
                              color: ColorConstant.color11,
                              fontWeight: FontWeight.w600,
                              fontSize: width * 0.035)),
                      SizedBox(height: width * 0.03),
                      SizedBox(
                        height: width * 0.48,
                        width: width,
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: infoList.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            mainAxisSpacing: width * 0.025,
                            crossAxisSpacing: width * 0.025,
                            childAspectRatio: 1,
                          ),
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                color: ColorConstant.color11.withOpacity(0.1),
                                borderRadius:
                                    BorderRadius.circular(width * 0.02),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(width * 0.02),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(infoList[index]["icon"],
                                        size: width * 0.06),
                                    SizedBox(height: 6),
                                    Text(
                                      infoList[index]["text"],
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
                                      infoList[index]["subtext"],
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

                      // Price & Book Button
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Price",
                              style:
                                  TextStyle(color: ColorConstant.textColor2)),
                          SizedBox(height: width * 0.01),
                          SizedBox(
                            height: width * 0.14,
                            child: GridView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: 3,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: width * 0.03,
                                mainAxisSpacing: width * 0.03,
                                childAspectRatio: 2.4,
                              ),
                              itemBuilder: (context, index) {
                                List<Map<String, String>> prices = [
                                  {
                                    "type": "Daily",
                                    "price":
                                        "₹${double.parse(widget.vehicle["price"]).toStringAsFixed(0)}"
                                  },
                                  {
                                    "type": "Weekly",
                                    "price":
                                        "₹${(double.parse(widget.vehicle["price"]) * 7).toStringAsFixed(0)}"
                                  },
                                  {
                                    "type": "Monthly",
                                    "price":
                                        "₹${(double.parse(widget.vehicle["price"]) * 30).toStringAsFixed(0)}"
                                  },
                                ];

                                final isSelected = selectPriceIndex == index;

                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectPriceIndex = index;
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: ColorConstant.bgColor,
                                      borderRadius:
                                          BorderRadius.circular(width * 0.015),
                                      border: Border.all(
                                        color: ColorConstant.color11.withOpacity(
                                                0.8) // Highlighted border
                                           ,
                                        width: width * 0.004,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          prices[index]["type"]!,
                                          style: TextStyle(
                                            fontSize: width * 0.025,
                                            fontWeight: isSelected
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                            color: ColorConstant.color11
                                                    .withOpacity(0.8)

                                          ),
                                        ),
                                        SizedBox(height: 2),

                                        Text(
                                          prices[index]["price"]!,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: width * 0.03,
                                              color: ColorConstant.color11
                                                  .withOpacity(0.8)
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Container(height: width*0.12,
                            width: width,
                            decoration: BoxDecoration(
                              color: ColorConstant.bgColor,
                              borderRadius:
                              BorderRadius.circular(width * 0.015),
                              border: Border.all(
                                color: Colors.green// Highlighted border
                                    , // Normal border
                                width: width * 0.004,
                              ),
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.call_outlined,size: width*0.055,color: Colors.green,),
                                  Text(
                                   "Call Now",
                                    style: TextStyle(
                                      fontSize: width * 0.035,
                                      fontWeight:  FontWeight.bold
                                         ,
                                      color:  Colors.green
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
