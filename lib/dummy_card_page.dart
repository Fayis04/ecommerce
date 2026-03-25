import 'package:flutter/material.dart';

class DummyCardPage extends StatefulWidget {
  final VoidCallback onSuccess;

  const DummyCardPage({super.key, required this.onSuccess});

  @override
  State<DummyCardPage> createState() => _DummyCardPageState();
}

class _DummyCardPageState extends State<DummyCardPage> {

  final cardNumber = TextEditingController();
  final expiry = TextEditingController();
  final cvv = TextEditingController();
  final name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Debit Card Payment")),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            /// CARD UI (REAL LOOK)
            Container(
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [Color(0xFF6A0F1F), Colors.black],
                ),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Text("Debit Card",
                      style: TextStyle(color: Colors.white)),

                  const Spacer(),

                  Text(
                    cardNumber.text.isEmpty
                        ? "XXXX XXXX XXXX XXXX"
                        : cardNumber.text,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        letterSpacing: 2),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name.text.isEmpty ? "CARD HOLDER" : name.text,
                        style: const TextStyle(color: Colors.white),
                      ),
                      Text(
                        expiry.text.isEmpty ? "MM/YY" : expiry.text,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 25),

            buildField("Card Number", cardNumber),
            const SizedBox(height: 15),

            Row(
              children: [
                Expanded(child: buildField("Expiry (MM/YY)", expiry)),
                const SizedBox(width: 10),
                Expanded(child: buildField("CVV", cvv)),
              ],
            ),

            const SizedBox(height: 15),
            buildField("Card Holder Name", name),

            const Spacer(),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6A0F1F),
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                /// DUMMY SUCCESS
                widget.onSuccess();
              },
              child: const Text(
                "Pay Now",
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildField(String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
      onChanged: (_) => setState(() {}), // updates card preview
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade200,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}