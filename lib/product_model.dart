class Product {
  final String name;
  final double price;
  final String shopName;
  final String description;
  final String category;
  bool inStock;
  int quantity;

  Product({
    required this.name,
    required this.price,
    required this.shopName,
    required this.description,
    required this.category,
    this.inStock = true,
    this.quantity = 1,
  });
}
