import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/color_pallete.dart';
import '../../data/models/pembelian.dart';
import '../../data/services/pembelian_service.dart';
import '../../data/services/pembeli_service.dart';
import '../../data/models/pembeli.dart';
import '../../utils/tokenUtils.dart';
import '../../data/api_service.dart';

class HistoriPembelianPage extends StatefulWidget {
  const HistoriPembelianPage({super.key});

  @override
  State<HistoriPembelianPage> createState() => _HistoriPembelianPageState();
}

class _HistoriPembelianPageState extends State<HistoriPembelianPage> {
  final PembelianService _pembelianService = PembelianService();
  final PembeliService _pembeliService = PembeliService();
  List<Pembelian> _historiPembelian = [];
  bool _isLoading = true;
  String? _errorMessage;
  String? _currentUserId;
  String? _currentPembeliId;
  String _selectedFilter = 'Semua';

  final List<String> _filterOptions = [
    'Semua',
    'Pembayaran valid',
    'Pembayaran tidak valid',
    'Menunggu verifikasi pembayaran',
    'Tidak mengirimkan bukti pembayaran',
  ];

  @override
  void initState() {
    super.initState();
    _loadUserDataAndHistory();
  }

  Future<void> _loadUserDataAndHistory() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      String? token = await getToken();
      if (token == null || token.isEmpty) {
        setState(() {
          _errorMessage = 'Silakan login terlebih dahulu';
          _isLoading = false;
        });
        return;
      }

      final decoded = decodeToken(token);
      if (decoded != null) {
        _currentUserId = decoded['id']?.toString() ?? '';
        String userRole = decoded['role'] ?? '';

        if (userRole.toLowerCase() != 'pembeli') {
          setState(() {
            _errorMessage = 'Halaman ini hanya untuk pembeli';
            _isLoading = false;
          });
          return;
        }

        final pembeli = await _pembeliService.getPembeliByIdAkun(_currentUserId!);
        _currentPembeliId = pembeli.idPembeli;

        await _loadHistoriPembelian();
      } else {
        setState(() {
          _errorMessage = 'Token tidak valid';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal memuat data: ${e.toString()}';
        _isLoading = false;
      });
      print('Error loading user data and history: $e');
    }
  }

  Future<void> _loadHistoriPembelian() async {
    if (_currentPembeliId == null) return;

    try {
      List<Pembelian> allPembelian = await _pembelianService.getAllPembelian();

      _historiPembelian = allPembelian.where((pembelian) {
        return pembelian.idPembeli == _currentPembeliId;
      }).toList();

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal memuat histori pembelian: ${e.toString()}';
        _isLoading = false;
      });
      print('Error loading pembelian history: $e');
    }
  }

  List<Pembelian> get _filteredPembelian {
    if (_selectedFilter == 'Semua') {
      return _historiPembelian;
    }
    return _historiPembelian.where((p) => p.statusPembelian == _selectedFilter).toList();
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'menunggu verifikasi pembayaran':
        return Colors.orange;
      case 'pembayaran valid':
        return Colors.green;
      case 'pembayaran tidak valid':
      case 'tidak mengirimkan bukti pembayaran':
        return Colors.red;
      default:
        return AppColors.textSecondary;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'menunggu verifikasi pembayaran':
        return Icons.pending;
      case 'pembayaran valid':
        return Icons.check_circle;
      case 'pembayaran tidak valid':
      case 'tidak mengirimkan bukti pembayaran':
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }

  String _formatCurrency(double? amount) {
    if (amount == null) return 'Rp 0';
    return 'Rp ${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  Widget _buildFilterChips() {
    return Container(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _filterOptions.length,
        itemBuilder: (context, index) {
          final filter = _filterOptions[index];
          final isSelected = _selectedFilter == filter;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(
                filter,
                style: TextStyle(
                  color: isSelected ? AppColors.white : AppColors.textPrimary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedFilter = filter;
                });
              },
              selectedColor: AppColors.primary,
              backgroundColor: AppColors.white,
              side: BorderSide(
                color: isSelected ? AppColors.primary : AppColors.textSecondary.withOpacity(0.3),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPembelianCard(Pembelian pembelian) {
    // Display the first item in SubPembelians for simplicity, or iterate if multiple items are needed
    final subPembelian = pembelian.subPembelians?.isNotEmpty == true ? pembelian.subPembelians![0] : null;
    final barang = subPembelian?.barang;

    if (barang == null) {
      return const SizedBox.shrink();
    }

    // Construct the image URL by prepending baseUrl if the image is just a filename
    String? imageUrl;
    if (barang.gambar != null && barang.gambar!.isNotEmpty) {
      final firstImage = barang.gambar!.split(',').first.trim();
      if (firstImage.isNotEmpty && !firstImage.startsWith('http')) {
        imageUrl = '${BaseApiService.baseUrlGambar}/uploads/barang/$firstImage';
      } else {
        imageUrl = firstImage;
      }
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _getStatusColor(pembelian.statusPembelian).withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(pembelian.statusPembelian).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getStatusIcon(pembelian.statusPembelian),
                    color: _getStatusColor(pembelian.statusPembelian),
                    size: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  pembelian.statusPembelian,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _getStatusColor(pembelian.statusPembelian),
                  ),
                ),
                const Spacer(),
                Text(
                  'ID: ${pembelian.idPembelian}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.grey[400]!,
                        ),
                      ),
                      child: imageUrl != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.image_not_supported,
                                    color: Colors.grey[600],
                                    size: 24,
                                  );
                                },
                              ),
                            )
                          : Icon(
                              Icons.shopping_bag,
                              color: Colors.grey[600],
                              size: 24,
                            ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            barang.nama,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[900],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _formatCurrency(barang.harga),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Kategori: ${barang.kategoriBarang}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      _buildDateRow(
                        'Tanggal Pembelian',
                        _formatDate(pembelian.tanggalPembelian),
                        Icons.calendar_today,
                      ),
                      if (pembelian.tanggalPelunasan != null) ...[
                        const SizedBox(height: 8),
                        _buildDateRow(
                          'Tanggal Pelunasan',
                          _formatDate(pembelian.tanggalPelunasan!),
                          Icons.payment,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      _buildPriceRow('Total Harga', pembelian.totalHarga),
                      _buildPriceRow('Ongkir', pembelian.ongkir),
                      if (pembelian.potonganPoin > 0)
                        _buildPriceRow('Potongan Poin', -pembelian.potonganPoin.toDouble(), isDiscount: true),
                      const SizedBox(height: 8),
                      const Divider(height: 1),
                      const SizedBox(height: 8),
                      _buildPriceRow('Total Bayar', pembelian.totalBayar, isBold: true),
                    ],
                  ),
                ),
                if (pembelian.poinDiperoleh > 0) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: Colors.amber.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.stars,
                          size: 14,
                          color: Colors.amber[800],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Poin diperoleh: ${pembelian.poinDiperoleh}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.amber[800],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                if (pembelian.alamat?.alamatLengkap != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: Colors.blue.withOpacity(0.2),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 14,
                          color: Colors.blue[800],
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Alamat: ${pembelian.alamat!.alamatLengkap}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue[800],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateRow(String label, String date, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          size: 14,
          color: Colors.grey[800],
        ),
        const SizedBox(width: 6),
        Text(
          '$label:',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[800],
          ),
        ),
        const Spacer(),
        Text(
          date,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey[900],
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRow(String label, double amount, {bool isBold = false, bool isDiscount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isBold ? 14 : 12,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
            color: isBold ? Colors.grey[900] : Colors.grey[800],
          ),
        ),
        Text(
          _formatCurrency(amount),
          style: TextStyle(
            fontSize: isBold ? 14 : 12,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.w500,
            color: isDiscount ? Colors.green : (isBold ? Colors.grey[900] : Colors.grey[800]),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.shopping_bag_outlined,
                size: 64,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              _selectedFilter == 'Semua'
                  ? 'Belum Ada Histori Pembelian'
                  : 'Tidak Ada Pembelian dengan Status "$_selectedFilter"',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _selectedFilter == 'Semua'
                  ? 'Mulai berbelanja untuk melihat histori di sini'
                  : 'Coba pilih filter status yang lain',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Histori Pembelian',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _loadUserDataAndHistory,
            icon: const Icon(
              Icons.refresh,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red.withOpacity(0.6),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _errorMessage!,
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadUserDataAndHistory,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.white,
                          ),
                          child: const Text('Coba Lagi'),
                        ),
                      ],
                    ),
                  ),
                )
              : Column(
                  children: [
                    _buildFilterChips(),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Text(
                            '${_filteredPembelian.length} pembelian ditemukan',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: _filteredPembelian.isEmpty
                          ? _buildEmptyState()
                          : ListView.builder(
                              itemCount: _filteredPembelian.length,
                              itemBuilder: (context, index) {
                                return _buildPembelianCard(_filteredPembelian[index]);
                              },
                            ),
                    ),
                  ],
                ),
    );
  }
}