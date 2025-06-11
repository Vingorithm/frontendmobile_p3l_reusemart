import 'package:flutter/material.dart';
import 'package:frontendmobile_p3l_reusemart/core/theme/color_pallete.dart';
import 'package:frontendmobile_p3l_reusemart/data/models/pegawai.dart';
import 'package:frontendmobile_p3l_reusemart/data/models/pembelian.dart';
import 'package:frontendmobile_p3l_reusemart/data/services/pegawai_service.dart';
import 'package:frontendmobile_p3l_reusemart/data/services/pembelian_service.dart';
import 'package:intl/intl.dart';
import '../../utils/tokenUtils.dart';

class HistoriTugasPage extends StatefulWidget {
  const HistoriTugasPage({super.key});

  @override
  State<HistoriTugasPage> createState() => _HistoriTugasPageState();
}

class _HistoriTugasPageState extends State<HistoriTugasPage> {
  bool isOngoing = true;
  String searchQuery = '';
  final pembelianService = PembelianService();

  List<Pembelian> _ongoingList = [];
  List<Pembelian> _selesaiList = [];
  Pegawai? _pegawaiData;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  String formatDate(DateTime? date) {
    if (date != null) {
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
    return "";
  }

  Future<void> fetchUserData() async {
    try {
      String? token = await getToken();
      print("Token ${token}");
      if (token == null || token.isEmpty) return;

      final decoded = decodeToken(token);
      print("Decoded ${decoded}");
      if (decoded != null) {
        print("hasil decode ${decoded['id']}");
        final pegawaiService = PegawaiService();
        final pegawai = await pegawaiService.getPegawaiByIdAkun(decoded['id']);
        print("idPegawai ${pegawai.idPegawai}");
        setState(() {
          _pegawaiData = pegawai;
        });
      }
    } catch (e) {
      print('Gagal memuat data pegawai: $e');
    }
  }

  Future<void> fetchPembelianData() async {
    try {
      final allPembelian = await pembelianService.getAllPembelian();

      final ongoing = <Pembelian>[];
      final selesai = <Pembelian>[];

      for (var p in allPembelian) {
        print("""
          Pembelian: ${p.idPembelian},
            Pengiriman: ${p.pengiriman?.idPengiriman},
              Pengkonfirmasi: ${p.pengiriman?.pegawai?.idPegawai},
                Akun: ${p.pengiriman?.pegawai?.akun?.idAkun},
            CS: ${p.customerService?.idPegawai},
              Akun: ${p.customerService?.akun?.idAkun}
            Alamat: ${p.alamat?.idAlamat},
            Pembeli: ${p.pembeli?.idPembeli}
              Akun: ${p.pembeli?.akun?.idAkun}
            SubPembelians: ${p.subPembelians?.first?.idSubPembelian}
              Barang: ${p.subPembelians?.first?.barang?.idBarang}
                PegawaiGudang: ${p.subPembelians?.first?.barang?.pegawaiGudang?.idPegawai}
                  Akun: ${p.subPembelians?.first?.barang?.pegawaiGudang?.akun?.idAkun}
                PegawaiHunter: ${p.subPembelians?.first?.barang?.hunter?.idPegawai}
                  Akun: ${p.subPembelians?.first?.barang?.hunter?.akun?.idAkun}
                Penitip: ${p.subPembelians?.first?.barang?.penitip?.idPenitip}
                  Akun: ${p.subPembelians?.first?.barang?.penitip?.akun?.idAkun}
                Penitipan: ${p.subPembelians?.first?.barang?.penitipan?.idPenitipan}
              Transaksi: ${p.subPembelians?.first?.transaksi?.idTransaksi}
          """);
        final jenis = p.pengiriman?.jenisPengiriman?.toLowerCase();
        final status = p.pengiriman?.statusPengiriman?.toLowerCase();
        final idPengkonfirmasi = p.pengiriman?.idPengkonfirmasi;

        print("idPengkonfirmasi ${idPengkonfirmasi}");
        print("id pegawai ${_pegawaiData?.idPegawai}");
        if (idPengkonfirmasi == _pegawaiData?.idPegawai) {
          if (jenis == "dikirim kurir") {
            if (status == "diproses" || status == "dalam pengiriman") {
              ongoing.add(p);
            } else if (status == "selesai") {
              selesai.add(p);
            }
          }
        }
      }

      setState(() {
        _ongoingList = ongoing;
        _selesaiList = selesai;
      });
    } catch (e) {
      print('Gagal memuat data pembelian: $e');
      // Tambahkan handling UI jika perlu
    }
  }

  Future<void> fetchData() async {
    await fetchUserData();
    await fetchPembelianData();
  }

  List<Pembelian> get filteredPembelian {
    final data = isOngoing ? _ongoingList : _selesaiList;

    if (searchQuery.trim().isEmpty) return data;

    return data.where((item) {
      final query = searchQuery.toLowerCase();
      return item.idPembelian.toLowerCase().contains(query) ||
          item.alamat?.alamatLengkap?.toLowerCase().contains(query) == true ||
          item.pembeli?.nama?.toLowerCase().contains(query) == true ||
          DateFormat('dd MMM yyyy')
              .format(item.tanggalPembelian)
              .toLowerCase()
              .contains(query);
    }).toList();
  }

  Future<void> showCustomDialog(
      BuildContext context, String title, String content) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title, style: TextStyle(fontSize: 16, color: AppColors.black.withOpacity(0.8))
        ),
        content: Text(content, style: TextStyle(fontSize: 12, color: AppColors.black.withOpacity(0.8))),
        actions: [
          ElevatedButton(
            child: Text("Tutup", style: TextStyle(fontSize: 12, color: AppColors.black.withOpacity(0.8))),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tugas Pengiriman',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildTabs(),
              const SizedBox(height: 12),
              TextField(
                onChanged: (value) => setState(() => searchQuery = value),
                decoration: InputDecoration(
                    hintText:
                        'Cari berdasarkan ID, alamat, penerima, atau tanggal',
                    filled: true,
                    fillColor: const Color(0xFFF3F3F3),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: const Icon(Icons.search),
                    hintStyle: TextStyle(
                        fontSize: 12, color: AppColors.black.withOpacity(0.8))),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  itemCount: filteredPembelian.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return _buildCard(filteredPembelian[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() {
                isOngoing = true;
                searchQuery = '';
              }),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isOngoing ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Belum Selesai',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isOngoing ? Colors.black : Colors.grey,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() {
                isOngoing = false;
                searchQuery = '';
              }),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: !isOngoing ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Selesai',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: !isOngoing ? Colors.black : Colors.grey,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(Pembelian data) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFDFDFD),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(1, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.pengiriman?.idPengiriman ?? '',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text('Alamat: ${data.alamat?.alamatLengkap}',
              style: TextStyle(
                  fontSize: 12, color: AppColors.black.withOpacity(0.8))),
          Text('Pembeli: ${data.pembeli?.nama}',
              style: TextStyle(
                  fontSize: 12, color: AppColors.black.withOpacity(0.8))),
          Text(
              'Tanggal Pengiriman: ${formatDate(data.pengiriman?.tanggalMulai)}',
              style: TextStyle(
                  fontSize: 12, color: AppColors.black.withOpacity(0.8))),
          if ((data.pengiriman?.statusPengiriman?.toLowerCase() ?? '') ==
              'selesai')
            Text(
                'Tanggal Selesai: ${formatDate(data.pengiriman?.tanggalBerakhir)}',
                style: TextStyle(
                    fontSize: 12, color: AppColors.black.withOpacity(0.8))),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    showCustomDialog(context, "Detail Pengiriman", "");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00994C),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(Icons.arrow_forward,
                      size: 18, color: AppColors.white),
                  label: const Text('Detail',
                      style: TextStyle(color: AppColors.white)),
                ),
              ),
              const SizedBox(width: 12),
              if (isOngoing)
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00994C),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: const Icon(Icons.check_circle_outline,
                        size: 18, color: AppColors.white),
                    label: const Text('Selesai',
                        style: TextStyle(color: AppColors.white)),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
