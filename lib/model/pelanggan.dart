class Pelanggan {
  int? id;
  String nama;
  String alamat;
  String nohp;
  String jenisLayanan;
  int beratKg;
  String status;

  Pelanggan({
    this.id,
    required this.nama,
    required this.alamat,
    required this.nohp,
    required this.jenisLayanan,
    required this.beratKg,
    required this.status,
  });

  factory Pelanggan.fromJson(Map<String, dynamic> json) {
    return Pelanggan(
      id: json['id'],
      nama: json['nama'] ?? "",
      alamat: json['alamat'] ?? "",
      nohp: json['nohp'] ?? "",
      jenisLayanan: json['jenis_layanan'] ?? "",
      beratKg: (json['berat_kg'] ?? 0) is int
          ? json['berat_kg']
          : int.tryParse(json['berat_kg'].toString()) ?? 0,
      status: json['status'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'alamat': alamat,
      'nohp': nohp,
      'jenis_layanan': jenisLayanan,
      'berat_kg': beratKg,
      'status': status,
    };
  }
}