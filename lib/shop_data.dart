import 'product_model.dart';
import 'order_model.dart';
List<Product> productList = [

  Product(
    name: "Silk Saree",
    price: 2500,
    shopName: "Royal Saree",
    description: "Premium silk wedding saree",
    category: "Sarees",
  ),

  Product(
    name: "Punjabi Jutti",
    price: 1200,
    shopName: "Jutti Store",
    description: "Handmade traditional jutti",
    category: "Footwear",
  ),

  Product(
    name: "Gold Bangles",
    price: 800,
    shopName: "Bangles World",
    description: "Elegant traditional bangles",
    category: "Jewellery",
  ),
];

List<Product> cartList = [];
List<Order> orderHistory = [];