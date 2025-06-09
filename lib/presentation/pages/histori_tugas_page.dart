import 'package:flutter/material.dart';
import 'package:frontendmobile_p3l_reusemart/core/theme/color_pallete.dart';

class HistoriTugasPage extends StatefulWidget {
  const HistoriTugasPage({super.key});

  @override
  State<HistoriTugasPage> createState() => _HistoriTugasPageState();
}

class _HistoriTugasPageState extends State<HistoriTugasPage> {
  bool isOngoing = true;
  String searchQuery = '';

  final List<Map<String, String>> ongoingData = [
    {
      'kode': '#KK–11.04.2025',
      'alamat': 'Jl. Babarsari 45',
      'penerima': 'Budianto',
      'tanggal': '12 Apr 2025',
    },
    {
      'kode': '#KK–13.04.2025',
      'alamat': 'Jl. Kaliurang Km.7',
      'penerima': 'Siti Aminah',
      'tanggal': '13 Apr 2025',
    },
  ];

  final List<Map<String, String>> selesaiData = [
    {
      'kode': '#KK–05.04.2025',
      'alamat': 'Jl. Affandi 10',
      'penerima': 'Dwi Nugroho',
      'tanggal': '05 Apr 2025',
    },
    {
      'kode': '#KK–06.04.2025',
      'alamat': 'Jl. Gejayan 22',
      'penerima': 'Rina Kartika',
      'tanggal': '06 Apr 2025',
    },
  ];

  List<Map<String, String>> get filteredData {
    final List<Map<String, String>> activeData =
        isOngoing ? ongoingData : selesaiData;

    if (searchQuery.trim().isEmpty) return activeData;

    return activeData.where((item) {
      final query = searchQuery.toLowerCase();
      return (item['kode']?.toLowerCase().contains(query) ?? false) ||
          (item['alamat']?.toLowerCase().contains(query) ?? false) ||
          (item['penerima']?.toLowerCase().contains(query) ?? false) ||
          (item['tanggal']?.toLowerCase().contains(query) ?? false);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tugas Pengiriman',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildTabs(),
              const SizedBox(height: 12),
              TextField(
                onChanged: (value) => setState(() => searchQuery = value),
                decoration: InputDecoration(
                  hintText: 'Cari berdasarkan ID, alamat, penerima, atau tanggal',
                  filled: true,
                  fillColor: const Color(0xFFF3F3F3),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Icons.search),
                  hintStyle: TextStyle(fontSize: 12, color: AppColors.black.withOpacity(0.8))
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  itemCount: filteredData.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return _buildCard(filteredData[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() {
                isOngoing = true;
                searchQuery = '';
              }),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isOngoing ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Belum Selesai',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isOngoing ? Colors.black : Colors.grey,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() {
                isOngoing = false;
                searchQuery = '';
              }),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: !isOngoing ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Selesai',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: !isOngoing ? Colors.black : Colors.grey,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(Map<String, String> data) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFDFDFD),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(1, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data['kode'] ?? '',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text('Alamat: ${data['alamat']}', style: TextStyle(fontSize: 12, color: AppColors.black.withOpacity(0.8))),
          Text('Penerima: ${data['penerima']}', style: TextStyle(fontSize: 12, color: AppColors.black.withOpacity(0.8))),
          Text('Tanggal: ${data['tanggal']}', style: TextStyle(fontSize: 12, color: AppColors.black.withOpacity(0.8))),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00994C),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.arrow_forward, size: 18, color: AppColors.white),
                  label: const Text('Detail', style: TextStyle(color: AppColors.white)),
                ),
              ),
              const SizedBox(width: 12),
              if (isOngoing)
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00994C),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: const Icon(Icons.check_circle_outline, size: 18, color: AppColors.white),
                    label: const Text('Selesai', style: TextStyle(color: AppColors.white)),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
