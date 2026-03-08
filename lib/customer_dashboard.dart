import 'package:flutter/material.dart';
import 'shop_view.dart';   // 👈 import this instead
import 'package:cloud_firestore/cloud_firestore.dart';


class CustomerDashboard extends StatelessWidget {
  const CustomerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ================= HEADER =================
Stack(
  children: [

    Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        image: DecorationImage(
          image: const AssetImage("assets/banner.jpeg"),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.25),
            BlendMode.darken,
          ),
        ),
      ),
    ),

    const Positioned(
      top: 70,
      left: 20,
      child: Text(
        "Vendura",
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: Color(0xFFD4AF37),
          letterSpacing: 2,
        ),
      ),
    ),

    Positioned(
      bottom: 25,
      left: 20,
      right: 20,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
            )
          ],
        ),
        child: const TextField(
          decoration: InputDecoration(
            icon: Icon(Icons.search),
            hintText: "Search products or shops...",
            border: InputBorder.none,
          ),
        ),
      ),
    )
  ],
),

           const SizedBox(height: 20),

// ================= SEARCH BAR =================


const SizedBox(height: 30),

// ================= CATEGORIES =================
const Padding(
  padding: EdgeInsets.symmetric(horizontal: 20),
  child: Text(
    "Categories",
    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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

// ================= SALES =================
const Padding(
  padding: EdgeInsets.symmetric(horizontal: 20),
  child: Text(
    "Sales & Offers",
    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  ),
),

const SizedBox(height: 15),

SizedBox(
  height: 120,
  child: ListView(
    scrollDirection: Axis.horizontal,
    padding: const EdgeInsets.symmetric(horizontal: 20),
    children: [
      offerCard("assets/mid1.jpeg"),
      offerCard("assets/mid2.jpeg"),
      offerCard("assets/mid3.jpeg"),
    ],
  ),
),

const SizedBox(height: 30),

            // ================= FEATURED SHOPS =================
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Featured Shops",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 15),

StreamBuilder(
  stream: FirebaseFirestore.instance.collection('shops').snapshots(),
  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {

    if (!snapshot.hasData) {
      return const Center(child: CircularProgressIndicator());
    }

    final shops = snapshot.data!.docs;

    return Column(
      children: shops.map((shop) {

        final data = shop.data() as Map<String, dynamic>;

return shopCard(
  data['shopName'] ?? "",
  data['logo'] ?? "",
  data['banner'] ?? "",
  context,
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

  // ================= SHOP CARD =================
Widget shopCard(
  String name,
  String logo,
  String banner,
  BuildContext context,
) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ShopView(
            shopName: name,
            logo: logo,
            banner: banner,
          ),
        ),
      );
    },
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [

          CircleAvatar(
            radius: 26,
            backgroundColor: Colors.grey[300],
            backgroundImage: logo.isNotEmpty
                ? NetworkImage(logo)
                : null,
            child: logo.isEmpty
                ? const Icon(Icons.store)
                : null,
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const Icon(Icons.arrow_forward_ios, size: 16),
        ],
      ),
    ),
  );
}
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
Widget offerCard(String image) {
  return Container(
    width: 140,
    margin: const EdgeInsets.only(right: 12),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      image: DecorationImage(
        image: AssetImage(image),
        fit: BoxFit.cover,
      ),
    ),
  );
}

}
