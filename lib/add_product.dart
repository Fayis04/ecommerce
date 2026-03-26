import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final quantityController = TextEditingController();
  final detailsController = TextEditingController();
  final categoryController = TextEditingController();

  bool isLoading = false;

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

  Future<String> uploadImage(File imageFile) async {
    final response = await cloudinary.uploadFile(
      CloudinaryFile.fromFile(
        imageFile.path,
        resourceType: CloudinaryResourceType.Image,
      ),
    );
    return response.secureUrl;
  }

  void addProduct() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      showMsg("User not logged in");
      return;
    }

    if (nameController.text.isEmpty ||
        priceController.text.isEmpty ||
        categoryController.text.isEmpty ||
        _image == null) {
      showMsg("Please fill all required fields");
      return;
    }

    double price = double.tryParse(priceController.text) ?? 0;
    int quantity = int.tryParse(quantityController.text) ?? 0;

    if (price <= 0) {
      showMsg("Enter valid price");
      return;
    }

    setState(() => isLoading = true);

    try {
      /// 🔥 Upload image
      String imageUrl = await uploadImage(_image!);

      /// 🔥 Save product
      await FirebaseFirestore.instance.collection('products').add({
        "name": nameController.text.trim(),
        "price": price,
        "category": categoryController.text.trim(),
        "description": detailsController.text.trim(),
        "image": imageUrl,
        "shopName": widget.shopName,
        "sellerId": user.uid, // ✅ IMPORTANT FIX
        "inStock": quantity > 0,
        "quantity": quantity,
        "createdAt": Timestamp.now(),
      });

      showMsg("Product Added Successfully");

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
    nameController.dispose();
    priceController.dispose();
    quantityController.dispose();
    detailsController.dispose();
    categoryController.dispose();
    super.dispose();
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

            const SizedBox(height: 25),

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
                            Text("Upload product image"),
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

            const SizedBox(height: 25),

            buildField("Product Name", nameController),
            const SizedBox(height: 15),

            buildField("Price", priceController,
                type: TextInputType.number),
            const SizedBox(height: 15),

            buildField("Quantity", quantityController,
                type: TextInputType.number),
            const SizedBox(height: 15),

            buildField("Product Details", detailsController),
            const SizedBox(height: 15),

            buildField("Category", categoryController),
            const SizedBox(height: 25),

            /// BUTTON
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                onPressed: isLoading ? null : addProduct,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6A0F1F),
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
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