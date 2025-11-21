import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app_ai/data/products_data.dart';
import 'package:shopping_app_ai/providers/favourite_provider.dart';
import 'package:shopping_app_ai/widgets/product_card.dart';

class FavouritesPage extends StatelessWidget {
  const FavouritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favourites'),
        elevation: 0,
      ),
      body: Consumer<FavouriteProvider>(
        builder: (context, favouriteProvider, child) {
          if (favouriteProvider.favouriteProductIds.isEmpty) {
            return _buildEmptyState(context);
          }

          // Filter products that are in favourites
          final favouriteProducts = products.where((product) {
            return favouriteProvider.isFavourite(product.id);
          }).toList();

          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.65,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: favouriteProducts.length,
            itemBuilder: (context, index) {
              final product = favouriteProducts[index];
              return ProductCard(product: product);
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 80,
            color: colorScheme.onSurface.withAlpha(77),
          ),
          const SizedBox(height: 16),
          Text(
            'No favourites yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start adding products to your favourites!',
            style: TextStyle(
              color: colorScheme.onSurface.withAlpha(153),
            ),
          ),
        ],
      ),
    );
  }

  
}