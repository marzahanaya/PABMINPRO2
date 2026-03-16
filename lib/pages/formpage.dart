import 'package:flutter/material.dart';
import '../model/pelanggan.dart';
import '../service/pelanggan_service.dart';

class FormPage extends StatefulWidget {
  final Pelanggan? pelanggan;
  final bool isDark;
  final VoidCallback toggleTheme;

  const FormPage({
    super.key,
    this.pelanggan,
    required this.isDark,
    required this.toggleTheme,
  });

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();

  final namaController = TextEditingController();
  final alamatController = TextEditingController();
  final hpController = TextEditingController();
  final beratController = TextEditingController();

  String status = "Proses";
  String jenisLayanan = "Cuci Kering";

  final service = PelangganService();

  @override
  void initState() {
    super.initState();

    if (widget.pelanggan != null) {
      namaController.text = widget.pelanggan!.nama;
      alamatController.text = widget.pelanggan!.alamat;
      hpController.text = widget.pelanggan!.nohp;
      beratController.text = widget.pelanggan!.beratKg.toString();
      status = widget.pelanggan!.status;
      jenisLayanan = widget.pelanggan!.jenisLayanan;
    }
  }

  Future simpanData() async {
    if (_formKey.currentState!.validate()) {
      final pelanggan = Pelanggan(
        id: widget.pelanggan?.id,
        nama: namaController.text,
        alamat: alamatController.text,
        nohp: hpController.text,
        jenisLayanan: jenisLayanan,
        beratKg: int.tryParse(beratController.text) ?? 0,
        status: status,
      );

      try {
        if (widget.pelanggan == null) {
          await service.insertPelanggan(pelanggan);
        } else {
          await service.updatePelanggan(pelanggan);
        }

        if (!mounted) return;

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Data berhasil disimpan")));

        Navigator.pop(context, true);
      } catch (e) {
        print("Error simpan: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.isDark
          ? Colors.grey.shade900
          : Colors.blue.shade50,

      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.pelanggan == null ? "Tambah Pelanggan" : "Edit Pelanggan",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),

        actions: [
          IconButton(
            icon: Icon(widget.isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: widget.toggleTheme,
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: _formKey,

          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: namaController,
                  decoration: const InputDecoration(
                    labelText: "Nama",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Nama tidak boleh kosong";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 15),

                TextFormField(
                  controller: alamatController,
                  decoration: const InputDecoration(
                    labelText: "Alamat",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Alamat tidak boleh kosong";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 15),

                TextFormField(
                  controller: hpController,
                  decoration: const InputDecoration(
                    labelText: "No HP",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "No HP tidak boleh kosong";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 15),

                DropdownButtonFormField<String>(
                  value: jenisLayanan,
                  items: const [
                    DropdownMenuItem(
                      value: "Cuci Kering",
                      child: Text("Cuci Kering"),
                    ),
                    DropdownMenuItem(
                      value: "Cuci Setrika",
                      child: Text("Cuci Setrika"),
                    ),
                    DropdownMenuItem(value: "Setrika", child: Text("Setrika")),
                    DropdownMenuItem(value: "Express", child: Text("Express")),
                  ],
                  onChanged: (value) {
                    setState(() {
                      jenisLayanan = value!;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: "Jenis Layanan",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 15),

                TextFormField(
                  controller: beratController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Berat (Kg)",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Berat tidak boleh kosong";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 15),

                DropdownButtonFormField<String>(
                  value: status,
                  items: const [
                    DropdownMenuItem(value: "Proses", child: Text("Proses")),
                    DropdownMenuItem(value: "Selesai", child: Text("Selesai")),
                    DropdownMenuItem(value: "Diambil", child: Text("Diambil")),
                  ],
                  onChanged: (value) {
                    setState(() {
                      status = value!;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: "Status Laundry",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: simpanData,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text("Simpan", style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}