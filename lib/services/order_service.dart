import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shopping_app_ai/models/item.dart';
import 'package:shopping_app_ai/models/order.dart';

class OrderService {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

	String get currentUserId {
		final user = _auth.currentUser;
		if (user == null) {
			throw Exception('No authenticated user found.');
		}
		return user.uid;
	}

	Future<String> get currentUserAddress async {
		DocumentSnapshot snapshot = await _firestore.collection('users').doc(currentUserId).get();
		final data = snapshot.data() as Map<String, dynamic>?;
		final String address = data?['address'];
		if (address.isEmpty) {
			throw Exception('Address not found.');
		}
		return address;
	}

	CollectionReference get _ordersCollection {
		return _firestore.collection('orders');
	}

	double calculateSubtotal(List<Item> cartItems) {
		if (cartItems.isEmpty) {
      throw Exception('Cart is empty');
    }

		double subtotal = 0.0;
		for (var item in cartItems) {
			subtotal += item.price * item.quantity;
		}

		return double.parse(subtotal.toStringAsFixed(2));
	}

	double calculateTotal(double subtotal, {double shippingFee = 5.0}) {
		double totalPrice = subtotal + shippingFee;
		return double.parse(totalPrice.toStringAsFixed(2));
	}

	Future<String> createOrderFromCart(List<Item> cartItems, {double shippingFee = 5.0}) async {
		try {
			final address = await currentUserAddress;

			final subtotal = calculateSubtotal(cartItems);
    	final totalAmount = calculateTotal(subtotal, shippingFee: shippingFee);

			final order = Order(
        userId: currentUserId,
				items: cartItems,
        subtotal: subtotal,
        shippingFee: shippingFee,
        totalAmount: totalAmount,
        shippingAddress: address,
        createdAt: DateTime.now(),
      );

			await _updateProductInventory(cartItems);

			DocumentReference doc = await _ordersCollection.add(order.toMap());

			debugPrint('Order created successfully');
			return doc.id;
		} catch(e) {
			debugPrint('Error creating order from cart: $e');
			throw Exception('Failed to create order from cart');
		}
	}

	Future<void> _updateProductInventory(List<Item> cartItems) async {
		try {
			WriteBatch batch = _firestore.batch();

			for (var item in cartItems) {
        DocumentReference productRef = _firestore.collection('products').doc(item.productId);

        batch.update(productRef, {
          'salesCount': FieldValue.increment(item.quantity),
          'stockCount': FieldValue.increment(-item.quantity),
        });
      }

			await batch.commit();
			debugPrint('Product inventory updated successfully.');
		} catch(e) {
			debugPrint('Error updating product inventory: $e');
			throw Exception('Failed to update product inventory.');
		}
	}

	Future<List<Order>> getAllOrders() async {
		try {
			QuerySnapshot snapshot = await _ordersCollection
          .where('userId', isEqualTo: currentUserId)
          .get();
			List<Order> orders = snapshot.docs.map((doc) {
				return Order.fromMap(
					doc.data() as Map<String, dynamic>,
					docId: doc.id
				);
			}).toList();

			debugPrint('Retrieved ${orders.length} orders for user $currentUserId');
			return orders;
		} catch(e) {
			debugPrint('Error retrieving orders: $e');
      debugPrint('Error type: ${e.runtimeType}');
      debugPrint('Stack trace: ${StackTrace.current}');
			throw Exception('Failed to get orders');
		}
	}
}