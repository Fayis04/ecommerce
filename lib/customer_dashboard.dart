import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

            /// 🔥 HEADER (CLEAN + PREMIUM)
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
                ),
              ),
            ),

            const SizedBox(height: 30),

            /// 🔥 CATEGORIES
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Categories",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6A0F1F),
                ),
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              height: 110,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  categoryCard("Saree", "assets/saree.jpeg"),
                  categoryCard("Bangles", "assets/bangles.jpeg"),
                  categoryCard("Pashmina", "assets/pashmina.jpeg"),
                ],
              ),
            ),

            const SizedBox(height: 30),

            /// 🔥 SHOPS TITLE
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

            /// 🔥 FIRESTORE SHOPS
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('shops')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),

              builder: (context, snapshot) {

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text("No shops available"),
                    ),
                  );
                }

                final shops = snapshot.data!.docs;

                return Column(
                  children: shops.map((shop) {

                    final data = shop.data() as Map<String, dynamic>;

                    return shopCard(
                      context,
                      data['shopName'] ?? "",
                      data['logo'] ?? "",
                      data['banner'] ?? "",
                      data['category'] ?? "",
                    );

                  }).toList(),
                );
              },
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  /// 🔥 SHOP CARD (FIXED)
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

            /// ✅ FIXED: NETWORK IMAGE (NOT FILE)
            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.grey.shade200,
              backgroundImage:
                  logo.isNotEmpty ? NetworkImage(logo) : null,
              child: logo.isEmpty
                  ? const Icon(Icons.store, color: Color(0xFF6A0F1F))
                  : null,
            ),

            const SizedBox(width: 16),

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

  /// CATEGORY CARD
  Widget categoryCard(String title, String image) {
    return Container(
      width: 110,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.cover,
        ),
      ),
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(6),
        decoration: const BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}