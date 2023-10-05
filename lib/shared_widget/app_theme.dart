import 'package:flutter/material.dart';

class AppTheme {

  static const Color primaryColor = Color(0xFFd6cb95);
  static const Color accentColor = Color(0xFFa3d1cf);

  // Background colors
  static const Color backgroundColor = Color(0xFFFFFFFF);
  static const Color scaffoldBackgroundColor = Color(0xFFF4F4F4);

  // Text colors
  static const Color textColor = Color(0xFF333333);
  static const Color subtitleColor = Color(0xFF666666);
  static const Color darkGrey = Color(0xFF211f1f);
  static const Color hintColor = Color(0xFFCCCCCC);

  // Custom text styles
  static const TextStyle headline1 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: textColor,
    fontFamily: 'Tajawal',

  );

  static const TextStyle headline2 = TextStyle(
    fontSize: 19,
    fontWeight: FontWeight.w500,
    color: textColor,
    fontFamily: 'Tajawal',
  );

  static const TextStyle bodyText1 = TextStyle(
    fontSize: 15,
    color: textColor,
    fontFamily: 'Tajawal',
  );

  static const TextStyle bodyText2 = TextStyle(
    fontSize: 13,
    color: subtitleColor,
    fontFamily: 'Tajawal',
  );


  static TextStyle customTextStyle({
    double fontSize = 15,
    Color color = Colors.black,
    FontWeight fontWeight = FontWeight.normal,
    FontStyle fontStyle = FontStyle.normal,
    TextDecoration decoration = TextDecoration.none,
  }) {
    return TextStyle(
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      decoration: decoration,
      fontFamily: 'Tajawal',
    );
  }

  // App bar theme
  static ThemeData getAppTheme() {
    return ThemeData(
      primaryColor: primaryColor,
      hintColor: accentColor,

      scaffoldBackgroundColor: scaffoldBackgroundColor,
      fontFamily: 'Tajawal',
      textTheme:  const TextTheme(
        displayLarge: headline1,
        displayMedium: headline2,
        bodyLarge: bodyText1,
        bodyMedium: bodyText2,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        centerTitle: true,
        titleTextStyle: TextStyle(color: Colors.white),
      ),
    );
  }
}
