import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app_ai/pages/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
	TextEditingController emailController = TextEditingController();
	TextEditingController passwordController = TextEditingController();

	Future<void> loginUser() async {
		try {
			await FirebaseAuth.instance.signInWithEmailAndPassword(
				email: emailController.text.trim(),
				password: passwordController.text.trim()
			);

		} on FirebaseAuthException catch (e) {
			if (!mounted) return;
			showDialog(context: context, builder: (context) {
				return AlertDialog(
					title: Text("Login Failed"),
					content: Text(e.message ?? "An unknown error occurred."),
					actions: [
						TextButton(
							onPressed: () {
								Navigator.of(context).pop();
							},
							child: Text("OK"),
						),
					],
				);
			});
		}
	}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
			body: Padding(
				padding: const EdgeInsets.all(16.0),
				child: Center(
					child: Column(
						mainAxisAlignment: MainAxisAlignment.center,
						children: [
							Text(
								"Jiji",
								style: TextStyle(
									fontSize: 32,
									fontWeight: FontWeight.bold,
									color: Theme.of(context).colorScheme.primary,
								),
							),

							SizedBox(height: 24),

							TextField(
								controller: emailController,
								decoration: InputDecoration(
									labelText: "Email",
									border: OutlineInputBorder(
										borderRadius: BorderRadius.circular(8),
									),
								),
							),

							SizedBox(height: 16),
				
							TextField(
								controller: passwordController,
								decoration: InputDecoration(
									labelText: "Password",
									border: OutlineInputBorder(
										borderRadius: BorderRadius.circular(8),
									)
								),
								obscureText: true,
							),

							SizedBox(height: 16),

							ElevatedButton(
								onPressed: () {
									loginUser();
								},
								style: ElevatedButton.styleFrom(
									minimumSize: Size(double.infinity, 48),
									shape: RoundedRectangleBorder(
										borderRadius: BorderRadius.circular(8),
									),
								),
								child: Text(
									"Login",
									style: TextStyle(
										fontSize: 16,
										fontWeight: FontWeight.bold,
									),
								),
							),

							SizedBox(height: 24),

							Row(
								mainAxisAlignment: MainAxisAlignment.center,
							  children: [
							    Text("New user? Click"),
									GestureDetector(
										child: Text(" here ",
											style: TextStyle(
												color: Theme.of(context).colorScheme.primary,
											),
										),
										onTap: () {
											Navigator.push(
												context,
												MaterialPageRoute(
													builder: (context) => RegisterPage(),
												),
											);
										},
									),
									Text("to register."),
							  ],
							),

							SizedBox(height: 8),

							GestureDetector(
								child: Text("Reset Password",
									style: TextStyle(
										color: Theme.of(context).colorScheme.primary,
									),
								),
								onTap: () {
									Navigator.push(
										context,
										MaterialPageRoute(
											builder: (context) => RegisterPage(),
										),
									);
								},
							),

				
							
						],
					),
				),
			),
		);
  }
}