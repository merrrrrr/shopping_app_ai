import 'package:flutter/material.dart';
import '../models/product.dart';
import '../data/cart.dart'; // import global cartItems

class ProductDetailsPage extends StatelessWidget {
  final Product product;

  const ProductDetailsPage({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
				child: SingleChildScrollView(
					padding: const EdgeInsets.only(bottom: 48),
					child: Column(
						crossAxisAlignment: CrossAxisAlignment.start,
						children: [
							SizedBox(
								height: 400,
								child: PageView(
									children: product.images.map((image) {
										return Image.asset(image, fit: BoxFit.contain);
									}).toList(),
								),
							),

							const SizedBox(height: 16),

							Padding(
								padding: const EdgeInsets.symmetric(horizontal: 16),
								child: Column(
									crossAxisAlignment: CrossAxisAlignment.start,
									children: [
										Text(
											product.name,
											style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
										),
											
										const SizedBox(height: 8),
											
										Text(
											"RM ${product.price.toStringAsFixed(2)}",
											style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
										),
											
										const SizedBox(height: 8),
										
										Text("Sales: ${product.sales}"),
											
										
										const SizedBox(height: 32),
											
										Divider(color: Colors.grey),
											
										const Text("Product Description", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
											
										const SizedBox(height: 16),
											
										Text(
											style: const TextStyle(height: 1.75),
											product.description == "" ? "No description available." : product.description,
										),
									],
								),
							),
						],
					),
				),
			),
      bottomNavigationBar: SafeArea(
				child: Container(
					padding: const EdgeInsets.all(12),
					decoration: BoxDecoration(
						color: Colors.white,
						boxShadow: [
							BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, -2)),
						],
					),
					child: Row(
						children: [
							Expanded(
								child: ElevatedButton(
									onPressed: () {
										cartItems.add(product); // 🛒 Add to global cart
										ScaffoldMessenger.of(context).showSnackBar(
											const SnackBar(content: Text("Added to Cart")),
										);
													
									},
									child: const Text("Add to Cart"),
								),
							),
							const SizedBox(width: 12),
							Expanded(
								child: ElevatedButton(
									onPressed: () {
										// Later: direct checkout logic
										ScaffoldMessenger.of(context).showSnackBar(
											const SnackBar(content: Text("Proceed to Buy Now")),
										);
									},
									style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
									child: const Text("Buy Now"),
								),
							),
						],
					),
				),
			),
    );
  }
}
