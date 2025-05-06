import 'package:drivex/core/constants/color_constant.dart';
import 'package:flutter/material.dart';

class AnimatedLogo2 extends StatefulWidget {
  final double fontSize;
  final bool animateLetters;

  const AnimatedLogo2({
    super.key,
    required this.fontSize,
    this.animateLetters = true,
  });

  @override
  State<AnimatedLogo2> createState() => _AnimatedLogo2State();
}

class _AnimatedLogo2State extends State<AnimatedLogo2> with TickerProviderStateMixin {
  List<String> letters = ['r', 'i', 'v', 'e'];
  List<Widget> fadedLetters = [];

  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeOutBack,
    );

    _scaleController.forward();

    if (widget.animateLetters) {
      _addLettersOneByOne();
    } else {
      // Show all letters at once for static use (like in login page)
      setState(() {
        fadedLetters = letters
            .map(
              (e) => Text(
            e,
            style: TextStyle(
              color: ColorConstant.primaryColor,
              fontSize: widget.fontSize,
              fontWeight: FontWeight.w500,
            ),
          ),
        )
            .toList();
      });
    }
  }

  void _addLettersOneByOne() async {
    for (int i = 0; i < letters.length; i++) {
      AnimationController fadeController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 200),
      );
      Animation<double> fadeAnimation =
      CurvedAnimation(parent: fadeController, curve: Curves.easeIn);

      fadeController.forward();

      setState(() {
        fadedLetters.add(
          FadeTransition(
            opacity: fadeAnimation,
            child: Text(
              letters[i],
              style: TextStyle(
                color: ColorConstant.backgroundColor.withOpacity(0.4),
                fontSize: widget.fontSize,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      });

      await Future.delayed(const Duration(milliseconds: 400));
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: widget.fontSize,
            fontWeight: FontWeight.bold,
            color: ColorConstant.backgroundColor,
            letterSpacing: 2,
          ),
          children: [
            const TextSpan(text: 'D'),
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: fadedLetters,
              ),
            ),
            const TextSpan(text: 'X'),
          ],
        ),
      ),
    );
  }
}
