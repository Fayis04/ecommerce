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

  bool isLoading = false;

  final String cloudName = "dnkjruqx3";
  final String uploadPreset = "vendura_upload";

  Future pickBanner() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => bannerImage = File(picked.path));
    }
  }

  Future pickLogo() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => logoImage = File(picked.path));
    }
  }

  Future<String?> uploadImage(File imageFile) async {
    try {
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
      }
    } catch (e) {
      print("Upload error: $e");
    }
    return null;
  }

  Future<void> createShop() async {

    final user = FirebaseAuth.instance.currentUser;

    if (user == null ||
        shopNameController.text.isEmpty ||
        categoryController.text.isEmpty ||
        bannerImage == null ||
        logoImage == null) {

      showMsg("Please fill all fields");
      return;
    }

    setState(() => isLoading = true);

    try {

      /// 🔥 Upload images
      String? bannerUrl = await uploadImage(bannerImage!);
      String? logoUrl = await uploadImage(logoImage!);

      if (bannerUrl == null || logoUrl == null) {
        showMsg("Image upload failed");
        return;
      }

      /// 🔥 Save shop
      await FirebaseFirestore.instance.collection("shops").add({
        "ownerId": user.uid,
        "shopName": shopNameController.text.trim(),
        "category": categoryController.text.trim(),
        "banner": bannerUrl,
        "logo": logoUrl,
        "createdAt": Timestamp.now(),
      });

      showMsg("Shop Created Successfully");

      Navigator.pop(context);

    } catch (e) {
      showMsg("Error: $e");
    }

    setState(() => isLoading = false);
  }

  void showMsg(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  void dispose() {
    shopNameController.dispose();
    categoryController.dispose();
    super.dispose();
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
                    ? const Center(child: Text("Tap to add shop banner"))
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

            /// NAME
            buildField("Shop Name", shopNameController),

            const SizedBox(height: 20),

            /// CATEGORY
            buildField("Category", categoryController),

            const SizedBox(height: 30),

            /// BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : createShop,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6A0F1F),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
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

  Widget buildField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF6A0F1F)),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}