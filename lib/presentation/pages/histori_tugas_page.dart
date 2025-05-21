import 'package:flutter/material.dart';

class HistoriTugasPage extends StatefulWidget {
  const HistoriTugasPage({super.key});

  @override
  State<HistoriTugasPage> createState() => _HistoriTugasPageState();
}

class _HistoriTugasPageState extends State<HistoriTugasPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Histori Tugas Screen',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}