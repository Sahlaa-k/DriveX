import 'package:drivex/core/constants/color_constant.dart';
import 'package:drivex/core/constants/localVariables.dart';
import 'package:drivex/main.dart';
import 'package:flutter/material.dart';

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
      'image': 'https://i.pr avatar.cc/150?img=2',
    },
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: 
        Expanded(child: Center(
          child: Column(
            children: [
              Container(
                height: height*.25,
                // width: width*.5,
                decoration: BoxDecoration(
                  color: ColorConstant.primaryColor,
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(width*.06),
                  bottomRight: Radius.circular(width*.06))
                ),
                child: Padding(
                  padding: EdgeInsets.all(width*.025),
                  child: Column(
                    children: [
                      SizedBox(height: height*.05,),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('DriveX',style: TextStyle(color: Colors.white,fontSize: height*.03),),
                          Container(
                            height: width*.1,
                            width: width*.1,
                            decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(width*.02)
                  ),
                            child: Center(
                              child: Icon(Icons.notifications,color: Colors.black,),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: height*.05,),

                      TextFormField(
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                // labelText: 'Enter your text',
                                hintText: 'Search here...',
                                hintStyle: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w600),
                                prefixIcon: Icon(Icons.search),
                                // suffixIcon: Icon(Icons.check_circle, color: Colors.green),
                                filled: true,
                                fillColor: Colors.white,
                                enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(width * .03),
                                    borderSide: BorderSide.none
                                    // BorderSide(color: ColorConstant.primaryColor, width: width * .006),
                                    ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(width * .03),
                                  borderSide: BorderSide.none,
                                  // BorderSide(color: ColorConstant.primaryColor, width: width * .006),
                                ),
                              ),
                            ),
                      
                //       ListTile(
                //   contentPadding: const EdgeInsets.all(12),
                //   leading: CircleAvatar(
                //     radius: 28,
                //     backgroundImage: NetworkImage(drivers['image']),
                //   ),
                //   title: Text(driver['name']),
                //   subtitle: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Text(driver['bio']),
                //       const SizedBox(height: 4),
                //       Row(
                //         children: [
                //           Icon(Icons.star, size: 18, color: Colors.orange),
                //           const SizedBox(width: 4),
                //           Text('${driver['rating']} ★'),
                //           const SizedBox(width: 10),
                //           Icon(Icons.location_on,
                //               size: 16, color: Colors.blueAccent),
                //           Text(driver['location']),
                //         ],
                //       )
                //     ],
                //   ),
                //   trailing: ElevatedButton(
                //     onPressed: () {},
                //     child: const Text('Hire'),
                //   ),
                // )
                    ],
                  ),
                ),
              ),

              
          
            ],
          ),
        )),
      )
    );
  }
}