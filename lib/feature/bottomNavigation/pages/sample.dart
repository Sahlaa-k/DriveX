// import 'package:flutter/material.dart';
// import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_maps_webservice/places.dart';

// class SearchPlacesPage extends StatefulWidget {
//   @override
//   _SearchPlacesPageState createState() => _SearchPlacesPageState();
// }

// class _SearchPlacesPageState extends State<SearchPlacesPage> {
//   final TextEditingController _fromController = TextEditingController();
//   final TextEditingController _toController = TextEditingController();

//   LatLng? fromLocation;
//   LatLng? toLocation;

//   static const String kGoogleApiKey = "YOUR_GOOGLE_API_KEY"; // 🔥 Put your API key here!

//   final Mode _mode = Mode.overlay; // you can also use Mode.fullscreen

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Select Locations'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _fromController,
//               readOnly: true,
//               onTap: () => _handlePressButton(isFrom: true),
//               decoration: InputDecoration(
//                 labelText: 'From Location',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 16),
//             TextField(
//               controller: _toController,
//               readOnly: true,
//               onTap: () => _handlePressButton(isFrom: false),
//               decoration: InputDecoration(
//                 labelText: 'To Location',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 32),
//             ElevatedButton(
//               onPressed: () {
//                 if (fromLocation != null && toLocation != null) {
//                   print('From: $fromLocation');
//                   print('To: $toLocation');
//                   // Later here you can call getDirections(fromLocation, toLocation)
//                 } else {
//                   print('Please select both locations');
//                 }
//               },
//               child: Text('Continue'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _handlePressButton({required bool isFrom}) async {
//     Prediction? p = await PlacesAutocomplete.show(
//       context: context,
//       apiKey: kGoogleApiKey,
//       mode: _mode,
//       language: "en",
//       components: [Component(Component.country, "in")], // Optional: restrict to a country, e.g., "in" for India
//     );

//     if (p != null) {
//       _displayPrediction(p, isFrom: isFrom);
//     }
//   }

//   Future<void> _displayPrediction(Prediction p, {required bool isFrom}) async {
//     GoogleMapsPlaces places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
//     PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);

//     final lat = detail.result.geometry!.location.lat;
//     final lng = detail.result.geometry!.location.lng;

//     setState(() {
//       if (isFrom) {
//         _fromController.text = p.description!;
//         fromLocation = LatLng(lat, lng);
//       } else {
//         _toController.text = p.description!;
//         toLocation = LatLng(lat, lng);
//       }
//     });
//   }
// }
