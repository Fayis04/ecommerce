import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'add_product.dart';

class SellerShopView extends StatefulWidget {
  const SellerShopView({super.key});

  @override
  State<SellerShopView> createState() => _SellerShopViewState();
}

class _SellerShopViewState extends State<SellerShopView> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F3),

      appBar: AppBar(
        backgroundColor: const Color(0xFF7B0000),
        title: const Text("My Shop"),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('shops')
            .where(
              'ownerId',
              isEqualTo: FirebaseAuth.instance.currentUser!.uid,
            )
            .snapshots(),

        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("You haven't created a shop yet"),
            );
          }

          var shop = snapshot.data!.docs.first;

          String shopName = shop['shopName'];

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// SHOP BANNER
                Stack(
                  clipBehavior: Clip.none,
                  children: [

                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: FileImage(File(shop['banner'])),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    Positioned(
                      bottom: -40,
                      left: 20,
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage: FileImage(File(shop['logo'])),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 50),

                /// SHOP NAME
                Center(
                  child: Text(
                    shopName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 5),

                /// CATEGORY
                Center(
                  child: Text(
                    shop['category'],
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),

                const SizedBox(height: 20),

                /// ADD PRODUCT BUTTON
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    width: double.infinity,

                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7B0000),
                      ),

                      icon: const Icon(Icons.add, color: Colors.white),

                      label: const Text(
                        "Add Product",
                        style: TextStyle(color: Colors.white),
                      ),

                      onPressed: () {

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AddProduct(
                              shopName: shopName,
                            ),
                          ),
                        );

                      },
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// PRODUCTS FROM FIRESTORE
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('products')
                      .where('shopName', isEqualTo: shopName)
                      .snapshots(),

                  builder: (context, productSnapshot) {

                    if (!productSnapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    var products = productSnapshot.data!.docs;

                    if (products.isEmpty) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Text("No products yet"),
                        ),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: products.length,

                      itemBuilder: (context, index) {

                        var product = products[index];

                        return ListTile(

                          leading: Image.file(
                            File(product['image']),
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),

                          title: Text(product['name']),

                          subtitle: Text("₹ ${product['price']}"),

                          trailing: Switch(
                            value: product['inStock'],

                            onChanged: (value) {

                              FirebaseFirestore.instance
                                  .collection('products')
                                  .doc(product.id)
                                  .update({
                                'inStock': value
                              });

                            },
                          ),
                        );
                      },
                    );
                  },
                ),

                const SizedBox(height: 40),

              ],
            ),
          );
        },
      ),
    );
  }
}