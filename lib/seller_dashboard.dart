import 'package:flutter/material.dart';
import 'create_shop.dart';
import 'seller_shop_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SellerHome extends StatelessWidget {
  const SellerHome({super.key});

  String get sellerId => FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F3),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 20),

              const Text(
                "Seller Dashboard",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5A0F1D),
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                "Manage your shop with elegance",
                style: TextStyle(color: Colors.black54),
              ),

              const SizedBox(height: 30),

              /// 🔹 CREATE SHOP
              dashboardCard(
                context,
                title: "Create My Shop",
                icon: Icons.storefront,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CreateShopScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 18),

              /// 🔹 VIEW SHOP
              dashboardCard(
                context,
                title: "My Shop",
                icon: Icons.shopping_bag_outlined,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SellerShopView(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 25),

              /// 🔥 BUSINESS OVERVIEW (FULLY FIXED)
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('orders')
                    .where('sellerId', isEqualTo: sellerId)
                    .snapshots(),
                builder: (context, snapshot) {

                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  var orders = snapshot.data!.docs;

                  int totalOrders = orders.length;

                  double revenue = 0;
                  for (var order in orders) {
                    var price = order['price'];
                    if (price is num) {
                      revenue += price.toDouble();
                    }
                  }

                  return Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade200,
                          blurRadius: 12,
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        const Text(
                          "Business Overview",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 18),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            /// 📦 ORDERS
                            statItem("$totalOrders", "Orders"),

                            /// 💰 REVENUE
                            statItem("₹${revenue.toStringAsFixed(0)}", "Revenue"),

                            /// 🛍 PRODUCTS (REAL-TIME FIX)
                            StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('products')
                                  .where('sellerId', isEqualTo: sellerId)
                                  .snapshots(),
                              builder: (context, productSnapshot) {

                                int count =
                                    productSnapshot.data?.docs.length ?? 0;

                                return statItem("$count", "Products");
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 25),

              const Text(
                "New Orders",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5A0F1D),
                ),
              ),

              const SizedBox(height: 10),

              /// 🔥 ORDER LIST (FIXED + STATUS ACTIONS)
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('orders')
                      .where('sellerId', isEqualTo: sellerId)
                      .snapshots(), // ✅ FIXED (no orderBy)

                  builder: (context, snapshot) {

                    if (snapshot.hasError) {
                      return const Center(child: Text("Error loading orders"));
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    var orders = snapshot.data?.docs ?? [];

                    if (orders.isEmpty) {
                      return const Center(
                        child: Text("No orders yet"),
                      );
                    }

                    return ListView.builder(
                      itemCount: orders.length,
                      itemBuilder: (context, index) {

                        var order = orders[index];

                        String productName =
                            order['productName'] ?? "Product";
                        var price = order['price'];
                        String status = order['status'] ?? 'pending';

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(15),

                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade200,
                                blurRadius: 8,
                              )
                            ],
                          ),

                          child: Row(
                            children: [

                              /// PRODUCT INFO
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      productName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text("₹ ${price ?? 0}"),
                                  ],
                                ),
                              ),

                              /// STATUS + ACTIONS
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [

                                  Text(
                                    status,
                                    style: TextStyle(
                                      color: status == 'delivered'
                                          ? Colors.green
                                          : status == 'shipped'
                                              ? Colors.blue
                                              : status == 'accepted'
                                                  ? Colors.orange
                                                  : Colors.red,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),

                                  const SizedBox(height: 6),

                                  if (status == 'pending')
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.check,
                                              color: Colors.green),
                                          onPressed: () {
                                            FirebaseFirestore.instance
                                                .collection('orders')
                                                .doc(order.id)
                                                .update({'status': 'accepted'});
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.close,
                                              color: Colors.red),
                                          onPressed: () {
                                            FirebaseFirestore.instance
                                                .collection('orders')
                                                .doc(order.id)
                                                .update({'status': 'rejected'});
                                          },
                                        ),
                                      ],
                                    ),

                                  if (status == 'accepted')
                                    TextButton(
                                      child: const Text("Ship"),
                                      onPressed: () {
                                        FirebaseFirestore.instance
                                            .collection('orders')
                                            .doc(order.id)
                                            .update({'status': 'shipped'});
                                      },
                                    ),

                                  if (status == 'shipped')
                                    TextButton(
                                      child: const Text("Deliver"),
                                      onPressed: () {
                                        FirebaseFirestore.instance
                                            .collection('orders')
                                            .doc(order.id)
                                            .update({'status': 'delivered'});
                                      },
                                    ),
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔹 UI CARD (UNCHANGED)
  Widget dashboardCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 10,
            )
          ],
        ),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 15),
            Text(title),
          ],
        ),
      ),
    );
  }
}

class statItem extends StatelessWidget {
  final String value;
  final String title;

  const statItem(this.value, this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(color: Colors.black54)),
      ],
    );
  }
}