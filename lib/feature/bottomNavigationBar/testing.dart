// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:google_ml_kit/google_ml_kit.dart';
//
// class LicenseScannerPage extends StatefulWidget {
//   const LicenseScannerPage({super.key});
//
//   @override
//   State<LicenseScannerPage> createState() => _LicenseScannerPageState();
// }
//
// class _LicenseScannerPageState extends State<LicenseScannerPage> {
//   File? _selectedImage;
//   bool? isLicenseValid;
//
//   final double width = 400; // You can replace this with MediaQuery if needed
//
//   Future<void> _pickImageAndCheck(ImageSource source) async {
//     final permissionStatus = await (source == ImageSource.camera
//         ? Permission.camera.request()
//         : Permission.photos.request());
//
//     if (!permissionStatus.isGranted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Permission denied")),
//       );
//       return;
//     }
//
//     final pickedFile = await ImagePicker().pickImage(source: source);
//     if (pickedFile == null) return;
//
//     final file = File(pickedFile.path);
//
//     setState(() {
//       _selectedImage = file;
//       isLicenseValid = null; // Reset
//     });
//
//     await _checkLicense(file);
//   }
//
//   Future<void> _checkLicense(File file) async {
//     final inputImage = InputImage.fromFile(file);
//     final textRecognizer = GoogleMlKit.vision.textRecognizer();
//     final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
//     final extracted = recognizedText.text.toLowerCase().trim();
//
//     print("🔍 Extracted Text: $extracted");
//
//     final licenseKeywords = [
//       'driving license',
//       'dl no',
//       'dl number',
//       'govt of india',
//       'transport department'
//     ];
//
//     if (extracted.isEmpty) {
//       // No text found at all
//       setState(() {
//         isLicenseValid = false;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('❌ No text found. Please upload a clear license image.'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     } else {
//       final isValid = licenseKeywords.any((keyword) => extracted.contains(keyword));
//       setState(() {
//         isLicenseValid = isValid;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(isValid ? '✅ Valid License Detected' : '❌ Invalid License'),
//           backgroundColor: isValid ? Colors.green : Colors.red,
//         ),
//       );
//     }
//
//     await textRecognizer.close();
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//
//     return Scaffold(
//       appBar: AppBar(title: const Text("License Verification")),
//       body: Center(
//     child: Column(
//     mainAxisSize: MainAxisSize.min,
//       children: [
//         GestureDetector(
//           onTap: () async {
//             await showModalBottomSheet(
//               context: context,
//               builder: (_) => SafeArea(
//                 child: Wrap(
//                   children: [
//                     ListTile(
//                       leading: const Icon(Icons.photo_camera),
//                       title: const Text('Take Photo'),
//                       onTap: () async {
//                         Navigator.pop(context);
//                         await _pickImageAndCheck(ImageSource.camera);
//                       },
//                     ),
//                     ListTile(
//                       leading: const Icon(Icons.photo_library),
//                       title: const Text('Choose from Gallery'),
//                       onTap: () async {
//                         Navigator.pop(context);
//                         await _pickImageAndCheck(ImageSource.gallery);
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//           child: Container(
//             width: screenWidth * 0.6,
//             height: screenWidth * 0.6,
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.grey),
//               borderRadius: BorderRadius.circular(12),
//               color: Colors.grey.shade100,
//             ),
//             child: _selectedImage != null
//                 ? Stack(
//               alignment: Alignment.topRight,
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(12),
//                   child: Image.file(
//                     _selectedImage!,
//                     width: screenWidth * 0.6,
//                     height: screenWidth * 0.6,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 if (isLicenseValid != null)
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: CircleAvatar(
//                       backgroundColor:
//                       isLicenseValid! ? Colors.green : Colors.red,
//                       child: Icon(
//                         isLicenseValid! ? Icons.check : Icons.close,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//               ],
//             )
//                 : Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(Icons.camera_alt,
//                     size: screenWidth * 0.1, color: Colors.grey),
//                 const SizedBox(height: 8),
//                 const Text(
//                   "Add License Photo",
//                   style: TextStyle(fontSize: 16, color: Colors.grey),
//                 ),
//               ],
//             ),
//           ),
//         ),
//
//         // ✅ License result text below image
//         if (isLicenseValid != null)
//           Padding(
//             padding: const EdgeInsets.only(top: 16.0),
//             child: Text(
//               isLicenseValid!
//                   ? "✅ License verified successfully"
//                   : "❌ Invalid license. Please upload a valid one.",
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w500,
//                 color: isLicenseValid! ? Colors.green : Colors.red,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ),
//       ],
//     ),
//     ),
//
//     );
//   }
// }
