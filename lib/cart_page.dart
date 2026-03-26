import 'package:flutter/material.dart';
import 'shop_data.dart';
import 'payment_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  double getTotal() {
    double total = 0;
    for (var item in cartList) {
      total += item.price * item.quantity;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cart")),

      /// 🛒 CART LIST
      body: cartList.isEmpty
          ? const Center(
              child: Text(
                "Your cart is empty 🛒",
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: cartList.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {

                var product = cartList[index];

                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 5,
                      )
                    ],
                  ),

                  child: Row(
                    children: [

                      /// PRODUCT INFO
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text("₹ ${product.price}"),
                          ],
                        ),
                      ),

                      /// CONTROLS
                      Row(
                        children: [

                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              setState(() {
                                if (product.quantity > 1) {
                                  product.quantity--;
                                }
                              });
                            },
                          ),

                          Text(product.quantity.toString()),

                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              setState(() {
                                product.quantity++;
                              });
                            },
                          ),

                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                cartList.removeAt(index);
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),

      /// 💰 BOTTOM BAR (BEST PRACTICE)
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total",
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  "₹ ${getTotal()}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {

                  if (cartList.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Cart is empty")),
                    );
                    return;
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          PaymentPage(total: getTotal()),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text("Proceed to Payment"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}