import 'package:flutter/material.dart';
import 'package:shopping_app_ai/widgets/bottom_nav_bar.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  // --- IMPROVED Light Theme Color Palette ---
  // All necessary colors are now defined here for easy maintenance.
  static const Color _lightPrimary = Color(0xFF0790E8);      // A vibrant, clear blue for buttons and accents
  static const Color _lightSecondary = Color(0xFF96A7BD);    // A muted, greyish-blue for inactive icons
  static const Color _lightTextPrimary = Color(0xFF1B263B);  // A very dark slate blue for main text (instead of pure black)
  static const Color _lightTextSecondary = Color(0xFF415A77); // A mid-toned slate blue for subtitles
  static const Color _lightBackground = Color(0xFFF8F9FA);  // A clean, off-white background
  static const Color _lightSurface = Color(0xFFFFFFFF);      // Pure white for elevated surfaces like cards


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: _lightBackground,

        colorScheme: const ColorScheme.light(
          primary: _lightPrimary,
          secondary: _lightSecondary,
          surface: _lightSurface,
          onSurface: _lightTextPrimary,
          onPrimary: Colors.white,
        ),

        // FIX 3: AppBar background now matches the scaffold for a seamless look.
        appBarTheme: const AppBarTheme(
          backgroundColor: _lightBackground,
          foregroundColor: _lightTextPrimary,
          elevation: 0,
        ),

        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: _lightSurface, // Uses surface color from palette
          selectedItemColor: _lightPrimary,
          unselectedItemColor: _lightSecondary,
          elevation: 8,
        ),

        cardTheme: CardThemeData(
          color: _lightSurface, // Uses surface color from palette
          // FIX 1: Shadow color is now derived from a palette color for consistency.
          shadowColor: _lightTextPrimary.withAlpha(50),
          elevation: 1, // A more subtle elevation is often cleaner
          surfaceTintColor: Colors.transparent, // Important for maintaining pure card color in M3
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: _lightPrimary,
            foregroundColor: Colors.white,
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),

        // FIX 2: Added a consistent TextTheme using the palette colors.
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: _lightTextPrimary),
          bodyMedium: TextStyle(color: _lightTextPrimary),
          bodySmall: TextStyle(color: _lightTextSecondary),
          titleLarge: TextStyle(color: _lightTextPrimary, fontWeight: FontWeight.bold),
          titleMedium: TextStyle(color: _lightTextPrimary, fontWeight: FontWeight.bold),
          titleSmall: TextStyle(color: _lightTextSecondary),
        ),

      ),
      
      themeMode: ThemeMode.light, // Set to light since there is no dark theme
      debugShowCheckedModeBanner: false,
      home: const BottomNavBar(),
    );
  }
}