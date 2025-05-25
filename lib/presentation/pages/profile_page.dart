import 'package:flutter/material.dart';
import '../../core/theme/color_pallete.dart';
import './login_page.dart';
import '../../utils/tokenUtils.dart';
import '../../main.dart';
import '../../presentation/widgets/confirm_modal.dart';
import '../../data/models/penitip.dart';
import '../../data/services/penitip_service.dart';
import 'about_page.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _email = 'Loading...';
  String _userId = '';
  String _userRole = '';
  bool _isLoggedIn = false;
  
  // Data khusus untuk penitip
  Penitip? _penitipData;
  bool _isLoadingPenitipData = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    String? token = await getToken();

    if (token == null || token.isEmpty) {
      setState(() {
        _email = 'Not logged in';
        _userId = '';
        _userRole = '';
        _isLoggedIn = false;
      });
      return;
    }

    final decoded = decodeToken(token);
    if (decoded != null) {
      setState(() {
        _email = decoded['email'] ?? 'Email not found';
        _userId = decoded['id']?.toString() ?? '';
        _userRole = decoded['role'] ?? 'User';
        _isLoggedIn = true;
      });
      
      // Jika role adalah penitip, load data penitip
      if (_userRole.toLowerCase() == 'penitip') {
        await _loadPenitipData();
      }
    } else {
      setState(() {
        _email = 'Token expired';
        _userId = '';
        _userRole = '';
        _isLoggedIn = false;
      });
    }
  }

  Future<void> _loadPenitipData() async {
    setState(() {
      _isLoadingPenitipData = true;
    });

    try {
      // Ambil data penitip berdasarkan ID akun
      final penitipRepository = PenitipService();
      final penitipData = await penitipRepository.getPenitipByIdAkun(_userId);
      
      setState(() {
        _penitipData = penitipData;
        _isLoadingPenitipData = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingPenitipData = false;
      });
      print('Error loading penitip data: $e');
    }
  }

  String _getRoleDisplayName(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return 'Admin';
      case 'penitip':
        return 'Penitip';
      case 'kurir':
        return 'Kurir';
      case 'pegawai gudang':
        return 'Pegawai Gudang';
      case 'hunter':
        return 'Hunter';
      case 'owner':
        return 'Owner';
      default:
        return 'User';
    }
  }

  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return Colors.red;
      case 'penitip':
        return AppColors.secondary;
      case 'seller':
        return AppColors.secondary;
      case 'user':
        return AppColors.primary;
      default:
        return AppColors.textSecondary;
    }
  }

  String _formatCurrency(double? amount) {
    if (amount == null) return 'Rp 0';
    return 'Rp ${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  Widget _buildRatingStars(double rating) {
    List<Widget> stars = [];
    int fullStars = rating.floor();
    bool hasHalfStar = (rating - fullStars) >= 0.5;
    
    for (int i = 0; i < fullStars; i++) {
      stars.add(const Icon(Icons.star, color: Colors.amber, size: 16));
    }
    
    if (hasHalfStar) {
      stars.add(const Icon(Icons.star_half, color: Colors.amber, size: 16));
    }
    
    int remainingStars = 5 - stars.length;
    for (int i = 0; i < remainingStars; i++) {
      stars.add(const Icon(Icons.star_border, color: Colors.amber, size: 16));
    }
    
    return Row(children: stars);
  }

  // Method untuk logout menggunakan ConfirmationModal
  void _handleLogout() {
    ConfirmationModal.showLogout(
      context,
      onConfirm: () async {
        await removeToken();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const RootScreen()),
          (route) => false,
        );
      },
    );
  }

  // Contoh method untuk delete account
  void _handleDeleteAccount() {
    ConfirmationModal.showDelete(
      context,
      itemName: 'account',
      onConfirm: () {
        // Logic untuk delete account
        print('Account deleted');
      },
    );
  }

  // Contoh method untuk save profile changes
  void _handleSaveChanges() {
    ConfirmationModal.showSaveChanges(
      context,
      onConfirm: () {
        // Logic untuk save changes
        print('Changes saved');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          if (_isLoggedIn)
            IconButton(
              onPressed: () {
                // Edit profile action - bisa menggunakan save confirmation
                _handleSaveChanges();
              },
              icon: const Icon(
                Icons.edit_outlined,
                color: AppColors.primary,
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Header Card
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
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Avatar with border
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.white,
                          width: 3,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: AppColors.white,
                        child: Text(
                          _isLoggedIn && _email.isNotEmpty && _email != 'Loading...'
                              ? (_penitipData?.namaPenitip.isNotEmpty == true 
                                  ? _penitipData!.namaPenitip[0].toUpperCase()
                                  : _email[0].toUpperCase())
                              : '?',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Name or Email
                    Text(
                      _penitipData?.namaPenitip ?? _email,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    // Email (jika ada nama penitip)
                    if (_penitipData?.namaPenitip != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        _email,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.white.withOpacity(0.8),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    
                    if (_isLoggedIn && _userRole.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      // Role Badge with Badge indicator for penitip
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppColors.white.withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              _getRoleDisplayName(_userRole),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                          // Badge indicator untuk penitip
                          if (_penitipData?.badge == true) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.verified,
                                color: AppColors.white,
                                size: 16,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                    
                    if (_isLoggedIn && _userId.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        'ID: $_userId',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Penitip Statistics Card (hanya untuk role penitip)
            if (_userRole.toLowerCase() == 'penitip' && _penitipData != null) ...[
              _buildPenitipStatsCard(),
              const SizedBox(height: 24),
            ],

            // Account Status Card
            if (_isLoggedIn) ...[
              _buildStatusCard(),
              const SizedBox(height: 24),
            ],

            // Menu Items
            if (!_isLoggedIn) ...[
              _buildMenuItem(
                icon: Icons.login,
                title: 'Login',
                subtitle: 'Masuk ke akun Anda',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                showBorder: true,
                iconColor: AppColors.primary,
              ),
              const SizedBox(height: 16),
            ],

            // Profile Menu Section
            _buildSectionTitle('Account Settings'),
            const SizedBox(height: 12),
            
            _buildMenuItem(
              icon: Icons.person_outline,
              title: 'Edit Profile',
              subtitle: 'Update your personal information',
              onTap: () {
                // Contoh penggunaan save changes confirmation
                _handleSaveChanges();
              },
            ),
            
            _buildMenuItem(
              icon: Icons.notifications_outlined,
              title: 'Notifications',
              subtitle: 'Manage your notification preferences',
              onTap: () {},
            ),
            
            _buildMenuItem(
              icon: Icons.security_outlined,
              title: 'Privacy & Security',
              subtitle: 'Control your privacy settings',
              onTap: () {},
            ),

            const SizedBox(height: 24),

            // Support Section
            _buildSectionTitle('Support'),
            const SizedBox(height: 12),

            _buildMenuItem(
              icon: Icons.info_outline,
              title: 'About ReuseMart',
              subtitle: 'App version and information',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutScreen()),
                );
              },
            ),

            const SizedBox(height: 24),

            // Logout Button
            if (_isLoggedIn) ...[
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.red.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _handleLogout, // Menggunakan ConfirmationModal
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.logout_outlined,
                              color: Colors.red,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Logout',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.red,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Sign out from your account',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.red,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildPenitipStatsCard() {
    if (_isLoadingPenitipData) {
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
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Container(
      width: double.infinity,
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
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.secondary.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.analytics_outlined,
                    color: AppColors.secondary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Penitip Statistics',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          
          // Stats Grid
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Top Row - Points and Rating
                Row(
                  children: [
                    Expanded(
                      child: _buildStatItem(
                        icon: Icons.stars,
                        iconColor: Colors.amber,
                        title: 'Total Poin',
                        value: '${_penitipData?.totalPoin ?? 0}',
                        subtitle: 'poin terkumpul',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildStatItem(
                        icon: Icons.star_rate,
                        iconColor: Colors.orange,
                        title: 'Rating',
                        value: '${_penitipData?.rating.toStringAsFixed(1) ?? '0.0'}',
                        subtitle: 'dari 5.0',
                        customWidget: _buildRatingStars(_penitipData?.rating ?? 0.0),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Bottom Row - Earnings and Badge
                Row(
                  children: [
                    Expanded(
                      child: _buildStatItem(
                        icon: Icons.account_balance_wallet,
                        iconColor: Colors.green,
                        title: 'Keuntungan',
                        value: _formatCurrency(_penitipData?.keuntungan),
                        subtitle: 'total pendapatan',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildStatItem(
                        icon: _penitipData?.badge == true ? Icons.verified : Icons.verified_outlined,
                        iconColor: _penitipData?.badge == true ? Colors.amber : Colors.grey,
                        title: 'Badge Status',
                        value: _penitipData?.badge == true ? 'Verified' : 'Regular',
                        subtitle: _penitipData?.badge == true ? 'penitip terverifikasi' : 'belum terverifikasi',
                      ),
                    ),
                  ],
                ),
                
                // Registration Date
                if (_penitipData?.tanggalRegistrasi != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Bergabung sejak ${_formatRegistrationDate(_penitipData!.tanggalRegistrasi!)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
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

  Widget _buildStatItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required String subtitle,
    Widget? customWidget,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: iconColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          if (customWidget != null) ...[
            const SizedBox(height: 4),
            customWidget,
          ],
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 10,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  String _formatRegistrationDate(DateTime date) {
    final months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  Widget _buildStatusCard() {
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
                  Icons.verified_user,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Account Status',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Active Account',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Your account is verified and active',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textPrimary.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool showBorder = false,
    Color? iconColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: showBorder
            ? Border.all(
                color: AppColors.primary.withOpacity(0.3),
                width: 1.5,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: (iconColor ?? AppColors.primary).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor ?? AppColors.primary,
                    size: 24,
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
                          fontSize: 16,
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
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: AppColors.textPrimary.withOpacity(0.4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}