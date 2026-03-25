import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// 👉 IMPORT CLOUDINARY (same as your shop upload)
import 'package:cloudinary_public/cloudinary_public.dart';

class AddProduct extends StatefulWidget {
  final String shopName;

  const AddProduct({
    super.key,
    required this.shopName,
  });

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController detailsController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();

  bool isLoading = false;

  // 👉 INIT CLOUDINARY (use SAME config you used before)
  final cloudinary = CloudinaryPublic('dnkjruqx3', 'vendura_upload');

  Future<void> _pickImage() async {
    final XFile? picked =
        await _picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        _image = File(picked.path);
      });
    }
  }

  /// 🔥 UPLOAD IMAGE TO CLOUDINARY
  Future<String> uploadImage(File imageFile) async {
    final response = await cloudinary.uploadFile(
      CloudinaryFile.fromFile(
        imageFile.path,
        resourceType: CloudinaryResourceType.Image,
      ),
    );

    return response.secureUrl; // ✅ IMPORTANT
  }

  /// ✅ ADD PRODUCT TO FIRESTORE
  void addProduct() async {
    if (nameController.text.isEmpty ||
        priceController.text.isEmpty ||
        categoryController.text.isEmpty ||
        _image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill required fields")),
      );
      return;
    }

    try {
      setState(() => isLoading = true);

      final user = FirebaseAuth.instance.currentUser;

      // 🔥 STEP 1: upload image
      String imageUrl = await uploadImage(_image!);

      // 🔥 STEP 2: save URL (NOT path)
      await FirebaseFirestore.instance.collection('products').add({
        "name": nameController.text,
        "price": double.parse(priceController.text),
        "category": categoryController.text,
        "description": detailsController.text,
        "image": imageUrl, // ✅ FIXED
        "shopName": widget.shopName,
        "ownerId": user!.uid,
        "inStock": quantityController.text == "0" ? false : true,
        "createdAt": Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Product Added")),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F3),

      body: SingleChildScrollView(
        child: Column(
          children: [
            /// HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
              decoration: const BoxDecoration(
                color: Color(0xFF6A0F1F),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                ),
              ),
              child: const Text(
                "Add Product",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFD4AF37),
                ),
              ),
            ),

            const SizedBox(height: 30),

            /// IMAGE PICKER
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey.shade200,
                ),
                child: _image == null
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_a_photo, size: 40),
                            SizedBox(height: 10),
                            Text("Tap to upload product image"),
                          ],
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.file(
                          _image!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 30),

            buildField("Product Name", nameController),
            const SizedBox(height: 20),

            buildField("Price", priceController,
                type: TextInputType.number),
            const SizedBox(height: 20),

            buildField("Quantity", quantityController,
                type: TextInputType.number),
            const SizedBox(height: 20),

            buildField("Product Details", detailsController),
            const SizedBox(height: 20),

            buildField("Category", categoryController),
            const SizedBox(height: 30),

            /// ADD BUTTON
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6A0F1F),
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: isLoading ? null : addProduct,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Add Product",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFFD4AF37),
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget buildField(
    String label,
    TextEditingController controller, {
    TextInputType type = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: controller,
        keyboardType: type,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Color(0xFF6A0F1F)),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}