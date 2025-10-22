import 'package:drivex/core/constants/color_constant.dart';
import 'package:drivex/core/constants/imageConstants.dart';
import 'package:drivex/core/constants/localVariables.dart';
import 'package:drivex/core/widgets/BackGroundTopGradient.dart';
import 'package:drivex/feature/bookings/screens/cancel_page.dart';
import 'package:drivex/feature/bookings/screens/canceldpage.dart';
import 'package:drivex/feature/bookings/screens/reschedule.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Historybookingpage extends StatefulWidget {
  const Historybookingpage({super.key});

  @override
  State<Historybookingpage> createState() => _UpcomingBookingPageState();
}
//https://in.pinterest.com/pin/454582156165299971/
class _UpcomingBookingPageState extends State<Historybookingpage> {
  final List<Map<String, dynamic>> completed = [
    {
      "type": "Driver",
      "from": "190 Blacker Ctr.beach",
      "to": "402 Banglour road",
      "dateTime": "16 Jul 2026 - 3:45 PM",
      "driver": "Budi Susanto",
      "payment": "Cash",
      "image": "assets/images/profile_pic.jpg",
    },
    {
      "type": "D2D",
      "from": "Warehouse 12A",
      "to": "Shopping District",
      "dateTime": "18 Jul 2026, 9:00 AM",
      "parcel": "Grocery",
      "image": "assets/images/pexels-israr-ahmrd-152664845-10568559.jpg",
      "payment": "UPI",
      "price": "₹149",
    },
    {
      "type": "Cab",
      "from": "Airport T2",
      "to": "City Center Mall",
      "dateTime": "21 Jul 2026, 5:30 PM",
      "driver": "Rahul Dev",
      "car": "Toyota Etios",
      "plate": "KL 15 AB 4321",
      "seats": "4 seats",
      "payment": "Card",
      "fare": "₹820",
      "image": "assets/images/rentalcar2.jpg",
    },
    {
      "type": "Driver",
      "from": "190 Blacker Ctr.beach",
      "to": "402 Banglour road",
      "dateTime": "16 Jul 2026 - 3:45 PM",
      "driver": "Budi Susanto",
      "payment": "Cash",
      "image": "assets/images/profile_pic.jpg",
    },
    {
      "type": "D2D",
      "from": "Warehouse 12A",
      "to": "Shopping District",
      "dateTime": "18 Jul 2026, 9:00 AM",
      "parcel": "Grocery",
      "image": "assets/images/pexels-israr-ahmrd-152664845-10568559.jpg",
      "payment": "UPI",
      "price": "₹149",
    },
    {
      "type": "Cab",
      "from": "Airport T2",
      "to": "City Center Mall",
      "dateTime": "21 Jul 2026, 5:30 PM",
      "driver": "Rahul Dev",
      "car": "Toyota Etios",
      "plate": "KL 15 AB 4321",
      "seats": "4 seats",
      "payment": "Card",
      "fare": "₹820",
      "image": "assets/images/rentalcar2.jpg",
    },
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.bgColor,
      body:       ListView.builder(
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: completed.length,

        itemBuilder: (context, index) {
          final item = completed[index];
          final String type = (item["type"] ?? "Driver") as String;

          return Container(
            margin: EdgeInsets.only(
                right: width * 0.03,
                left: width*0.03,

                bottom: width * 0.03),
            height: width * 0.45,
            width: width *1,
            decoration: BoxDecoration(
              color: ColorConstant.bgColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
              borderRadius:
              BorderRadius.all(Radius.circular(width * 0.03)),
            ),
            child: Padding(
              padding: EdgeInsets.all(width * 0.02),
              // ===================== INLINE SWITCH =====================
              child: (type == "D2D")
              // -------- D2D CONTAINER (parcel) --------
                  ? Column(
                children: [

                  Row(
                    children: [
                      Text(
                        "16 Jul 2026 - 3:45 PM",
                        style: TextStyle(
                            color: ColorConstant.thirdColor,
                            fontSize: width * 0.03),
                      ),
                      Spacer(),
                      Container(
                        height: width * 0.06,
                        width: width * 0.2,
                        decoration: BoxDecoration(
                            color: Colors.yellow
                                .withOpacity(0.4),
                            borderRadius:
                            BorderRadius.all(
                                Radius.circular(
                                    width * 0.03))),
                        child: Center(
                          child: Text(
                            item["type"],
                            style: TextStyle(
                                color: ColorConstant
                                    .thirdColor,
                                fontSize: width * 0.03,
                                fontWeight:
                                FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(width: width*0.02,),
                      Icon(Icons.arrow_forward_ios,color: ColorConstant.thirdColor.withOpacity(0.5,),size: width*0.035,)

                    ],
                  ),
                  SizedBox(height: width * 0.03),
                  Row(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      // LEFT: avatar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(
                            width * 0.03),
                        child: Image.asset(
                          item["image"] ?? "",
                          width: width * 0.20,
                          height: width * 0.20,
                          fit: BoxFit.cover,
                        ),
                      ),

                      SizedBox(width: width * 0.02),

                      // RIGHT: name + from/to
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            // name (standalone)
                            Text(
                              item["parcel"] ?? "-",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color:
                                ColorConstant.thirdColor,
                                fontSize: width * 0.038,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            SizedBox(height: width * 0.016),

                            // from/to row: connector + addresses
                            Row(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                // connector column
                                SizedBox(
                                  height: width *
                                      0.11, // shorter than avatar so name fits above
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      Icon(
                                          Icons
                                              .my_location_outlined,
                                          size: width * 0.038,
                                          color: Colors.red),
                                      Container(
                                        width: width * 0.003,
                                        height: width * 0.025,
                                        color: ColorConstant
                                            .thirdColor
                                            .withOpacity(0.2),
                                      ),
                                      Icon(
                                          CupertinoIcons
                                              .location_north_line,
                                          size: width * 0.045,
                                          color:
                                          Colors.green),
                                    ],
                                  ),
                                ),

                                SizedBox(width: width * 0.02),

                                // from/to column (no name here)
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                    children: [
                                      Text(
                                        item["from"] ?? "-",
                                        maxLines: 1,
                                        overflow: TextOverflow
                                            .ellipsis,
                                        style: TextStyle(
                                          color: ColorConstant
                                              .thirdColor,
                                          fontSize:
                                          width * 0.03,
                                        ),
                                      ),
                                      SizedBox(
                                        height: width * 0.03,
                                      ),
                                      Text(
                                        item["to"] ?? "-",
                                        maxLines: 1,
                                        overflow: TextOverflow
                                            .ellipsis,
                                        style: TextStyle(
                                          color: ColorConstant
                                              .thirdColor,
                                          fontSize:
                                          width * 0.03,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: width * 0.03),
                  Row(
                    children: [

                      Container(
                        height: width * 0.085,
                        width: width *0.9,
                        decoration: BoxDecoration(
                          color: ColorConstant.color11
                              .withOpacity(0.9),
                          borderRadius: BorderRadius.all(
                              Radius.circular(width * 0.03)),
                        ),
                        alignment: Alignment.center,
                        child: Text("Book Again",
                            style: TextStyle(
                                color: ColorConstant.bgColor,
                                fontSize: width * 0.033,
                                fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                ],
              )
              // -------- CAB CONTAINER --------item["image"] ??
              //                                                     "assets/images/profile_pic.jpg"
                  : (type == "Cab")
                  ? Column(
                children: [

                  Row(
                    children: [
                      Text(
                        "16 Jul 2026 - 3:45 PM",
                        style: TextStyle(
                            color: ColorConstant.thirdColor,
                            fontSize: width * 0.03),
                      ),
                      Spacer(),
                      Container(
                        height: width * 0.06,
                        width: width * 0.2,
                        decoration: BoxDecoration(
                            color: Colors.yellow
                                .withOpacity(0.4),
                            borderRadius:
                            BorderRadius.all(
                                Radius.circular(
                                    width * 0.03))),
                        child: Center(
                          child: Text(
                            item["type"],
                            style: TextStyle(
                                color: ColorConstant
                                    .thirdColor,
                                fontSize: width * 0.03,
                                fontWeight:
                                FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(width: width*0.02,),
                      Icon(Icons.arrow_forward_ios,color: ColorConstant.thirdColor.withOpacity(0.5,),size: width*0.035,)

                    ],
                  ),
                  SizedBox(height: width * 0.03),
                  Row(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      // LEFT: avatar
                      ClipRRect(
                        borderRadius:
                        BorderRadius.circular(
                            width * 0.03),
                        child: Image.asset(
                          item["image"] ??
                              "assets/images/rentalcar2.jpg",
                          width: width * 0.20,
                          height: width * 0.20,
                          fit: BoxFit.cover,
                        ),
                      ),

                      SizedBox(width: width * 0.02),

                      // RIGHT: name + from/to
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            // name (standalone)
                            Text(
                              item["car"] ?? "-",
                              maxLines: 1,
                              overflow:
                              TextOverflow.ellipsis,
                              style: TextStyle(
                                color: ColorConstant
                                    .thirdColor,
                                fontSize: width * 0.038,
                                fontWeight:
                                FontWeight.w600,
                              ),
                            ),

                            SizedBox(
                                height: width * 0.016),

                            // from/to row: connector + addresses
                            Row(
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                              children: [
                                // connector column
                                SizedBox(
                                  height: width *
                                      0.11, // shorter than avatar so name fits above
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      Icon(
                                          Icons
                                              .my_location_outlined,
                                          size: width *
                                              0.038,
                                          color:
                                          Colors.red),
                                      Container(
                                        width:
                                        width * 0.003,
                                        height:
                                        width * 0.025,
                                        color: ColorConstant
                                            .thirdColor
                                            .withOpacity(
                                            0.2),
                                      ),
                                      Icon(
                                          CupertinoIcons
                                              .location_north_line,
                                          size: width *
                                              0.045,
                                          color: Colors
                                              .green),
                                    ],
                                  ),
                                ),

                                SizedBox(
                                    width: width * 0.02),

                                // from/to column (no name here)
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                    children: [
                                      Text(
                                        item["from"] ??
                                            "-",
                                        maxLines: 1,
                                        overflow:
                                        TextOverflow
                                            .ellipsis,
                                        style: TextStyle(
                                          color: ColorConstant
                                              .thirdColor,
                                          fontSize:
                                          width *
                                              0.03,
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                        width * 0.03,
                                      ),
                                      Text(
                                        item["to"] ?? "-",
                                        maxLines: 1,
                                        overflow:
                                        TextOverflow
                                            .ellipsis,
                                        style: TextStyle(
                                          color: ColorConstant
                                              .thirdColor,
                                          fontSize:
                                          width *
                                              0.03,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: width * 0.03),
                  Row(
                    children: [

                      Container(
                        height: width * 0.085,
                        width: width *0.9,
                        decoration: BoxDecoration(
                          color: ColorConstant.color11
                              .withOpacity(0.9),
                          borderRadius: BorderRadius.all(
                              Radius.circular(width * 0.03)),
                        ),
                        alignment: Alignment.center,
                        child: Text("Book Again",
                            style: TextStyle(
                                color: ColorConstant.bgColor,
                                fontSize: width * 0.033,
                                fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                ],
              )
              // -------- DRIVER CONTAINER (default) --------
                  : Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "16 Jul 2026 - 3:45 PM",
                        style: TextStyle(
                            color: ColorConstant.thirdColor,
                            fontSize: width * 0.03),
                      ),
                      Spacer(),
                      Container(
                        height: width * 0.06,
                        width: width * 0.2,
                        decoration: BoxDecoration(
                            color: Colors.yellow
                                .withOpacity(0.4),
                            borderRadius:
                            BorderRadius.all(
                                Radius.circular(
                                    width * 0.03))),
                        child: Center(
                          child: Text(
                            item["type"],
                            style: TextStyle(
                                color: ColorConstant
                                    .thirdColor,
                                fontSize: width * 0.03,
                                fontWeight:
                                FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(width: width*0.02,),
                      Icon(Icons.arrow_forward_ios,color: ColorConstant.thirdColor.withOpacity(0.5,),size: width*0.035,)

                    ],
                  ),
                  SizedBox(height: width * 0.03),
                  Row(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      // LEFT: avatar
                      ClipRRect(
                        borderRadius:
                        BorderRadius.circular(
                            width * 0.03),
                        child: Image.asset(
                          item["image"] ??
                              "assets/images/profile_pic.jpg",
                          width: width * 0.20,
                          height: width * 0.20,
                          fit: BoxFit.cover,
                        ),
                      ),

                      SizedBox(width: width * 0.02),

                      // RIGHT: name + from/to
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            // name (standalone)
                            Text(
                              item["driver"] ?? "-",
                              maxLines: 1,
                              overflow:
                              TextOverflow.ellipsis,
                              style: TextStyle(
                                color: ColorConstant
                                    .thirdColor,
                                fontSize: width * 0.038,
                                fontWeight:
                                FontWeight.w600,
                              ),
                            ),

                            SizedBox(
                                height: width * 0.016),

                            // from/to row: connector + addresses
                            Row(
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                              children: [
                                // connector column
                                SizedBox(
                                  height: width *
                                      0.11, // shorter than avatar so name fits above
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      Icon(
                                          Icons
                                              .my_location_outlined,
                                          size: width *
                                              0.038,
                                          color:
                                          Colors.red),
                                      Container(
                                        width:
                                        width * 0.003,
                                        height:
                                        width * 0.025,
                                        color: ColorConstant
                                            .thirdColor
                                            .withOpacity(
                                            0.2),
                                      ),
                                      Icon(
                                          CupertinoIcons
                                              .location_north_line,
                                          size: width *
                                              0.045,
                                          color: Colors
                                              .green),
                                    ],
                                  ),
                                ),

                                SizedBox(
                                    width: width * 0.02),

                                // from/to column (no name here)
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                    children: [
                                      Text(
                                        item["from"] ??
                                            "-",
                                        maxLines: 1,
                                        overflow:
                                        TextOverflow
                                            .ellipsis,
                                        style: TextStyle(
                                          color: ColorConstant
                                              .thirdColor,
                                          fontSize:
                                          width *
                                              0.03,
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                        width * 0.03,
                                      ),
                                      Text(
                                        item["to"] ?? "-",
                                        maxLines: 1,
                                        overflow:
                                        TextOverflow
                                            .ellipsis,
                                        style: TextStyle(
                                          color: ColorConstant
                                              .thirdColor,
                                          fontSize:
                                          width *
                                              0.03,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: width * 0.03),


                      Container(
                        height: width * 0.085,
                        width: width *0.9,
                        decoration: BoxDecoration(
                          color: ColorConstant.color11
                              .withOpacity(0.9),
                          borderRadius: BorderRadius.all(
                              Radius.circular(width * 0.03)),
                        ),
                        alignment: Alignment.center,
                        child: Text("Book Again",
                            style: TextStyle(
                                color: ColorConstant.bgColor,
                                fontSize: width * 0.033,
                                fontWeight: FontWeight.w700)),
                      ),

                ],
              ),
              // =================== END INLINE SWITCH ===================
            ),
          );
        },
      ),
    );
  }



}

