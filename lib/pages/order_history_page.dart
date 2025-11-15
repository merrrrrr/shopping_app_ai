import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopping_app_ai/models/purchase_order.dart';
import 'package:shopping_app_ai/services/order_service.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
	OrderService orderService = OrderService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History'),
      ),
      body: FutureBuilder<List<PurchaseOrder>>(
        future: orderService.getAllOrders(),
        builder: (context, snapshot) {

          final orders = snapshot.data ?? [];
					debugPrint('Snapshot: ${snapshot.data}');
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              return Card(
                child: Text('Order ${index + 1}'),
              );
            },
          );
        },
      ),
    );
  }

}
