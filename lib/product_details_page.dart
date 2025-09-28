import 'package:flutter/material.dart';
import '../models/product.dart';
import '../data/cart.dart'; // import global cartItems

class ProductDetailsPage extends StatelessWidget {
  final Product product;

  const ProductDetailsPage({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
				child: SafeArea(
								child: Stack(
									children: [
										SingleChildScrollView(
											padding: const EdgeInsets.only(bottom: 80),
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
																	style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.cyan[500]),
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
				
										Positioned(
											top: 16,
											right: 16,
											child: Container(
												decoration: BoxDecoration(
													color: Colors.white,
													borderRadius: BorderRadius.circular(25),
													boxShadow: [
														BoxShadow(
															color: Colors.grey.withAlpha(125),
															blurRadius: 5,
															offset: const Offset(0, 3),
														),
													],
												),
												child: IconButton(
													onPressed: () {
														
													},
													style: ButtonStyle(
														splashFactory: NoSplash.splashFactory
													),
													icon: const Icon(Icons.favorite_border),
												),
											),
										),
				
										Positioned(
											bottom: 0,
											left: 0,
											right: 0,
											child: Container(
												padding: const EdgeInsets.all(12),
												decoration: BoxDecoration(
													color: Colors.white
												),
												child: ElevatedButton(
													onPressed: () {
														cartItems.add(product);
													},
													style: ElevatedButton.styleFrom(
														padding: const EdgeInsets.symmetric(vertical: 16),
														shape: RoundedRectangleBorder(
															borderRadius: BorderRadius.circular(12),
														),
													),
													child: const Text("Add to Cart"),
												),
											)
										),
									]
								),
							),
			),
    
    );
  }
}
