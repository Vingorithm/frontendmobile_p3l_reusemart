import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data/models/akun.dart';
import '../data/models/alamat_pembeli.dart';
import '../data/models/barang.dart';
import '../data/models/bonus_top_seller.dart';
import '../data/models/claim_merchandise.dart';
import '../data/models/diskusi_produk.dart';
import '../data/models/donasi_barang.dart';
import '../data/models/keranjang.dart';
import '../data/models/merchandise.dart';
import '../data/models/organisasi_amal.dart';
import '../data/models/pegawai.dart';
import '../data/models/pembeli.dart';
import '../data/models/pembelian.dart';
import '../data/models/pengiriman.dart';
import '../data/models/penitip.dart';
import '../data/models/penitipan.dart';
import '../data/models/request_donasi.dart';
import '../data/models/review_produk.dart';
import '../data/models/sub_pembelian.dart';
import '../data/models/transaksi.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:3000/api';

  // Akun
  Future<List<Akun>> getAllAkun() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/akun'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Akun.fromJson(json)).toList();
      } else {
        print('Failed to load akun: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load akun: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching akun: $e');
      rethrow;
    }
  }

  Future<Akun> getAkunById(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/akun/$id'));
      if (response.statusCode == 200) {
        return Akun.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('Akun not found');
      } else {
        throw Exception('Failed to load akun: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching akun by id: $e');
      rethrow;
    }
  }

  // AlamatPembeli
  Future<List<AlamatPembeli>> getAllAlamatPembeli() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/alamat-pembeli'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => AlamatPembeli.fromJson(json)).toList();
      } else {
        print('Failed to load alamat pembeli: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load alamat pembeli: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching alamat pembeli: $e');
      rethrow;
    }
  }

  Future<AlamatPembeli> getAlamatPembeliById(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/alamat-pembeli/$id'));
      if (response.statusCode == 200) {
        return AlamatPembeli.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('AlamatPembeli not found');
      } else {
        throw Exception('Failed to load alamat pembeli: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching alamat pembeli by id: $e');
      rethrow;
    }
  }

  // Barang
  Future<List<Barang>> getAllBarang() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/barang'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Barang.fromJson(json)).toList();
      } else {
        print('Failed to load barang: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load barang: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching barang: $e');
      rethrow;
    }
  }

  Future<Barang> getBarangById(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/barang/$id'));
      if (response.statusCode == 200) {
        return Barang.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('Barang not found');
      } else {
        throw Exception('Failed to load barang: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching barang by id: $e');
      rethrow;
    }
  }

  // BonusTopSeller
  Future<List<BonusTopSeller>> getAllBonusTopSeller() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/bonus-top-seller'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => BonusTopSeller.fromJson(json)).toList();
      } else {
        print('Failed to load bonus top seller: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load bonus top seller: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching bonus top seller: $e');
      rethrow;
    }
  }

  Future<BonusTopSeller> getBonusTopSellerById(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/bonus-top-seller/$id'));
      if (response.statusCode == 200) {
        return BonusTopSeller.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('BonusTopSeller not found');
      } else {
        throw Exception('Failed to load bonus top seller: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching bonus top seller by id: $e');
      rethrow;
    }
  }

  // ClaimMerchandise
  Future<List<ClaimMerchandise>> getAllClaimMerchandise() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/claim-merchandise'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => ClaimMerchandise.fromJson(json)).toList();
      } else {
        print('Failed to load claim merchandise: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load claim merchandise: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching claim merchandise: $e');
      rethrow;
    }
  }

  Future<ClaimMerchandise> getClaimMerchandiseById(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/claim-merchandise/$id'));
      if (response.statusCode == 200) {
        return ClaimMerchandise.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('ClaimMerchandise not found');
      } else {
        throw Exception('Failed to load claim merchandise: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching claim merchandise by id: $e');
      rethrow;
    }
  }

  // DiskusiProduk
  Future<List<DiskusiProduk>> getAllDiskusiProduk() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/diskusi-produk'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => DiskusiProduk.fromJson(json)).toList();
      } else {
        print('Failed to load diskusi produk: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load diskusi produk: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching diskusi produk: $e');
      rethrow;
    }
  }

  Future<DiskusiProduk> getDiskusiProdukById(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/diskusi-produk/$id'));
      if (response.statusCode == 200) {
        return DiskusiProduk.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('DiskusiProduk not found');
      } else {
        throw Exception('Failed to load diskusi produk: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching diskusi produk by id: $e');
      rethrow;
    }
  }

  // DonasiBarang
  Future<List<DonasiBarang>> getAllDonasiBarang() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/donasi-barang'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => DonasiBarang.fromJson(json)).toList();
      } else {
        print('Failed to load donasi barang: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load donasi barang: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching donasi barang: $e');
      rethrow;
    }
  }

  Future<DonasiBarang> getDonasiBarangById(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/donasi-barang/$id'));
      if (response.statusCode == 200) {
        return DonasiBarang.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('DonasiBarang not found');
      } else {
        throw Exception('Failed to load donasi barang: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching donasi barang by id: $e');
      rethrow;
    }
  }

  // Keranjang
  Future<List<Keranjang>> getAllKeranjang() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/keranjang'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Keranjang.fromJson(json)).toList();
      } else {
        print('Failed to load keranjang: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load keranjang: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching keranjang: $e');
      rethrow;
    }
  }

  Future<Keranjang> getKeranjangById(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/keranjang/$id'));
      if (response.statusCode == 200) {
        return Keranjang.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('Keranjang not found');
      } else {
        throw Exception('Failed to load keranjang: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching keranjang by id: $e');
      rethrow;
    }
  }

  // Merchandise
  Future<List<Merchandise>> getAllMerchandise() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/merchandise'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Merchandise.fromJson(json)).toList();
      } else {
        print('Failed to load merchandise: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load merchandise: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching merchandise: $e');
      rethrow;
    }
  }

  Future<Merchandise> getMerchandiseById(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/merchandise/$id'));
      if (response.statusCode == 200) {
        return Merchandise.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('Merchandise not found');
      } else {
        throw Exception('Failed to load merchandise: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching merchandise by id: $e');
      rethrow;
    }
  }

  // OrganisasiAmal
  Future<List<OrganisasiAmal>> getAllOrganisasiAmal() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/organisasi-amal'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => OrganisasiAmal.fromJson(json)).toList();
      } else {
        print('Failed to load organisasi amal: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load organisasi amal: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching organisasi amal: $e');
      rethrow;
    }
  }

  Future<OrganisasiAmal> getOrganisasiAmalById(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/organisasi-amal/$id'));
      if (response.statusCode == 200) {
        return OrganisasiAmal.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('OrganisasiAmal not found');
      } else {
        throw Exception('Failed to load organisasi amal: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching organisasi amal by id: $e');
      rethrow;
    }
  }

  // Pegawai
  Future<List<Pegawai>> getAllPegawai() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/pegawai'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Pegawai.fromJson(json)).toList();
      } else {
        print('Failed to load pegawai: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load pegawai: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching pegawai: $e');
      rethrow;
    }
  }

  Future<Pegawai> getPegawaiById(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/pegawai/$id'));
      if (response.statusCode == 200) {
        return Pegawai.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('Pegawai not found');
      } else {
        throw Exception('Failed to load pegawai: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching pegawai by id: $e');
      rethrow;
    }
  }

  // Pembeli
  Future<List<Pembeli>> getAllPembeli() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/pembeli'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Pembeli.fromJson(json)).toList();
      } else {
        print('Failed to load pembeli: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load pembeli: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching pembeli: $e');
      rethrow;
    }
  }

  Future<Pembeli> getPembeliById(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/pembeli/$id'));
      if (response.statusCode == 200) {
        return Pembeli.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('Pembeli not found');
      } else {
        throw Exception('Failed to load pembeli: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching pembeli by id: $e');
      rethrow;
    }
  }

  // Pembelian
  Future<List<Pembelian>> getAllPembelian() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/pembelian'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Pembelian.fromJson(json)).toList();
      } else {
        print('Failed to load pembelian: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load pembelian: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching pembelian: $e');
      rethrow;
    }
  }

  Future<Pembelian> getPembelianById(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/pembelian/$id'));
      if (response.statusCode == 200) {
        return Pembelian.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('Pembelian not found');
      } else {
        throw Exception('Failed to load pembelian: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching pembelian by id: $e');
      rethrow;
    }
  }

  // Pengiriman
  Future<List<Pengiriman>> getAllPengiriman() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/pengiriman'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Pengiriman.fromJson(json)).toList();
      } else {
        print('Failed to load pengiriman: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load pengiriman: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching pengiriman: $e');
      rethrow;
    }
  }

  Future<Pengiriman> getPengirimanById(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/pengiriman/$id'));
      if (response.statusCode == 200) {
        return Pengiriman.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('Pengiriman not found');
      } else {
        throw Exception('Failed to load pengiriman: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching pengiriman by id: $e');
      rethrow;
    }
  }

  // Penitip
  Future<List<Penitip>> getAllPenitip() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/penitip'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Penitip.fromJson(json)).toList();
      } else {
        print('Failed to load penitip: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load penitip: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching penitip: $e');
      rethrow;
    }
  }

  Future<Penitip> getPenitipById(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/penitip/$id'));
      if (response.statusCode == 200) {
        return Penitip.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('Penitip not found');
      } else {
        throw Exception('Failed to load penitip: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching penitip by id: $e');
      rethrow;
    }
  }

  // Penitipan
  Future<List<Penitipan>> getAllPenitipan() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/penitipan'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Penitipan.fromJson(json)).toList();
      } else {
        print('Failed to load penitipan: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load penitipan: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching penitipan: $e');
      rethrow;
    }
  }

  Future<Penitipan> getPenitipanById(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/penitipan/$id'));
      if (response.statusCode == 200) {
        return Penitipan.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('Penitipan not found');
      } else {
        throw Exception('Failed to load penitipan: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching penitipan by id: $e');
      rethrow;
    }
  }

  // RequestDonasi
  Future<List<RequestDonasi>> getAllRequestDonasi() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/request-donasi'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => RequestDonasi.fromJson(json)).toList();
      } else {
        print('Failed to load request donasi: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load request donasi: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching request donasi: $e');
      rethrow;
    }
  }

  Future<RequestDonasi> getRequestDonasiById(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/request-donasi/$id'));
      if (response.statusCode == 200) {
        return RequestDonasi.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('RequestDonasi not found');
      } else {
        throw Exception('Failed to load request donasi: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching request donasi by id: $e');
      rethrow;
    }
  }

  // ReviewProduk
  Future<List<ReviewProduk>> getAllReviewProduk() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/review-produk'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => ReviewProduk.fromJson(json)).toList();
      } else {
        print('Failed to load review produk: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load review produk: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching review produk: $e');
      rethrow;
    }
  }

  Future<ReviewProduk> getReviewProdukById(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/review-produk/$id'));
      if (response.statusCode == 200) {
        return ReviewProduk.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('ReviewProduk not found');
      } else {
        throw Exception('Failed to load review produk: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching review produk by id: $e');
      rethrow;
    }
  }

  // SubPembelian
  Future<List<SubPembelian>> getAllSubPembelian() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/sub-pembelian'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => SubPembelian.fromJson(json)).toList();
      } else {
        print('Failed to load sub pembelian: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load sub pembelian: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching sub pembelian: $e');
      rethrow;
    }
  }

  Future<SubPembelian> getSubPembelianById(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/sub-pembelian/$id'));
      if (response.statusCode == 200) {
        return SubPembelian.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('SubPembelian not found');
      } else {
        throw Exception('Failed to load sub pembelian: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching sub pembelian by id: $e');
      rethrow;
    }
  }

  // Transaksi
  Future<List<Transaksi>> getAllTransaksi() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/transaksi'));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Transaksi.fromJson(json)).toList();
      } else {
        print('Failed to load transaksi: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load transaksi: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching transaksi: $e');
      rethrow;
    }
  }

  Future<Transaksi> getTransaksiById(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/transaksi/$id'));
      if (response.statusCode == 200) {
        return Transaksi.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('Transaksi not found');
      } else {
        throw Exception('Failed to load transaksi: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching transaksi by id: $e');
      rethrow;
    }
  }
}