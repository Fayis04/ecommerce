import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'create_shop.dart';
import 'shop_view.dart';
import 'seller_shop_view.dart';

class SellerShopPage extends StatelessWidget {
  const SellerShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Shop"),
        backgroundColor: const Color(0xFF8B0000),
      ),

      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("shops")
            .where("ownerId", isEqualTo: user!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final shops = snapshot.data!.docs;
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD4AF37),
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SellerShopView()),
              );
            },
            child: const Text("my shop", style: TextStyle(color: Colors.black)),
          );
          const SizedBox(height: 20);
          // ================= NO SHOP =================
          if (shops.isEmpty) {
            return Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD4AF37),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreateShopScreen(),
                    ),
                  );
                },
                child: const Text(
                  "create my shop",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            );
          }

          // ================= MY SHOP =================
          final shop = shops.first.data();

          String banner = shop['banner'] ?? "";
          String logo = shop['logo'] ?? "";
          String shopName = shop['shopName'] ?? "";
          String category = shop['category'] ?? "";

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Banner
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: banner.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(banner),
                            fit: BoxFit.cover,
                          )
                        : null,
                    color: Colors.grey[300],
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: logo.isNotEmpty
                          ? NetworkImage(logo)
                          : null,
                      child: logo.isEmpty
                          ? const Icon(Icons.store, size: 30)
                          : null,
                    ),

                    const SizedBox(width: 15),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          shopName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Text(
                          category,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B0000),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text("View My Shop"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ShopView(
                          shopName: shopName,
                          logo: logo,
                          banner: banner,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
