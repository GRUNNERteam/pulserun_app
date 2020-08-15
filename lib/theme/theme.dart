import 'package:flutter/material.dart';

// Ref
// https://coolors.co/ff9f1c-ffbf69-ffffff-cbf3f0-2ec4b6
class GlobalTheme {
  static const Color mediumBlue = const Color(0xff4A64FE);

  static const Color default_background = const Color(0xFFCBF3F0);
  static const Color default_text = const Color(0xFFFFFFFF);
  static const Color default_error = Colors.redAccent;
  static const Color default_valid = Colors.greenAccent;

  static const Color orange_peel = const Color(0xFFFF9F1C);
  static const Color mellow_apricot = const Color(0xFFFFBF69);
  static const Color white = const Color(0xFFFFFFFF);
  static const Color light_cyan = const Color(0xFFCBF3F0);
  static const Color tiffany_blue = const Color(0xFF2EC4B6);

  static const Color light_cyan_shadow = Color.fromRGBO(203, 243, 240, 0.3);

  static ThemeData mytheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: tiffany_blue,
    accentColor: light_cyan,
    fontFamily: 'Open Sans',
    textTheme: TextTheme(
      headline3: TextStyle(
        color: default_text,
      ),
    ),
  );
}
