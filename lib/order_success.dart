import 'package:flutter/material.dart';
import 'customer_dashboard.dart';

class OrderSuccess extends StatelessWidget {
  const OrderSuccess({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F3),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              /// ✅ SUCCESS ICON
              const Icon(
                Icons.check_circle,
                size: 100,
                color: Colors.green,
              ),

              const SizedBox(height: 25),

              /// 🎉 TITLE
              const Text(
                "Order Placed!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              /// 📦 SUBTEXT
              const Text(
                "Your order has been placed successfully.\nThank you for shopping with us!",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54),
              ),

              const SizedBox(height: 40),

              /// 🛍 BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CustomerDashboard(),
                      ),
                      (route) => false,
                    );
                  },
                  child: const Text("Continue Shopping"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}