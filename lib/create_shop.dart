import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'shop_view.dart';

class CreateShopScreen extends StatefulWidget {
  const CreateShopScreen({super.key});

  @override
  State<CreateShopScreen> createState() => _CreateShopScreenState();
}

class _CreateShopScreenState extends State<CreateShopScreen> {

  final shopNameController = TextEditingController();
  final categoryController = TextEditingController();

  File? bannerImage;
  File? logoImage;

  final picker = ImagePicker();

  /// PICK BANNER
  Future pickBanner() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        bannerImage = File(picked.path);
      });
    }
  }

  /// PICK LOGO
  Future pickLogo() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        logoImage = File(picked.path);
      });
    }
  }

  /// CREATE SHOP
  void createShop() async {

    final user = FirebaseAuth.instance.currentUser;

    if (shopNameController.text.isEmpty ||
        categoryController.text.isEmpty ||
        bannerImage == null ||
        logoImage == null) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please complete all fields"),
        ),
      );
      return;
    }

    /// SAVE SHOP TO FIRESTORE
    await FirebaseFirestore.instance.collection('shops').add({

      'ownerId': user!.uid,
      'shopName': shopNameController.text.trim(),
      'category': categoryController.text.trim(),

      /// currently local paths
      'banner': bannerImage!.path,
      'logo': logoImage!.path,

      'createdAt': Timestamp.now(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Shop created successfully")),
    );

    /// OPEN SHOP PAGE AFTER CREATION
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ShopView(
          shopName: shopNameController.text,
          banner: bannerImage!.path,
          logo: logoImage!.path,
          category: categoryController.text,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F3),

      appBar: AppBar(
        title: const Text("Create Your Shop"),
        backgroundColor: const Color(0xFF6A0F1F),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            /// BANNER IMAGE
            GestureDetector(
              onTap: pickBanner,

              child: Container(
                height: 150,
                width: double.infinity,

                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(15),
                ),

                child: bannerImage == null
                    ? const Center(
                        child: Text("Tap to add shop banner"),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.file(
                          bannerImage!,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 25),

            /// LOGO
            GestureDetector(
              onTap: pickLogo,

              child: CircleAvatar(
                radius: 45,
                backgroundColor: Colors.grey.shade300,

                backgroundImage:
                    logoImage != null ? FileImage(logoImage!) : null,

                child: logoImage == null
                    ? const Icon(Icons.camera_alt)
                    : null,
              ),
            ),

            const SizedBox(height: 25),

            /// SHOP NAME
            TextField(
              controller: shopNameController,

              decoration: InputDecoration(
                labelText: "Shop Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 15),

            /// CATEGORY
            TextField(
              controller: categoryController,

              decoration: InputDecoration(
                labelText: "Shop Category",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 25),

            /// CREATE BUTTON
            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6A0F1F),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),

                onPressed: createShop,

                child: const Text(
                  "Create Shop",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}