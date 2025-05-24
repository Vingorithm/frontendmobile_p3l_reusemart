import 'package:flutter/material.dart';
import '../../core/theme/color_pallete.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'About ReuseMart',
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
            color: AppColors.primary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // App Logo/Header
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      // decoration: BoxDecoration(
                      //   color: AppColors.white.withOpacity(0.2),
                      //   borderRadius: BorderRadius.circular(20),
                      // ),
                      child: Image.asset(
                        'assets/images/logo.png', // Path relatif ke logo
                        width: 200, // Diperbesar dari 60 ke 72 (20% lebih besar)
                        height: 100,
                        fit: BoxFit.contain, // Memastikan gambar tidak terpotong
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Platform Jual Beli Barang Bekas Berkualitas',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // About ReuseMart Section
            _buildSectionCard(
              title: 'Tentang ReuseMart',
              icon: Icons.info_outline,
              children: [
                const Text(
                  'ReuseMart adalah perusahaan yang bergerak di bidang penjual barang bekas berkualitas yang berbasis di Yogyakarta. Didirikan oleh Pak Raka Pratama dengan visi mengurangi penumpukan sampah dan memberikan kesempatan kedua bagi barang-barang bekas yang masih layak pakai.',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textPrimary,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 16),
                _buildFeatureItem(
                  icon: Icons.store,
                  title: 'Sistem Penitipan',
                  description: 'Layanan penitipan barang dengan pengelolaan penuh oleh tim ReuseMart',
                ),
                _buildFeatureItem(
                  icon: Icons.eco,
                  title: 'Ramah Lingkungan',
                  description: 'Mendukung konsep reduce, reuse, recycle untuk kelestarian lingkungan',
                ),
                _buildFeatureItem(
                  icon: Icons.verified,
                  title: 'Quality Control',
                  description: 'Setiap barang melalui proses QC untuk menjamin kualitas',
                ),
                _buildFeatureItem(
                  icon: Icons.favorite,
                  title: 'Donasi Sosial',
                  description: 'Barang yang tidak laku akan disumbangkan ke organisasi sosial',
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Development Team Section
            _buildSectionCard(
              title: 'Tim Pengembang',
              icon: Icons.group,
              children: [
                const Text(
                  'Aplikasi ini dikembangkan dalam rangka mata kuliah Pengembangan Proyek Perangkat Lunak (P3L) oleh:',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textPrimary,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 20),
                _buildDeveloperCard(
                  name: 'Kevin Philips Tanamas',
                  role: 'Full Stack Developer',
                  initial: 'K',
                ),
                const SizedBox(height: 12),
                _buildDeveloperCard(
                  name: 'Ivan Tjandra',
                  role: 'Full Stack Developer',
                  initial: 'I',
                ),
                const SizedBox(height: 12),
                _buildDeveloperCard(
                  name: 'Richard Angelico Pudjohartono',
                  role: 'Full Stack Developer',
                  initial: 'R',
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Project Info Section
            _buildSectionCard(
              title: 'Informasi Proyek',
              icon: Icons.code,
              children: [
                _buildInfoRow('Mata Kuliah', 'Pengembangan Proyek Perangkat Lunak (P3L)'),
                _buildInfoRow('Platform', 'Mobile & Web Application'),
                _buildInfoRow('Teknologi', 'Flutter, Express.js, React.js'),
                _buildInfoRow('Target', 'Android Mobile & Web Browser'),
                _buildInfoRow('Status', 'In Development'),
              ],
            ),

            const SizedBox(height: 24),

            // Contact Section
            _buildSectionCard(
              title: 'Kontak & Dukungan',
              icon: Icons.support_agent,
              children: [
                _buildContactItem(
                  icon: Icons.location_on,
                  title: 'Alamat',
                  subtitle: 'Yogyakarta, Indonesia',
                ),
                _buildContactItem(
                  icon: Icons.access_time,
                  title: 'Jam Operasional',
                  subtitle: '08:00 - 20:00 WIB',
                ),
                _buildContactItem(
                  icon: Icons.phone,
                  title: 'Customer Service',
                  subtitle: 'Hubungi kami untuk bantuan',
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Footer
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.1),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Made with Love for Environment',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '© 2025 ReuseMart. All rights reserved.',
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.textPrimary.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.secondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              icon,
              color: AppColors.secondary,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textPrimary.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeveloperCard({
    required String name,
    required String role,
    required String initial,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: AppColors.primary,
            child: Text(
              initial,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  role,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textPrimary.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const Text(
            ': ',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textPrimary,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary.withOpacity(0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.secondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: AppColors.secondary,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textPrimary.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}