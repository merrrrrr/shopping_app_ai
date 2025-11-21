import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app_ai/firebase_options.dart';
import 'package:shopping_app_ai/pages/login_page.dart';
import 'package:shopping_app_ai/providers/cart_provider.dart';
import 'package:shopping_app_ai/providers/favourite_provider.dart';
import 'package:shopping_app_ai/widgets/bottom_nav_bar.dart';

void main() async{
	WidgetsFlutterBinding.ensureInitialized();
	await Firebase.initializeApp(
		options: DefaultFirebaseOptions.currentPlatform
	);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  static const Color _lightPrimary = Color(0xFF0790E8); 
  static const Color _lightSecondary = Color(0xFF96A7BD);
  static const Color _lightTextPrimary = Color(0xFF1B263B);
  static const Color _lightTextSecondary = Color(0xFF415A77);
  static const Color _lightBackground = Color(0xFFF8F9FA);
  static const Color _lightSurface = Color(0xFFFFFFFF);


  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => FavouriteProvider()),
      ],
			child: MaterialApp(
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
			
					appBarTheme: const AppBarTheme(
						backgroundColor: _lightBackground,
						foregroundColor: _lightTextPrimary,
						elevation: 0,
					),
			
					bottomNavigationBarTheme: const BottomNavigationBarThemeData(
						backgroundColor: _lightSurface,
						selectedItemColor: _lightPrimary,
						unselectedItemColor: _lightSecondary,
						elevation: 8,
					),
			
					cardTheme: CardThemeData(
						color: _lightSurface,
						shadowColor: _lightTextPrimary.withAlpha(50),
						elevation: 1,
						surfaceTintColor: Colors.transparent,
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
			
					textTheme: const TextTheme(
						bodyLarge: TextStyle(color: _lightTextPrimary),
						bodyMedium: TextStyle(color: _lightTextPrimary),
						bodySmall: TextStyle(color: _lightTextSecondary),
						titleLarge: TextStyle(color: _lightTextPrimary, fontWeight: FontWeight.bold),
						titleMedium: TextStyle(color: _lightTextPrimary, fontWeight: FontWeight.bold),
						titleSmall: TextStyle(color: _lightTextSecondary),
					),
				),
				
				themeMode: ThemeMode.light,
				debugShowCheckedModeBanner: false,
				// home: const BottomNavBar(),
				home: StreamBuilder(
					stream: FirebaseAuth.instance.authStateChanges(),
					builder:(context, snapshot) {
						if (snapshot.connectionState == ConnectionState.waiting) {
							return Center(
								child: CircularProgressIndicator()
							);
						}
	
						if (snapshot.hasData) {
							return const BottomNavBar();
						}
							
						return const LoginPage();
					},
				)
			),
		);
  }
}