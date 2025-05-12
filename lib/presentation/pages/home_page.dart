// lib/presentation/pages/home_screen.dart
import 'package:flutter/material.dart';
import '../../data/api_service.dart';
import '../../core/theme/color_pallete.dart';
import '../../data/models/barang_model.dart';
import '../../presentation/widgets/persistent_navbar.dart';
import '../../presentation/widgets/product_card.dart';
import '../../presentation/widgets/category_card.dart';
import '../../presentation/widgets/search_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Barang>> _futureBarang;

  @override
  void initState() {
    super.initState();
    _futureBarang = _apiService.getAllBarang();
  }

  final List<Map<String, dynamic>> _categories = [
    {
      'name': 'Elektronik',
      'image': 'https://via.placeholder.com/150',
      'discount': 17,
    },
    {
      'name': 'Furniture',
      'image': 'https://via.placeholder.com/150',
      'discount': 17,
    },
    {
      'name': 'Fashion',
      'image': 'https://via.placeholder.com/150',
      'discount': null,
    },
    {
      'name': 'Aksesoris',
      'image': 'https://via.placeholder.com/150',
      'discount': null,
    },
  ];

  final List<Map<String, dynamic>> _productTypes = [
    {
      'name': 'Laptop & Komputer',
      'image': 'https://via.placeholder.com/150',
      'count': 21,
    },
    {
      'name': 'Smartphone',
      'image': 'https://via.placeholder.com/150',
      'count': 32,
    },
    {
      'name': 'Audio & Visual',
      'image': 'https://via.placeholder.com/150',
      'count': 21,
    },
    {
      'name': 'Gaming',
      'image': 'https://via.placeholder.com/150',
      'count': 15,
    },
    {
      'name': 'Kamera',
      'image': 'https://via.placeholder.com/150',
      'count': 12,
    },
    {
      'name': 'Aksesoris',
      'image': 'https://via.placeholder.com/150',
      'count': 32,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SearchBarWidget(
                hintText: 'Ketik "Kursi Kantor" 🔍',
                onSearch: (query) {
                  // Handle search logic here
                  debugPrint('Searching for: $query');
                },
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  setState(() {
                    _futureBarang = _apiService.getAllBarang();
                  });
                },
                child: ListView(
                  padding: const EdgeInsets.only(bottom: 16),
                  children: [
                    _buildCategorySection(),
                    _buildProductTypeSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Text(
            'Kategori Produk',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        SizedBox(
          height: 190,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final category = _categories[index];
              return CategoryCard(
                name: category['name'],
                imageUrl: category['image'],
                discount: category['discount'],
                onTap: () {
                  // Handle category tap
                  debugPrint('Category tapped: ${category['name']}');
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProductTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              const Text(
                'Produk Terhype',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(
                  Icons.local_fire_department,
                  color: AppColors.white,
                  size: 16,
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
            childAspectRatio: 0.9,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: _productTypes.length,
          itemBuilder: (context, index) {
            final productType = _productTypes[index];
            return ProductCard(
              name: productType['name'],
              imageUrl: productType['image'],
              count: productType['count'],
              onTap: () {
                // Handle product type tap
                debugPrint('Product type tapped: ${productType['name']}');
              },
            );
          },
        ),
      ],
    );
  }
}