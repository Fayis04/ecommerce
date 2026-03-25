import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'add_product.dart';

class SellerShopView extends StatefulWidget {
  const SellerShopView({super.key});

  @override
  State<SellerShopView> createState() => _SellerShopViewState();
}

class _SellerShopViewState extends State<SellerShopView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F3),

      appBar: AppBar(
        backgroundColor: const Color(0xFF6A0F1F),
        title: const Text("My Shop"),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('shops')
            .where(
              'ownerId',
              isEqualTo: FirebaseAuth.instance.currentUser!.uid,
            )
            .snapshots(),

        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("You haven't created a shop yet"),
            );
          }

          var shops = snapshot.data!.docs;

          return ListView.builder(
            itemCount: shops.length,
            itemBuilder: (context, index) {

              var shopData = shops[index].data() as Map<String, dynamic>;

              String shopName = shopData['shopName'] ?? "";
              String banner = shopData['banner'] ?? "";
              String logo = shopData['logo'] ?? "";
              String category = shopData['category'] ?? "";

              return Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// 🔥 BANNER + LOGO
                    Stack(
                      clipBehavior: Clip.none,
                      children: [

                        Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: banner.isNotEmpty
                                  ? NetworkImage(banner)
                                  : const AssetImage('assets/placeholder.png') as ImageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        Positioned(
                          bottom: -40,
                          left: 20,
                          child: CircleAvatar(
                            radius: 40,
                            backgroundImage: logo.isNotEmpty
                                ? NetworkImage(logo)
                                : const AssetImage('assets/placeholder.png'),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 50),

                    /// SHOP NAME
                    Center(
                      child: Text(
                        shopName,
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
                        category,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// 🔥 ADD PRODUCT BUTTON
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6A0F1F),
                          ),
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
                                  shopName: shopName,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    /// 🔥 PRODUCTS LIST
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('products')
                          .where('shopName', isEqualTo: shopName)
                          .snapshots(),

                      builder: (context, productSnapshot) {

                        if (!productSnapshot.hasData) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        var products = productSnapshot.data!.docs;

                        if (products.isEmpty) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: Text("No products yet"),
                            ),
                          );
                        }

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: products.length,

                          itemBuilder: (context, i) {

                            var product = products[i];

                            return Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 8),
                              padding: const EdgeInsets.all(12),

                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),

                              child: Row(
                                children: [

                                  /// IMAGE
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image(
                                      image: (product['image'] != null &&
                                              product['image'].toString().startsWith('http'))
                                          ? NetworkImage(product['image'])
                                          : const AssetImage('assets/placeholder.png') as ImageProvider,
                                      height: 60,
                                      width: 60,
                                      fit: BoxFit.cover,
                                    ),
                                  ),

                                  const SizedBox(width: 12),

                                  /// DETAILS
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product['name'] ?? "",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text("₹ ${product['price'] ?? ""}"),
                                      ],
                                    ),
                                  ),

                                  /// STOCK SWITCH
                                  Switch(
                                    activeThumbColor: const Color(0xFF6A0F1F),
                                    value: product['inStock'] ?? true,
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
                            );
                          },
                        );
                      },
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}