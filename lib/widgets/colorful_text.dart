import 'package:flutter/material.dart';

import '../constants.dart';

class ColourfulText extends StatelessWidget {
  final String text;
  const ColourfulText({
    super.key, required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: TextStyle(
            foreground: Paint()..shader = linearGradient,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}