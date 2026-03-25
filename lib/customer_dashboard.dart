import 'dart:io'; // 🔥 IMPORTANT (for FileImage)

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'shop_view.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CustomerDashboard extends StatefulWidget {
  const CustomerDashboard({super.key});

  @override
  State<CustomerDashboard> createState() => _CustomerDashboardState();
}

class _CustomerDashboardState extends State<CustomerDashboard> {
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F3),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 🔥 HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
              decoration: const BoxDecoration(
                color: Color(0xFF6A0F1F),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Vendura",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFD4AF37),
                    ),
                  ),

                  Row(
                    children: [

                      /// 🛒 CART
                      IconButton(
                        icon: const Icon(Icons.shopping_cart, color: Colors.white),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CartPage(),
                            ),
                          );
                        },
                      ),

                      /// 👤 PROFILE
                      IconButton(
                        icon: const Icon(Icons.person, color: Colors.white),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProfilePage(),
                            ),
                          );
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),

            /// 🔍 SEARCH
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search shops...",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value.toLowerCase();
                  });
                },
              ),
            ),

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

            /// 🔥 SHOPS
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

                final shops = snapshot.data!.docs.where((shop) {
                  final data = shop.data() as Map<String, dynamic>;
                  final name = (data['shopName'] ?? "").toLowerCase();
                  return name.contains(searchQuery);
                }).toList();

                if (shops.isEmpty) {
                  return const Center(child: Text("No matching shops"));
                }

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

  /// 🔥 SHOP CARD
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

            /// 🔥 FIXED LOGO
            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.grey.shade200,
              backgroundImage: (logo.isNotEmpty && logo.startsWith('http'))
                  ? NetworkImage(logo)
                  : null,
              child: (logo.isEmpty || !logo.startsWith('http'))
                  ? const Icon(Icons.store, color: Color(0xFF6A0F1F))
                  : null,
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(category,
                      style:
                          const TextStyle(color: Colors.grey, fontSize: 13)),
                ],
              ),
            ),

            const Icon(Icons.arrow_forward_ios,
                size: 16, color: Color(0xFF6A0F1F)),
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
        child: Text(title,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}

/// 🛒 CART PAGE
class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("User not logged in")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("My Cart")),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('cart')
            .snapshots(),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Cart is empty"));
          }

          final items = snapshot.data!.docs;
          double total = 0;

          return Column(
            children: [

              Expanded(
                child: ListView(
                  children: items.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;

                    final price = (data['price'] ?? 0).toDouble();
                    final quantity = data['quantity'] ?? 1;

                    total += price * quantity;

                    return ListTile(

                      /// 🔥 FIXED IMAGE
                      leading: (data['image'] != null &&
                              data['image'].toString().startsWith('http'))
                          ? Image.network(
                              data['image'],
                              width: 50,
                              fit: BoxFit.cover,
                            )
                          : const Icon(Icons.image),

                      title: Text(data['name'] ?? ""),
                      subtitle: Text("₹$price x $quantity"),

                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () async {
                              if (quantity > 1) {
                                await doc.reference.update({
                                  'quantity': quantity - 1,
                                });
                              } else {
                                await doc.reference.delete();
                              }
                            },
                          ),

                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () async {
                              await doc.reference.update({
                                'quantity': quantity + 1,
                              });
                            },
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),

              /// TOTAL
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text("Total: ₹${total.toStringAsFixed(2)}",
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text("Checkout"),
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

/// 👤 PROFILE
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: const Center(child: Text("User Profile")),
    );
  }
}
