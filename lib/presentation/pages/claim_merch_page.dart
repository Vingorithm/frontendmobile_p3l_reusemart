import 'package:flutter/material.dart';
import '../../core/theme/color_pallete.dart';
import '../../data/models/claim_merchandise.dart';
import '../../data/services/claim_merchandise_service.dart';
import '../../data/services/pembeli_service.dart';
import '../../utils/tokenUtils.dart';

class ClaimScreen extends StatefulWidget {
  const ClaimScreen({super.key});

  @override
  State<ClaimScreen> createState() => _ClaimScreenState();
}

class _ClaimScreenState extends State<ClaimScreen> {
  final ClaimMerchandiseService _claimService = ClaimMerchandiseService();
  final PembeliService _pembeliService = PembeliService();
  List<ClaimMerchandise> _claimHistory = [];
  bool _isLoading = true;
  String? _errorMessage;
  String? _currentUserId;
  String? _currentPembeliId;
  String _selectedFilter = 'Semua';

  final List<String> _filterOptions = [
    'Semua',
    'Menunggu diambil',
    'Selesai',
    'Diproses',
  ];

  @override
  void initState() {
    super.initState();
    _loadUserDataAndClaims();
  }

  Future<void> _loadUserDataAndClaims() async {
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

        await _loadClaimHistory();
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
      print('Error loading user data and claims: $e');
    }
  }

  Future<void> _loadClaimHistory() async {
    if (_currentPembeliId == null) return;

    try {
      _claimHistory = await _claimService.getClaimMerchandiseByIdPembeli(_currentPembeliId!);
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal memuat histori claim: ${e.toString()}';
        _isLoading = false;
      });
      print('Error loading claim history: $e');
    }
  }

  List<ClaimMerchandise> get _filteredClaims {
    if (_selectedFilter == 'Semua') {
      return _claimHistory;
    }
    return _claimHistory.where((claim) => 
        claim.statusClaimMerchandise == _selectedFilter).toList();
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'menunggu diambil':
        return Colors.orange;
      case 'selesai':
        return Colors.green;
      case 'diproses':
        return Colors.orange;
      default:
        return AppColors.textSecondary;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'menunggu diambil':
        return Icons.pending;
      case 'selesai':
        return Icons.check_circle;
      case 'diproses':
        return Icons.pending;
      default:
        return Icons.info;
    }
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

  Widget _buildClaimCard(ClaimMerchandise claim) {
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
              color: _getStatusColor(claim.statusClaimMerchandise).withOpacity(0.1),
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
                    color: _getStatusColor(claim.statusClaimMerchandise).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getStatusIcon(claim.statusClaimMerchandise),
                    color: _getStatusColor(claim.statusClaimMerchandise),
                    size: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  claim.statusClaimMerchandise,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _getStatusColor(claim.statusClaimMerchandise),
                  ),
                ),
                const Spacer(),
                Text(
                  'ID: ${claim.idClaimMerchandise}',
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
                      child: Icon(
                        Icons.card_giftcard,
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
                            claim.merchandise?.namaMerchandise ?? 'Claim Merchandise',
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
                            'ID Merch: ${claim.idMerchandise}',
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
                        'Tanggal Claim',
                        _formatDate(claim.tanggalClaim),
                        Icons.calendar_today,
                      ),
                      if (claim.tanggalAmbil != null) ...[
                        const SizedBox(height: 8),
                        _buildDateRow(
                          'Tanggal Ambil',
                          _formatDate(claim.tanggalAmbil!),
                          Icons.event_available,
                        ),
                      ],
                    ],
                  ),
                ),
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
                        Icons.support_agent,
                        size: 14,
                        color: Colors.blue[800],
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Customer Service ID: ${claim.idCustomerService}',
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
                Icons.card_giftcard_outlined,
                size: 64,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              _selectedFilter == 'Semua' 
                  ? 'Belum Ada Histori Claim'
                  : 'Tidak Ada Claim dengan Status "$_selectedFilter"',
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
                  ? 'Belum ada Claim merchandise yang dibuat'
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
          'Histori Claim Merchandise',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _loadUserDataAndClaims,
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
                          onPressed: _loadUserDataAndClaims,
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
                            '${_filteredClaims.length} Claim Merchandise ditemukan',
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
                      child: _filteredClaims.isEmpty
                          ? _buildEmptyState()
                          : ListView.builder(
                              itemCount: _filteredClaims.length,
                              itemBuilder: (context, index) {
                                return _buildClaimCard(_filteredClaims[index]);
                              },
                            ),
                    ),
                  ],
                ),
    );
  }
}