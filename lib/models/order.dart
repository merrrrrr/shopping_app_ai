import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopping_app/models/item.dart';

class Order {
  final String? id;
  final String userId;
	final List<Item> items;
  final double subtotal;
  final double shippingFee;
  final double totalAmount;
  final String shippingAddress;
  final DateTime createdAt;

  Order({
    this.id,
    required this.userId,
		required this.items,
    required this.subtotal,
    required this.shippingFee,
    required this.totalAmount,
    required this.shippingAddress,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
			'items': items.map((item) => item.toMap()).toList(),
      'subtotal': subtotal,
      'shippingFee': shippingFee,
      'totalAmount': totalAmount,
      'shippingAddress': shippingAddress,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory Order.fromMap(Map<String, dynamic> map, {String? docId}) {
    return Order(
      id: docId,
      userId: map['userId'],
			items: (map['items'] as List).map((item) => Item.fromMap(item)).toList(),
      subtotal: (map['subtotal'] as num).toDouble(),
      shippingFee: (map['shippingFee'] as num).toDouble(),
      totalAmount: (map['totalAmount'] as num).toDouble(),
      shippingAddress: map['shippingAddress'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
}

