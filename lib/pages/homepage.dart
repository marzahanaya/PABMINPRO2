import 'package:flutter/material.dart';
import '../service/pelanggan_service.dart';
import '../pages/formpage.dart';
import '../model/pelanggan.dart';

class HomePage extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDark;

  const HomePage({
    super.key,
    required this.toggleTheme,
    required this.isDark,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Pelanggan> pelanggan = [];
  final service = PelangganService();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {

    try {

      final data = await service.getPelanggan();

      if (!mounted) return;

      setState(() {
        pelanggan = data;
        isLoading = false;
      });

    } catch (e) {

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

    }
  }

  Color getStatusColor(String status) {
    switch (status) {
      case "Selesai":
        return Colors.green;
      case "Proses":
        return Colors.orange;
      case "Diambil":
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  void deleteData(int id) async {

    await service.deletePelanggan(id);

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Data berhasil dihapus")));

    loadData();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        centerTitle: true,
        elevation: 0,

        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.bubble_chart_rounded),
            SizedBox(width: 8),
            Text(
              "QuickWash",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ],
        ),

        actions: [
          IconButton(
            icon: Icon(widget.isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: widget.toggleTheme,
          )
        ],
      ),

      body: Container(

        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: widget.isDark
                ? [Colors.grey.shade900, Colors.black]
                : [const Color(0xffe3f2fd), const Color(0xffbbdefb)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: isLoading
            ? const Center(child: CircularProgressIndicator())

            : pelanggan.isEmpty
                ? const Center(
                    child: Text(
                      "Belum ada data pelanggan",
                      style: TextStyle(fontSize: 16),
                    ),
                  )

                : RefreshIndicator(
                    onRefresh: loadData,
                    child: ListView.builder(
                      itemCount: pelanggan.length,
                      itemBuilder: (context, index) {

                        final data = pelanggan[index];

                        return Card(

                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 6),

                          elevation: 3,

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),

                          child: ListTile(

                            leading: CircleAvatar(
                              backgroundColor: Colors.blue.shade100,
                              child: const Icon(Icons.person,
                                  color: Colors.blue),
                            ),

                            title: Row(
                              children: [

                                Expanded(
                                  child: Text(
                                    data.nama,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),

                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: getStatusColor(data.status)
                                        .withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    data.status,
                                    style: TextStyle(
                                      color: getStatusColor(data.status),
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4),

                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Row(
                                    children: [
                                      const Icon(Icons.location_on,
                                          size: 14),
                                      const SizedBox(width: 4),
                                      Expanded(child: Text(data.alamat)),
                                    ],
                                  ),

                                  Row(
                                    children: [
                                      const Icon(Icons.phone, size: 14),
                                      const SizedBox(width: 4),
                                      Text(data.nohp),
                                    ],
                                  ),

                                  Row(
                                    children: [
                                      const Icon(Icons.local_laundry_service,
                                          size: 14),
                                      const SizedBox(width: 4),
                                      Text(data.jenisLayanan),
                                      const SizedBox(width: 8),
                                      Text("${data.beratKg} Kg"),
                                    ],
                                  ),

                                ],
                              ),
                            ),

                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [

                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.blue),

                                  onPressed: () async {

                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => FormPage(
                                          pelanggan: data,
                                          isDark: widget.isDark,
                                          toggleTheme: widget.toggleTheme,
                                        ),
                                      ),
                                    );

                                    if (result == true) {
                                      loadData();
                                    }
                                  },
                                ),

                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),

                                  onPressed: () {
                                    deleteData(data.id!);
                                  },
                                ),

                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
      ),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),

        onPressed: () async {

          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FormPage(
                isDark: widget.isDark,
                toggleTheme: widget.toggleTheme,
              ),
            ),
          );

          if (result == true) {
            loadData();
          }
        },
      ),
    );
  }
}