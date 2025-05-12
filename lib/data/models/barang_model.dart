class Barang {
  final String idBarang;
  final String? idPenitip;
  final String? idHunter;
  final String? idPegawaiGudang;
  final String nama;
  final String deskripsi;
  final String gambar;
  final double harga;
  final bool garansiBerlaku;
  final DateTime? tanggalGaransi;
  final double berat;
  final String statusQc;
  final String kategoriBarang;
  final dynamic penitip;

  Barang({
    required this.idBarang,
    this.idPenitip,
    this.idHunter,
    this.idPegawaiGudang,
    required this.nama,
    required this.deskripsi,
    required this.gambar,
    required this.harga,
    required this.garansiBerlaku,
    this.tanggalGaransi,
    required this.berat,
    required this.statusQc,
    required this.kategoriBarang,
    this.penitip,
  });

  factory Barang.fromJson(Map<String, dynamic> json) {
    return Barang(
      idBarang: json['id_barang'],
      idPenitip: json['id_penitip'],
      idHunter: json['id_hunter'],
      idPegawaiGudang: json['id_pegawai_gudang'],
      nama: json['nama'],
      deskripsi: json['deskripsi'],
      gambar: json['gambar'] ?? 'https://via.placeholder.com/400x300',
      harga: double.parse(json['harga'].toString()),
      garansiBerlaku: json['garansi_berlaku'] == 1,
      tanggalGaransi: json['tanggal_garansi'] != null
          ? DateTime.parse(json['tanggal_garansi'])
          : null,
      berat: double.parse(json['berat'].toString()),
      statusQc: json['status_qc'],
      kategoriBarang: json['kategori_barang'],
      penitip: json['Penitip'],
    );
  }
}