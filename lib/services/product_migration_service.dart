import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../data/products_data.dart';

class ProductMigrationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> migrateProductsToFirestore() async {
    try {
      final batch = _firestore.batch();
      
      for (var product in products) {
        final docRef = _firestore.collection('products').doc(product.id);
        
        batch.set(docRef, {
          'name': product.name,
          'price': product.price,
          'salesCount': product.sales,
          'stockCount': product.quantity,
          'description': product.description,
          'images': product.images,
          'category': product.category,
          'brand': product.brand,
          'rating': product.rating,
        });
      }
      
      await batch.commit();
      debugPrint('Successfully migrated ${products.length} products to Firestore');
    } catch (e) {
      debugPrint('Error migrating products: $e');
      rethrow;
    }
  }

}
