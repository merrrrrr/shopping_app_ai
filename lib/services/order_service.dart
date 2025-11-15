import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shopping_app_ai/models/order_item.dart';
import 'package:shopping_app_ai/models/purchase_order.dart';

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

	double calculateSubtotal(List<OrderItem> cartItems) {
		if (cartItems.isEmpty) {
      throw Exception('Cart is empty');
    }

		double subtotal = 0.0;
		for (var item in cartItems) {
			Map<String, dynamic> itemMap = item.toMap();
			double price = itemMap['price'];
			int quantity = itemMap['quantity'];
			subtotal += price * quantity;
		}

		return double.parse(subtotal.toStringAsFixed(2));
	}

	double calculateTotal(double subtotal, {double shippingFee = 5.0}) {
		double totalPrice = subtotal + shippingFee;
		return double.parse(totalPrice.toStringAsFixed(2));
	}

	Future<String> createOrderFromCart(List<OrderItem> cartItems, {double shippingFee = 5.0}) async {
		try {
			final address = await currentUserAddress;

			final subtotal = calculateSubtotal(cartItems);
    	final totalAmount = calculateTotal(subtotal, shippingFee: shippingFee);

			final order = PurchaseOrder(
        userId: currentUserId,
				items: cartItems,
        subtotal: subtotal,
        shippingFee: shippingFee,
        totalAmount: totalAmount,
        shippingAddress: address,
        createdAt: DateTime.now(),
      );

			DocumentReference doc = await _ordersCollection.add(order.toMap());
			debugPrint('Order created successfully');
			return doc.id;
		} catch(e) {
			debugPrint('Error creating order from cart: $e');
			throw Exception('Failed to create order from cart');
		}
	}

	Future<List<PurchaseOrder>> getAllOrders() async {
		try {
			QuerySnapshot snapshot = await _ordersCollection
          .where('userId', isEqualTo: currentUserId)
          .get();
			List<PurchaseOrder> orders = snapshot.docs.map((doc) {
				return PurchaseOrder.fromMap(
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

	Future<PurchaseOrder?> getOrderById(String orderId) async {
		try {
			DocumentSnapshot doc = await _ordersCollection.doc(orderId).get();
			debugPrint('Retrieved order: ${doc.data()}');
			final order = PurchaseOrder.fromMap(
				doc.data() as Map<String, dynamic>,
				docId: doc.id
			);
			if (order.userId != currentUserId) {
				return null;
			}
			return order;
		} catch(e) {
			debugPrint('Error getting order: $e');
			throw Exception('Failed to get order');
		}
	}

	Future<void> updateOrderStatus(String orderId, String newStatus) async {
    try {
      await _ordersCollection.doc(orderId).update({
        'status': newStatus,
      });
      debugPrint('Order status updated to: $newStatus');
    } catch (e) {
      debugPrint('Error updating order status: $e');
      throw Exception('Failed to update order status');
    }
  }

	Future<void> cancelOrder(String orderId) async {
    try {
      await updateOrderStatus(orderId, 'Cancelled');
    } catch (e) {
      debugPrint('Error cancelling order: $e');
      throw Exception('Failed to cancel order');
    }
  }

	Future<void> deleteOrder(String orderId) async {
		try {
			await _ordersCollection.doc(orderId).delete();
			debugPrint('Order deleted successfully.');
		} catch(e) {
			debugPrint('Error deleting order: $e');
			throw Exception('Failed to delete order');
		}
	}
}