// import 'package:drivex/core/constants/color_constant.dart';
// import 'package:drivex/core/constants/localVariables.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// class Testingpage extends StatefulWidget {
//   const Testingpage({super.key});
//   @override
//   State<Testingpage> createState() => _TestingpageState();
// }
// class _TestingpageState extends State<Testingpage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               child: SizedBox(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         Container(
//                           width: width * .25,
//                           height: width * .15,
//                           decoration: BoxDecoration(
//                               color: Colors.black,
//                               borderRadius: BorderRadius.only(
//                                   topLeft: Radius.circular(width * .05),
//                                   topRight: Radius.circular(width * .05))),
//                         ),
//                         Container(
//                           width: width * .15,
//                           height: width * .15,
//                           decoration: BoxDecoration(
//                               color: Colors.black,
//                               borderRadius: BorderRadius.only(
//                                   topLeft: Radius.circular(width * .5),
//                                   topRight: Radius.circular(width * .5),
//                                   bottomRight: Radius.circular(width * .5))),
//                           child: CircleAvatar(
//                             backgroundColor: ColorConstant.backgroundColor,
//                             child: Align(
//                               alignment: Alignment.topRight,
//                               child: CircleAvatar(
//                                 radius: width * .06,
//                                 backgroundColor: Colors.amber,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     Container(
//                       width: width * .4,
//                       height: width * .2,
//                       decoration: BoxDecoration(
//                           color: Colors.black,
//                           borderRadius: BorderRadius.only(
//                               bottomLeft: Radius.circular(width * .05),
//                               bottomRight: Radius.circular(width * .05),
//                               topRight: Radius.circular(width * .05))),
//                     )
//                   ],
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
