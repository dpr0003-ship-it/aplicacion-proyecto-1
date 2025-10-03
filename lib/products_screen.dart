import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('¡Bienvenido! Aquí irán los productos.'),
      ),
    );
  }
}
