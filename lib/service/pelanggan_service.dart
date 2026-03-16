import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/pelanggan.dart';

class PelangganService {
  final supabase = Supabase.instance.client;

  Future<List<Pelanggan>> getPelanggan() async {
    try {
      final response = await supabase
          .from('pelanggan')
          .select()
          .order('id', ascending: false);

      return (response as List)
          .map((data) => Pelanggan.fromJson(data))
          .toList();
    } catch (e) {
      print("Error get data: $e");
      return [];
    }
  }

  Future insertPelanggan(Pelanggan pelanggan) async {
    try {
      await supabase.from('pelanggan').insert({
        'nama': pelanggan.nama,
        'alamat': pelanggan.alamat,
        'nohp': pelanggan.nohp,
        'jenis_layanan': pelanggan.jenisLayanan,
        'berat_kg': pelanggan.beratKg,
        'status': pelanggan.status,
        'waktu': DateTime.now().toIso8601String(), // PERBAIKAN ERROR
      });

      print("Data pelanggan berhasil disimpan");
    } catch (e) {
      print("Error insert: $e");
    }
  }

  Future updatePelanggan(Pelanggan pelanggan) async {
    try {
      await supabase
          .from('pelanggan')
          .update({
            'nama': pelanggan.nama,
            'alamat': pelanggan.alamat,
            'nohp': pelanggan.nohp,
            'jenis_layanan': pelanggan.jenisLayanan,
            'berat_kg': pelanggan.beratKg,
            'status': pelanggan.status,
          })
          .eq('id', pelanggan.id!);

      print("Data berhasil diupdate");
    } catch (e) {
      print("Error update: $e");
    }
  }

  Future deletePelanggan(int id) async {
    try {
      await supabase.from('pelanggan').delete().eq('id', id);
    } catch (e) {
      print("Error delete: $e");
    }
  }
}