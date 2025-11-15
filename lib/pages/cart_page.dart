import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shopping_app_ai/models/order_item.dart';
import 'package:shopping_app_ai/models/purchase_order.dart';
import 'package:shopping_app_ai/services/order_service.dart';
import '../data/cart.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
	final OrderService orderService = OrderService();

  void removeItem(int index) {
    setState(() {
      cartItems.removeAt(index);
    });
	}

	void updateQuantity(int index, int newQuantity) {
    setState(() {
      if (newQuantity <= 0) {
        removeItem(index);
        return;
      }
      
      final item = cartItems[index];
      cartItems[index] = OrderItem(
        productId: item.productId,
        productName: item.productName,
        imageUrl: item.imageUrl,
        price: item.price,
        quantity: newQuantity,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Shopping Cart")),
      body: cartItems.isEmpty ? const Center(
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
                OrderItem cartItem = cartItems[index];

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
																					onPressed: cartItems[index].quantity > 1 ? () {
																						updateQuantity(index, cartItems[index].quantity - 1);
																					} : null,
																				),
																				Text(
																					cartItems[index].quantity.toString(),
																					style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
																				),
																				IconButton(
																					icon: const Icon(Icons.add_circle_outline),
																					onPressed: () {
																						updateQuantity(index, cartItems[index].quantity + 1);
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
		double subtotal = orderService.calculateSubtotal(cartItems);
		double totalPrice = orderService.calculateTotal(subtotal);
		
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
            onPressed: cartItems.isEmpty ? null : () async {
							final orderId = await orderService.createOrderFromCart(cartItems);
							cartItems.clear();
              showDialog(context: context, builder: (context) {
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
							});
            },
            child: const Text("Checkout"),
          )
        ],
      ),
    );
	}
}

