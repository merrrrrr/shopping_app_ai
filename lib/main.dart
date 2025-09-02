import 'package:flutter/material.dart';
import 'package:shopping_app_ai/bottom_nav_bar.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
			debugShowCheckedModeBanner: false,
      home: BottomNavBar(),
    );
  }
}
