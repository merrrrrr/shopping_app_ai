import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../models/product.dart';
import '../../data/cart.dart';
import '../../data/favourite.dart';

class ProductDetailsPage extends StatefulWidget {
  final Product product;
  
  const ProductDetailsPage({super.key, required this.product});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int quantity = 1;

	final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
			bottomNavigationBar: SafeArea(child: _buildAddToCartBar(context)),
      body: SafeArea(
        child: Stack(
          children: [
						SingleChildScrollView(
							physics: const ClampingScrollPhysics(),
							padding: const EdgeInsets.only(bottom: 80),
							child: Column(
								crossAxisAlignment: CrossAxisAlignment.start,
								children: [
									SizedBox(
										height: 400,
										child: Stack(
											alignment: Alignment.bottomCenter,
											children: [

												// ========= IMAGE SECTION ==========
												PageView(
													controller: _pageController,
													children: widget.product.images.map((image) {
														return Image.asset(image, fit: BoxFit.contain);
													}).toList(),
												),

												// ========= IMAGE INDICATOR SECTION ==========
												Padding(
													padding: const EdgeInsets.only(bottom: 16.0),
													child: SmoothPageIndicator(
														controller: _pageController,
														count: widget.product.images.length,
														effect: WormEffect(
															dotHeight: 10,
															dotWidth: 10,
															activeDotColor: Theme.of(context).colorScheme.primary,
															dotColor: Colors.grey.shade300,
														),
													),
												),
											],
										),
									),

                  const SizedBox(height: 16),

                  // ========== PRODUCT INFO SECTION ==========
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

												// Product Name
                        Text(
                          widget.product.name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                          
                        const SizedBox(height: 12),
                          
												// Price
                        Text(
                          "RM ${widget.product.price.toStringAsFixed(2)}",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                          
                        const SizedBox(height: 16),
                        
												// Sales & Rating Row
                        Row(
													children: [
														Text(
															"${widget.product.sales} sold",
															style: Theme.of(context).textTheme.bodyMedium,
														),

														const SizedBox(width: 8),
														const Text("|"),
														const SizedBox(width: 8),

														Text(
															"${widget.product.rating}",
															style: Theme.of(context).textTheme.bodyMedium
														),

														const Icon(
															Icons.star,
															color: Colors.amber,
															size: 20
														),
													],
												),
                          
                        const SizedBox(height: 24),
                          
                        const Divider(),
                        
                        const SizedBox(height: 16),
                          
                        // ========== DESCRIPTION SECTION ==========
                        Text(
                          "Product Description", 
                          style: Theme.of(context).textTheme.titleMedium
                        ),
                          
                        const SizedBox(height: 8),
                          
                        Text(
                          widget.product.description.isEmpty
														? "No description available."
														: widget.product.description,
                          style: const TextStyle(height: 1.75),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // --- FAVORITE & BACK BUTTONS ---
            _buildAppBarButtons(context),            
          ]
        ),
      ),
    );
  }
  
  Widget _buildAppBarButtons(BuildContext context) {
    return Positioned(
      top: 16,
      left: 16,
      right: 16,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // ========== BACK BUTTON ==========
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withAlpha(50),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              style: IconButton.styleFrom(splashFactory: NoSplash.splashFactory),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),

          // ========== FAVORITE BUTTON ==========
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withAlpha(50),
              shape: BoxShape.circle,
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
              style: IconButton.styleFrom(splashFactory: NoSplash.splashFactory),
              icon: Icon(
                favouriteProductIds.contains(widget.product.id)
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: favouriteProductIds.contains(widget.product.id)
                    ? Colors.red
                    : Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
	Widget _buildAddToCartBar(BuildContext context) {
		return Container(
			padding: const EdgeInsets.all(12),
			decoration: BoxDecoration(
				color: Theme.of(context).colorScheme.surface,
			),
			child: Row(
				children: [

					// ========== ADD TO CART BUTTON ==========
					Expanded(
						child: ElevatedButton(
							onPressed: () {
								final existingIndex = cartItems.indexWhere((item) => item.keys.first.id == widget.product.id);

								if (existingIndex != -1) {
									final existingProduct = cartItems[existingIndex].keys.first;
									final currentQuantity = cartItems[existingIndex].values.first;
									cartItems[existingIndex] = {existingProduct: currentQuantity + quantity};
								} else {
									cartItems.add({widget.product: quantity});
								}

								ScaffoldMessenger.of(context).showSnackBar(
									SnackBar(
										content: Text('Product added to cart successfully!'),
										duration: const Duration(milliseconds: 700),
									),
								);
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

					// ========== QUANTITY SELECTOR ==========
					Row(
						children: [
							IconButton(
								icon: const Icon(Icons.remove_circle_outline),
								onPressed: quantity > 1
								? () => setState(() {quantity -= 1;})
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
		);
	}
  
}