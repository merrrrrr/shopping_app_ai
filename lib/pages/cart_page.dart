import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app_ai/models/item.dart';
import '../providers/cart_provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Shopping Cart")),
      body: Consumer<CartProvider>(
				builder: (context, cartProvider, child) {
				  if (cartProvider.cartItems.isEmpty) {
            return const Center(
              child: Text(
                "Your cart is empty",
                style: TextStyle(fontSize: 18),
              ),
            );
          }
				
					return Column(
						children: [
							Expanded(
								child: ListView.builder(
									itemCount: cartProvider.cartItems.length,
									itemBuilder: (context, index) {
										Item cartItem = cartProvider.cartItems[index];
					
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
																			cartProvider.removeItem(index);
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
																				cartItem.imageUrl,
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
																						cartItem.productName,
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
																								"RM ${cartItem.price.toStringAsFixed(2)}",
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
																										onPressed: cartProvider.cartItems[index].quantity > 1 ? () {
																											cartProvider.updateQuantity(index, cartProvider.cartItems[index].quantity - 1);
																										} : null,
																									),
																									Text(
																										cartProvider.cartItems[index].quantity.toString(),
																										style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
																									),
																									IconButton(
																										icon: const Icon(Icons.add_circle_outline),
																										onPressed: () {
																											cartProvider.updateQuantity(index, cartProvider.cartItems[index].quantity + 1);
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
					
							_buildCheckoutBar(context, cartProvider),
					
						],
					);
				},
			),
    );
  }


	Widget _buildCheckoutBar(BuildContext context, CartProvider cartProvider) {
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
            "Total: RM ${cartProvider.total.toStringAsFixed(2)}",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          ElevatedButton(
            onPressed: cartProvider.cartItems.isEmpty ? null : () async {
							final orderId = await cartProvider.checkout();
							cartProvider.clearCart();

							if (!context.mounted) return;
              showDialog(
								context: context,
								builder: (context) {
									return AlertDialog(
										title: Text('Checkout Successful'),
										content: Text('Order placed successfully! Order ID: ${orderId.substring(0, 8)}'),
										actions: [
											TextButton(
												onPressed: () {
													Navigator.of(context).pop();
												},
												child: Text("OK"),
											),
										],
									);
								}
							);
            },
            child: const Text("Checkout"),
          )
        ],
      ),
    );
	}
}

