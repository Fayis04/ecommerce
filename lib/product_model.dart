class Product {
  final String id;
  final String name;
  final double price;
  final String category;
  final String description;
  final String shopName;
  final String image;
  final String sellerId;

  bool inStock;
  int quantity;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.description,
    required this.shopName,
    required this.image,
    required this.sellerId,
    this.inStock = true,
    this.quantity = 1,
  });

  /// 🔥 SAFE FROM FIRESTORE
  factory Product.fromMap(Map<String, dynamic> data, String id) {
    return Product(
      id: id,
      name: data['name'] ?? '',
      price: (data['price'] is num)
          ? (data['price'] as num).toDouble()
          : 0.0,
      category: data['category'] ?? '',
      description: data['description'] ?? '',
      shopName: data['shopName'] ?? '',
      image: data['image'] ?? '',
      sellerId: data['sellerId'] ?? '',
      inStock: data['inStock'] ?? true,
      quantity: (data['quantity'] is int) ? data['quantity'] : 1,
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
      'sellerId': sellerId,
      'inStock': inStock,
      'quantity': quantity,
    };
  }

  /// 🔥 COPY (VERY USEFUL FOR CART)
  Product copyWith({
    String? id,
    String? name,
    double? price,
    String? category,
    String? description,
    String? shopName,
    String? image,
    String? sellerId,
    bool? inStock,
    int? quantity,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      category: category ?? this.category,
      description: description ?? this.description,
      shopName: shopName ?? this.shopName,
      image: image ?? this.image,
      sellerId: sellerId ?? this.sellerId,
      inStock: inStock ?? this.inStock,
      quantity: quantity ?? this.quantity,
    );
  }
}