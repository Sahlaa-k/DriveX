import 'package:drivex/core/constants/color_constant.dart';
import 'package:drivex/core/constants/localVariables.dart';
import 'package:drivex/feature/bottomNavigation/pages/DriverProfile.dart';
import 'package:drivex/feature/bottomNavigation/pages/RequestPage.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Map<String, dynamic>> drivers = [
    {
      'name': 'Ravi Kumar',
      'rating': 4.8,
      'location': '1.2 km',
      'bio': '5+ yrs experience, knows city well',
      'image': 'https://i.pravatar.cc/150?img=1',
    },
    {
      'name': 'Amit Verma',
      'rating': 4.6,
      'location': '2.5 km',
      'bio': 'Punctual & polite, 3+ yrs driving',
      'image': 'https://i.pravatar.cc/150?img=2',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              // height: width * .5,
              decoration: BoxDecoration(
                color: ColorConstant.primaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(width * .05),
                  bottomRight: Radius.circular(width * .05),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(width * .025),
                child: SafeArea(
                  child: Column(
                    children: [
                      // Container(
                      //   decoration: BoxDecoration(
                      //     border: Border.all()
                      //   ),
                      //   child: SizedBox(height: width * .05)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'DriveX',
                            style: GoogleFonts.inika(
                                color: Colors.white,
                                fontSize: width * .06,
                                fontWeight: FontWeight.w500),
                          ),
                          Container(
                            height: width * .1,
                            width: width * .1,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(width * .02),
                            ),
                            child:  Center(
                              child: Icon(
                                Icons.notifications,
                                color: Colors.black,
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: width * .15),
                      SizedBox(
                        height: height * .06,
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Search here...',
                            hintStyle: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w600,
                            ),
                            prefixIcon:  Icon(Icons.search),
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(width * .03),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(width * .03),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // SizedBox(height: 20),
            ListView.builder(
              itemCount: drivers.length,
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              // scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(
                      right: width * .025,
                      left: width * .025,
                      top: width * .025 / 4,
                      bottom: width * .025 / 4),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context, CupertinoPageRoute(builder: (context) => DriverProfilePage(driver: drivers[index]),));
                    },
                    child: Container(
                      // height: width * .3,
                      // width: 1,
                      // color: Colors.black45,
                    
                      decoration: BoxDecoration(
                          // border: Border.all(),
                          borderRadius:
                              BorderRadius.all(Radius.circular(width * .025)),
                          color: ColorConstant.primaryColor.withOpacity(.25)),
                      child: Padding(
                        padding: EdgeInsets.all(width * .02),
                        child: SizedBox(
                          child: Row(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                // mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: width * .07,
                                        backgroundImage: NetworkImage(
                                            drivers[index]['image'].toString()),
                                      ),
                                      SizedBox(
                                        width: width * .025,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(drivers[index]['name'].toString()),
                                          Text(
                                            drivers[index]['bio'].toString(),
                                            style:
                                                TextStyle(fontSize: width * .03),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                        height: width * .02,
                                      ),
                                  

                                  SizedBox(
                                    
                                    child: Row(
                                      // mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                                        
                                      children: [
                                        Container(
                                            height: width*.058,
                                            // width: width * .15,
                                            decoration: BoxDecoration(
                                                // border: Border.all(),
                                                borderRadius: BorderRadius.circular(
                                                    width * .015),
                                                color: Colors.white),
                                            child: Center(
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: width * .01,
                                                    right: width * .01),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons.star,
                                                        size: width*.04,
                                                        color: Colors.orange),
                                                    SizedBox(width: width*.01),
                                                    Text(drivers[index]['rating']
                                                        .toString(),style: TextStyle(fontSize: width*.03),)
                                                    // Text('${driver['rating']} ★')
                                                  ],
                                                ),
                                              ),
                                            )),
                                        SizedBox(
                                          width: width * .01,
                                        ),
                                        Container(
                                            height: width*.058,
                                            // width: width * .18,
                                            decoration: BoxDecoration(
                                                // border: Border.all(),
                                                borderRadius: BorderRadius.circular(
                                                    width * .015),
                                                color: Colors.white),
                                            child: Center(
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: width * .01,
                                                    right: width * .01),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons.location_on,
                                                        size: width*.04,
                                                        color: Colors.blueAccent),
                                                        SizedBox(width: width*.01),
                                                    Text(drivers[index]['location']
                                                        .toString(),style: TextStyle(fontSize: width*.03)),
                                                    // Text('${driver['rating']} ★')
                                                  ],
                                                ),
                                              ),
                                            )),
                                            SizedBox(
                                          width: width * .01,
                                        ),
                                        Container(
                                            height: width*.058,
                                            // width: width * .18,
                                            decoration: BoxDecoration(
                                                // border: Border.all(),
                                                borderRadius: BorderRadius.circular(
                                                    width * .015),
                                                color: Colors.white),
                                            child: Center(
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: width * .01,
                                                    right: width * .01),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons.circle_rounded,
                                                        size: width*.025,
                                                        color: Colors.green),
                                                        SizedBox(width: width*.01),
                                                    Text('Avaialable'
                                                        .toString(),style: TextStyle(fontSize: width*.03)),
                                                    // Text('${driver['rating']} ★')
                                                  ],
                                                ),
                                              ),
                                            )),
                                      ],
                                    ),
                                  )
                    
                                  //     ListView.builder(
                                  //   itemCount: 2,
                                  //   padding: EdgeInsets.zero,
                                  //   shrinkWrap: true,
                                  //   physics: NeverScrollableScrollPhysics(),
                                  //   scrollDirection: Axis.horizontal,
                                  //   itemBuilder: (context, index) {
                                  //   return Container(
                                  //     height: 20,
                                  //     width: 10,
                                  //     // color: Colors.black45,
                                  //     decoration: BoxDecoration(
                                  //       border: Border.all(),
                                  //       color: Colors.black26
                                  //     ),
                                  //     child: Text(" h"),
                    
                                  //   );
                                  //  },),
                    
                                  // SizedBox(
                                  //   height: 30,
                                  //   // width: width*1,
                                  //   child: ListView.builder(
                                  //     padding: EdgeInsets.all(0),
                                  //     scrollDirection: Axis.horizontal,
                                  //     physics: NeverScrollableScrollPhysics(),
                                  //     shrinkWrap: true,
                                  //     itemCount: drivers.length,
                                  //     itemBuilder: (context, index) {
                                  //       return Padding(
                                  //         padding:  EdgeInsets.all(width*.01),
                                  //         child: Container(
                                  //             height: 20,
                                  //             // width: 20,
                                  //             decoration: BoxDecoration(
                                  //                 border: Border.all(),
                                  //                 color: Colors.black26),
                                  //             child: Center(
                                  //               child: Padding(
                                  //                 padding: EdgeInsets.only(left: width*.01,right: width*.01),
                                  //                 child: Row(mainAxisSize: MainAxisSize.min,
                                  //                 mainAxisAlignment: MainAxisAlignment.center,
                                  //                 crossAxisAlignment: CrossAxisAlignment.center,
                                  //                   children: [
                                  //                     Icon(Icons.star,
                                  //                         size: 18, color: Colors.orange),
                                  //                     SizedBox(width: 4),
                                  //                     Text(drivers[index]['rating'].toString())
                                  //                     // Text('${driver['rating']} ★')
                                  //                   ],
                                  //                 ),
                                  //               ),
                                  //             )),
                                  //       );
                                  //     },
                                  //   ),

                                  // Container(
                                  //   height: 20,
                                  //   width: 20,
                                  //   color: Colors.black,
                                  // )
                                ],
                              ),
                              Icon(Icons.arrow_forward_ios_rounded,size: width*.045,color: Colors.white,)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),







            ...drivers.map((driver) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: CircleAvatar(
                      radius: 28,
                      backgroundImage: NetworkImage(driver['image']),
                    ),
                    title: Text(driver['name']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(driver['bio']),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.star,
                                size: 18, color: Colors.orange),
                            const SizedBox(width: 4),
                            Text('${driver['rating']} ★'),
                            const SizedBox(width: 10),
                            const Icon(Icons.location_on,
                                size: 16, color: Colors.blueAccent),
                            Text(driver['location']),
                          ],
                        ),
                      ],
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {
                        // Add your hire action here
                      },
                      child: const Text('Hire'),
                    ),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.push(context, CupertinoPageRoute(builder: (context) => Requestpage(),));
      },),
    );
  }
}
