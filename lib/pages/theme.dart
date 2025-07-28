import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Nusantara-inspired color palette
const Color nusantaraBeige = Color(0xFFFDF7F0);      // Warm beige background
const Color earthBrown = Color(0xFF8B4513);          // Traditional earth brown
const Color goldenAmber = Color(0xFFD4A574);         // Golden amber
const Color deepTeak = Color(0xFF654321);            // Deep teak wood
const Color batikIndigo = Color(0xFF2E4A62);         // Traditional batik indigo
const Color warmCream = Color(0xFFFAF0E6);           // Warm cream
const Color richMaroon = Color(0xFF800020);          // Rich maroon
const Color softGold = Color(0xFFE6B800);            // Soft gold accent

final ThemeData appTheme = ThemeData(
  scaffoldBackgroundColor: nusantaraBeige,
  colorScheme: ColorScheme.fromSeed(
    seedColor: earthBrown,
    surface: warmCream,
    primary: earthBrown,
    onPrimary: Colors.white,
    secondary: goldenAmber,
    onSecondary: deepTeak,
    tertiary: batikIndigo,
    onTertiary: Colors.white,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: earthBrown,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 3,
      textStyle: GoogleFonts.poppins(
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: batikIndigo,
      textStyle: GoogleFonts.poppins(
        fontWeight: FontWeight.w500,
        fontSize: 14,
      ),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: goldenAmber),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: earthBrown, width: 2),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: goldenAmber.withOpacity(0.5)),
    ),
    labelStyle: GoogleFonts.poppins(color: deepTeak),
    hintStyle: GoogleFonts.poppins(color: Colors.grey[600]),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  ),
  textTheme: TextTheme(
    headlineLarge: GoogleFonts.dmSerifDisplay(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: deepTeak,
    ),
    headlineMedium: GoogleFonts.dmSerifDisplay(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: deepTeak,
    ),
    titleLarge: GoogleFonts.poppins(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: earthBrown,
    ),
    titleMedium: GoogleFonts.poppins(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: earthBrown,
    ),
    bodyLarge: GoogleFonts.poppins(
      fontSize: 16,
      color: deepTeak,
    ),
    bodyMedium: GoogleFonts.poppins(
      fontSize: 14,
      color: deepTeak,
    ),
    bodySmall: GoogleFonts.poppins(
      fontSize: 12,
      color: Colors.grey[700],
    ),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: earthBrown,
    foregroundColor: Colors.white,
    elevation: 2,
    titleTextStyle: GoogleFonts.poppins(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
  ),
  cardTheme: CardThemeData(
    color: Colors.white,
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  useMaterial3: true,
);

// Legacy colors for backward compatibility
const Color batikBeige = nusantaraBeige;
const Color jetBlack = deepTeak;
const Color oldGold = softGold;
const Color terracotta = earthBrown;
