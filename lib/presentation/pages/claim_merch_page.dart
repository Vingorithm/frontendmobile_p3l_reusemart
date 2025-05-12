// lib/presentation/pages/claim_merch_page.dart
import 'package:flutter/material.dart';

class ClaimScreen extends StatelessWidget {
  const ClaimScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Claim Merch Screen',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}