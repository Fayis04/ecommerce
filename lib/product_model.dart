class Product {
  final String name;
  final double price;
  final String category;
  final String description;
  final String shopName;
  final String image;

  bool inStock;
  int quantity;

  Product({
    required this.name,
    required this.price,
    required this.category,
    required this.description,
    required this.shopName,
    required this.image,
    this.inStock = true,
    this.quantity = 1,
  });

  /// 🔥 FROM FIRESTORE
  factory Product.fromMap(Map<String, dynamic> data) {
    return Product(
      name: data['name'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      category: data['category'] ?? '',
      description: data['description'] ?? '',
      shopName: data['shopName'] ?? '',
      image: data['image'] ?? '',
      inStock: data['inStock'] ?? true,
      quantity: data['quantity'] ?? 1,
    );
  }

  /// 🔥 TO FIRESTORE
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'category': category,
      'description': description,
      'shopName': shopName,
      'image': image,
      'inStock': inStock,
      'quantity': quantity,
    };
  }
}