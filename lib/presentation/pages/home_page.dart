// lib/presentation/pages/home_page.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../data/api_service.dart';
import '../../core/theme/color_pallete.dart';
import '../../data/models/barang.dart';
import '../../presentation/widgets/product_card.dart';
import '../../presentation/widgets/category_card.dart';
import '../../presentation/widgets/search_bar.dart';
import '../../presentation/widgets/persistent_navbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Barang>> _futureBarang;
  String _searchQuery = '';
  int _selectedNavIndex = 0;

  @override
  void initState() {
    super.initState();
    _futureBarang = _apiService.getAllBarang();
  }

  // Filter Barang based on search query
  List<Barang> _filterBarang(List<Barang> barang, String query) {
    if (query.isEmpty) {
      return barang.where((item) => item.statusQc == 'Lulus').toList();
    }
    final lowerQuery = query.toLowerCase();
    return barang
        .where((item) =>
            item.statusQc == 'Lulus' &&
            (item.nama.toLowerCase().contains(lowerQuery) ||
                item.kategoriBarang.toLowerCase().contains(lowerQuery)))
        .toList();
  }

  // Get unique categories with curated images
  List<Map<String, dynamic>> _getCategories(List<Barang> barang) {
    final categories = <String, Map<String, dynamic>>{};
    final categoryImages = {
      'Elektronik & Gadget': 'https://images.unsplash.com/photo-1516321497487-e288fb19713f',
      'Kosmetik & Perawatan Diri': 'https://images.unsplash.com/photo-1596755094514-f87e34085b2c',
      'Buku, Alat Tulis, & Peralatan Sekolah': 'https://images.unsplash.com/photo-1503676260728-332c239b4121',
      'Hobi, Mainan, & Koleksi': 'https://images.unsplash.com/photo-1515488042361-ee00e0ddd4e4',
      'Otomotif & Aksesori': 'https://images.unsplash.com/photo-1503376780353-7e6692767b70',
      'Pakaian & Aksesori': 'https://images.unsplash.com/photo-1558769132-cb1aea458c5e',
    };

    for (var item in barang) {
      if (!categories.containsKey(item.kategoriBarang)) {
        categories[item.kategoriBarang] = {
          'name': item.kategoriBarang,
          'image': categoryImages[item.kategoriBarang] ?? 'https://via.placeholder.com/150',
          'discount': null, // Update if backend provides discount data
        };
      }
    }
    return categories.values.toList();
  }

  // Get product count for a category
  int _getProductCount(List<Barang> barang, String category) {
    return barang.where((item) => item.kategoriBarang == category).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                'Selamat Berbelanja!',
                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      color: AppColors.primary,
                    ),
              ),
            ),
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SearchBarWidget(
                hintText: 'Cari Produk Impianmu 🔍',
                onSearch: (query) {
                  setState(() {
                    _searchQuery = query;
                  });
                },
              ),
            ),
            // Main Content
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  setState(() {
                    _futureBarang = _apiService.getAllBarang();
                  });
                },
                color: AppColors.primary,
                child: FutureBuilder<List<Barang>>(
                  future: _futureBarang,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Gagal memuat produk: ${snapshot.error}',
                              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _futureBarang = _apiService.getAllBarang();
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              ),
                              child: Text(
                                'Coba Lagi',
                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                      color: AppColors.white,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Text(
                          'Tidak ada produk tersedia',
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                color: AppColors.textSecondary,
                              ),
                        ),
                      );
                    }

                    final barangList = _filterBarang(snapshot.data!, _searchQuery);
                    final categories = _getCategories(barangList);

                    return ListView(
                      padding: const EdgeInsets.only(bottom: 24),
                      children: [
                        _buildCategorySection(context, categories),
                        _buildProductTypeSection(context, barangList),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection(BuildContext context, List<Map<String, dynamic>> categories) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Text(
            'Kategori Produk',
            style: Theme.of(context).textTheme.displaySmall!.copyWith(
                  color: AppColors.textPrimary,
                ),
          ),
        ),
        SizedBox(
          height: 160,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return FadeInAnimation(
                delay: index * 100,
                child: CategoryCard(
                  name: category['name'],
                  imageUrl: category['image'],
                  discount: category['discount'],
                  onTap: () {
                    debugPrint('Category tapped: ${category['name']}');
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProductTypeSection(BuildContext context, List<Barang> barangList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Text(
                'Produk Terpopuler',
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      color: AppColors.textPrimary,
                    ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.secondary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.local_fire_department,
                  color: AppColors.white,
                  size: 18,
                ),
              ),
            ],
          ),
        ),
        GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: barangList.length,
          itemBuilder: (context, index) {
            final barang = barangList[index];
            return FadeInAnimation(
              delay: index * 100,
              child: ProductCard(
                name: barang.nama,
                imageUrl: barang.imageUrls.isNotEmpty
                    ? barang.imageUrls.first
                    : 'https://via.placeholder.com/150',
                price: barang.harga,
                hasWarranty: barang.garansiBerlaku,
                count: _getProductCount(barangList, barang.kategoriBarang),
                onTap: () {
                  debugPrint('Product tapped: ${barang.nama}');
                },
              ),
            );
          },
        ),
      ],
    );
  }
}

// Simple FadeIn Animation Widget
class FadeInAnimation extends StatefulWidget {
  final Widget child;
  final int delay;

  const FadeInAnimation({super.key, required this.child, this.delay = 0});

  @override
  State<FadeInAnimation> createState() => _FadeInAnimationState();
}

class _FadeInAnimationState extends State<FadeInAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: widget.child,
      ),
    );
  }
}