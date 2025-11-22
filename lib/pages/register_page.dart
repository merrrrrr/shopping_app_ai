import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/pages/address_form_page.dart';
import 'package:shopping_app/services/user_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
	TextEditingController nameController = TextEditingController();
	TextEditingController emailController = TextEditingController();
	TextEditingController phoneNumberController = TextEditingController();
	TextEditingController passwordController = TextEditingController();
	TextEditingController confirmPasswordController = TextEditingController();

	Future<void> registerUser() async {
		try {
			if (passwordController.text != confirmPasswordController.text) {
				if (!mounted) return;
				showDialog(
					context: context,
					builder: (context) => AlertDialog(
						title: const Text("Password Mismatch"),
						content: const Text("Password and Confirm Password do not match."),
						actions: [
							TextButton(
								onPressed: () => Navigator.of(context).pop(),
								child: const Text("OK"),
							),
						],
					),
				);
				return;
			}

			await UserService().createUser(
				nameController.text.trim(),
				emailController.text.trim(),
				phoneNumberController.text.trim(),
				passwordController.text.trim()
			);

			if (!mounted) return;
			showDialog(context: context, builder: (context) {
				return AlertDialog(
					title: Text("Registration Successful"),
					content: Text('Registration successful! Please login with your credentials.'),
					actions: [
						TextButton(
							onPressed: () {
								Navigator.of(context).pop();
								Navigator.of(context).pop();
								Navigator.push(context, MaterialPageRoute(
									builder: (context) => AddressFormPage()
								));
							},
							child: Text("OK"),
						),
					],
				);
			});

		} on FirebaseAuthException catch (e) {
			if (!mounted) return;
			showDialog(context: context, builder: (context) {
				return AlertDialog(
					title: Text("Registration Failed"),
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
							controller: nameController,
							decoration: InputDecoration(
								labelText: "Name",
								border: OutlineInputBorder(
									borderRadius: BorderRadius.circular(8),
								),
							),
						),

						SizedBox(height: 16),

						TextField(
							controller: emailController,
							decoration: InputDecoration(
								labelText: "Email",
								border: OutlineInputBorder(
									borderRadius: BorderRadius.circular(8),
								),
							),
							keyboardType: TextInputType.emailAddress,
						),

						SizedBox(height: 16),

						TextField(
							controller: phoneNumberController,
							decoration: InputDecoration(
								labelText: "Phone Number",
								border: OutlineInputBorder(
									borderRadius: BorderRadius.circular(8),
								),
							),
							keyboardType: TextInputType.phone,
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
						
						TextField(
								controller: confirmPasswordController,
								decoration: InputDecoration(
									labelText: "Confirm Password",
									border: OutlineInputBorder(
										borderRadius: BorderRadius.circular(8),
									)
								),
								obscureText: true,
							),

							SizedBox(height: 16),

							ElevatedButton(
								onPressed: () {
									registerUser();
								},
								style: ElevatedButton.styleFrom(
									minimumSize: Size(double.infinity, 48),
									shape: RoundedRectangleBorder(
										borderRadius: BorderRadius.circular(8),
									),
								),
								child: Text(
									"Register",
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
							    Text("Already have an account? "),
							    GestureDetector(
										child: Text("Login",
											style: TextStyle(
												color: Theme.of(context).colorScheme.primary,
											),
										),
										onTap: () {
											Navigator.pop(context);
											},
									)
							  ],
							),
						],
					),
				),
			),
		);
  }
}