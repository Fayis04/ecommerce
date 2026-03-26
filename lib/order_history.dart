import 'package:flutter/material.dart';
import 'shop_data.dart';
import 'intl/intl.dart'; // add intl package if not already

class OrderHistory extends StatelessWidget {
  const OrderHistory({super.key});

  String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy, hh:mm a').format(date);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("My Orders")),

      body: orderHistory.isEmpty
          ? const Center(
              child: Text(
                "No orders yet 📦",
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: orderHistory.length,
              itemBuilder: (context, index) {

                var order = orderHistory[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(15),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 6,
                      )
                    ],
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      /// 💰 TOTAL
                      Text(
                        "₹ ${order.total}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      /// 💳 PAYMENT
                      Text(
                        "Payment: ${order.paymentMethod}",
                        style: const TextStyle(color: Colors.black54),
                      ),

                      const SizedBox(height: 4),

                      /// 📅 DATE
                      Text(
                        formatDate(order.date),
                        style: const TextStyle(color: Colors.black54),
                      ),

                      const SizedBox(height: 10),

                      /// 📦 ITEMS COUNT
                      Text(
                        "Items: ${order.items.length}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}