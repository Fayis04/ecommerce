import 'package:flutter/material.dart';

class DummyGPayPage extends StatefulWidget {
  final VoidCallback onSuccess;

  const DummyGPayPage({super.key, required this.onSuccess});

  @override
  State<DummyGPayPage> createState() => _DummyGPayPageState();
}

class _DummyGPayPageState extends State<DummyGPayPage> {

  final upiController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("GPay Payment")),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            /// GPay UI HEADER
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

            TextField(
              controller: upiController,
              decoration: InputDecoration(
                hintText: "Enter UPI ID (example@upi)",
                filled: true,
                fillColor: Colors.grey.shade200,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Saved UPI IDs",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 10),

            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text("user@upi"),
              onTap: () {
                setState(() {
                  upiController.text = "user@upi";
                });
              },
            ),

            const Spacer(),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                /// DUMMY SUCCESS
                widget.onSuccess();
              },
              child: const Text(
                "Pay with GPay",
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}