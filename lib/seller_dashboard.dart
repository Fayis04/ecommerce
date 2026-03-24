import 'package:flutter/material.dart';
import 'create_shop.dart';
import 'seller_shop_view.dart';

class SellerHome extends StatelessWidget {
  const SellerHome({super.key});

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

              /// TITLE
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
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),

              const SizedBox(height: 30),

              /// CREATE SHOP
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

              /// MY SHOP
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

              /// BUSINESS OVERVIEW
              Container(
                padding: const EdgeInsets.all(22),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      blurRadius: 12,
                      offset: const Offset(0, 6),
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
                        color: Color(0xFF5A0F1D),
                      ),
                    ),

                    const SizedBox(height: 18),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [

                        statItem("12", "Orders"),
                        statItem("₹18k", "Revenue"),
                        statItem("24", "Products"),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
              offset: const Offset(0, 5),
            )
          ],
        ),

        child: Row(
          children: [

            Container(
              padding: const EdgeInsets.all(10),

              decoration: BoxDecoration(
                color: const Color(0xFFD4AF37),
                borderRadius: BorderRadius.circular(10),
              ),

              child: Icon(icon, color: Colors.black),
            ),

            const SizedBox(width: 15),

            Text(
              title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Color(0xFF5A0F1D),
              ),
            )
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

        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF5A0F1D),
          ),
        ),

        const SizedBox(height: 4),

        Text(
          title,
          style: const TextStyle(color: Colors.black54),
        )
      ],
    );
  }
}