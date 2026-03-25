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
        title: const Text("My Shops"),
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

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// 🔥 BANNER
                  Container(
                    height: 160,
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

                  /// 🔥 SHOP INFO
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage: logo.isNotEmpty
                          ? NetworkImage(logo)
                          : const AssetImage('assets/placeholder.png'),
                    ),
                    title: Text(
                      shopName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(category),
                  ),

                  /// 🔥 ADD PRODUCT BUTTON
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6A0F1F),
                        minimumSize: const Size(double.infinity, 45),
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
                            builder: (_) => AddProduct(shopName: shopName),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// 🔥 PRODUCTS
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
                        return const Padding(
                          padding: EdgeInsets.all(10),
                          child: Center(child: Text("No products yet")),
                        );
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: products.length,
                        itemBuilder: (context, i) {

                          var product = products[i];
                          var data = product.data() as Map<String, dynamic>;

                          int qty = data['quantity'] ?? 0;
                          String image = data['image'] ?? "";

                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
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
                                    image: image.startsWith('http')
                                        ? NetworkImage(image)
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
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        data['name'] ?? "",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text("₹ ${data['price'] ?? 0}"),
                                    ],
                                  ),
                                ),

                                /// 🔥 QUANTITY CONTROL
                                Column(
                                  children: [
                                    Row(
                                      children: [

                                        /// ➖
                                        IconButton(
                                          icon: const Icon(Icons.remove),
                                          onPressed: () async {
                                            if (qty > 0) {
                                              int newQty = qty - 1;

                                              await FirebaseFirestore.instance
                                                  .collection('products')
                                                  .doc(product.id)
                                                  .update({
                                                "quantity": newQty,
                                                "inStock": newQty > 0,
                                              });
                                            }
                                          },
                                        ),

                                        /// QTY
                                        Text(
                                          "$qty",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),

                                        /// ➕
                                        IconButton(
                                          icon: const Icon(Icons.add),
                                          onPressed: () async {
                                            int newQty = qty + 1;

                                            await FirebaseFirestore.instance
                                                .collection('products')
                                                .doc(product.id)
                                                .update({
                                              "quantity": newQty,
                                              "inStock": true,
                                            });
                                          },
                                        ),
                                      ],
                                    ),

                                    /// STOCK TEXT
                                    Text(
                                      qty > 0 ? "In Stock" : "Out of Stock",
                                      style: TextStyle(
                                        color: qty > 0 ? Colors.green : Colors.red,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),

                  const SizedBox(height: 20),
                  const Divider(thickness: 2),
                ],
              );
            },
          );
        },
      ),
    );
  }
}