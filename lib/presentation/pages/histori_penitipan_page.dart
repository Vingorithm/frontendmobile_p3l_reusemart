import 'package:flutter/material.dart';
import '../../core/theme/color_pallete.dart';
import '../../utils/tokenUtils.dart';
import '../../data/services/penitipan_service.dart';
import '../../data/services/penitip_service.dart';
import '../../data/models/penitipan.dart';
import '../../data/models/penitip.dart';

class HistoriPenitipanPage extends StatefulWidget {
  const HistoriPenitipanPage({super.key});

  @override
  State<HistoriPenitipanPage> createState() => _HistoriPenitipanPageState();
}

class _HistoriPenitipanPageState extends State<HistoriPenitipanPage> {
  List<PenitipanWithDetails> _penitipanList = [];
  bool _isLoading = true;
  String? _errorMessage;
  String _userId = '';
  String _penitipId = '';
  String _selectedFilter = 'Semua';
  
  final List<String> _filterOptions = [
    'Semua',
    'Dalam Masa Penitipan',
    'Berakhir',
    'Diambil',
    'Dikembalikan'
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
        _userId = decoded['id']?.toString() ?? '';
        String _userRole = decoded['role'] ?? '';
        
        if (_userRole.toLowerCase() != 'penitip') {
          setState(() {
            _errorMessage = 'Halaman ini hanya untuk penitip';
            _isLoading = false;
          });
          return;
        }

        // Get penitip data first
        final penitipService = PenitipService();
        final penitipData = await penitipService.getPenitipByIdAkun(_userId);
        _penitipId = penitipData.idPenitip;

        // Then get penitipan history
        await _loadPenitipanHistory();
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

  Future<void> _loadPenitipanHistory() async {
    try {
      final penitipanService = PenitipanService();
      // Assuming you'll add this method to PenitipanService
      final penitipanList = await penitipanService.getPenitipanByIdPenitip(_penitipId);

      setState(() {
        _penitipanList = penitipanList;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal memuat histori penitipan: ${e.toString()}';
        _isLoading = false;
      });
      print('Error loading penitipan history: $e');
    }
  }

  List<PenitipanWithDetails> get _filteredPenitipan {
    if (_selectedFilter == 'Semua') {
      return _penitipanList;
    }
    return _penitipanList.where((p) => p.penitipan.statusPenitipan == _selectedFilter).toList();
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'Dalam masa penitipan':
        return Colors.blue;
      case 'terjual':
        return Colors.green;
      case 'diambil':
        return Colors.orange;
      case 'dikembalikan':
        return Colors.red;
      default:
        return AppColors.textSecondary;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'Dalam masa penitipan':
        return Icons.inventory_2;
      case 'terjual':
        return Icons.sell;
      case 'diambil':
        return Icons.check_circle;
      case 'dikembalikan':
        return Icons.keyboard_return;
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

  Widget _buildPenitipanCard(PenitipanWithDetails item) {
    final penitipan = item.penitipan;
    final barang = item.barang;
    
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
          // Header with status
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _getStatusColor(penitipan.statusPenitipan).withOpacity(0.1),
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
                    color: _getStatusColor(penitipan.statusPenitipan).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getStatusIcon(penitipan.statusPenitipan),
                    color: _getStatusColor(penitipan.statusPenitipan),
                    size: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  penitipan.statusPenitipan,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _getStatusColor(penitipan.statusPenitipan),
                  ),
                ),
                const Spacer(),
                Text(
                  'ID: ${penitipan.idPenitipan}',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Item info
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image placeholder
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.textSecondary.withOpacity(0.2),
                        ),
                      ),
                      child: barang?.gambar != null && barang!.gambar.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                barang.gambar.split(',').first,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.image_not_supported,
                                    color: AppColors.textSecondary,
                                    size: 24,
                                  );
                                },
                              ),
                            )
                          : Icon(
                              Icons.inventory_2,
                              color: AppColors.textSecondary,
                              size: 24,
                            ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            barang?.nama ?? 'Nama barang tidak tersedia',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          if (barang?.harga != null)
                            Text(
                              _formatCurrency(barang!.harga),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          const SizedBox(height: 4),
                          Text(
                            'Kategori: ${barang?.kategoriBarang ?? 'N/A'}',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Dates info
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      _buildDateRow(
                        'Mulai Penitipan',
                        _formatDate(penitipan.tanggalAwalPenitipan),
                        Icons.calendar_today,
                      ),
                      const SizedBox(height: 8),
                      _buildDateRow(
                        'Berakhir',
                        _formatDate(penitipan.tanggalAkhirPenitipan),
                        Icons.event,
                      ),
                      const SizedBox(height: 8),
                      _buildDateRow(
                        'Batas Pengambilan',
                        _formatDate(penitipan.tanggalBatasPengambilan),
                        Icons.schedule,
                      ),
                    ],
                  ),
                ),
                
                // Extension info
                if (penitipan.perpanjangan) ...[
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
                          Icons.extension,
                          size: 14,
                          color: Colors.amber[700],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Diperpanjang',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.amber[700],
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
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: 6),
        Text(
          '$label:',
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
        const Spacer(),
        Text(
          date,
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
                Icons.inventory_2_outlined,
                size: 64,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              _selectedFilter == 'Semua' 
                  ? 'Belum Ada Histori Penitipan'
                  : 'Tidak Ada Penitipan dengan Status "$_selectedFilter"',
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
                  ? 'Mulai titipkan barang Anda untuk melihat histori di sini'
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
          'Histori Penitipan',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.textPrimary,
          ),
        ),
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
                    // Filter chips
                    _buildFilterChips(),
                    const SizedBox(height: 8),
                    
                    // Results count
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Text(
                            '${_filteredPenitipan.length} penitipan ditemukan',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // List
                    Expanded(
                      child: _filteredPenitipan.isEmpty
                          ? _buildEmptyState()
                          : ListView.builder(
                              itemCount: _filteredPenitipan.length,
                              itemBuilder: (context, index) {
                                return _buildPenitipanCard(_filteredPenitipan[index]);
                              },
                            ),
                    ),
                  ],
                ),
    );
  }
}