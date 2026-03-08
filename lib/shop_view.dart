import 'package:flutter/material.dart';
import '/shop_data.dart';
import 'product_model.dart';
import 'product_details.dart';
import 'cart_page.dart';

class ShopView extends StatelessWidget {
  final String shopName;
  final String logo;
  final String banner;
  
  const ShopView({super.key, required this.shopName, required this.logo,required this.banner});

  @override
  Widget build(BuildContext context) {
    List<Product> shopProducts = productList
        .where((p) => p.shopName == shopName)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(shopName),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartPage()),
              );
            },
          ),
        ],
      ),

      body: GridView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: shopProducts.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          Product product = shopProducts[index];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProductDetails(product: product),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.image, size: 60),
                  const SizedBox(height: 10),
                  Text(product.name),
                  Text("₹ ${product.price}"),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
