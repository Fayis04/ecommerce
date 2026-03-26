import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'shop_details.dart';

class ShopListScreen extends StatelessWidget {
  const ShopListScreen({super.key});

  ImageProvider getImage(String path) {
    if (path.isNotEmpty && path.startsWith('http')) {
      return NetworkImage(path);
    } else {
      return const AssetImage("assets/placeholder.png");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shops'),
        backgroundColor: const Color(0xFF1B5E20),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('shops')
            .snapshots(),
        builder: (context, snapshot) {

          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final shops = snapshot.data!.docs;

          if (shops.isEmpty) {
            return const Center(child: Text("No shops available"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: shops.length,
            itemBuilder: (context, index) {

              final doc = shops[index];
              final data = doc.data() as Map<String, dynamic>;

              String name = data['shopName'] ?? "Shop";
              String category = data['category'] ?? "";
              String logo = data['logo'] ?? "";

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ShopDetails(
                        shopName: name,
                        shopId: doc.id,
                      ),
                    ),
                  );
                },

                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 6,
                      )
                    ],
                  ),

                  child: Row(
                    children: [

                      /// 🔥 LOGO
                      CircleAvatar(
                        radius: 25,
                        backgroundImage: getImage(logo),
                      ),

                      const SizedBox(width: 12),

                      /// 🔥 DETAILS
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              category,
                              style: const TextStyle(color: Colors.black54),
                            ),
                          ],
                        ),
                      ),

                      const Icon(Icons.arrow_forward_ios, size: 16),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}