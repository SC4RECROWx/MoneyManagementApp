import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.teal,
    textTheme: GoogleFonts.interTextTheme().copyWith(
      displaySmall: TextStyle(
        color: Colors.black54,
        fontSize: 8,
        fontWeight: FontWeight.w400,
      ),
      headlineSmall: TextStyle(
        color: Colors.black87,
        fontSize: 8,
        fontWeight: FontWeight.w500,
      ),
    ),

    dropdownMenuTheme: DropdownMenuThemeData(
      textStyle: GoogleFonts.inter(
        color: Colors.black87,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.teal, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.teal, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.black26, width: 1),
        ),
        filled: true,
        fillColor: const Color(0xFFF6F8FB),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        hintStyle: GoogleFonts.inter(color: Colors.black54, fontSize: 15),
        labelStyle: GoogleFonts.inter(color: Colors.black87, fontSize: 15),
      ),
      menuStyle: MenuStyle(
        backgroundColor: WidgetStateProperty.all(const Color(0xFFFFFFFF)),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        elevation: WidgetStateProperty.all(6),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        ),
        shadowColor: WidgetStateProperty.all(Colors.black12),
      ),
    ),
    scaffoldBackgroundColor: const Color(0xFFF6F8FB),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue).copyWith(
      primary: const Color(0xFF43A6A5), // Primary color updated
      secondary: const Color(0xFF4A5568),
      surface: const Color(0xFFFFFFFF),
      error: const Color(0xFFB00020),
      onError: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: const TextStyle(
          fontSize: 16,
          // fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),

    iconTheme: const IconThemeData(color: Colors.white),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF43A6A5), // Primary color updated
      elevation: 0,
      titleTextStyle: GoogleFonts.roboto(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFF6F8FB),
      labelStyle: const TextStyle(color: Colors.black87),
      hintStyle: const TextStyle(color: Colors.black54),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: const Color(0xFF43A6A5), // Primary color updated
      unselectedItemColor: Colors.grey,
      showSelectedLabels: true,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.teal,
    scaffoldBackgroundColor: const Color(0xFF181A20),
    colorScheme: ColorScheme.dark().copyWith(
      primary: const Color(0xFF43A6A5), // Primary color updated
      secondary: const Color(0xFF4A5568),
      surface: const Color(0xFF232B47),
      error: const Color(0xFFB00020),
      onError: Colors.white,
    ),
    textTheme: GoogleFonts.robotoTextTheme(ThemeData.dark().textTheme),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF43A6A5), // Primary color updated
      elevation: 0,
      titleTextStyle: GoogleFonts.roboto(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF232B47),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF232B47),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      labelStyle: const TextStyle(color: Colors.white70),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: const Color(0xFF232B47),
      selectedItemColor: const Color(0xFF43A6A5), // Primary color updated
      unselectedItemColor: Colors.grey[400],
      showSelectedLabels: true,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
  );
}
