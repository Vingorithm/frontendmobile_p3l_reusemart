import 'package:flutter/material.dart';
import '../../core/theme/color_pallete.dart';
import './login_page.dart';
import '../../utils/tokenUtils.dart';
import '../../main.dart';
import '../../presentation/widgets/confirm_modal.dart';
import '../../data/models/penitip.dart';
import '../../data/models/pembeli.dart';
import '../../data/models/pegawai.dart';
import '../../data/services/penitip_service.dart';
import '../../data/services/pembeli_service.dart';
import '../../data/services/pegawai_service.dart';
import '../../data/services/transaksi_service.dart';
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

  // Data khusus untuk pembeli
  Pembeli? _pembeliData;
  bool _isLoadingPembeliData = false;

  // Data khusus untuk pegawai
  Pegawai? _pegawaiData;
  bool _isLoadingPegawaiData = false;

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
      // Jika role adalah pembeli, load data pembeli
      else if (_userRole.toLowerCase() == 'pembeli') {
        await _loadPembeliData();
      }
      // Jika role adalah kurir atau hunter, load data pegawai
      else if (_userRole.toLowerCase() == 'kurir' ||
          _userRole.toLowerCase() == 'hunter') {
        await _loadPegawaiData();
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

  String? _errorMessage;

  Future<void> _loadPenitipData() async {
    setState(() {
      _isLoadingPenitipData = true;
      _errorMessage = null;
    });

    try {
      final penitipRepository = PenitipService();
      final penitipData = await penitipRepository.getPenitipByIdAkun(_userId);

      setState(() {
        _penitipData = penitipData;
        _isLoadingPenitipData = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingPenitipData = false;
        _errorMessage = 'Gagal memuat data penitip: ${e.toString()}';
      });
      print('Error loading penitip data: $e');
    }
  }

  Future<void> _loadPembeliData() async {
    setState(() {
      _isLoadingPembeliData = true;
      _errorMessage = null;
    });

    try {
      // Cari pembeli berdasarkan id_akun
      print("cek");
      final pembeliService = PembeliService();
      final allPembeli = await pembeliService.getPembeliByIdAkun(_userId);

      // // Cari pembeli yang id_akun nya sesuai dengan userId
      // final pembeliData = allPembeli.firstWhere(
      //   (pembeli) => pembeli.idAkun == _userId,
      //   orElse: () => throw Exception('Data pembeli tidak ditemukan'),
      // );

      print(allPembeli);
      setState(() {
        _pembeliData = allPembeli;
        _isLoadingPembeliData = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingPembeliData = false;
        _errorMessage = 'Gagal memuat data pembeli: ${e.toString()}';
      });
      print('Error loading pembeli data: $e');
    }
  }

  Future<void> _loadPegawaiData() async {
    setState(() {
      _isLoadingPegawaiData = true;
      _errorMessage = null;
    });

    try {
      final pegawaiService = PegawaiService();
      final pegawai = await pegawaiService.getPegawaiByIdAkun(_userId);

      // Cari pembeli yang id_akun nya sesuai dengan userId
      print(pegawai);

      setState(() {
        _pegawaiData = pegawai;
        _isLoadingPegawaiData = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingPegawaiData = false;
        _errorMessage = 'Gagal memuat data pegawai: ${e.toString()}';
      });
      print('Error loading pegawai data: $e');
    }
  }

  String _getRoleDisplayName(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return 'Admin';
      case 'penitip':
        return 'Penitip';
      case 'pembeli':
        return 'Pembeli';
      case 'kurir':
        return 'Kurir';
      case 'pegawai gudang':
        return 'Pegawai Gudang';
      case 'hunter':
        return 'Hunter';
      case 'owner':
        return 'Owner';
      case 'customer service':
        return 'Customer Service';
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
      case 'pembeli':
        return Colors.blue;
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
                          _isLoggedIn &&
                                  _email.isNotEmpty &&
                                  _email != 'Loading...'
                              ? (_penitipData?.namaPenitip.isNotEmpty == true
                                  ? _penitipData!.namaPenitip[0].toUpperCase()
                                  : _pembeliData?.nama.isNotEmpty == true
                                      ? _pembeliData!.nama[0].toUpperCase()
                                      : _pegawaiData?.namaPegawai.isNotEmpty ==
                                              true
                                          ? _pegawaiData!.namaPegawai[0]
                                              .toUpperCase()
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
                      _penitipData?.namaPenitip ??
                          _pembeliData?.nama ??
                          _pegawaiData?.namaPegawai ??
                          _email,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    // Email (jika ada nama penitip atau pembeli)
                    if (_penitipData?.namaPenitip != null ||
                        _pembeliData?.nama != null ||
                        _pegawaiData?.namaPegawai != null) ...[
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
            if (_userRole.toLowerCase() == 'penitip') ...[
              _buildPenitipStatsCard(),
              const SizedBox(height: 24),
            ],

            // Pembeli Statistics Card (hanya untuk role pembeli)
            if (_userRole.toLowerCase() == 'pembeli') ...[
              _buildPembeliStatsCard(),
              const SizedBox(height: 24),
            ],

            // Hunter Commission Card (hanya untuk role hunter) - TAMBAH INI
            if (_userRole.toLowerCase() == 'hunter') ...[
              _buildHunterCommissionCard(),
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
                  'Statistik Penitip',
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
                        value:
                            '${_penitipData?.rating.toStringAsFixed(1) ?? '0.0'}',
                        subtitle: 'dari 5.0',
                        customWidget:
                            _buildRatingStars(_penitipData?.rating ?? 0.0),
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
                        icon: _penitipData?.badge == true
                            ? Icons.verified
                            : Icons.verified_outlined,
                        iconColor: _penitipData?.badge == true
                            ? Colors.amber
                            : Colors.grey,
                        title: 'Badge Status',
                        value: _penitipData?.badge == true
                            ? 'Top Seller'
                            : 'Tidak Ada',
                        subtitle: _penitipData?.badge == true
                            ? 'penitip top seller bulan ini'
                            : 'penitip tidak memiliki badge',
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

  Widget _buildPembeliStatsCard() {
    if (_isLoadingPembeliData) {
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

    if (_errorMessage != null) {
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
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadPembeliData,
              child: const Text('Coba Lagi'),
            ),
          ],
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
              color: Colors.blue.withOpacity(0.1),
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
                    color: Colors.blue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.shopping_bag_outlined,
                    color: Colors.blue,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Statistik Pembeli',
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
                // Main Row - Points and Member ID
                Row(
                  children: [
                    Expanded(
                      child: _buildStatItem(
                        icon: Icons.stars,
                        iconColor: Colors.amber,
                        title: 'Total Poin',
                        value: '${_pembeliData?.totalPoin ?? 0}',
                        subtitle: 'poin terkumpul',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildStatItem(
                        icon: Icons.card_membership,
                        iconColor: Colors.blue,
                        title: 'Member ID',
                        value: _pembeliData?.idPembeli ?? '-',
                        subtitle: 'identitas member',
                      ),
                    ),
                  ],
                ),

                // Registration Date
                if (_pembeliData?.tanggalRegistrasi != null) ...[
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
                          'Bergabung sejak ${_formatRegistrationDate(_pembeliData!.tanggalRegistrasi)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // Additional Info Card
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.blue.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 16,
                            color: Colors.blue,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Status Member',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue.shade800,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Member aktif ReuseMart dengan poin yang dapat ditukarkan untuk berbagai penawaran menarik',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.blue.shade700,
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

  Widget _buildHunterCommissionCard() {
    return FutureBuilder<Pegawai>(
      future: PegawaiService()
          .getPegawaiByIdAkun(_userId), // Ambil data pegawai dulu
      builder: (context, pegawaiSnapshot) {
        if (pegawaiSnapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: 200,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (pegawaiSnapshot.hasError || !pegawaiSnapshot.hasData) {
          return Container(
            height: 200,
            child: Center(child: Text('Error loading pegawai data')),
          );
        }

        final pegawai = pegawaiSnapshot.data!;
        final idPegawai =
            pegawai.idPegawai; // Atau sesuai nama property di model Pegawai

        print('🔍 Hunter ID (id_pegawai): $idPegawai');

        // Sekarang fetch komisi dengan id_pegawai
        return FutureBuilder<Map<String, dynamic>>(
          future: TransaksiService().getHunterKomisiSummary(idPegawai),
          builder: (context, komisiSnapshot) {
            print('🔍 Hunter komisi response: ${komisiSnapshot.data}');

            if (komisiSnapshot.connectionState == ConnectionState.waiting) {
              return Container(
                height: 200,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            double totalKomisi = 0.0;
            int jumlahTransaksi = 0;

            if (komisiSnapshot.hasData && komisiSnapshot.data != null) {
              final data = komisiSnapshot.data!;
              totalKomisi = double.tryParse(
                      data['total_komisi_hunter']?.toString() ?? '0') ??
                  0.0;
              jumlahTransaksi =
                  int.tryParse(data['jumlah_transaksi']?.toString() ?? '0') ??
                      0;
            }

            // Rest of your UI code...
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
                  // Header section...
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
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
                            color: Colors.orange.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.attach_money_outlined,
                            color: Colors.orange,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Komisi Hunter',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Content section...
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.account_balance_wallet,
                                      color: Colors.green, size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Total Komisi',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Rp ${totalKomisi.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Dari $jumlahTransaksi transaksi',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // History button section...

                        const SizedBox(height: 16), // Tambahkan ini
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
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
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
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
