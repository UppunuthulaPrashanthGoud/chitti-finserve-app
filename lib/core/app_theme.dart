// Shared app colors, themes, and font setup
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Toggle this to switch between Montserrat and Poppins
const bool usePoppinsFont = false; // Set to true to use Poppins, false for Montserrat

class AppColors {
  static const Color primary = Color(0xFF005DFF); // Royal Blue
  static const Color accent = Colors.white;
  static const Color lightGrey = Color(0xFFF5F6FA);
}

TextTheme getAppTextTheme(BuildContext context) {
  final baseTheme = Theme.of(context).textTheme.apply(
    bodyColor: Colors.black87,
    displayColor: AppColors.primary,
  );
  return usePoppinsFont
      ? GoogleFonts.poppinsTextTheme(baseTheme)
      : GoogleFonts.montserratTextTheme(baseTheme);
}

ThemeData appTheme(BuildContext context, {bool isDark = false}) => ThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.lightGrey,
      cardColor: Colors.white,
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.accent,
        background: AppColors.lightGrey,
        surface: Colors.white,
      ),
      textTheme: getAppTextTheme(context),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: usePoppinsFont ? 'Poppins' : 'Montserrat',
          fontWeight: FontWeight.bold,
          fontSize: 22,
          color: Colors.white,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        labelStyle: TextStyle(
          fontFamily: usePoppinsFont ? 'Poppins' : 'Montserrat',
          color: AppColors.primary,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          textStyle: TextStyle(
            fontFamily: usePoppinsFont ? 'Poppins' : 'Montserrat',
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 2,
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.black54,
        selectedLabelStyle: TextStyle(fontFamily: usePoppinsFont ? 'Poppins' : 'Montserrat', fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(fontFamily: usePoppinsFont ? 'Poppins' : 'Montserrat'),
        elevation: 10,
        type: BottomNavigationBarType.fixed,
      ),
    );
