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

  // 🔹 Cloudinary config
  final String cloudName = "dnkjruqx3";
  final String uploadPreset = "vendura_upload";

  Future pickBanner() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        bannerImage = File(picked.path);
      });
    }
  }

  Future pickLogo() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        logoImage = File(picked.path);
      });
    }
  }

  // 🔹 Upload image to Cloudinary
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

Future<void> createShop() async {
  try {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User not logged in")),
      );
      return;
    }

    String bannerUrl = "";
    String logoUrl = "";

    // Upload banner
    if (bannerImage != null) {
      bannerUrl = await uploadImage(bannerImage!) ?? "";
    }

    // Upload logo
    if (logoImage != null) {
      logoUrl = await uploadImage(logoImage!) ?? "";
    }

    await FirebaseFirestore.instance.collection("shops").add({
      "ownerId": user.uid,
      "shopName": shopNameController.text,
      "category": categoryController.text,
      "banner": bannerUrl,
      "logo": logoUrl,
      "createdAt": Timestamp.now(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Shop Created Successfully")),
    );

    Navigator.pop(context);

  } catch (e) {

    print("CREATE SHOP ERROR: $e");

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error: $e")),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),

      appBar: AppBar(
        title: const Text("Create Shop"),
        backgroundColor: const Color(0xFF8B0000),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            GestureDetector(
              onTap: pickBanner,
              child: Container(
                height: 160,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.grey[300],
                  image: bannerImage != null
                      ? DecorationImage(
                          image: FileImage(bannerImage!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: bannerImage == null
                    ? const Center(child: Text("Tap to add Shop Banner"))
                    : null,
              ),
            ),

            const SizedBox(height: 20),

            GestureDetector(
              onTap: pickLogo,
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.grey[300],
                backgroundImage:
                    logoImage != null ? FileImage(logoImage!) : null,
                child: logoImage == null
                    ? const Icon(Icons.add_a_photo)
                    : null,
              ),
            ),

            const SizedBox(height: 30),

            TextField(
              controller: shopNameController,
              decoration: const InputDecoration(
                labelText: "Shop Name",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: categoryController,
              decoration: const InputDecoration(
                labelText: "Shop Category",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B0000),
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: createShop,
              child: const Text("Create Shop"),
            )
          ],
        ),
      ),
    );
  }
}
