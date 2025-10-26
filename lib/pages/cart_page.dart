import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../data/cart.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  double get totalPrice {
    double total = 0;
    for (final cartItem in cartItems) {
      final product = cartItem.keys.first;
      final quantity = cartItem.values.first;
      total += product.price * quantity;
    }
    return total;
  }

  void removeItem(int index) {
    setState(() {
      cartItems.removeAt(index);
    });
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
                      final cartItem = cartItems[index];
                      final product = cartItem.keys.first;
                      final quantity = cartItem.values.first;

                      return Card(
												clipBehavior: Clip.hardEdge,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        child: Slidable(
													endActionPane: ActionPane(
														motion: const BehindMotion(),
														extentRatio: 0.35,
														children: [
															SlidableAction(
																onPressed: (context) {
																	removeItem(index);
																},
																backgroundColor: Colors.red,
															  foregroundColor: Colors.white,
																icon: Icons.delete,
																label: 'Delete',
																flex: 2,
															),
														]
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
																				style: TextStyle(
																					fontSize: 14,
																					fontWeight: FontWeight.bold,
																					color: Theme.of(context).colorScheme.onSurface,
																				),
																				maxLines: 2,
																				overflow: TextOverflow.ellipsis,
																			),
																			Row(
																				mainAxisAlignment: MainAxisAlignment.spaceBetween,
																				children: [
																					Text(
																						"RM ${product.price.toStringAsFixed(2)}",
																						style: TextStyle(
																							color: Theme.of(context).colorScheme.primary,
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
																													cartItems[index] = { product: quantity - 1 };
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
																										cartItems[index] = { product: quantity + 1 };
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
												),
                      );
                    },
                  ),
                ),

								_buildCheckoutBar(context),

              ],
            ),
    );
  }


	Widget _buildCheckoutBar(BuildContext context) {
		return Container(
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
                  content: Text("Checkout Successful!"),
                ),
              );
            },
            child: const Text("Checkout"),
          ),
        ],
      ),
    );
	}
}

