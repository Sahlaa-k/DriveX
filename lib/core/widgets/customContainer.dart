import 'package:flutter/cupertino.dart';

class TopRightNotchClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    const double radius = 30.0;
    const double notchSize =40.0;

    // Top-left rounded corner
    path.moveTo(0, radius);
    path.quadraticBezierTo(0, 0, radius, 0);

    // Move to notch start
    path.lineTo(size.width - notchSize - radius, 0);

    // Inward notch (top-right indent)
    path.quadraticBezierTo(
      size.width - notchSize, 0,
      size.width - notchSize, notchSize,
    );

    // Outward curve to blend smoothly to the right edge
    path.quadraticBezierTo(
      size.width - notchSize, notchSize * 1.8,
      size.width - notchSize / 2, notchSize * 2,
    );

    path.quadraticBezierTo(
      size.width, notchSize * 2.2,
      size.width, notchSize * 3,
    );

    // Down right edge
    path.lineTo(size.width, size.height - radius);
    path.quadraticBezierTo(size.width, size.height, size.width - radius, size.height);

    // Bottom edge
    path.lineTo(radius, size.height);
    path.quadraticBezierTo(0, size.height, 0, size.height - radius);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
//
// class PerfectNotchClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     final double radius = 24.0;
//     final double notchRadius = 20.0;
//
//     final path = Path();
//
//     // Top-left curve
//     path.moveTo(0, radius);
//     path.quadraticBezierTo(0, 0, radius, 0);
//
//
//
//
//     // Line to just before notch
//     path.lineTo(size.width - notchRadius * 2, 0);
//
//     // Perfect notch curve (semi-circle inward)
//     path.arcToPoint(
//       Offset(size.width, notchRadius * 2),
//       radius: Radius.circular(notchRadius * 2),
//       clockwise: false,
//     );
//
//     // Right side
//     path.lineTo(size.width, size.height - radius);
//     path.quadraticBezierTo(size.width, size.height, size.width - radius, size.height);
//
//     // Bottom
//     path.lineTo(radius, size.height);
//     path.quadraticBezierTo(0, size.height, 0, size.height - radius);
//
//     path.close();
//     return path;
//   }
//
//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) => false;
// }
