import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'product_details.dart';
import 'add_product.dart';
import 'product_model.dart';

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
  /// 🔥 ADD TO CART FUNCTION
  Future<void> addToCart({
    required String productId,
    required String name,
    required double price,
    required String image,
  }) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    final cartRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('cart')
        .doc(productId);

    final doc = await cartRef.get();

    if (doc.exists) {
      await cartRef.update({'quantity': FieldValue.increment(1)});
    } else {
      await cartRef.set({
        'productId': productId,
        'name': name,
        'price': price,
        'image': image,
        'quantity': 1,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F3),

      floatingActionButton: widget.isSeller
          ? FloatingActionButton.extended(
              backgroundColor: const Color(0xFF6A0F1F),
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text("Add Product"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddProduct(shopName: widget.shopName),
                  ),
                );
              },
            )
          : null,

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔥 PREMIUM BANNER
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 220,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(widget.banner),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                Container(
                  height: 220,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Colors.black54, Colors.transparent],
                    ),
                  ),
                ),

                Positioned(
                  bottom: -40,
                  left: 20,
                  child: CircleAvatar(
                    radius: 42,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 38,
                      backgroundImage: NetworkImage(widget.logo),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 50),

            /// SHOP NAME + CATEGORY
            Center(
              child: Column(
                children: [
                  Text(
                    widget.shopName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6A0F1F),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.category,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            /// 🔥 PRODUCTS
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
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 0.75,
                  ),
                  itemBuilder: (context, index) {
                    var product = products[index];
                    var data = product.data() as Map<String, dynamic>;

                    return GestureDetector(
                      onTap: () {
                        /// ✅ ONLY NAVIGATION (NO CART ADD)
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                ProductDetails(product: Product.fromMap(data)),
                          ),
                        );
                      },

                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 12,
                            ),
                          ],
                        ),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// IMAGE + CART ICON
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(18),
                              ),
                              child: Stack(
                                children: [
                                  Image.network(
                                    data['image'],
                                    height: 130,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),

                                  /// 🛒 ONLY ADD BUTTON
                                  if (!widget.isSeller)
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            30,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.1,
                                              ),
                                              blurRadius: 6,
                                            ),
                                          ],
                                        ),
                                        child: IconButton(
                                          icon: const Icon(
                                            Icons.add_shopping_cart,
                                            color: Color(0xFF6A0F1F),
                                          ),
                                          onPressed: () async {
                                            await addToCart(
                                              productId: product.id,
                                              name: data['name'],
                                              price: (data['price'] as num)
                                                  .toDouble(),
                                              image: data['image'],
                                            );

                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text("Added to cart"),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data['name'],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),

                                  const SizedBox(height: 6),

                                  Text(
                                    "₹ ${data['price']}",
                                    style: const TextStyle(
                                      color: Color(0xFFD4AF37),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),

                                  const SizedBox(height: 6),

                                  /// SELLER CONTROL
                                  if (widget.isSeller)
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text("In Stock"),
                                        Switch(
                                          value: data['inStock'],
                                          activeThumbColor: const Color(
                                            0xFF6A0F1F,
                                          ),
                                          onChanged: (value) {
                                            FirebaseFirestore.instance
                                                .collection('products')
                                                .doc(product.id)
                                                .update({'inStock': value});
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
