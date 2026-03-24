import 'dart:io';
import 'package:flutter/material.dart';
import 'shop_data.dart';
import 'product_model.dart';
import 'product_details.dart';
import 'add_product.dart';

class ShopView extends StatefulWidget {
  final String shopName;
  final String banner;
  final String logo;
  final String category;
  final bool isSeller;

  const ShopView({
    super.key,
    required this.shopName,
    required this.banner,
    required this.logo,
    required this.category,
    this.isSeller = false,
  });

  @override
  State<ShopView> createState() => _ShopViewState();
}

class _ShopViewState extends State<ShopView> {

  Map<String, List<Product>> groupProducts() {

    Map<String, List<Product>> grouped = {};

    for (var product in productList) {

      if (product.shopName != widget.shopName) continue;

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
      backgroundColor: const Color(0xFFF8F6F3),

      /// SELLER ADD PRODUCT BUTTON
      floatingActionButton: widget.isSeller
          ? FloatingActionButton.extended(
              backgroundColor: const Color(0xFF6A0F1F),
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                "Add Product",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddProduct(
                      shopName: widget.shopName,
                    ),
                  ),
                ).then((_) {
                  setState(() {});
                });

              },
            )
          : null,

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// BANNER
            Stack(
              clipBehavior: Clip.none,
              children: [

                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(File(widget.banner)),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                Positioned(
                  bottom: -40,
                  left: 20,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: FileImage(File(widget.logo)),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 50),

            /// SHOP NAME
            Center(
              child: Text(
                widget.shopName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 5),

            Center(
              child: Text(
                widget.category,
                style: const TextStyle(color: Colors.grey),
              ),
            ),

            const SizedBox(height: 30),

            /// PRODUCTS
            ...grouped.keys.map((category) {

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      category,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6A0F1F),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),

                    itemCount: grouped[category]!.length,

                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      childAspectRatio: 0.72,
                    ),

                    itemBuilder: (context, index) {

                      final product = grouped[category]![index];

                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade200,
                              blurRadius: 8,
                            )
                          ],
                        ),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            ClipRRect(
                              borderRadius:
                                  const BorderRadius.vertical(
                                top: Radius.circular(16),
                              ),
                              child: Image.file(
                                File(product.image),
                                height: 120,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(10),

                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [

                                  Text(
                                    product.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 5),

                                  Text(
                                    "₹ ${product.price}",
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  /// CUSTOMER BUTTON
                                  if (!widget.isSeller)
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFF1B5E20),
                                      ),
                                      onPressed: () {

                                        cartList.add(product);

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content:
                                                Text("Added to cart"),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        "Add to Cart",
                                        style: TextStyle(
                                            color: Colors.white),
                                      ),
                                    ),

                                  /// SELLER CONTROLS
                                  if (widget.isSeller)
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [

                                        const Text("In Stock"),

                                        Switch(
                                          value: product.inStock,
                                          onChanged: (value) {
                                            setState(() {
                                              product.inStock =
                                                  value;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 25),
                ],
              );
            }).toList(),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}