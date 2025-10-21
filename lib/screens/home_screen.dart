import 'package:flutter/material.dart';
import 'package:recipe_gsg/services/shared_prefs.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await SharedPrefs.logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
        title: const Text('Home'),
        centerTitle: true,
      ),
    );
  }
}
