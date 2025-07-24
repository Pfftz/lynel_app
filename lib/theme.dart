import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color batikBeige = Color(0xFFEFE5DC);
const Color jetBlack = Color(0xFF000000); // ← sebelumnya javaBrown
const Color oldGold = Color(0xFFC2A94E);
const Color terracotta = Color(0xFFD2691E);

final ThemeData appTheme = ThemeData(
  scaffoldBackgroundColor: jetBlack, // Background → Jet Black
  colorScheme: ColorScheme.fromSeed(
    seedColor: terracotta,           
    background: jetBlack,
    primary: terracotta,
    onPrimary: Colors.white,
    secondary: batikBeige,
    onSecondary: jetBlack,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: terracotta,   
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      textStyle: GoogleFonts.poppins(
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: batikBeige,
      textStyle: GoogleFonts.poppins(
        fontWeight: FontWeight.w500,
        fontSize: 14,
        decoration: TextDecoration.underline,
      ),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: terracotta),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: terracotta, width: 2),
    ),
    labelStyle: GoogleFonts.poppins(color: oldGold),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  ),
  textTheme: TextTheme(
    headlineLarge: GoogleFonts.dmSerifDisplay(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: oldGold, // Heading → Old Gold
    ),
    bodyMedium: GoogleFonts.poppins(
      fontSize: 16,
      color: batikBeige,
    ),
    bodySmall: GoogleFonts.poppins(
      fontSize: 14,
      color: batikBeige,
    ),
  ),
  useMaterial3: true,
);
