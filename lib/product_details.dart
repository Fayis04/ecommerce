import 'package:flutter/material.dart';
import 'product_model.dart';
import 'shop_data.dart';
import 'payment_page.dart';

class ProductDetails extends StatelessWidget {
  final Product product;

  const ProductDetails({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [

            const Center(
              child: Icon(Icons.image, size: 120),
            ),

            const SizedBox(height: 20),

            Text(product.name,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),

            Text("₹ ${product.price}"),

            const SizedBox(height: 10),

            Text(product.description),

            const Spacer(),

            ElevatedButton(
              onPressed: () {
                cartList.add(product);
                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  const SnackBar(
                    content:
                        Text("Added to Cart"),
                  ),
                );
              },
              child: const Text("Add to Cart"),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                       PaymentPage(total: product.price),
                  ),
                );
              },
              child: const Text("Buy Now"),
            ),
          ],
        ),
      ),
    );
  }
}
