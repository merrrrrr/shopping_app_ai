import 'package:flutter/material.dart';
import 'package:shopping_app_ai/widgets/bottom_nav_bar.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
		scaffoldBackgroundColor: Colors.white,
		appBarTheme: const AppBarTheme(
			backgroundColor: Colors.white,
			shadowColor: Colors.grey,
		),

        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Colors.blueGrey[700],
          unselectedItemColor: Colors.grey,
        ),

				cardTheme: CardThemeData(
					color: Colors.white,
					shadowColor: Colors.grey[200],
					elevation: 2
				),

				elevatedButtonTheme: ElevatedButtonThemeData(
					style: ElevatedButton.styleFrom(
						backgroundColor: Colors.blueGrey[700],
						foregroundColor: Colors.white,
						textStyle: TextStyle(
							fontWeight: FontWeight.bold,
							fontSize: 16,
						),
					),
				),

        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const BottomNavBar(),
    );
  }
}