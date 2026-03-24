class Product {
  String name;
  double price;
  String category;
  String description;
  String shopName;
  String image;
  bool inStock;

  Product({
    required this.name,
    required this.price,
    required this.category,
    required this.description,
    required this.shopName,
    required this.image,
    this.inStock = true,
  });
}