import 'package:flutter/material.dart';
import 'package:frontendmobile_p3l_reusemart/core/theme/color_pallete.dart';
import 'package:frontendmobile_p3l_reusemart/data/models/pegawai.dart';
import 'package:frontendmobile_p3l_reusemart/data/models/pembelian.dart';
import 'package:frontendmobile_p3l_reusemart/data/models/pengiriman.dart';
import 'package:frontendmobile_p3l_reusemart/data/services/notificationServices.dart';
import 'package:frontendmobile_p3l_reusemart/data/services/pegawai_service.dart';
import 'package:frontendmobile_p3l_reusemart/data/services/pembelian_service.dart';
import 'package:frontendmobile_p3l_reusemart/data/services/pengiriman_service.dart';
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

  String formatCurrency(double? value) {
    if (value == null) return "-";
    final formatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return formatter.format(value);
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

  Future<void> handleSelesai(Pembelian pembelian) async {
    try {
      final pengirimanService = PengirimanService();
      final notificationService = Notificationservices();
      Pengiriman? pengiriman = pembelian.pengiriman;

      if (pengiriman == null) throw Exception("Pengiriman tidak ditemukan.");

      // Kirim update status dan tanggal saat ini
      final responsePengiriman = await pengirimanService.updatePengiriman(
        pengiriman.idPengiriman,
        {
          "status_pengiriman": "Selesai",
          "tanggal_berakhir": DateTime.now().toIso8601String(),
        },
      );

      print("FCM Token Pembeli: ${pembelian.pembeli?.akun?.fcmToken}");

      final pembeliToken = pembelian.pembeli?.akun?.fcmToken;
      if (pembeliToken != null && pembeliToken.isNotEmpty) {
        await notificationService.sendPushNotification(
          "Pesanan Sudah Sampai",
          "Pesanan dengan id pembelian ${pembelian.idPembelian} sudah selesai dikirim!",
          pembeliToken,
        );
      }

      // Loop pakai for agar bisa pakai await
      for (var item in pembelian.subPembelians ?? []) {
        final penitipToken = item.barang?.penitip?.akun?.fcmToken;
        print("FCM Token Penitip: $penitipToken");

        if (penitipToken != null && penitipToken.isNotEmpty) {
          await notificationService.sendPushNotification(
            "Barang Selesai Dikirim",
            "Barang dengan id ${item.barang?.idBarang} sudah selesai dikirim!",
            penitipToken,
          );
        }
      }

      await fetchData();
    } catch (e) {
      print('Gagal menyelesaikan pengiriman: $e');
    }
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

  Future<void> showDetailPengirimanDialog(
      BuildContext context, String title, String content) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title,
            style: TextStyle(
                fontSize: 16,
                color: AppColors.black.withOpacity(0.8),
                fontWeight: FontWeight.bold)),
        content: Text(content,
            style: TextStyle(
                fontSize: 14,
                color: AppColors.black.withOpacity(1),
                fontWeight: FontWeight.w400)),
        actions: [
          TextButton(
            child: Text("Tutup",
                style: TextStyle(
                    fontSize: 16, color: AppColors.black.withOpacity(0.8))),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Future<void> showConfirmPengirimanDialog(
      BuildContext context, String title, String content, Pembelian pembelian) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title,
            style: TextStyle(
                fontSize: 16,
                color: AppColors.black.withOpacity(0.8),
                fontWeight: FontWeight.bold)),
        content: Text(content,
            style: TextStyle(
                fontSize: 14,
                color: AppColors.black.withOpacity(1),
                fontWeight: FontWeight.w400)),
        actions: [
          TextButton(
            child: Text("Tutup",
                style: TextStyle(
                    fontSize: 16, color: AppColors.black.withOpacity(0.8))),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text("Selesai",
                style: TextStyle(
                    fontSize: 16, color: AppColors.black.withOpacity(0.8))),
            onPressed: () {
              handleSelesai(pembelian);
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
          Text('Status Pengiriman: ${data.pengiriman?.statusPengiriman}',
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
                    String message = """
Pembelian:
      ID Pembelian: ${data?.idPembelian}
      Tanggal Pembelian: ${formatDate(data?.tanggalPembelian)}
      Status Pembelian: ${data?.statusPembelian}
      Customer Service: ${data?.customerService?.namaPegawai}

Pembeli: 
      Nama: ${data?.pembeli?.nama}
      Alamat: ${data?.alamat?.alamatLengkap}
      Email: ${data?.pembeli?.akun?.email}

Pengiriman:
      Kurir: ${data?.pengiriman?.pegawai?.namaPegawai}
      Status Pengiriman: ${data?.pengiriman?.statusPengiriman}
      Tanggal Pengiriman: ${formatDate(data?.pengiriman?.tanggalMulai)} ${data?.pengiriman?.statusPengiriman == "Selesai" ? "\n\t\t\t\t\t\tTanggal Selesai: ${formatDate(data?.pengiriman?.tanggalBerakhir)}" : ""}

Barang:
      Daftar Item: ${data?.subPembelians?.map((item) => item.barang?.nama).where((nama) => nama != null).join(', ') ?? '-'}
      Total Bayar: ${formatCurrency(data?.totalBayar)}
                    """;
                    showDetailPengirimanDialog(
                        context, "Detail Pengiriman", message);
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
                    onPressed: () {
                      showConfirmPengirimanDialog(
                          context,
                          "Konfirmasi",
                          "Apakah anda yakin ingin mengubah status pengiriman ${data?.pengiriman?.idPengiriman} menjadi 'Selesai' ?",
                          data);
                    },
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
