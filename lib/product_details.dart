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
      backgroundColor: const Color(0xFFF8F6F3),

      appBar: AppBar(
        title: Text(product.name),
        backgroundColor: const Color(0xFF6A0F1F),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔥 PRODUCT IMAGE
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: product.image.startsWith("http")
                      ? NetworkImage(product.image)
                      : const AssetImage("assets/placeholder.png")
                            as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 🔥 NAME
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6A0F1F),
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// 🔥 PRICE
                  Text(
                    "₹ ${product.price}",
                    style: const TextStyle(
                      fontSize: 20,
                      color: Color(0xFFD4AF37),
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// 🔥 DESCRIPTION TITLE
                  const Text(
                    "Product Description",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6A0F1F),
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// 🔥 DESCRIPTION
                  Text(
                    product.description,
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),

                  const SizedBox(height: 30),

                  /// 🔥 ADD TO CART
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6A0F1F),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        cartList.add(product);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Added to cart")),
                        );
                      },
                      child: const Text(
                        "Add to Cart",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFFD4AF37),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  /// 🔥 BUY NOW (FIXED)
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: Color(0xFF6A0F1F),
                          width: 2,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        /// optional: instant checkout
                        cartList.clear();
                        cartList.add(product);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PaymentPage(total: product.price),
                          ),
                        );
                      },
                      child: const Text(
                        "Buy Now",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF6A0F1F),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
