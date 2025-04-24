import 'package:flutter/material.dart';

class Constant {
  // static const Color bgSecondary = Color.fromARGB(255, 0, 0, 0);
  static const Color bgPrimary = Color.fromARGB(255, 246, 246, 246);
  static const Color bgSecondary = Color(0xFF16B1A9);

  // static const Color bgPrimary = Color(0xFF303030);
  static const Color textPrimary = Color.fromARGB(255, 41, 41, 41);
  static const Color textSecondary = Color.fromARGB(255, 116, 116, 116);

  static const Color bgGreen = Color(0xFF4CAF50);
  static const Color bgRed = Color(0xFFF44336);
  static const Color bgOrange = Color.fromARGB(255, 255, 140, 0);

  static const Color bgWhite = Color.fromARGB(255, 255, 255, 255);
  static const Color bgBlue = Color.fromARGB(255, 0, 170, 255);

  static Widget textWithStyle(
      {required String text,
      required double size,
      String? fontFamily,
      FontStyle? fontStyle,
      required Color color,
      FontWeight? fontWeight = FontWeight.w500,
      double? fontSpacing,
      int? maxLine,
      List<Shadow>? shadow,
      TextAlign? textAlign}) {
    return Text(
      text,
      textAlign: textAlign,
      overflow: TextOverflow.ellipsis,
      maxLines: maxLine,
      style: TextStyle(
          shadows: shadow,
          color: color,
          fontSize: size,
          fontWeight: fontWeight,
          fontStyle: fontStyle,
          letterSpacing: fontSpacing,
          fontFamily: 'Nunito'),
    );
  }
}
