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
      total += item.price;
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

                return ListTile(
                  title: Text(cartList[index].name),
                  subtitle: Text(
                      "₹ ${cartList[index].price}"),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        cartList.removeAt(index);
                      });
                    },
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
                      fontWeight:
                          FontWeight.bold),
                ),

                const SizedBox(height: 10),

                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const PaymentPage(),
                      ),
                    );
                  },
                  child:
                      const Text("Proceed to Payment"),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
