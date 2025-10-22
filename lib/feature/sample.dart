import 'dart:math' as math;
import 'package:flutter/material.dart';

class CustomCarDrivePage extends StatefulWidget {
  const CustomCarDrivePage({super.key});

  @override
  State<CustomCarDrivePage> createState() => _CustomCarDrivePageState();
}

class _CustomCarDrivePageState extends State<CustomCarDrivePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  final double _speed = 1.0;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFF6F8FC);

    return Scaffold(
      backgroundColor: bg,
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Animated background
          AnimatedBuilder(
            animation: _ctrl,
            builder: (context, _) {
              return CustomPaint(
                painter: _ScenePainter(
                  t: _ctrl.value,
                  speed: _speed,
                ),
                size: Size.infinite,
              );
            },
          ),

          // App Name “DriveX”
          Positioned(
            top: MediaQuery.of(context).size.height * 0.25,
            child: Column(
              children: [
                Text(
                  "DriveX",
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: Colors.blue.shade700,
                    shadows: [
                      Shadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Your Drive, Simplified",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ScenePainter extends CustomPainter {
  _ScenePainter({required this.t, required this.speed});
  final double t;
  final double speed;

  double _offset(double base, double width) {
    final d = (t * base * speed) % 1.0;
    return d * width;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Background gradient
    final sky = Rect.fromLTWH(0, 0, w, h);
    final skyPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFBFD9FF), Color(0xFFE7F0FF), Colors.white],
      ).createShader(sky);
    canvas.drawRect(sky, skyPaint);

    // Sun
    final sunCenter = Offset(w * 0.82, h * 0.18);
    final sunPaint = Paint()..color = const Color(0xFFFFE082);
    canvas.drawCircle(sunCenter, w * 0.07, sunPaint);

    // Clouds
    _drawClouds(canvas, size);

    // Hills
    _drawHills(canvas, size,
        yFactor: 0.55,
        color: const Color(0xFF9EC3E6),
        speedBase: 0.08,
        amplitude: 0.12,
        smoothness: 4);
    _drawHills(canvas, size,
        yFactor: 0.67,
        color: const Color(0xFF7FAED9),
        speedBase: 0.16,
        amplitude: 0.10,
        smoothness: 5);

    // City skyline
    _drawCity(canvas, size);

    // Road + car
    final roadTop = h * 0.78;
    _drawRoad(canvas, size, roadTop);
    _drawCar(canvas, size, roadTop);
  }

  void _drawClouds(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final c1 = _offset(0.03, w);
    final c2 = _offset(0.045, w);
    final c3 = _offset(0.06, w);

    void cloud(Offset p, double s, double alpha) {
      final paint = Paint()..color = Colors.white.withOpacity(alpha);
      final r = Rect.fromCenter(center: p, width: s * w, height: s * w * 0.45);
      canvas.drawOval(r, paint);
      canvas.drawOval(
          Rect.fromCenter(
              center: p + Offset(-0.18 * s * w, -0.02 * s * w),
              width: s * w * 0.6,
              height: s * w * 0.35),
          paint);
      canvas.drawOval(
          Rect.fromCenter(
              center: p + Offset(0.22 * s * w, -0.03 * s * w),
              width: s * w * 0.55,
              height: s * w * 0.33),
          paint);
    }

    cloud(Offset(w - c1, h * 0.18), 0.22, 0.9);
    cloud(Offset(w * 0.25 - c2, h * 0.26), 0.18, 0.85);
    cloud(Offset(w * 1.2 - c3, h * 0.22), 0.2, 0.8);
  }

  void _drawHills(Canvas canvas, Size size,
      {required double yFactor,
        required Color color,
        required double speedBase,
        required double amplitude,
        required int smoothness}) {
    final w = size.width;
    final h = size.height;
    final baseOffset = _offset(speedBase, w);
    final yBase = h * yFactor;
    final amp = h * amplitude;

    Path makeTile(double xShift) {
      final p = Path()..moveTo(xShift, h);
      p.lineTo(xShift, yBase);
      final segW = w / smoothness;
      for (int i = 0; i <= smoothness; i++) {
        final x = xShift + i * segW;
        final y = yBase +
            math.sin((i / smoothness) * math.pi * 2) * amp * (0.6 + 0.4 * yFactor);
        final ctrlX = x - segW * 0.5;
        final ctrlY = yBase +
            math.sin(((i - 0.5) / smoothness) * math.pi * 2) *
                amp *
                (0.6 + 0.4 * yFactor);
        p.quadraticBezierTo(ctrlX, ctrlY, x, y);
      }
      p.lineTo(xShift + w, h);
      p.close();
      return p;
    }

    final paint = Paint()..color = color;
    canvas.drawPath(makeTile(-baseOffset), paint);
    canvas.drawPath(makeTile(w - baseOffset), paint);
  }

  void _drawCity(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final top = h * 0.72;
    final paint = Paint()..color = const Color(0x5590A9C4);
    final dash = _offset(0.12, w);
    for (double x = -dash; x < w + 300; x += 90) {
      final bh = 20.0 + (x % 180) * 0.25;
      final r = RRect.fromRectAndRadius(
          Rect.fromLTWH(x, top - bh, 28, bh), const Radius.circular(4));
      canvas.drawRRect(r, paint);
    }
  }

  void _drawRoad(Canvas canvas, Size size, double roadTop) {
    final w = size.width;
    final h = size.height;
    final roadRect = Rect.fromLTWH(0, roadTop, w, h - roadTop);
    final roadPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF48505A), Color(0xFF2E333B)],
      ).createShader(roadRect);
    canvas.drawRect(roadRect, roadPaint);

    final lineY = roadTop + (h - roadTop) * 0.45;
    final dashW = 48.0;
    final gapW = 28.0;
    final period = dashW + gapW;
    final shift = _offset(0.6, period);
    final paint = Paint()..color = const Color(0xFFEAECEE);
    for (double x = -shift; x < w + period; x += period) {
      final r = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, lineY - 4, dashW, 8),
        const Radius.circular(4),
      );
      canvas.drawRRect(r, paint);
    }
  }

  void _drawCar(Canvas canvas, Size size, double roadTop) {
    final w = size.width;
    final h = size.height;

    final carW = w * 0.25;
    final carH = carW * 0.5;
    final carX = w * 0.38;
    final carY = roadTop - carH + 10;

    final carBody = RRect.fromRectAndCorners(
      Rect.fromLTWH(carX, carY, carW, carH),
      topLeft: const Radius.circular(20),
      topRight: const Radius.circular(20),
      bottomLeft: const Radius.circular(6),
      bottomRight: const Radius.circular(6),
    );

    final carPaint = Paint()..color = Colors.blue.shade600;
    canvas.drawRRect(carBody, carPaint);

    // Windows
    final windowPaint = Paint()..color = Colors.white.withOpacity(0.8);
    final windowRect = Rect.fromLTWH(carX + 20, carY + 10, carW - 40, carH * 0.45);
    canvas.drawRRect(
        RRect.fromRectAndRadius(windowRect, const Radius.circular(8)),
        windowPaint);

    // Wheels
    final wheelPaint = Paint()..color = Colors.black;
    final wheelRadius = carH * 0.22;
    final leftWheel = Offset(carX + 20, carY + carH);
    final rightWheel = Offset(carX + carW - 20, carY + carH);
    canvas.drawCircle(leftWheel, wheelRadius, wheelPaint);
    canvas.drawCircle(rightWheel, wheelRadius, wheelPaint);

    // Small highlight rim
    final rimPaint = Paint()..color = Colors.grey.shade400;
    canvas.drawCircle(leftWheel, wheelRadius * 0.5, rimPaint);
    canvas.drawCircle(rightWheel, wheelRadius * 0.5, rimPaint);
  }

  @override
  bool shouldRepaint(covariant _ScenePainter oldDelegate) =>
      oldDelegate.t != t || oldDelegate.speed != speed;
}
