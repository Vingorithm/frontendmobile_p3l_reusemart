import 'package:flutter/material.dart';

class HistoriPembelianPage extends StatefulWidget {
  const HistoriPembelianPage({super.key});

  @override
  State<HistoriPembelianPage> createState() => _HistoriPembelianPageState();
}

class _HistoriPembelianPageState extends State<HistoriPembelianPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Histori Pembelian Screen',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}