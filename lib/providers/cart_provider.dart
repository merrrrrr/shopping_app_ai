import 'package:flutter/material.dart';
import 'package:shopping_app/models/item.dart';
import 'package:shopping_app/services/order_service.dart';

class CartProvider with ChangeNotifier {
	final List<Item> _cartItems = [];
	final OrderService _orderService = OrderService();

	List<Item> get cartItems => List.unmodifiable(_cartItems);
  
  int get itemCount => _cartItems.length;
  
  double get subtotal => _orderService.calculateSubtotal(_cartItems);
  
  double get total => _orderService.calculateTotal(subtotal);

	void addItem(Item item) {
		final existingItemIndex = _cartItems.indexWhere((cartItem) => cartItem.productId == item.productId);

		if (existingItemIndex != -1) {
			_cartItems[existingItemIndex] = Item.fromMap({
        ..._cartItems[existingItemIndex].toMap(),
        'quantity': _cartItems[existingItemIndex].quantity + item.quantity,
      });
		} else {
			_cartItems.add(item);
		}

		notifyListeners();
	}

	void removeItem(int index) {
		_cartItems.removeAt(index);
		notifyListeners();
	}

	void updateQuantity(int index, int newQuantity) {
		_cartItems[index] = Item.fromMap({
			...cartItems[index].toMap(),
      'quantity': newQuantity,
		});
		notifyListeners();
	}

	void clearCart() {
		_cartItems.clear();
		notifyListeners();
	}

	Future<String> checkout() async {
		final orderId = await _orderService.createOrderFromCart(cartItems);
		clearCart();
		return orderId;
	}
}