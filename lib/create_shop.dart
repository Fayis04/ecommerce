import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

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

  final ImagePicker picker = ImagePicker();

  /// 🔥 Cloudinary config
  final String cloudName = "dnkjruqx3";
  final String uploadPreset = "vendura_upload";

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

  /// 🔥 UPLOAD IMAGE TO CLOUDINARY
  Future<String?> uploadImage(File imageFile) async {

    final url = Uri.parse(
        "https://api.cloudinary.com/v1_1/$cloudName/image/upload");

    var request = http.MultipartRequest("POST", url);

    request.fields['upload_preset'] = uploadPreset;

    request.files.add(
      await http.MultipartFile.fromPath('file', imageFile.path),
    );

    var response = await request.send();

    if (response.statusCode == 200) {
      final resData = await response.stream.bytesToString();
      final data = jsonDecode(resData);
      return data['secure_url'];
    } else {
      return null;
    }
  }

  /// ✅ CREATE SHOP
  Future<void> createShop() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null ||
          shopNameController.text.isEmpty ||
          categoryController.text.isEmpty ||
          bannerImage == null ||
          logoImage == null) {

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please fill all fields")),
        );
        return;
      }

      /// Upload images
      String bannerUrl = await uploadImage(bannerImage!) ?? "";
      String logoUrl = await uploadImage(logoImage!) ?? "";

      /// Save to Firestore
      await FirebaseFirestore.instance.collection("shops").add({
        "ownerId": user.uid,
        "shopName": shopNameController.text.trim(),
        "category": categoryController.text.trim(),
        "banner": bannerUrl,
        "logo": logoUrl,
        "createdAt": Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Shop Created Successfully")),
      );

      Navigator.pop(context);

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F3),

      appBar: AppBar(
        title: const Text("Create Shop"),
        backgroundColor: const Color(0xFF6A0F1F),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            /// BANNER
            GestureDetector(
              onTap: pickBanner,
              child: Container(
                height: 160,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.grey.shade200,
                  image: bannerImage != null
                      ? DecorationImage(
                          image: FileImage(bannerImage!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: bannerImage == null
                    ? const Center(
                        child: Text("Tap to add shop banner"),
                      )
                    : null,
              ),
            ),

            const SizedBox(height: 25),

            /// LOGO
            GestureDetector(
              onTap: pickLogo,
              child: CircleAvatar(
                radius: 45,
                backgroundColor: Colors.grey.shade200,
                backgroundImage:
                    logoImage != null ? FileImage(logoImage!) : null,
                child: logoImage == null
                    ? const Icon(Icons.camera_alt)
                    : null,
              ),
            ),

            const SizedBox(height: 30),

            /// SHOP NAME
            TextField(
              controller: shopNameController,
              decoration: InputDecoration(
                labelText: "Shop Name",
                labelStyle: const TextStyle(color: Color(0xFF6A0F1F)),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// CATEGORY
            TextField(
              controller: categoryController,
              decoration: InputDecoration(
                labelText: "Category",
                labelStyle: const TextStyle(color: Color(0xFF6A0F1F)),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 30),

            /// BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6A0F1F),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: createShop,
                child: const Text(
                  "Create Shop",
                  style: TextStyle(
                    color: Color(0xFFD4AF37),
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