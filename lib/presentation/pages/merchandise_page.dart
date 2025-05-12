// lib/presentation/pages/merchandise_page.dart
import 'package:flutter/material.dart';

class MerchandiseScreen extends StatelessWidget {
  const MerchandiseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Merchandise Screen',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}