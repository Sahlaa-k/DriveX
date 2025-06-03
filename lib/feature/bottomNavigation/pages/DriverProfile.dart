import 'package:flutter/material.dart';
import 'package:drivex/core/constants/color_constant.dart';

class DriverProfilePage extends StatelessWidget {
  const DriverProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F7FA),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: height * 0.4,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.lightBlueAccent, Colors.blue],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(30)),
                  ),
                ),
                Positioned(
                  top: height * 0.08,
                  left: 20,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  ),
                ),
                Positioned(
                  top: height * 0.08,
                  right: 20,
                  child: const Icon(Icons.favorite_border, color: Colors.white),
                ),
                Column(
                  children: [
                    SizedBox(height: height * 0.12),
                    CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          const NetworkImage("https://i.pravatar.cc/150?img=12"),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Ravi Kumar",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      "Professional Driver",
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // _iconCircle(Icons.info_outline, "Details"),
                          // _iconCircle(Icons.phone, "Call"),
                          // _iconCircle(Icons.message, "Chat"),
                          // _iconCircle(Icons.car_rental, "Book"),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // _infoTile("Experience", "5+ Years"),
                  // _infoTile("Rating", "⭐ 4.8"),
                  // _infoTile("Comfort", "High"),
                ],
              ),
            ),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  // _profileDetailTile("Vehicle Types", "Cars, Bikes"),
                  // _profileDetailTile("Transmission", "Manual & Automatic"),
                  // _profileDetailTile("Speed Avg", "55-60 km/h"),
                  // _profileDetailTile("Languages", "English, Hindi"),
                  // _profileDetailTile("Availability", "Full Day / Part Time"),
                ],
              ),
            ),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorConstant.primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  minimumSize: Size(double.infinity, 55),
                ),
                child: const Text("Hire Driver", style: TextStyle(fontSize: 18)),
              ),
            ),
            const SizedBox(height: 30)
          ],
        ),
      ),
    );
  }

//   Widget _iconCircle(IconData icon, String label) {
//     return Column(
//       children: [
//         CircleAvatar(
//           radius: 24,
//           backgroundColor: Colors.white,
//           child: Icon(icon, color: Colors.blueAccent),
//         ),
//         const SizedBox(height: 6),
//         Text(label, style: const TextStyle(fontSize: 12)),
//       ],
//     );
//   }

//   Widget _infoTile(String title, String subtitle) {
//     return Container(
//       padding: const EdgeInsets.all(10),
//       width: 100,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: ColorConstant.primaryColor.withOpacity(.5)),
//       ),
//       child: Column(
//         children: [
//           Text(subtitle,
//               style: const TextStyle(
//                   fontSize: 14, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 4),
//           Text(title, style: const TextStyle(fontSize: 12, color: Colors.black54))
//         ],
//       ),
//     );
//   }

//   Widget _profileDetailTile(String title, String value) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: Row(
//         children: [
//           Expanded(
//             child: Text(
//               title,
//               style: const TextStyle(fontSize: 16, color: Colors.black87),
//             ),
//           ),
//           Text(
//             value,
//             style: const TextStyle(
//                 fontWeight: FontWeight.w600, fontSize: 16, color: Colors.black),
//           )
//         ],
//       ),
//     );
//   }
}