import 'package:flutter/material.dart';

class HistoriPenitipanPage extends StatefulWidget {
  const HistoriPenitipanPage({super.key});

  @override
  State<HistoriPenitipanPage> createState() => _HistoriPenitipanPageState();
}

class _HistoriPenitipanPageState extends State<HistoriPenitipanPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Histori Penitipan Screen',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}