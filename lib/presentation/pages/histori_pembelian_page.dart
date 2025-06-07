import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/pembelian.dart';
import '../../data/models/pembeli.dart';
import '../../data/services/sub_pembelian_service.dart';
import '../../data/services/pembeli_service.dart';
import '../../utils/tokenUtils.dart';

class HistoriPembelianPage extends StatefulWidget {
  const HistoriPembelianPage({super.key});

  @override
  State<HistoriPembelianPage> createState() => _HistoriPembelianPageState();
}

class _HistoriPembelianPageState extends State<HistoriPembelianPage> {
  final SubPembelianService _subPembelianService = SubPembelianService();
  final PembeliService _pembeliService = PembeliService();
  List<Pembelian> _historiPembelian = [];
  bool _isLoading = true;
  String? _error;
  String? _currentUserId; // id_akun
  String? _currentPembeliId; // id_pembeli

  @override
  void initState() {
    super.initState();
    _loadCurrentUserAndHistory();
  }

  Future<void> _loadCurrentUserAndHistory() async {
    try {
      // Ambil token dari SharedPreferences
      String? token = await getToken();
      
      if (token == null) {
        setState(() {
          _error = 'Token tidak ditemukan. Silakan login kembali.';
          _isLoading = false;
        });
        return;
      }

      // Decode token untuk mendapatkan user ID (id_akun)
      Map<String, dynamic>? userInfo = decodeToken(token);
      
      if (userInfo == null) {
        setState(() {
          _error = 'Token tidak valid atau telah kedaluwarsa. Silakan login kembali.';
          _isLoading = false;
        });
        return;
      }

      _currentUserId = userInfo['id'];

      // Ambil data pembeli berdasarkan id_akun untuk mendapatkan id_pembeli
      await _loadPembeliData();

    } catch (e) {
      setState(() {
        _error = 'Terjadi kesalahan: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadPembeliData() async {
    if (_currentUserId == null) return;

    try {
      // Ambil data pembeli berdasarkan id_akun
      Pembeli pembeli = await _pembeliService.getPembeliByIdAkun(_currentUserId!);
      _currentPembeliId = pembeli.idPembeli;

      // Load histori pembelian berdasarkan id_pembeli
      await _loadHistoriPembelian();

    } catch (e) {
      setState(() {
        _error = 'Gagal memuat data pembeli: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadHistoriPembelian() async {
    if (_currentPembeliId == null) return;

    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      List<Pembelian> histori = await _subPembelianService
          .getHistoryPembelianByPembeliId(_currentPembeliId!);

      setState(() {
        _historiPembelian = histori;
        _isLoading = false;
      });

    } catch (e) {
      setState(() {
        _error = 'Gagal memuat histori pembelian: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshHistori() async {
    await _loadCurrentUserAndHistory();
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  String _formatCurrency(double amount) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(amount);
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'paid':
      case 'lunas':
      case 'pembayaran valid':
        return Colors.green;
      case 'cancelled':
      case 'batal':
        return Colors.red;
      case 'processing':
      case 'diproses':
        return Colors.blue;
      case 'shipped':
      case 'dikirim':
        return Colors.purple;
      case 'delivered':
      case 'selesai':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  Widget _buildPembelianCard(Pembelian pembelian) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header dengan ID dan Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'ID: ${pembelian.idPembelian}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(pembelian.statusPembelian).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _getStatusColor(pembelian.statusPembelian),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    pembelian.statusPembelian,
                    style: TextStyle(
                      color: _getStatusColor(pembelian.statusPembelian),
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Tanggal Pembelian
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  'Tanggal: ${_formatDate(pembelian.tanggalPembelian)}',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),

            // Tanggal Pelunasan (jika ada)
            if (pembelian.tanggalPelunasan != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.payment, size: 16, color: Colors.green),
                  const SizedBox(width: 8),
                  Text(
                    'Lunas: ${_formatDate(pembelian.tanggalPelunasan!)}',
                    style: const TextStyle(
                      color: Colors.green,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),

            // Detail Harga
            Column(
              children: [
                _buildPriceRow('Total Harga', pembelian.totalHarga),
                _buildPriceRow('Ongkir', pembelian.ongkir),
                if (pembelian.potonganPoin > 0)
                  _buildPriceRow('Potongan Poin', -pembelian.potonganPoin.toDouble(), isDiscount: true),
                const SizedBox(height: 4),
                const Divider(),
                _buildPriceRow('Total Bayar', pembelian.totalBayar, isBold: true),
              ],
            ),

            // Poin yang diperoleh
            if (pembelian.poinDiperoleh > 0) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.stars, color: Colors.amber, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'Poin diperoleh: ${pembelian.poinDiperoleh}',
                      style: const TextStyle(
                        color: Colors.amber,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Alamat pengiriman
            if (pembelian.alamat != null) ...[
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.location_on, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Alamat: ${pembelian.alamat}',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount, {bool isBold = false, bool isDiscount = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isBold ? 16 : 14,
            ),
          ),
          Text(
            _formatCurrency(amount),
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isBold ? 16 : 14,
              color: isDiscount ? Colors.green : null,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histori Pembelian'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshHistori,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.red.shade700,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadCurrentUserAndHistory,
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }

    if (_historiPembelian.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'Belum ada histori pembelian',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Mulai berbelanja untuk melihat histori pembelian Anda',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: _historiPembelian.length,
      itemBuilder: (context, index) {
        return _buildPembelianCard(_historiPembelian[index]);
      },
    );
  }
}