import 'product_model.dart';

class Order {
  final String? id; // 🔥 optional (for Firebase)
  final List<Product> items;
  final double total;
  final String paymentMethod;
  final DateTime date;
  final String status; // 🔥 NEW (pending, accepted, delivered)

  Order({
    this.id,
    required this.items,
    required this.total,
    required this.paymentMethod,
    required this.date,
    this.status = 'pending', // default
  });

  /// 🔥 CONVERT TO MAP (for Firebase)
  Map<String, dynamic> toMap() {
    return {
      'total': total,
      'paymentMethod': paymentMethod,
      'date': date.toIso8601String(),
      'status': status,
      'items': items.map((e) => e.toMap()).toList(),
    };
  }

  /// 🔥 FROM MAP (optional for future use)
  factory Order.fromMap(Map<String, dynamic> data, {String? id}) {
    return Order(
      id: id,
      total: (data['total'] ?? 0).toDouble(),
      paymentMethod: data['paymentMethod'] ?? '',
      date: DateTime.parse(data['date']),
      status: data['status'] ?? 'pending',
      items: (data['items'] as List<dynamic>? ?? [])
          .map((e) => Product.fromMap(e, e['id'] ?? ''))
          .toList(),
    );
  }
}