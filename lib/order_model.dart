import 'product_model.dart';

class Order {
  final List<Product> items;
  final double total;
  final String paymentMethod;
  final DateTime date;

  Order({
    required this.items,
    required this.total,
    required this.paymentMethod,
    required this.date,
  });
}
