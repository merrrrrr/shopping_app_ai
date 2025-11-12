class Product {
  final String id;
  final String name;
  final int sales;
  final double price;
  final double? discountedPrice;
  final String description;
  final List<String> images;
  final String category;
  final String brand;
  final double rating;
  final int quantity;

  Product({
    required this.id,
    required this.name,
    required this.price,
		this.discountedPrice,
    required this.sales,
    required this.description,
    required this.images,
    required this.category,
    required this.brand,
    required this.rating,
    required this.quantity,
  });

  /// Convert Product to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'discountedPrice': discountedPrice,
      'sales': sales,
      'description': description,
      'images': images,
      'category': category,
      'brand': brand,
      'rating': rating,
      'quantity': quantity,
    };
  }
}