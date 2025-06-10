import 'package:flutter/material.dart';
import '../../data/models/merchandise.dart';
import '../../data/api_service.dart';
import '../../data/services/merchandise_service.dart';
import '../../core/theme/color_pallete.dart';
import '../widgets/merchandise_card.dart';
import '../widgets/search_bar.dart';
import 'claim_merch_page.dart';

class MerchandiseScreen extends StatefulWidget {
  const MerchandiseScreen({super.key});

  @override
  State<MerchandiseScreen> createState() => _MerchandiseScreenState();
}

class _MerchandiseScreenState extends State<MerchandiseScreen> {
  final MerchandiseService _apiService = MerchandiseService();
  late Future<List<Merchandise>> _futureMerchandise;
  String _searchQuery = '';
  String _selectedFilter = 'All'; // Track selected filter option

  @override
  void initState() {
    super.initState();
    _futureMerchandise = _apiService.getAllMerchandise();
  }

  // Filter merchandise based on search query and hargaPoin
  List<Merchandise> _filterMerchandise(List<Merchandise> merchandise, String query, String filter) {
    List<Merchandise> filteredList = merchandise;

    // Apply search query filter
    if (query.isNotEmpty) {
      final lowerQuery = query.toLowerCase();
      filteredList = filteredList
          .where((item) =>
              item.namaMerchandise.toLowerCase().contains(lowerQuery) ||
              item.deskripsi.toLowerCase().contains(lowerQuery))
          .toList();
    }

    // Apply hargaPoin filter
    switch (filter) {
      case 'Below 100':
        filteredList = filteredList.where((item) => item.hargaPoin < 100).toList();
        break;
      case '100-500':
        filteredList = filteredList.where((item) => item.hargaPoin >= 100 && item.hargaPoin <= 500).toList();
        break;
      case 'Above 500':
        filteredList = filteredList.where((item) => item.hargaPoin > 500).toList();
        break;
      case 'All':
      default:
        // No additional filtering needed
        break;
    }

    return filteredList;
  }

  // Show filter options in a modal bottom sheet
  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Filter by Points',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              _buildFilterOption('All', 'All Points'),
              _buildFilterOption('Below 100', 'Below 100 Points'),
              _buildFilterOption('100-500', '100 - 500 Points'),
              _buildFilterOption('Above 500', 'Above 500 Points'),
            ],
          ),
        );
      },
    );
  }

  // Build individual filter option
  Widget _buildFilterOption(String value, String label) {
    return ListTile(
      title: Text(
        label,
        style: TextStyle(
          color: _selectedFilter == value ? AppColors.primary : AppColors.textPrimary,
          fontWeight: _selectedFilter == value ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: _selectedFilter == value
          ? Icon(Icons.check, color: AppColors.primary)
          : null,
      onTap: () {
        setState(() {
          _selectedFilter = value;
        });
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Merchandise',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ClaimScreen(),
                ),
              );
            },
            icon: const Icon(
              Icons.history,
              color: AppColors.primary,
            ),
            tooltip: 'Claim History',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar and Filter Section
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                SearchBarWidget(
                  hintText: 'Cari merchandise...',
                  onSearch: (query) {
                    setState(() {
                      _searchQuery = query;
                    });
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _showFilterOptions,
                        icon: const Icon(Icons.filter_list, size: 20),
                        label: const Text('Filter'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.white,
                          foregroundColor: AppColors.primary,
                          elevation: 0,
                          side: const BorderSide(color: AppColors.primary),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Sort functionality
                        },
                        icon: const Icon(Icons.sort, size: 20),
                        label: const Text('Urutkan'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.white,
                          foregroundColor: AppColors.primary,
                          elevation: 0,
                          side: const BorderSide(color: AppColors.primary),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Main Content
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  _futureMerchandise = _apiService.getAllMerchandise();
                });
              },
              color: AppColors.primary,
              child: FutureBuilder<List<Merchandise>>(
                future: _futureMerchandise,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _buildLoadingState();
                  } else if (snapshot.hasError) {
                    return _buildErrorState();
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return _buildEmptyState();
                  }

                  final merchandiseList = _filterMerchandise(snapshot.data!, _searchQuery, _selectedFilter);

                  if (merchandiseList.isEmpty && (_searchQuery.isNotEmpty || _selectedFilter != 'All')) {
                    return _buildSearchEmptyState();
                  }

                  return _buildMerchandiseGrid(merchandiseList);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMerchandiseGrid(List<Merchandise> merchandiseList) {
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.68,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: merchandiseList.length,
      itemBuilder: (context, index) {
        final merchandise = merchandiseList[index];
        return MerchandiseCard(
          merchandise: merchandise,
          onTap: () {
            debugPrint('Merchandise tapped: ${merchandise.namaMerchandise}');
            // Navigate to detail page
          },
        );
      },
    );
  }

  Widget _buildSearchEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 80,
              color: AppColors.gray,
            ),
            const SizedBox(height: 16),
            Text(
              'Merchandise Tidak Ditemukan',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Coba gunakan kata kunci lain atau filter lain',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _searchQuery = '';
                  _selectedFilter = 'All';
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Lihat Semua'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppColors.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'Memuat merchandise...',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: AppColors.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Terjadi Kesalahan',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Gagal memuat merchandise',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _futureMerchandise = _apiService.getAllMerchandise();
                });
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.card_giftcard_outlined,
              size: 80,
              color: AppColors.gray,
            ),
            const SizedBox(height: 16),
            Text(
              'Belum Ada Merchandise',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Merchandise akan segera tersedia',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}