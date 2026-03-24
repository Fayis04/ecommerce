import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'product_details.dart';
import 'add_product.dart';
import 'shop_data.dart';

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

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F3),

      /// 🔥 SELLER ADD BUTTON
      floatingActionButton: widget.isSeller
          ? FloatingActionButton.extended(
              backgroundColor: const Color(0xFF6A0F1F),
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text("Add Product"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddProduct(
                      shopName: widget.shopName,
                    ),
                  ),
                );
              },
            )
          : null,

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 🔥 BANNER
            Stack(
              clipBehavior: Clip.none,
              children: [

                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(widget.banner),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                Positioned(
                  bottom: -40,
                  left: 20,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(widget.logo),
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
                  color: Color(0xFF6A0F1F),
                ),
              ),
            ),

            const SizedBox(height: 5),

            /// CATEGORY
            Center(
              child: Text(
                widget.category,
                style: const TextStyle(color: Colors.grey),
              ),
            ),

            const SizedBox(height: 25),

            /// 🔥 PRODUCTS FROM FIRESTORE
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('products')
                  .where('shopName', isEqualTo: widget.shopName)
                  .snapshots(),

              builder: (context, snapshot) {

                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                var products = snapshot.data!.docs;

                if (products.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text("No products yet"),
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: products.length,

                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 0.72,
                  ),

                  itemBuilder: (context, index) {

                    var product = products[index];

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProductDetails(
                              product: Product.fromMap(
                                product.data() as Map<String, dynamic>,
                              ),
                            ),
                          ),
                        );
                      },

                      child: Container(
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

                            /// IMAGE
                            ClipRRect(
                              borderRadius:
                                  const BorderRadius.vertical(
                                top: Radius.circular(16),
                              ),
                              child: Image.network(
                                product['image'],
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
                                    product['name'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 5),

                                  Text(
                                    "₹ ${product['price']}",
                                    style: const TextStyle(
                                      color: Color(0xFFD4AF37),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  /// CUSTOMER BUTTON
                                  if (!widget.isSeller)
                                    ElevatedButton(
                                      style:
                                          ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFF6A0F1F),
                                      ),
                                      onPressed: () {
                                        cartList.add(
                                          Product.fromMap(
                                            product.data()
                                                as Map<String, dynamic>,
                                          ),
                                        );

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

                                  /// SELLER CONTROL
                                  if (widget.isSeller)
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [

                                        const Text("In Stock"),

                                        Switch(
                                          value: product['inStock'],
                                          activeColor:
                                              const Color(0xFF6A0F1F),
                                          onChanged: (value) {
                                            FirebaseFirestore.instance
                                                .collection('products')
                                                .doc(product.id)
                                                .update({
                                              'inStock': value
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
                      ),
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}