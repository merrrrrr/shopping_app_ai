import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shopping_app_ai/data/products_data.dart';
import 'package:shopping_app_ai/models/order_item.dart';
import 'package:shopping_app_ai/models/product.dart';
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
		return _firestore.collection('users').doc(currentUserId).collection('orders');
	}

	Future<String> createOrderFromCart(List<Map<Product, int>> cartItems, {double shippingFee = 5.0}) async {
		try {
			if (cartItems.isEmpty) {
        throw Exception('Cart is empty');
      }

			double subtotal = 0.0;
			for (var item in cartItems) {
				Product product = item.keys.first;
				double price = product.price;
				int quantity = item.values.first;
				subtotal += price * quantity;
			}

			final address = await currentUserAddress;

			final order = PurchaseOrder(
        userId: currentUserId,
        subtotal: subtotal,
        shippingFee: shippingFee,
        totalAmount: subtotal + shippingFee,
        shippingAddress: address,
        status: 'Pending',
        createdAt: DateTime.now(),
      );

			final orderDoc = await _ordersCollection.add(order.toMap());
			final orderId = orderDoc.id;

			final itemsCollection = orderDoc.collection('items');
			for (var item in cartItems) {
				Product product = item.keys.first;
				int quantity = item.values.first;

				final orderItem = OrderItem(
          productId: product.id,
          productName: product.name,
          imageUrl: product.images.first,
          priceAtPurchase: product.price,
          quantity: quantity,
				);

				await itemsCollection.add(orderItem.toMap());
			}

			debugPrint('Order created successfully');
			return orderId;
		} catch(e) {
			debugPrint('Error creating order from cart: $e');
			throw Exception('Failed to create order from cart');
		}
	}

	Future<List<PurchaseOrder>> getAllOrders() async {
		try {
			QuerySnapshot snapshot = await _ordersCollection.get();
			List<PurchaseOrder> orders = snapshot.docs.map((doc) {
				return PurchaseOrder.fromMap(doc.data() as Map<String, dynamic>);
			}).toList();
			return orders;
		} catch(e) {
			debugPrint('Error retrieving orders: $e');
			throw Exception('Failed to get orders');
		}
	}

	Future<PurchaseOrder?> getOrderById(String orderId) async {
		try {
			DocumentSnapshot doc = await _ordersCollection.doc(orderId).get();
			debugPrint('Retrieved order: ${doc.data()}');		
			return PurchaseOrder.fromMap(doc.data() as Map<String, dynamic>);
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