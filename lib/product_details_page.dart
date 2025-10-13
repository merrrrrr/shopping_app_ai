import 'package:flutter/material.dart';
import '../models/product.dart';
import '../data/cart.dart';
import '../data/favourite.dart';

class ProductDetailsPage extends StatefulWidget {
  final Product product;
  
  const ProductDetailsPage({super.key, required this.product});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int quantity = 1;

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
												children: widget.product.images.map((image) {
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
														widget.product.name,
														style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
													),
														
													const SizedBox(height: 8),
														
													Text(
														"RM ${widget.product.price.toStringAsFixed(2)}",
														style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.cyan[500]),
													),
														
													const SizedBox(height: 8),
													
													Text("Sales: ${widget.product.sales}"),
														
													
													const SizedBox(height: 32),
														
													Divider(color: Colors.grey),
														
													const Text("Product Description", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
														
													const SizedBox(height: 16),
														
													Text(
														style: const TextStyle(height: 1.75),
														widget.product.description == "" ? "No description available." : widget.product.description,
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
											setState(() {
												if (favouriteProductIds.contains(widget.product.id)) {
													favouriteProductIds.remove(widget.product.id);
												} else {
													favouriteProductIds.add(widget.product.id);
												}
											});
										},
										style: ButtonStyle(
											splashFactory: NoSplash.splashFactory
										),
										icon: Icon(
											favouriteProductIds.contains(widget.product.id)
												? Icons.favorite
												: Icons.favorite_border,
											color: favouriteProductIds.contains(widget.product.id)
												? Colors.red
												: Colors.grey,
										),
									),
								),
							),

							Positioned(
								top: 16,
								left: 16,
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
											Navigator.pop(context);
										},
										style: ButtonStyle(
											splashFactory: NoSplash.splashFactory
										),
										icon: const Icon(Icons.arrow_back),
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
									child: Row(
									  children: [
									    Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            cartItems.add({widget.product: quantity});
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text("Add to Cart"),
                        ),
                      ),
                      Row(
												children: [
													IconButton(
														icon: const Icon(Icons.remove_circle_outline),
														onPressed: quantity > 1
																? () {
																		setState(() {
																			quantity -= 1;
																		});
																	}
																: null,
													),
													Text(
														quantity.toString(),
														style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
													),
													IconButton(
														icon: const Icon(Icons.add_circle_outline),
														onPressed: () {
															setState(() {
																quantity += 1;
															});
														},
													),
												],
											),
									  ],
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
