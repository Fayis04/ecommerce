import 'package:flutter/material.dart';
import 'shop_data.dart';

class OrderHistory extends StatelessWidget {
  const OrderHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Orders")),
      body: ListView.builder(
        itemCount: orderHistory.length,
        itemBuilder: (context, index) {

          var order = orderHistory[index];

          return ListTile(
            title: Text("₹ ${order.total}"),
            subtitle: Text(
                "${order.paymentMethod} • ${order.date.toString()}"),
          );
        },
      ),
    );
  }
}
