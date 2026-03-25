import 'package:flutter/material.dart';
import 'shop_data.dart';
import 'order_model.dart';
import 'order_success.dart';
import 'dummy_card_page.dart';
import 'dummy_gpay_page.dart';
class PaymentPage extends StatefulWidget {
  final double total;

  const PaymentPage({super.key, required this.total});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {

  String paymentMethod = "Cash on Delivery";

  /// 🔥 COMMON ORDER FUNCTION (we will extend later)
  void placeOrder(String method) {

    orderHistory.add(
      Order(
        items: List.from(cartList),
        total: widget.total,
        paymentMethod: method,
        date: DateTime.now(),
      ),
    );

    cartList.clear();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const OrderSuccess(),
      ),
    );
  }

  /// 🔥 HANDLE PAYMENT CLICK
  void handlePayment() {

    if (paymentMethod == "Cash on Delivery") {
      placeOrder("Cash on Delivery");
    }

    else if (paymentMethod == "Debit Card") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DummyCardPage(
            onSuccess: () => placeOrder("Debit Card"),
          ),
        ),
      );
    }

    else if (paymentMethod == "GPay") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DummyGPayPage(
            onSuccess: () => placeOrder("GPay"),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Payment")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            Text(
              "Total Amount: ₹ ${widget.total}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            RadioListTile(
              value: "Cash on Delivery",
              groupValue: paymentMethod,
              title: const Text("Cash on Delivery"),
              onChanged: (value) {
                setState(() => paymentMethod = value!);
              },
            ),

            RadioListTile(
              value: "Debit Card",
              groupValue: paymentMethod,
              title: const Text("Debit Card"),
              onChanged: (value) {
                setState(() => paymentMethod = value!);
              },
            ),

            RadioListTile(
              value: "GPay",
              groupValue: paymentMethod,
              title: const Text("GPay"),
              onChanged: (value) {
                setState(() => paymentMethod = value!);
              },
            ),

            const Spacer(),

            ElevatedButton(
              onPressed: handlePayment,
              child: const Text("Proceed"),
            )
          ],
        ),
      ),
    );
  }
}