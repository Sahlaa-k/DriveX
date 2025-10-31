// import 'dart:convert';

// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:http/http.dart' as http;

// class RouteResult {
//   final double km; // total driving distance (km)
//   final int minutes; // total duration (mins)
//   final List<LatLng> path; // overview polyline decoded (optional)

//   RouteResult({required this.km, required this.minutes, required this.path});
// }

// Future<RouteResult?> getRoadRouteDistance({
//   required String apiKey,
//   required LatLng origin,
//   required LatLng destination,
//   List<LatLng> waypoints = const [],
//   bool optimize = false,
// }) async {
//   final wp = waypoints.isEmpty
//       ? ""
//       : "&waypoints=${optimize ? 'optimize:true|' : ''}"
//           "${waypoints.map((w) => "${w.latitude},${w.longitude}").join('|')}";

//   final uri = Uri.parse(
//     "https://maps.googleapis.com/maps/api/directions/json"
//     "?origin=${origin.latitude},${origin.longitude}"
//     "&destination=${destination.latitude},${destination.longitude}"
//     "$wp"
//     "&mode=driving&units=metric&key=$apiKey",
//   );

//   final res = await http.get(uri);
//   if (res.statusCode != 200) return null;
//   final data = jsonDecode(res.body);

//   if (data['status'] != 'OK' || (data['routes'] as List).isEmpty) return null;

//   final route = data['routes'][0];
//   final legs = (route['legs'] as List);

//   int meters = 0;
//   int seconds = 0;
//   for (final l in legs) {
//     meters += (l['distance']['value'] as num).toInt();
//     seconds += (l['duration']['value'] as num).toInt();
//   }

//   final overview = route['overview_polyline']?['points'] as String? ?? "";
//   final path = _decodePolyline(overview);

//   return RouteResult(
//     km: meters / 1000.0,
//     minutes: (seconds / 60).round(),
//     path: path,
//   );
// }

// List<LatLng> _decodePolyline(String encoded) {
//   if (encoded.isEmpty) return [];
//   final poly = <LatLng>[];
//   int index = 0, lat = 0, lng = 0;

//   while (index < encoded.length) {
//     int b, shift = 0, result = 0;
//     do {
//       b = encoded.codeUnitAt(index++) - 63;
//       result |= (b & 0x1f) << shift;
//       shift += 5;
//     } while (b >= 0x20);
//     final dlat = ((result & 1) == 1) ? ~(result >> 1) : (result >> 1);
//     lat += dlat;

//     shift = 0;
//     result = 0;
//     do {
//       b = encoded.codeUnitAt(index++) - 63;
//       result |= (b & 0x1f) << shift;
//       shift += 5;
//     } while (b >= 0x20);
//     final dlng = ((result & 1) == 1) ? ~(result >> 1) : (result >> 1);
//     lng += dlng;

//     poly.add(LatLng(lat / 1e5, lng / 1e5));
//   }
//   return poly;
// }

// --------------------------------------------

import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

/// ─────────────────────────────────────────────────────────
/// RouteResult — Simple model holding Google Directions data
/// ─────────────────────────────────────────────────────────
class RouteResult {
  /// Total driving distance (in km)
  final double km;

  /// Total estimated time (in minutes)
  final int minutes;

  /// Decoded polyline path of the route
  final List<LatLng> path;

  RouteResult({
    required this.km,
    required this.minutes,
    required this.path,
  });
}

/// ─────────────────────────────────────────────────────────
/// Fetch route data from Google Directions API
/// Returns:
///   • null if no route found or failed
///   • RouteResult with km, minutes, and decoded polyline
/// ─────────────────────────────────────────────────────────
Future<RouteResult?> getRoadRouteDistance({
  required String apiKey,
  required LatLng origin,
  required LatLng destination,
  List<LatLng> waypoints = const [],
  bool optimize = false,
}) async {
  // Construct waypoints string
  final wp = waypoints.isEmpty
      ? ""
      : "&waypoints=${optimize ? 'optimize:true|' : ''}"
          "${waypoints.map((w) => "${w.latitude},${w.longitude}").join('|')}";

  final uri = Uri.parse(
    "https://maps.googleapis.com/maps/api/directions/json"
    "?origin=${origin.latitude},${origin.longitude}"
    "&destination=${destination.latitude},${destination.longitude}"
    "$wp"
    "&mode=driving&units=metric&key=$apiKey",
  );

  final res = await http.get(uri);
  if (res.statusCode != 200) return null;

  final data = jsonDecode(res.body);

  // Handle possible Google API errors
  if (data['status'] != 'OK' || (data['routes'] as List).isEmpty) {
    // Optional: print diagnostic info
    // print('Directions API error: ${data['status']} — ${data['error_message'] ?? ''}');
    return null;
  }

  final route = data['routes'][0];
  final legs = (route['legs'] as List);

  int meters = 0;
  int seconds = 0;

  // Combine all legs (if multiple)
  for (final l in legs) {
    meters += (l['distance']['value'] as num).toInt();
    seconds += (l['duration']['value'] as num).toInt();
  }

  final overview = route['overview_polyline']?['points'] as String? ?? "";
  final path = _decodePolyline(overview);

  return RouteResult(
    km: meters / 1000.0,
    minutes: (seconds / 60).round(),
    path: path,
  );
}

/// ─────────────────────────────────────────────────────────
/// Polyline decoder — converts Google's encoded polyline string
/// into a list of LatLng coordinates.
/// ─────────────────────────────────────────────────────────
List<LatLng> _decodePolyline(String encoded) {
  if (encoded.isEmpty) return [];
  final List<LatLng> poly = [];
  int index = 0, lat = 0, lng = 0;

  while (index < encoded.length) {
    int b, shift = 0, result = 0;
    do {
      b = encoded.codeUnitAt(index++) - 63;
      result |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);
    final dlat = ((result & 1) == 1) ? ~(result >> 1) : (result >> 1);
    lat += dlat;

    shift = 0;
    result = 0;
    do {
      b = encoded.codeUnitAt(index++) - 63;
      result |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);
    final dlng = ((result & 1) == 1) ? ~(result >> 1) : (result >> 1);
    lng += dlng;

    poly.add(LatLng(lat / 1e5, lng / 1e5));
  }
  return poly;
}
