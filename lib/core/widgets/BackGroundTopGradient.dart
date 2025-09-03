import 'package:drivex/core/constants/color_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Backgroundtopgradient extends StatefulWidget {
  final Widget child;
  const Backgroundtopgradient({super.key, required this.child});

  @override
  State<Backgroundtopgradient> createState() => _BackgroundtopgradientState();
}

class _BackgroundtopgradientState extends State<Backgroundtopgradient> {
  final ScrollController _scrollController = ScrollController();
  double scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        scrollOffset = _scrollController.offset;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  double get topOpacity => (0.9 - (scrollOffset * 0.005)).clamp(0.0, 0.9);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // color: Colors.blue,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.0, 0.3],
          colors: [
            ColorConstant.color11.withOpacity(0.4),
            // ColorConstant.backgroundColor.withOpacity(topOpacity),
            Colors.transparent
          ],
        ),
      ),
      child: SingleChildScrollView(
        controller: _scrollController,
        child: widget.child,
      ),
    );
  }
}
///////=========
// import 'package:flutter/material.dart';

// class GradientWrapper extends StatefulWidget {
//   final Widget child;

//   const GradientWrapper({super.key, required this.child});

//   @override
//   State<GradientWrapper> createState() => _GradientWrapperState();
// }

// class _GradientWrapperState extends State<GradientWrapper> {
//   final ScrollController _scrollController = ScrollController();
//   double scrollOffset = 0.0;

//   @override
//   void initState() {
//     super.initState();
//     _scrollController.addListener(() {
//       setState(() {
//         scrollOffset = _scrollController.offset;
//       });
//     });
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }

//   double get topOpacity => (0.9 - (scrollOffset * 0.005)).clamp(0.0, 0.9);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           stops: [0.0, 0.3],
//           colors: [
//             Colors.lightBlue.withOpacity(topOpacity),
//             Colors.white.withOpacity(topOpacity),
//           ],
//         ),
//       ),
//       child: SingleChildScrollView(
//         controller: _scrollController,
//         child: widget.child,
//       ),
//     );
//   }
// }
