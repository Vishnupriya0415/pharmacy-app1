import 'package:flutter/material.dart';

class ColorConstants {
  // static Color  = Color(0xff8F00FF);
  static MaterialColor primaryColor = const MaterialColor(0xFFFFC000, {
    50: Color(0xFFFFFCF3),
    100: Color(0xFFFFF9E6),
    200: Color(0xFFFFF0C0),
    300: Color(0xFFFFE697),
    400: Color(0xFFFFD34D),
    500: Color(0xFFFFC000),
    600: Color(0xFFE3AB00),
    700: Color(0xFF997400),
    800: Color(0xFF735700),
    900: Color(0xFF4A3800),
  });
  static Color white = fromHex('#FFFFFF');

  static Color black = fromHex('#000000');

  static Color lightViolet = fromHex('#090F47');

  static Color lightVioletMixedGrey = fromHex('#090F47');
  static Color lightVioletMixedWhite = Colors.white;

  static Color darkblue = fromHex('#090F47');

  static Color indigo = fromHex('#4157FF');

  static Color grey = fromHex('#C4C4C4');

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
