import 'package:flutter/material.dart';
import 'shop_data.dart';
import 'product_model.dart';

class SellerShopView extends StatefulWidget {
  const SellerShopView({super.key});

  @override
  State<SellerShopView> createState() => _SellerShopViewState();
}

class _SellerShopViewState extends State<SellerShopView> {

  Map<String, List<Product>> groupProducts() {
    Map<String, List<Product>> grouped = {};

    for (var product in productList) {
      if (!grouped.containsKey(product.category)) {
        grouped[product.category] = [];
      }
      grouped[product.category]!.add(product);
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {

    final grouped = groupProducts();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF7B0000),
        title: const Text("My Shop"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: grouped.keys.map((category) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    category,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),

                ...grouped[category]!.map((product) {
                  return ListTile(
                    title: Text(product.name),
                    subtitle: Text("₹ ${product.price}"),
                    trailing: Switch(
                      value: product.inStock,
                      onChanged: (value) {
                        setState(() {
                          product.inStock = value;
                        });
                      },
                    ),
                  );
                }),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}