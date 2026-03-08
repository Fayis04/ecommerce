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
      body: Column(
        children: [

          Expanded(
            child: ListView.builder(
              itemCount: cartList.length,
              itemBuilder: (context, index) {

                var product = cartList[index];

                return ListTile(
                  title: Text(product.name),
                  subtitle: Text("₹ ${product.price}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
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
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            cartList.removeAt(index);
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [

                Text(
                  "Total: ₹ ${getTotal()}",
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            PaymentPage(total: getTotal()),
                      ),
                    );
                  },
                  child: const Text("Proceed to Payment"),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
