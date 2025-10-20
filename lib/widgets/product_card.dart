import 'package:flutter/material.dart';
import '../models/product.dart';
import '../product_details_page.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
    	onTap: () {
    		Navigator.push(
    			context,
    			MaterialPageRoute(
    				builder: (context) => ProductDetailsPage(product: product),
    			),
    		);
    	},
    	child: Card(
    		clipBehavior: Clip.hardEdge,
    		shape: RoundedRectangleBorder(
    			borderRadius: BorderRadius.circular(12),
    		),
    		child: Column(
    			crossAxisAlignment: CrossAxisAlignment.start,
    			children: [
    				AspectRatio(
    					aspectRatio: 1,
    					child: Image.asset(
    						product.images.first,
    						fit: BoxFit.contain,
    					),
    				),
    				Padding(
    					padding: const EdgeInsets.all(8),
    					child: Column(
    						crossAxisAlignment: CrossAxisAlignment.start,
    						children: [
    							Text(
    								product.name,
    								maxLines: 2,
    								overflow: TextOverflow.ellipsis,
    								style: const TextStyle(fontWeight: FontWeight.bold),
    							),
    							const SizedBox(height: 2),
    							Text(
    								"RM ${product.price.toStringAsFixed(2)}",
    								style: TextStyle(
    									fontSize: 16,
    									fontWeight: FontWeight.bold,
    									color: Theme.of(context).colorScheme.primary,
    								),
    							),
    							const SizedBox(height: 2),
    							Text(
    								"Sales: ${product.sales}",
    								style: const TextStyle(
    									fontSize: 12,
    									color: Colors.grey,
    								),
    							),
    						],
    					),
    				),
    			],
    		),
    	),
    );
  }
}
