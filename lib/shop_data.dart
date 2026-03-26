import 'product_model.dart';
import 'order_model.dart';

/// 🛒 CART (local for now)
List<Product> cartList = [];

/// 📦 ORDER HISTORY
List<Order> orderHistory = [];

/// 🔥 ADD TO CART (SMART)
void addToCart(Product product) {
  int index = cartList.indexWhere((p) => p.id == product.id);

  if (index != -1) {
    cartList[index].quantity += 1; // increase qty
  } else {
    cartList.add(product);
  }
}

/// 🔥 REMOVE FROM CART
void removeFromCart(Product product) {
  cartList.removeWhere((p) => p.id == product.id);
}

/// 🔥 CLEAR CART
void clearCart() {
  cartList.clear();
}