// import 'package:flutter/material.dart';
// import 'package:drivex/core/constants/color_constant.dart';
//
// class DriverProfilePage extends StatelessWidget {
//   final Map<String, dynamic> driver;
//   const DriverProfilePage({super.key, required this.driver});
//
//   @override
//   Widget build(BuildContext context) {
//     final List<String> languages = [
//       'English',
//       'Hindi',
//       'Spanish',
//       'French',
//       'Arabic',
//       'Mandarin',
//       'Russian',
//       'Tamil',
//       'German',
//       'Japanese',
//       'Korean',
//       'Malayalam',
//     ];
//
//     final List<Map<String, String>> data = [
//       {
//         'Name': 'Rating',
//         'Age': '25',
//       },
//       {
//         'Name': 'Asha',
//         'Age': '30',
//       },
//       {
//         'Name': 'Carlos',
//         'Age': '28',
//       },
//       {
//         'Name': 'Mina',
//         'Age': '22',
//       },
//     ];
//     final List<String> columns = [
//       'Name',
//       'Age',
//     ];
//
//     double width = MediaQuery.of(context).size.width;
//     double height = MediaQuery.of(context).size.height;
//
//     return Scaffold(
//       // backgroundColor: const Color(0xFFF3F7FA),
//       body: Container(
//         height: height * 1,
//         width: width * 1,
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               // ColorConstant.secondaryColor,
//               ColorConstant.primaryColor,
//               ColorConstant.secondaryColor,
//               // Colors.blue.shade100,
//               Colors.white,
//               Colors.white,
//             ],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             // stops: [0.4, 0.8],
//           ),
//         ),
//         child: SingleChildScrollView(
//           child: SafeArea(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 // SizedBox(height: 100,),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     GestureDetector(
//                         onTap: () {
//                           // Navigator.pop(context);
//                           print(driver);
//                         },
//                         child: SizedBox(
//                             height: width * .15,
//                             width: width * .15,
//                             child: Icon(
//                               Icons.arrow_back_ios_rounded,
//                               size: width * .08,
//                               color: Colors.white,
//                             ))),
//                     SizedBox(
//                         height: width * .15,
//                         width: width * .15,
//                         child: Icon(
//                           Icons.favorite_border_rounded,
//                           size: width * .08,
//                           color: Colors.white,
//                         )),
//                   ],
//                 ),
//                 SizedBox(
//                   height: width * .1,
//                 ),
//                 CircleAvatar(
//                     radius: width * .15,
//                     backgroundImage: NetworkImage(driver['image'])),
//                 SizedBox(
//                   height: width * .05,
//                 ),
//                 Container(
//                   width: width * .9,
//                   // height: width*1.9,
//                   decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius:
//                           BorderRadius.all(Radius.circular(width * .05))),
//                   child: Column(
//                     children: [
//                       SizedBox(
//                         height: width * .05,
//                       ),
//                       Text(driver['name'],
//                           style: TextStyle(
//                               fontSize: width * .045,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.black.withOpacity(.75))),
//                       Text(
//                         '#Driver Code',
//                         style: TextStyle(
//                             fontSize: width * .035,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black.withOpacity(.5)),
//                       ),
//                       Container(
//                           height: width * .058,
//                           width: width * .3,
//                           decoration: BoxDecoration(
//                               // border: Border.all(),
//                               borderRadius: BorderRadius.circular(width * .015),
//                               color: Colors.black.withOpacity(.2)),
//                           child: Center(
//                             child: Padding(
//                               padding: EdgeInsets.only(
//                                   left: width * .01, right: width * .01),
//                               child: Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//                                   Icon(Icons.circle_rounded,
//                                       size: width * .025,
//                                       color: Colors.redAccent),
//                                   SizedBox(width: width * .01),
//                                   Text('Not Available'.toString(),
//                                       style: TextStyle(fontSize: width * .03)),
//                                   // Text('${driver['rating']} ★')
//                                 ],
//                               ),
//                             ),
//                           )),
//                       SizedBox(
//                         height: width * .025,
//                       ),
//                       Container(
//                           height: width * .058,
//                           width: width * .3,
//                           decoration: BoxDecoration(
//                               border: Border.all(),
//                               borderRadius: BorderRadius.circular(width * .015),
//                               color: Colors.white),
//                           child: Center(
//                             child: Padding(
//                               padding: EdgeInsets.only(
//                                   left: width * .01, right: width * .01),
//                               child: Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//                                   Icon(Icons.circle_rounded,
//                                       size: width * .025,
//                                       color: Colors.redAccent),
//                                   SizedBox(width: width * .01),
//                                   Text('rating details'.toString(),
//                                       style: TextStyle(fontSize: width * .03)),
//                                   // Text('${driver['rating']} ★')
//                                 ],
//                               ),
//                             ),
//                           )),
//                       SizedBox(
//                         height: width * .025,
//                       ),
//                       Container(
//                           // height: width * .058,
//                           width: width * .8,
//                           decoration: BoxDecoration(
//                               border: Border.all(
//                                 color:
//                                     ColorConstant.primaryColor.withOpacity(.5),
//                                 width: width * .004,
//                               ),
//                               borderRadius: BorderRadius.circular(width * .015),
//                               color: Colors.white),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Padding(
//                                 padding: EdgeInsets.all(width * .015),
//                                 child: Container(
//                                     height: width * .058,
//                                     width: width * .2,
//                                     decoration: BoxDecoration(
//                                         // border: Border.all(),
//                                         borderRadius:
//                                             BorderRadius.circular(width * .015),
//                                         color: Colors.black.withOpacity(.2)),
//                                     child: Center(
//                                       child: Padding(
//                                         padding: EdgeInsets.only(
//                                             left: width * .01,
//                                             right: width * .01),
//                                         child: Text(
//                                           "Bio",
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.w600,
//                                               color: Colors.black
//                                                   .withOpacity(.75)),
//                                         ),
//                                       ),
//                                     )),
//                               ),
//                               Padding(
//                                 padding: EdgeInsets.all(width * .015),
//                                 child: Column(
//                                   children: [
//                                     Text(driver['bio']),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           )),
//                       SizedBox(
//                         height: width * .025,
//                       ),
//                       Container(
//                           // height: width * .058,
//                           width: width * .8,
//                           decoration: BoxDecoration(
//                               border: Border.all(
//                                 color:
//                                     ColorConstant.primaryColor.withOpacity(.5),
//                                 width: width * .004,
//                               ),
//                               borderRadius: BorderRadius.circular(width * .015),
//                               color: Colors.white),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               SizedBox(
//                                 // width: width * 0.8,
//                                 // height: width*.56,
//                                 child: GridView.builder(
//                                   shrinkWrap: true,
//                                   physics: NeverScrollableScrollPhysics(),
//                                   padding: EdgeInsets.only(
//                                       top: width * .02,
//                                       right: width * .02,
//                                       left: width * .02,
//                                       bottom: width * .02),
//                                   gridDelegate:
//                                       SliverGridDelegateWithFixedCrossAxisCount(
//                                     crossAxisCount: 1, // 2 items per row
//                                     crossAxisSpacing:
//                                         10, // space between columns
//                                     mainAxisSpacing: 10, // space between rows
//                                     childAspectRatio:
//                                         width * .025, // width/height ratio
//                                   ),
//                                   itemCount: driver.length,
//                                   itemBuilder: (context, index) {
//                                     return Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Container(
//                                           width: width * .37,
//                                           decoration: BoxDecoration(
//                                             color: Colors.blue.shade100,
//                                             borderRadius: BorderRadius.circular(
//                                                 width * .015),
//                                           ),
//                                           alignment: Alignment.center,
//                                           child: Text(
//                                             driver.keys
//                                                 .toList()[index]
//                                                 .toString(),
//                                             style: TextStyle(
//                                                 fontSize: width * .0325),
//                                           ),
//                                         ),
//                                         Container(
//                                           width: width * .37,
//                                           decoration: BoxDecoration(
//                                             color: Colors.blue.shade100,
//                                             borderRadius: BorderRadius.circular(
//                                                 width * .015),
//                                           ),
//                                           alignment: Alignment.center,
//                                           child: Text(
//                                             driver.values
//                                                 .toList()[index]
//                                                 .toString(),
//                                             style: TextStyle(
//                                                 fontSize: width * .0325),
//                                           ),
//                                         )
//                                       ],
//                                     );
//                                   },
//                                 ),
//                               ),
//                             ],
//                           )),
//                       SizedBox(
//                         height: width * .025,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           Container(
//                               height: width * .2,
//                               width: width * .2,
//                               decoration: BoxDecoration(
//                                   border: Border.all(
//                                     color: ColorConstant.primaryColor
//                                         .withOpacity(.5),
//                                     width: width * .004,
//                                   ),
//                                   borderRadius:
//                                       BorderRadius.circular(width * .015),
//                                   color: Colors.white),
//                               child: Padding(
//                                 padding: EdgeInsets.only(
//                                     left: width * .01, right: width * .01),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                                   children: [
//                                     SizedBox(
//                                       height: width * .01,
//                                     ),
//                                     Text('Rating',
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.w600,
//                                             color:
//                                                 Colors.black.withOpacity(.75))),
//                                     SizedBox(
//                                       height: width * .01,
//                                     ),
//                                     Text('${driver['rating']}★'),
//                                   ],
//                                 ),
//                               )),
//                           Container(
//                               height: width * .2,
//                               width: width * .2,
//                               decoration: BoxDecoration(
//                                   border: Border.all(
//                                     color: ColorConstant.primaryColor
//                                         .withOpacity(.5),
//                                     width: width * .004,
//                                   ),
//                                   borderRadius:
//                                       BorderRadius.circular(width * .015),
//                                   color: Colors.white),
//                               child: Padding(
//                                 padding: EdgeInsets.only(
//                                     left: width * .01, right: width * .01),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                                   children: [
//                                     SizedBox(
//                                       height: width * .01,
//                                     ),
//                                     Text('Likes',
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.w600,
//                                             color:
//                                                 Colors.black.withOpacity(.75))),
//                                     SizedBox(
//                                       height: width * .01,
//                                     ),
//                                     Text('1.4 k'),
//                                   ],
//                                 ),
//                               )),
//                           Container(
//                               height: width * .2,
//                               width: width * .2,
//                               decoration: BoxDecoration(
//                                   border: Border.all(
//                                     color: ColorConstant.primaryColor
//                                         .withOpacity(.5),
//                                     width: width * .004,
//                                   ),
//                                   borderRadius:
//                                       BorderRadius.circular(width * .015),
//                                   color: Colors.white),
//                               child: Padding(
//                                 padding: EdgeInsets.only(
//                                     left: width * .01, right: width * .01),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                                   children: [
//                                     SizedBox(
//                                       height: width * .01,
//                                     ),
//                                     Text('Dislikes',
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.w600,
//                                             color:
//                                                 Colors.black.withOpacity(.75))),
//                                     SizedBox(
//                                       height: width * .01,
//                                     ),
//                                     Text('6'),
//                                   ],
//                                 ),
//                               ))
//                         ],
//                       ),
//                       SizedBox(
//                         height: width * .025,
//                       ),
//                       Container(
//                           // height: width * .058,
//                           width: width * .8,
//                           decoration: BoxDecoration(
//                               border: Border.all(
//                                 color:
//                                     ColorConstant.primaryColor.withOpacity(.5),
//                                 width: width * .004,
//                               ),
//                               borderRadius: BorderRadius.circular(width * .015),
//                               color: Colors.white),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Padding(
//                                 padding: EdgeInsets.all(width * .015),
//                                 child: Container(
//                                     height: width * .058,
//                                     width: width * .25,
//                                     decoration: BoxDecoration(
//                                         // border: Border.all(),
//                                         borderRadius:
//                                             BorderRadius.circular(width * .015),
//                                         color: Colors.black.withOpacity(.2)),
//                                     child: Center(
//                                       child: Padding(
//                                         padding: EdgeInsets.only(
//                                             left: width * .01,
//                                             right: width * .01),
//                                         child: Text(
//                                           "Language",
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.w600,
//                                               color: Colors.black
//                                                   .withOpacity(.75)),
//                                         ),
//                                       ),
//                                     )),
//                               ),
//                               SizedBox(
//                                 // width: width * 0.8,
//                                 // height: width*.56,
//                                 child: GridView.builder(
//                                   shrinkWrap: true,
//                                   physics: NeverScrollableScrollPhysics(),
//                                   padding: EdgeInsets.only(
//                                       right: width * .02,
//                                       left: width * .02,
//                                       bottom: width * .02),
//                                   gridDelegate:
//                                       SliverGridDelegateWithFixedCrossAxisCount(
//                                     crossAxisCount: 2, // 2 items per row
//                                     crossAxisSpacing:
//                                         10, // space between columns
//                                     mainAxisSpacing: 10, // space between rows
//                                     childAspectRatio:
//                                         width * .0125, // width/height ratio
//                                   ),
//                                   itemCount: languages.length,
//                                   itemBuilder: (context, index) {
//                                     return Container(
//                                       decoration: BoxDecoration(
//                                         color: Colors.blue.shade100,
//                                         borderRadius:
//                                             BorderRadius.circular(width * .015),
//                                       ),
//                                       alignment: Alignment.center,
//                                       child: Text(
//                                         languages[index],
//                                         style:
//                                             TextStyle(fontSize: width * .0325),
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               ),
//                             ],
//                           )),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
