// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

class ReadData extends StatelessWidget {
  final String id;
  final String nama_makanan;
  final String bahan;
  final String langkah_pembuatan;

  const ReadData(
      {Key? key,
      required this.id,
      required this.nama_makanan,
      required this.bahan,
      required this.langkah_pembuatan})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lihat Data"),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            Text(
              'ID: $id',
              style: const TextStyle(
                fontSize: 18, // Adjust the font size as needed
                fontWeight: FontWeight.bold, // Add emphasis with bold text
              ),
            ),
            const SizedBox(
              height: 10,
            ), // Add some spacing between the text widgets
            Text(
              'Nama Makanan: $nama_makanan',
              style: const TextStyle(
                fontSize: 16, // Adjust the font size as needed
              ),
            ),
            const SizedBox(height: 5), // Add a smaller spacing
            Text(
              'Bahan: $bahan',
              style: const TextStyle(
                fontSize: 16, // Adjust the font size as needed
              ),
            ),
            const SizedBox(height: 5), // Add a smaller spacing
            Text(
              'Langkah Pembuatan: $langkah_pembuatan',
              style: const TextStyle(
                fontSize: 16, // Adjust the font size as needed
              ),
            ),
          ],
        ),
      ),
    );
  }
}
