// lib/presentation/pages/home_page.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import '../../data/api_service.dart';
import '../../data/services/barang_service.dart';
import '../../core/theme/color_pallete.dart';
import '../../data/models/barang.dart';
import '../../presentation/widgets/product_card.dart';
import '../../presentation/widgets/category_card.dart';
import '../../presentation/widgets/search_bar.dart';
import '../pages/detail_product.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final BarangService _apiService = BarangService();
  late Future<List<Barang>> _futureBarang;
  String _searchQuery = '';
  late AnimationController _headerAnimationController;
  late AnimationController _contentAnimationController;
  late Animation<double> _headerFadeAnimation;
  late Animation<Offset> _headerSlideAnimation;

  // Carousel controller dan timer
  late PageController _carouselController;
  late Timer _carouselTimer;
  int _currentCarouselIndex = 0;

  // Data promosi carousel
  final List<Map<String, dynamic>> _promoData = [
    {
      'title': 'Flash Sale 70%',
      'subtitle': 'Elektronik Berkualitas',
      'image':
          'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?w=600',
      'gradient': [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
    },
    {
      'title': 'Koleksi Terbaru',
      'subtitle': 'Fashion & Aksesoris',
      'image':
          'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=600',
      'gradient': [Color(0xFF667eea), Color(0xFF764ba2)],
    },
    {
      'title': 'Eco Friendly',
      'subtitle': 'Produk Ramah Lingkungan',
      'image':
          'https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?w=600',
      'gradient': [Color(0xFF11998e), Color(0xFF38ef7d)],
    },
    {
      'title': 'Gratis Ongkir',
      'subtitle': 'Minimum Pembelian 100K',
      'image':
          'https://images.unsplash.com/photo-1566576912321-d58ddd7a6088?w=600',
      'gradient': [Color(0xFFf093fb), Color(0xFFf5576c)],
    },
  ];

  @override
  void initState() {
    super.initState();
    _futureBarang = _apiService.getAllBarang();

    // Initialize carousel
    _carouselController = PageController();
    _startCarouselTimer();

    // Initialize animations
    _headerAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _contentAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _headerFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _headerAnimationController, curve: Curves.easeOut),
    );
    _headerSlideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
        parent: _headerAnimationController, curve: Curves.easeOut));

    // Start animations
    _headerAnimationController.forward();
    _contentAnimationController.forward();
  }

  void _startCarouselTimer() {
    _carouselTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_carouselController.hasClients) {
        _currentCarouselIndex = (_currentCarouselIndex + 1) % _promoData.length;
        _carouselController.animateToPage(
          _currentCarouselIndex,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _headerAnimationController.dispose();
    _contentAnimationController.dispose();
    _carouselController.dispose();
    _carouselTimer.cancel();
    super.dispose();
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

  // Get unique categories dengan icon yang sesuai
  List<Map<String, dynamic>> _getCategories(List<Barang> barang) {
    final categories = <String, Map<String, dynamic>>{};
    final categoryIcons = {
      'Elektronik & Gadget': Icons.devices_outlined,
      'Kosmetik & Perawatan Diri': Icons.face_outlined,
      'Buku, Alat Tulis, & Peralatan Sekolah': Icons.book_outlined,
      'Hobi, Mainan, & Koleksi': Icons.toys_outlined,
      'Otomotif & Aksesori': Icons.directions_car_outlined,
      'Pakaian & Aksesori': Icons.checkroom_outlined,
    };

    final categoryColors = {
      'Elektronik & Gadget': const Color(0xFF3498DB),
      'Kosmetik & Perawatan Diri': const Color(0xFFE91E63),
      'Buku, Alat Tulis, & Peralatan Sekolah': const Color(0xFF9C27B0),
      'Hobi, Mainan, & Koleksi': const Color(0xFFFF9800),
      'Otomotif & Aksesori': const Color(0xFF607D8B),
      'Pakaian & Aksesori': const Color(0xFF795548),
    };

    for (var item in barang) {
      if (!categories.containsKey(item.kategoriBarang)) {
        categories[item.kategoriBarang] = {
          'name': item.kategoriBarang,
          'icon': categoryIcons[item.kategoriBarang] ?? Icons.category_outlined,
          'color': categoryColors[item.kategoriBarang] ?? AppColors.primary,
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
          children: [
            // Enhanced Header with gradient and brand
            _buildEnhancedHeader(),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: FadeInAnimation(
                delay: 300,
                child: SearchBarWidget(
                  hintText: 'Ketik "Kursi Estetik" 🔍',
                  onSearch: (query) {
                    setState(() {
                      _searchQuery = query;
                    });
                  },
                ),
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
                      return _buildLoadingState();
                    } else if (snapshot.hasError) {
                      return _buildErrorState(snapshot.error.toString());
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return _buildEmptyState();
                    }

                    final barangList =
                        _filterBarang(snapshot.data!, _searchQuery);
                    final categories = _getCategories(barangList);

                    return SingleChildScrollView(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: Column(
                        children: [
                          // Promotional Carousel
                          _buildPromotionalCarousel(),

                          // Quick Stats
                          _buildQuickStats(barangList),

                          // Categories Horizontal List Section
                          _buildCategoryHorizontalList(
                              context, categories, barangList),

                          // Popular Products Section
                          _buildProductSection(context, barangList),
                        ],
                      ),
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

  Widget _buildEnhancedHeader() {
    return SlideTransition(
      position: _headerSlideAnimation,
      child: FadeTransition(
        opacity: _headerFadeAnimation,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary,
                AppColors.primary.withOpacity(0.8),
                AppColors.secondary.withOpacity(0.1),
              ],
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(32),
              bottomRight: Radius.circular(32),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top bar with brand and notifications
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.recycling_rounded,
                            color: AppColors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ReuseMart',
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                    letterSpacing: 1.2,
                                  ),
                            ),
                            Text(
                              'Kualitas Terbaik, QC Terbaik',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    color: AppColors.white.withOpacity(0.8),
                                    fontSize: 12,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.favorite_outline,
                            color: AppColors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Stack(
                            children: [
                              Icon(
                                Icons.notifications_outlined,
                                color: AppColors.white,
                                size: 20,
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: AppColors.secondary,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Welcome message
                Text(
                  'Selamat Datang! 👋',
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Temukan produk bekas berkualitas dengan harga terbaik',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: AppColors.white.withOpacity(0.9),
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPromotionalCarousel() {
    return FadeInAnimation(
      delay: 400,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        height: 180,
        child: PageView.builder(
          controller: _carouselController,
          onPageChanged: (index) {
            setState(() {
              _currentCarouselIndex = index;
            });
          },
          itemCount: _promoData.length,
          itemBuilder: (context, index) {
            final promo = _promoData[index];
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: promo['gradient'],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: promo['gradient'][0].withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Background pattern
                  Positioned(
                    right: -20,
                    top: -20,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 30,
                    bottom: -30,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  // Content
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                promo['title'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                promo['subtitle'],
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.3),
                                  ),
                                ),
                                child: const Text(
                                  'Belanja Sekarang',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(
                              imageUrl: promo['image'],
                              height: 120,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: Colors.white.withOpacity(0.1),
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: Colors.white.withOpacity(0.1),
                                child: const Icon(
                                  Icons.image_not_supported,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildQuickStats(List<Barang> barangList) {
    return FadeInAnimation(
      delay: 500,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: _buildStatItem(
                icon: Icons.inventory_2_outlined,
                label: 'Produk',
                value: '${barangList.length}+',
                color: AppColors.primary,
              ),
            ),
            Container(
              width: 1,
              height: 30,
              color: AppColors.gray.withOpacity(0.3),
            ),
            Expanded(
              child: _buildStatItem(
                icon: Icons.verified_user_outlined,
                label: 'Terjamin',
                value: '100%',
                color: const Color(0xFF00C853),
              ),
            ),
            Container(
              width: 1,
              height: 30,
              color: AppColors.gray.withOpacity(0.3),
            ),
            Expanded(
              child: _buildStatItem(
                icon: Icons.local_shipping_outlined,
                label: 'Gratis Ongkir',
                value: 'Ya',
                color: AppColors.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: color,
            size: 18,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryHorizontalList(BuildContext context,
      List<Map<String, dynamic>> categories, List<Barang> barangList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.secondary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.apps_rounded,
                  color: AppColors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Kategori',
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    'Pilih kategori favorit Anda',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Horizontal scrollable categories
        FadeInAnimation(
          delay: 600,
          child: SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return Container(
                  width: 100,
                  margin: const EdgeInsets.only(right: 16),
                  child: FadeInAnimation(
                    delay: 600 + (index * 100),
                    child: GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Kategori: ${category['name']}'),
                            backgroundColor: category['color'],
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: category['color'].withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                category['icon'],
                                color: category['color'],
                                size: 28,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              category['name'].length > 12
                                  ? '${category['name'].substring(0, 10)}...'
                                  : category['name'],
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${_getProductCount(barangList, category['name'])} item',
                              style: TextStyle(
                                fontSize: 8,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductSection(BuildContext context, List<Barang> barangList) {
    // Increased product count from 6 to 12
    final displayedProductCount =
        barangList.length > 16 ? 16 : barangList.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.secondary],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.local_fire_department_rounded,
                      color: AppColors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Produk Terpopuler',
                        style:
                            Theme.of(context).textTheme.headlineSmall!.copyWith(
                                  color: AppColors.textPrimary,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      Text(
                        'Pilihan favorit pelanggan',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  // Navigate to all products
                },
                child: Text(
                  'Lihat Semua',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
        GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: displayedProductCount,
          itemBuilder: (context, index) {
            final barang = barangList[index];
            return FadeInAnimation(
              delay: 800 + (index * 100),
              child: ProductCard(
                name: barang.nama,
                imageUrl: barang.imageUrls.isNotEmpty
                    ? barang.imageUrls.first
                    : 'https://via.placeholder.com/200',
                price: barang.harga,
                hasWarranty: barang.garansiBerlaku,
                count: _getProductCount(barangList, barang.kategoriBarang),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailProductPage(idBarang: barang.idBarang),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: CircularProgressIndicator(
              color: AppColors.primary,
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Memuat produk terbaik untuk Anda...',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                size: 60,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Oops! Terjadi Kesalahan',
              style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Gagal memuat produk. Silakan coba lagi.',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _futureBarang = _apiService.getAllBarang();
                });
              },
              icon: Icon(Icons.refresh),
              label: Text('Coba Lagi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
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
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.inventory_2_outlined,
                size: 60,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Belum Ada Produk',
              style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Produk sedang dalam proses penambahan.\nSilakan cek kembali nanti.',
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

// Enhanced FadeIn Animation Widget with more options
class FadeInAnimation extends StatefulWidget {
  final Widget child;
  final int delay;
  final Duration duration;
  final Curve curve;

  const FadeInAnimation({
    super.key,
    required this.child,
    this.delay = 0,
    this.duration = const Duration(milliseconds: 600),
    this.curve = Curves.easeOut,
  });

  @override
  State<FadeInAnimation> createState() => _FadeInAnimationState();
}

class _FadeInAnimationState extends State<FadeInAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));

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
      child: SlideTransition(
        position: _slideAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: widget.child,
        ),
      ),
    );
  }
}
