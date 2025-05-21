import 'package:flutter/material.dart';

class HistoriKomisiPage extends StatefulWidget {
  const HistoriKomisiPage({super.key});

  @override
  State<HistoriKomisiPage> createState() => _HistoriKomisiPageState();
}

class _HistoriKomisiPageState extends State<HistoriKomisiPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Histori Komisi Screen',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}