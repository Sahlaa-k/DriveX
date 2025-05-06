import 'package:drivex/core/constants/color_constant.dart';
import 'package:flutter/material.dart';

class AnimatedLogo extends StatefulWidget {
  final double fontSize;
  final bool animateLetters;

  const AnimatedLogo({
    super.key,
    required this.fontSize,
    this.animateLetters = true,
  });

  @override
  State<AnimatedLogo> createState() => _AnimatedLogoState();
}

class _AnimatedLogoState extends State<AnimatedLogo> with TickerProviderStateMixin {
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
              color: ColorConstant.secondaryColor,
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
                color: ColorConstant.secondaryColor,
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
