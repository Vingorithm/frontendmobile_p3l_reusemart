// lib/presentation/pages/detail_merch.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../data/models/merchandise.dart';
import '../../data/services/merchandise_service.dart';
import '../../data/services/claim_merchandise_service.dart';
import '../../data/services/pembeli_service.dart';
import '../../data/models/pembeli.dart';
import '../../core/theme/color_pallete.dart';
import '../../presentation/widgets/toast_universal.dart';
import '../../utils/tokenUtils.dart';

class DetailMerchPage extends StatefulWidget {
  final String idMerchandise;
  const DetailMerchPage({super.key, required this.idMerchandise});

  @override
  State<DetailMerchPage> createState() => _DetailMerchPageState();
}

class _DetailMerchPageState extends State<DetailMerchPage> {
  late Future<Merchandise> _futureMerchandise;
  String _userId = '';
  Pembeli? _pembeliData;
  bool _isProcessingClaim = false;

  @override
  void initState() {
    super.initState();
    _futureMerchandise =
        MerchandiseService().getMerchandiseById(widget.idMerchandise);
    _initializeUserData();
  }

  Future<void> _initializeUserData() async {
    try {
      final token = await getToken();
      if (token != null) {
        final decoded = decodeToken(token);
        if (decoded != null && decoded.containsKey('id')) {
          setState(() {
            _userId = decoded['id'];
          });
          await _loadPembeliData();
        }
      }
    } catch (e) {
      print('Error initializing user data: $e');
    }
  }

  Future<void> _loadPembeliData() async {
    try {
      final pembeliService = PembeliService();
      final allPembeli = await pembeliService.getAllPembeli();

      final pembeliData = allPembeli.firstWhere(
        (pembeli) => pembeli.idAkun == _userId,
        orElse: () => throw Exception('Data pembeli tidak ditemukan'),
      );

      setState(() {
        _pembeliData = pembeliData;
      });
    } catch (e) {
      print('Error loading pembeli data: $e');
    }
  }

  Future<void> _handleClaimMerchandise(Merchandise merchandise) async {
    if (_pembeliData == null) {
      ToastUtils.showError(context, 'Data pembeli tidak ditemukan');
      return;
    }

    if (_pembeliData!.totalPoin < merchandise.hargaPoin) {
      ToastUtils.showError(context,
          'Poin tidak cukup! Anda memiliki ${_pembeliData!.totalPoin} poin, membutuhkan ${merchandise.hargaPoin} poin');
      return;
    }

    if (merchandise.stokMerchandise <= 0) {
      ToastUtils.showError(context, 'Stok merchandise habis');
      return;
    }

    setState(() {
      _isProcessingClaim = true;
    });

    try {
      final claimService = ClaimMerchandiseService();
      final pembeliService = PembeliService();
      final merchandiseService = MerchandiseService();
      final now = DateTime.now().toIso8601String();

      // Create claim merchandise
      await claimService.createClaimMerchandise(
        idMerchandise: merchandise.idMerchandise,
        idPembeli: _pembeliData!.idPembeli,
        idCustomerService: 'P1',
        tanggalClaim: now,
        statusClaimMerchandise: 'Diproses',
      );

      // Kurangi poin pembeli
      final newTotalPoin = _pembeliData!.totalPoin - merchandise.hargaPoin;
      await pembeliService.updatePoinPembeli(
          _pembeliData!.idPembeli, newTotalPoin);

      // Kurangi stok merchandise
      final newStok = merchandise.stokMerchandise - 1;
      await merchandiseService.updateStokMerchandise(
          merchandise.idMerchandise, newStok);

      // Refresh merchandise data untuk update stok
      setState(() {
        _futureMerchandise =
            MerchandiseService().getMerchandiseById(widget.idMerchandise);
      });

      // Refresh pembeli data untuk update poin
      await _loadPembeliData();

      ToastUtils.showSuccess(context,
          'Berhasil claim ${merchandise.namaMerchandise}! Poin Anda berkurang ${merchandise.hargaPoin}');
    } catch (e) {
      print('Error claiming merchandise: $e');
      ToastUtils.showError(context, 'Gagal melakukan claim: ${e.toString()}');
    } finally {
      setState(() {
        _isProcessingClaim = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: FutureBuilder<Merchandise>(
        future: _futureMerchandise,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Gagal memuat data merchandise'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('Merchandise tidak ditemukan'));
          }

          final merchandise = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 400,
                  width: double.infinity,
                  margin: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CachedNetworkImage(
                      imageUrl: merchandise.gambar,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[200],
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[200],
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.card_giftcard_outlined,
                                size: 50, color: Colors.grey),
                            SizedBox(height: 8),
                            Text('No Image',
                                style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          merchandise.namaMerchandise,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.stars,
                                color: AppColors.primary,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${merchandise.hargaPoin} Poin',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Deskripsi:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          merchandise.deskripsi,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.inventory_2_outlined,
                                color: merchandise.stokMerchandise > 0
                                    ? Colors.green
                                    : Colors.red,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Stok Tersedia',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    '${merchandise.stokMerchandise} unit',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: merchandise.stokMerchandise > 0
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if (_pembeliData != null) ...[
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.stars,
                                    color: AppColors.primary, size: 16),
                                const SizedBox(width: 8),
                                Text(
                                  'Poin Anda: ${_pembeliData!.totalPoin}',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: (merchandise.stokMerchandise > 0 &&
                                    !_isProcessingClaim)
                                ? () => _handleClaimMerchandise(merchandise)
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: _isProcessingClaim
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.card_giftcard,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        merchandise.stokMerchandise > 0
                                            ? (_pembeliData != null
                                                ? 'Claim Sekarang (${merchandise.hargaPoin} Poin)'
                                                : 'Claim Sekarang')
                                            : 'Stok Habis',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
