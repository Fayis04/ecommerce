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

  /// 🔥 FORMAT CARD NUMBER
  String formatCard(String input) {
    input = input.replaceAll(' ', '');
    if (input.length > 16) input = input.substring(0, 16);

    List<String> parts = [];
    for (int i = 0; i < input.length; i += 4) {
      parts.add(input.substring(i, i + 4 > input.length ? input.length : i + 4));
    }
    return parts.join(' ');
  }

  void validateAndPay() {
    if (cardNumber.text.isEmpty ||
        expiry.text.isEmpty ||
        cvv.text.isEmpty ||
        name.text.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    widget.onSuccess();
  }

  @override
  void dispose() {
    cardNumber.dispose();
    expiry.dispose();
    cvv.dispose();
    name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    String formattedCard = formatCard(cardNumber.text);

    return Scaffold(
      appBar: AppBar(title: const Text("Debit Card Payment")),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            /// 💳 CARD PREVIEW
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
                    formattedCard.isEmpty
                        ? "XXXX XXXX XXXX XXXX"
                        : formattedCard,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      letterSpacing: 2,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name.text.isEmpty ? "CARD HOLDER" : name.text.toUpperCase(),
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

            buildField("Card Number", cardNumber,
                type: TextInputType.number),

            const SizedBox(height: 15),

            Row(
              children: [
                Expanded(
                  child: buildField("Expiry (MM/YY)", expiry,
                      type: TextInputType.datetime),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: buildField("CVV", cvv,
                      obscure: true,
                      type: TextInputType.number),
                ),
              ],
            ),

            const SizedBox(height: 15),

            buildField("Card Holder Name", name,
                type: TextInputType.text),

            const Spacer(),

            /// 💰 PAY BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: validateAndPay,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6A0F1F),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  "Pay Now",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildField(
    String hint,
    TextEditingController controller, {
    TextInputType type = TextInputType.text,
    bool obscure = false,
  }) {
    return TextField(
      controller: controller,
      onChanged: (_) => setState(() {}),
      keyboardType: type,
      obscureText: obscure,
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