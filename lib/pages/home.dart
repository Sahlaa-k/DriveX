import 'package:drivex/core/constants/color_constant.dart';
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
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: height * .25,
              decoration: BoxDecoration(
                color: ColorConstant.primaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(width * .06),
                  bottomRight: Radius.circular(width * .06),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(width * .025),
                child: Column(
                  children: [
                    SizedBox(height: height * .05),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'DriveX',
                          style: GoogleFonts.inika(color: Colors.white,fontSize: width*.06,
                          fontWeight: FontWeight.w500
                          ),
                        ),
                        Container(
                          height: width * .1,
                          width: width * .1,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(width * .02),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.notifications,
                              color: Colors.black,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: height * .065),
                    SizedBox(
                      height: height*.06,
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Search here...',
                          hintStyle: const TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w600,
                          ),
                          prefixIcon: const Icon(Icons.search),
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
            const SizedBox(height: 20),
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
    );
  }
}
