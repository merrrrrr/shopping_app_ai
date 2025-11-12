class OrderItem {
  final String productId;
  final String productName;
  final String imageUrl;
  final double priceAtPurchase;
  final int quantity;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.imageUrl,
    required this.priceAtPurchase,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'imageUrl': imageUrl,
      'priceAtPurchase': priceAtPurchase,
      'quantity': quantity,
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      productId: map['productId'],
      productName: map['productName'],
      imageUrl: map['imageUrl'],
      priceAtPurchase: (map['priceAtPurchase'] as num).toDouble(),
      quantity: map['quantity'],
    );
  }
}