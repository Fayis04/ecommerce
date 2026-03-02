class Product {
  final String name;
   final String category;
  final double price;
  final String shopName;
  final String description;
  bool inStock;

  Product({
    required this.name,
    required this.category,
    required this.price,
    required this.shopName,
    required this.description,
    this.inStock = true,
  });
}
