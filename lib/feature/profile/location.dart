import 'dart:convert';

import 'package:drivex/core/constants/localVariables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class Location extends StatefulWidget {
  const Location({super.key});

  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {
  late GoogleMapController? mapController;

  GoogleMapController? _mapController;
  // LatLng pickup = LatLng(10.998, 76.990); // Replace with your pickup
  LatLng pickup = LatLng(10.998, 76.990); // Replace with your pickup
  LatLng drop = LatLng(10.995, 76.995); // Replace with your drop
  Set<Polyline> _polylines = {};

  LatLng startLocation = LatLng(10.0159, 76.3419); // Example: Cochin
  LatLng endLocation = LatLng(10.0889, 76.5276); // Example: Aluva

  final String googleAPIKey = "AIzaSyD1fU_UDudvvy1HEPEoJ4Ify_YOYDlhdEY";

  @override
  void initState() {
    super.initState();
    polylinePoints = PolylinePoints();
    _getDirections();
    setMarkers();
    getRoute();
  }

  Future<void> _getDirections() async {
    final String apiKey = "AIzaSyD1fU_UDudvvy1HEPEoJ4Ify_YOYDlhdEY";

    final String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${pickup.latitude},${pickup.longitude}&destination=${drop.latitude},${drop.longitude}&key=$apiKey";

    final response = await http.get(Uri.parse(url));
    final json = jsonDecode(response.body);

    if (json["routes"].isNotEmpty) {
      final points = json["routes"][0]["overview_polyline"]["points"];
      final polylinePoints = _decodePolyline(points);

      setState(() {
        _polylines.add(Polyline(
          polylineId: PolylineId("route"),
          color: Colors.blue,
          width: 5,
          points: polylinePoints,
        ));
      });
    }

    print(url);
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> polyline = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;

      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dLat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dLat;

      shift = 0;
      result = 0;

      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dLng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dLng;

      polyline.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return polyline;
  }

  void setMarkers() {
    markers.add(Marker(
      markerId: MarkerId("start"),
      position: startLocation,
      infoWindow: InfoWindow(title: "Pickup"),
    ));

    markers.add(Marker(
      markerId: MarkerId("end"),
      position: endLocation,
      infoWindow: InfoWindow(title: "Drop"),
    ));
  }

  Future<void> getRoute() async {
    final url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${startLocation.latitude},${startLocation.longitude}&destination=${endLocation.latitude},${endLocation.longitude}&key=$googleAPIKey";

    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);

    if (data["routes"].isNotEmpty) {
      final points = PolylinePoints().decodePolyline(
        data["routes"][0]["overview_polyline"]["points"],
      );

      if (points.isNotEmpty) {
        setState(() {
          polylineCoordinates =
              points.map((e) => LatLng(e.latitude, e.longitude)).toList();
        });
      }
    }
  }

  Set<Marker> markers = {};
  List<LatLng> polylineCoordinates = [];
  late PolylinePoints polylinePoints;

  final CameraPosition _initialPosition = CameraPosition(
    target: LatLng(10.8505, 76.2711), // Example: Kerala
    zoom: 14.0,
  );
  var details;

  TextEditingController PickUpController = TextEditingController();
  TextEditingController DropOffController = TextEditingController();

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location service is enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    print("-------------------------------");
    print(serviceEnabled);
    print("-------------------------------");
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    // Check permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
          'Location permissions are permanently denied, we cannot request.');
    }

    // Get current position
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<String> getPlaceFromCoordinates(double lat, double lon) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        details = place;

        // Customize this as needed
        String address = [
          place.name,
          place.street,
          place.subLocality,
          place.locality,
          place.administrativeArea,
          place.country,
          place.postalCode
        ].where((part) => part != null && part!.isNotEmpty).join(', ');
        // print("-------------------------------");
        // print(address);
        // print(address.runtimeType);
        // // List details = address.to;
        // print("-------------------------------");

        return address;
      } else {
        return "No place found for the given coordinates.";
      }
    } catch (e) {
      return "Error getting place: ${e.toString()}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: height * .5,
            width: width * .75,
            decoration: BoxDecoration(border: Border.all()),
            // child: GoogleMap(
            //   initialCameraPosition: _initialPosition,
            //   onMapCreated: (controller) {
            //     mapController = controller;
            //   },
            //   myLocationEnabled: true,
            //   myLocationButtonEnabled: true,
            //   zoomControlsEnabled: false,
            // ),
            //////////////////////
            // child: GoogleMap(
            //   myLocationEnabled: true,
            //   initialCameraPosition: CameraPosition(
            //     target: startLocation,
            //     zoom: 12,
            //   ),
            //   onMapCreated: (controller) =>
            //       mapController = controller,
            //   markers: markers,
            //   polylines: {
            //     Polyline(
            //       polylineId: PolylineId("route"),
            //       points: polylineCoordinates,
            //       color: Colors.blue,
            //       width: 5,
            //     )
            //   },
            // )
            ///////////////////////
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: pickup,
                zoom: 14,
              ),
              onMapCreated: (controller) {
                _mapController = controller;
              },
              polylines: _polylines,
              markers: {
                Marker(markerId: MarkerId("pickup"), position: pickup),
                Marker(markerId: MarkerId("drop"), position: drop),
              },
              myLocationEnabled: true,
            ),
          ),
        ],
      ),
    );
  }
}
