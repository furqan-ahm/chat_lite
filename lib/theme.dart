import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'constants/colors.dart';

ThemeData theme = ThemeData(
  // colorTheme

  splashColor: primaryColor.withOpacity(0.1),
  primaryColor: primaryColor,
  scaffoldBackgroundColor: const Color(0xffEBF4FA),
  colorScheme: ColorScheme.fromSwatch().copyWith(
    //the scroll overflow color is this one. (secondary)
    secondary: primaryColor.withOpacity(0.1),
    primary: primaryColor,
  ),
  //textTheme

  textTheme: TextTheme(
    headlineLarge: GoogleFonts.urbanist(
      textStyle: const TextStyle(
        fontSize: 32,
        color: bodyTextColor,
        fontWeight: FontWeight.w600,
      ),
    ),
    headlineMedium: GoogleFonts.urbanist(
      textStyle: const TextStyle(
        fontSize: 24,
        color: bodyTextColor,
        fontWeight: FontWeight.w500,
      ),
    ),
    headlineSmall: GoogleFonts.urbanist(
      textStyle: const TextStyle(
        fontSize: 16,
        color: bodyTextColor,
        fontWeight: FontWeight.w500,
      ),
    ),
    bodyLarge: GoogleFonts.urbanist(
      textStyle: const TextStyle(
        fontSize: 28,
        color: bodyTextColor,
        fontWeight: FontWeight.w500,
      ),
    ),
    bodyMedium: GoogleFonts.urbanist(
      textStyle: const TextStyle(
        fontSize: 13,
        color: bodyTextColor,
        fontWeight: FontWeight.w500,
      ),
    ),
    bodySmall: GoogleFonts.urbanist(
      textStyle: const TextStyle(
        fontSize: 14,
        color: bodyTextColor,
        fontWeight: FontWeight.w500,
      ),
    ),
    labelSmall: GoogleFonts.urbanist(
      textStyle: const TextStyle(
        fontSize: 11,
        color: Colors.white,
        fontWeight: FontWeight.w400,
      ),
    ),
  ),
);