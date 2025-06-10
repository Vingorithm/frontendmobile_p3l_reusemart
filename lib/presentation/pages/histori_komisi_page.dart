// lib/presentation/pages/history_komisi.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../data/services/transaksi_service.dart';
import '../../data/services/sub_pembelian_service.dart';
import '../../data/services/pegawai_service.dart';
import '../../data/models/sub_pembelian.dart';
import '../../core/theme/color_pallete.dart';
import '../../utils/tokenUtils.dart';

class HistoryKomisiDetailPage extends StatefulWidget {
  const HistoryKomisiDetailPage({super.key});
  @override
  State<HistoryKomisiDetailPage> createState() =>
      _HistoryKomisiDetailPageState();
}

class _HistoryKomisiDetailPageState extends State<HistoryKomisiDetailPage> {
  late Future<Map<String, dynamic>> _futureKomisiData;
  String _userId = '';

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      final token = await getToken();
      if (token != null) {
        final decoded = decodeToken(token);
        if (decoded != null && decoded.containsKey('id')) {
          setState(() {
            _userId = decoded['id'];
          });
          _loadKomisiData();
        }
      }
    } catch (e) {
      print('Error initializing data: $e');
    }
  }

  void _loadKomisiData() {
    _futureKomisiData = _getKomisiWithDetails();
  }

  Future<Map<String, dynamic>> _getKomisiWithDetails() async {
    // Get pegawai data first
    final pegawai = await PegawaiService().getPegawaiByIdAkun(_userId);
    final idPegawai = pegawai.idPegawai;

    // Get komisi summary
    final komisiData =
        await TransaksiService().getHunterKomisiSummary(idPegawai);

    // Get detailed data for each transaction
    final List<dynamic> transaksiList = komisiData['transaksi'] ?? [];
    final List<Map<String, dynamic>> detailedTransaksi = [];

    for (var transaksi in transaksiList) {
      try {
        final subPembelianId = transaksi['SubPembelian']['id_sub_pembelian'];
        final subPembelianDetail =
            await SubPembelianService().getSubPembelianById(subPembelianId);

        detailedTransaksi.add({
          'transaksi': transaksi,
          'detail': subPembelianDetail,
        });
      } catch (e) {
        print('Error loading detail for ${transaksi['id_transaksi']}: $e');
        // Add without detail if error
        detailedTransaksi.add({
          'transaksi': transaksi,
          'detail': null,
        });
      }
    }

    return {
      'summary': komisiData,
      'detailed_transaksi': detailedTransaksi,
    };
  }

  String _formatPrice(dynamic price) {
    final priceDouble = double.tryParse(price.toString()) ?? 0.0;
    return 'Rp ${priceDouble.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    try {
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return '-';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false, // Hapus back button
        title: const Text(
          'History Komisi',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true, // Center title
        backgroundColor: AppColors.white,
        elevation: 0,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _futureKomisiData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Gagal memuat data komisi',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _loadKomisiData();
                      });
                    },
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('Tidak ada data'));
          }

          final data = snapshot.data!;
          final summary = data['summary'] as Map<String, dynamic>;
          final detailedTransaksi =
              data['detailed_transaksi'] as List<Map<String, dynamic>>;

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _loadKomisiData();
              });
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Summary Card
                  _buildSummaryCard(summary),
                  const SizedBox(height: 24),

                  // Transaction List Header
                  Row(
                    children: [
                      Icon(Icons.history, color: AppColors.primary, size: 20),
                      const SizedBox(width: 8),
                      const Text(
                        'Riwayat Transaksi',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Transaction List
                  if (detailedTransaksi.isEmpty)
                    _buildEmptyState()
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: detailedTransaksi.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        return _buildTransactionCard(detailedTransaksi[index]);
                      },
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard(Map<String, dynamic> summary) {
    final totalKomisi =
        double.tryParse(summary['total_komisi_hunter']?.toString() ?? '0') ??
            0.0;
    final jumlahTransaksi = summary['jumlah_transaksi'] ?? 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.account_balance_wallet,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Total Komisi Hunter',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            _formatPrice(totalKomisi),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Dari $jumlahTransaksi transaksi',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionCard(Map<String, dynamic> item) {
    final transaksi = item['transaksi'];
    final detail = item['detail'] as SubPembelian?;

    final komisiHunter =
        double.tryParse(transaksi['komisi_hunter']?.toString() ?? '0') ?? 0.0;
    final barangNama =
        transaksi['SubPembelian']?['Barang']?['nama'] ?? 'Unknown Item';
    final barangHarga = transaksi['SubPembelian']?['Barang']?['harga'] ?? '0';
    final idTransaksi = transaksi['id_transaksi'] ?? '';

    // Get additional details from SubPembelian if available
    String tanggalPelunasan = '-';
    String statusPembelian = '-';
    String idPembelian = '-';

    if (detail != null && detail.pembelian != null) {
      tanggalPelunasan = _formatDate(detail.pembelian!.tanggalPelunasan);
      statusPembelian = detail.pembelian!.statusPembelian ?? '-';
      idPembelian = detail.pembelian!.idPembelian ?? '-';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Transaction Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      barangNama,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'ID: $idTransaksi',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _formatPrice(komisiHunter),
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Transaction Details
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                _buildDetailRow('Harga Barang', _formatPrice(barangHarga)),
                const SizedBox(height: 8),
                _buildDetailRow('Tanggal Pelunasan', tanggalPelunasan),
                const SizedBox(height: 8),
                _buildDetailRow('ID Pembelian', idPembelian),
                const SizedBox(height: 8),
                _buildDetailRow('Status', statusPembelian),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Belum Ada Transaksi',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Transaksi komisi akan muncul di sini',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
