import 'package:flutter/material.dart';
import 'colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primaryColor,
    hintColor: AppColors.accentColor,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontSize: 16.0, color: Colors.black87),
      bodyMedium: TextStyle(fontSize: 14.0, color: Colors.black87),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primaryColor,
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20.0),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        textStyle: const TextStyle(fontSize: 18.0, color: Colors.white),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.darkPrimaryColor,
    hintColor: AppColors.darkAccentColor,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontSize: 16.0, color: Colors.white),
      bodyMedium: TextStyle(fontSize: 14.0, color: Colors.white),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkPrimaryColor,
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20.0),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.darkPrimaryColor,
        textStyle: const TextStyle(fontSize: 18.0, color: Colors.white),
      ),
    ),
  );
}
