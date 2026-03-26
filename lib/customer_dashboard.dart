import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'shop_view.dart';

class CustomerDashboard extends StatefulWidget {
  const CustomerDashboard({super.key});

  @override
  State<CustomerDashboard> createState() => _CustomerDashboardState();
}

class _CustomerDashboardState extends State<CustomerDashboard> {

  String searchText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F1EC),

      appBar: AppBar(
        backgroundColor: const Color(0xFF7A0E1A),
        title: const Text("Home"),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: Icon(Icons.shopping_cart),
          )
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(15),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 🔍 SEARCH BAR (WORKING)
            TextField(
              onChanged: (value) {
                setState(() {
                  searchText = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: "Search shops...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// 📂 CATEGORIES (UNCHANGED)
            const Text(
              "Categories",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                categoryCard("Saree"),
                categoryCard("Bangles"),
                categoryCard("Pashmina"),
              ],
            ),

            const SizedBox(height: 20),

            const Text(
              "Shops",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            /// 🔥 SHOP LIST WITH SEARCH
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('shops')
                    .snapshots(),
                builder: (context, snapshot) {

                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  var shops = snapshot.data!.docs;

                  /// 🔥 FILTER LOGIC
                  var filteredShops = shops.where((shop) {
                    var data = shop.data() as Map<String, dynamic>;
                    String name = (data['shopName'] ?? "").toLowerCase();
                    return name.contains(searchText);
                  }).toList();

                  if (filteredShops.isEmpty) {
                    return const Center(child: Text("No shops found"));
                  }

                  return ListView.builder(
                    itemCount: filteredShops.length,
                    itemBuilder: (context, index) {

                      var shop = filteredShops[index];
                      var data = shop.data() as Map<String, dynamic>;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),

                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),

                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Colors.pinkAccent,
                          ),
                          title: Text(data['shopName'] ?? "Shop"),
                          subtitle: Text(data['category'] ?? ""),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),

                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ShopView(
                                  shopName: data['shopName'] ?? "",
                                  banner: data['banner'] ?? "",
                                  logo: data['logo'] ?? "",
                                  category: data['category'] ?? "",
                                  isSeller: false,
                                ),
                              ),
                            );
                          },
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
    );
  }
}

/// 🔹 CATEGORY CARD (UNCHANGED UI)
class categoryCard extends StatelessWidget {
  final String title;

  const categoryCard(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: 100,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}