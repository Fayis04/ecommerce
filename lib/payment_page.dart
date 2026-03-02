import 'package:flutter/material.dart';
import 'order_success.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String paymentMethod = "COD";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Payment")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            RadioListTile(
              value: "COD",
              groupValue: paymentMethod,
              title: const Text("Cash on Delivery"),
              onChanged: (value) {
                setState(() {
                  paymentMethod = value!;
                });
              },
            ),

            RadioListTile(
              value: "Card",
              groupValue: paymentMethod,
              title: const Text("Debit Card"),
              onChanged: (value) {
                setState(() {
                  paymentMethod = value!;
                });
              },
            ),

            RadioListTile(
              value: "GPay",
              groupValue: paymentMethod,
              title: const Text("GPay"),
              onChanged: (value) {
                setState(() {
                  paymentMethod = value!;
                });
              },
            ),

            const Spacer(),

            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const OrderSuccess()),
                );
              },
              child: const Text("Place Order"),
            ),
          ],
        ),
      ),
    );
  }
}
