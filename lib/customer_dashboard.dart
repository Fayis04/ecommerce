import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'shop_view.dart';

class CustomerDashboard extends StatelessWidget {
  const CustomerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F3),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),

              decoration: const BoxDecoration(
                color: Color(0xFF6A0F1F),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),

              child: const Text(
                "Vendura",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFD4AF37),
                  letterSpacing: 1,
                ),
              ),
            ),

            const SizedBox(height: 30),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Shops",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6A0F1F),
                ),
              ),
            ),

            const SizedBox(height: 15),

            /// FIRESTORE SHOP LIST
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('shops')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),

              builder: (context, snapshot) {

                /// LOADING
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                /// NO SHOPS
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text("No shops available"),
                    ),
                  );
                }

                var shops = snapshot.data!.docs;

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: shops.length,

                  itemBuilder: (context, index) {

                    var shop = shops[index];

                    return shopCard(
                      context,
                      shop['shopName'],
                      shop['logo'],
                      shop['banner'],
                      shop['category'],
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  /// SHOP CARD UI
  Widget shopCard(
    BuildContext context,
    String name,
    String logo,
    String banner,
    String category,
  ) {

    return GestureDetector(
      onTap: () {

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ShopView(
              shopName: name,
              banner: banner,
              logo: logo,
              category: category,
            ),
          ),
        );

      },

      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: const EdgeInsets.all(16),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
            ),
          ],
        ),

        child: Row(
          children: [

            /// SHOP LOGO
            ClipRRect(
              borderRadius: BorderRadius.circular(50),

              child: logo.isNotEmpty
                  ? Image.file(
                      File(logo),
                      height: 56,
                      width: 56,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.store,
                          size: 40,
                          color: Color(0xFF6A0F1F),
                        );
                      },
                    )
                  : const Icon(
                      Icons.store,
                      size: 40,
                      color: Color(0xFF6A0F1F),
                    ),
            ),

            const SizedBox(width: 16),

            /// SHOP DETAILS
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    category,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Color(0xFF6A0F1F),
            ),
          ],
        ),
      ),
    );
  }
}