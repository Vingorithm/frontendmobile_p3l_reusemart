// lib/presentation/pages/transaksi_page.dart
import 'package:flutter/material.dart';

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Transaction Screen',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}