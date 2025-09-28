import 'package:flutter/material.dart';
import 'data/cart.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // Track quantity for each cart item
  final Map<int, int> quantities = {};

  @override
  void initState() {
    super.initState();
    // Initialize quantities to 1 for each item
    for (int i = 0; i < cartItems.length; i++) {
      quantities[i] = 1;
    }
  }

  double get totalPrice {
    double total = 0;
    for (int i = 0; i < cartItems.length; i++) {
      total += cartItems[i].price * (quantities[i] ?? 1);
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Shopping Cart")),
      body: cartItems.isEmpty
          ? const Center(
              child: Text(
                "Your cart is empty",
                style: TextStyle(fontSize: 18),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final product = cartItems[index];
                      final quantity = quantities[index] ?? 1;
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  product.images.first,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Row(
																			mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "RM ${product.price.toStringAsFixed(2)}",
                                          style: const TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),

																				Row(
																					children: [
																						IconButton(
																							icon: const Icon(Icons.remove_circle_outline),
																							onPressed: quantity > 1
																									? () {
																											setState(() {
																												quantities[index] = quantity - 1;
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
																									quantities[index] = quantity + 1;
																								});
																							},
																						),
																					],
																				),
                                      ],
                                    ),
                                    
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Bottom total price and checkout button
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, -2),
                      )
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total: RM ${totalPrice.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Checkout feature coming soon!"),
                            ),
                          );
                        },
                        child: const Text("Checkout"),
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
