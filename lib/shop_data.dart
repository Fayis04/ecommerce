import 'product_model.dart';

/// All products in the app
List<Product> productList = [];

/// Cart items
List<Product> cartList = [];

class Shop {
  String name;
  String banner;
  String logo;
  String category;

  Shop({
    required this.name,
    required this.banner,
    required this.logo,
    required this.category,
  });
}

List<Shop> shopList = [];