import 'package:flutter/material.dart';
import 'shop_data.dart';
import 'order_model.dart' as myOrder;
import 'order_success.dart';
import 'dummy_card_page.dart';
import 'dummy_gpay_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PaymentPage extends StatefulWidget {
  final double total;

  const PaymentPage({super.key, required this.total});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {

  String paymentMethod = "Cash on Delivery";
  bool isLoading = false;

  /// 🔥 SAVE TO FIREBASE
  Future<void> saveOrderToFirebase(String method) async {

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception("User not logged in");
    }

    for (var item in cartList) {
      await FirebaseFirestore.instance.collection('orders').add({
        'productId': item.id ?? item.name,
        'productName': item.name,
        'price': item.price,
        'sellerId': item.sellerId ?? 'unknown',
        'buyerId': user.uid,
        'paymentMethod': method,
        'status': 'pending',
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  /// 🔥 PLACE ORDER
  void placeOrder(String method) async {

    if (!mounted) return;
    setState(() => isLoading = true);

    try {

      await saveOrderToFirebase(method);

      orderHistory.add(
        myOrder.Order(
          items: List.from(cartList),
          total: widget.total,
          paymentMethod: method,
          date: DateTime.now(),
        ),
      );

      cartList.clear();

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const OrderSuccess(),
        ),
      );

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Order failed: $e")),
        );
      }
    }

    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  /// 🔥 HANDLE PAYMENT
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

      body: Stack(
        children: [

          Padding(
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

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : handlePayment,
                    child: const Text("Proceed"),
                  ),
                )
              ],
            ),
          ),

          /// 🔥 LOADING OVERLAY (NEW)
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}