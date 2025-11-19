class Product {
  final String id;
  final String name;
  final int sales;
  final double price;
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
    required this.sales,
    required this.description,
    required this.images,
    required this.category,
    required this.brand,
    required this.rating,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'sales': sales,
      'description': description,
      'images': images,
      'category': category,
      'brand': brand,
      'rating': rating,
      'quantity': quantity,
    };
  }

	factory Product.fromMap(Map<String, dynamic> map) {
		return Product(
			id: map['id'],
			name: map['name'],
			price: map['price'],
			sales: map['sales'],
			description: map['description'],
			images: (map['images']),
			category: map['category'],
			brand: map['brand'],
			rating: map['rating'],
			quantity: map['quantity']
		);
	}
}