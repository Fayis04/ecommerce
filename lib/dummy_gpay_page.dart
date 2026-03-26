import 'package:flutter/material.dart';

class DummyGPayPage extends StatefulWidget {
  final VoidCallback onSuccess;

  const DummyGPayPage({super.key, required this.onSuccess});

  @override
  State<DummyGPayPage> createState() => _DummyGPayPageState();
}

class _DummyGPayPageState extends State<DummyGPayPage> {

  final upiController = TextEditingController();

  /// 🔥 VALIDATE + PROCESS PAYMENT
  void validateAndPay() async {
    String upi = upiController.text.trim();

    if (upi.isEmpty || !upi.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter valid UPI ID")),
      );
      return;
    }

    /// 🔥 SHOW PROCESSING DIALOG
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 15),
                Text("Processing Payment..."),
              ],
            ),
          ),
        ),
      ),
    );

    /// ⏳ WAIT (simulate payment)
    await Future.delayed(const Duration(seconds: 2));

    Navigator.pop(context); // close dialog

    /// ✅ SUCCESS CALLBACK
    widget.onSuccess();
  }

  @override
  void dispose() {
    upiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("GPay Payment")),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 🔥 HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.black,
              ),
              child: const Column(
                children: [
                  Icon(Icons.account_balance_wallet,
                      color: Colors.white, size: 40),
                  SizedBox(height: 10),
                  Text(
                    "Google Pay",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  )
                ],
              ),
            ),

            const SizedBox(height: 30),

            /// 💳 UPI INPUT
            TextField(
              controller: upiController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: "Enter UPI ID (example@upi)",
                prefixIcon: const Icon(Icons.account_balance),
                filled: true,
                fillColor: Colors.grey.shade200,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// 📌 SAVED UPI
            const Text(
              "Saved UPI IDs",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 10),

            Card(
              child: ListTile(
                leading: const Icon(Icons.account_circle),
                title: const Text("user@upi"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                onTap: () {
                  setState(() {
                    upiController.text = "user@upi";
                  });
                },
              ),
            ),

            const Spacer(),

            /// 💰 PAY BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: validateAndPay,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  "Pay with GPay",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}