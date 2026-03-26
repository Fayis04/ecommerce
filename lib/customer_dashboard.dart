import 'package:flutter/material.dart';
import 'shop_view.dart';
import 'cart_page.dart';

class CustomerDashboard extends StatefulWidget {
  const CustomerDashboard({super.key});

  @override
  State<CustomerDashboard> createState() => _CustomerDashboardState();
}

class _CustomerDashboardState extends State<CustomerDashboard> {

  /// 🔥 SAFE IMAGE HANDLER (NEW)
  ImageProvider getImage(String path) {
    if (path.startsWith('http')) {
      return NetworkImage(path);
    } else {
      return AssetImage(path);
    }
  }

  /// 🔥 CATEGORY CARD
  Widget categoryCard(String title, String image) {
    return Container(
      width: 110,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(
          image: getImage(image), // ✅ FIXED
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        alignment: Alignment.bottomCenter,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.black.withOpacity(0.4),
        ),
        padding: const EdgeInsets.all(6),
        child: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  /// 🔥 SHOP TILE
  Widget shopTile({
    required String name,
    required String category,
    required String logo,
  }) {
    return Container(
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

      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: getImage(logo), // ✅ FIXED
        ),
        title: Text(name),
        subtitle: Text(category),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),

        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ShopView(
                shopName: name,
                banner: logo,
                logo: logo,
                category: category,
                isSeller: false,
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F4F2),

      appBar: AppBar(
        backgroundColor: const Color(0xFF6A0F1F),
        title: const Text("Home"),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CartPage(),
                ),
              );
            },
          )
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(15),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 🔍 SEARCH BAR
            TextField(
              decoration: InputDecoration(
                hintText: "Search shops...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// 🟡 CATEGORIES
            const Text(
              "Categories",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  categoryCard("Saree", "assets/saree.jpg"),
                  categoryCard("Bangles", "assets/bangles.jpg"),
                  categoryCard("Pashmina", "assets/pashmina.jpg"),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// 🏪 SHOPS
            const Text(
              "Shops",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: ListView(
                children: [

                  shopTile(
                    name: "foodie",
                    category: "food",
                    logo: "assets/shop.png",
                  ),

                  shopTile(
                    name: "phulkaa",
                    category: "saree",
                    logo: "assets/shop.png",
                  ),

                  shopTile(
                    name: "hihha",
                    category: "haha",
                    logo: "assets/shop.png",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}