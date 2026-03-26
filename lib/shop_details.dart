import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'product_model.dart';
import 'product_details.dart';

class ShopDetails extends StatelessWidget {
  final String shopName;
  final String shopId;

  const ShopDetails({
    super.key,
    required this.shopName,
    required this.shopId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B5E20),
        title: Text(shopName),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// 🔥 BANNER
          Container(
            height: 180,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/banner.jpeg"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          const SizedBox(height: 20),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Products",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 15),

          /// 🔥 FIREBASE PRODUCTS
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('shops')
                  .doc(shopId)
                  .collection('products')
                  .snapshots(),
              builder: (context, snapshot) {

                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final products = snapshot.data!.docs;

                if (products.isEmpty) {
                  return const Center(
                    child: Text("No products available"),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: products.length,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 0.8,
                  ),
                  itemBuilder: (context, index) {

                    final doc = products[index];
                    final data = doc.data() as Map<String, dynamic>;

                    /// ✅ SAFE PRODUCT MODEL
                    Product product = Product.fromMap(data, doc.id);

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                ProductDetails(product: product),
                          ),
                        );
                      },
                      child: ProductCard(
                        name: product.name,
                        price: product.price,
                        image: product.image,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String name;
  final double price;
  final String image;

  const ProductCard({
    super.key,
    required this.name,
    required this.price,
    required this.image,
  });

  ImageProvider getImage() {
    if (image.isNotEmpty && image.startsWith('http')) {
      return NetworkImage(image);
    } else {
      return const AssetImage("assets/placeholder.png");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
          ),
        ],
      ),

      child: Column(
        children: [

          /// 🔥 IMAGE
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(15)),
              child: Image(
                image: getImage(),
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text("₹ ${price.toStringAsFixed(0)}"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}