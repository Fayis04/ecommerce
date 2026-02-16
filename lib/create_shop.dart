import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateShopScreen extends StatefulWidget {
  const CreateShopScreen({super.key});

  @override
  State<CreateShopScreen> createState() => _CreateShopScreenState();
}

class _CreateShopScreenState extends State<CreateShopScreen> {
  final shopNameController = TextEditingController();
  final categoryController = TextEditingController();

  void createShop() async {
    final user = FirebaseAuth.instance.currentUser;

    await FirebaseFirestore.instance.collection('shops').add({
      'ownerId': user!.uid,
      'shopName': shopNameController.text,
      'category': categoryController.text,
      'createdAt': Timestamp.now(),
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Shop Created')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Shop')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: shopNameController,
              decoration: const InputDecoration(labelText: 'Shop Name'),
            ),
            TextField(
              controller: categoryController,
              decoration: const InputDecoration(labelText: 'Category'),
            ),
            ElevatedButton(
              onPressed: createShop,
              child: const Text('Create Shop'),
            ),
          ],
        ),
      ),
    );
  }
}
