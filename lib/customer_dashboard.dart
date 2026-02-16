import 'package:flutter/material.dart';
import 'shop_list.dart';

class CustomerDashboard extends StatelessWidget {
  const CustomerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Customer Dashboard')),
     body: Center(
  child: ElevatedButton(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ShopListScreen(),
        ),
      );
    },
    child: const Text('Browse Shops'),
  ),
),

    );
  }
}
