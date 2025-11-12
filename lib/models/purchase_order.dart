import 'package:cloud_firestore/cloud_firestore.dart';

class PurchaseOrder {
  final String? id;
  final String userId;
  final double subtotal;
  final double shippingFee;
  final double totalAmount;
  final String shippingAddress;
  final String status;
  final DateTime createdAt;

  PurchaseOrder({
    this.id,
    required this.userId,
    required this.subtotal,
    required this.shippingFee,
    required this.totalAmount,
    required this.shippingAddress,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'subtotal': subtotal,
      'shippingFee': shippingFee,
      'totalAmount': totalAmount,
      'shippingAddress': shippingAddress,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory PurchaseOrder.fromMap(Map<String, dynamic> map, {String? docId}) {
    return PurchaseOrder(
      id: docId,
      userId: map['userId'],
      subtotal: (map['subtotal'] as num).toDouble(),
      shippingFee: (map['shippingFee'] as num).toDouble(),
      totalAmount: (map['totalAmount'] as num).toDouble(),
      shippingAddress: map['shippingAddress'],
      status: map['status'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
}

