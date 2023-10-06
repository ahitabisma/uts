// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:utsmobile/list_data.dart';
import 'package:utsmobile/sidemenu.dart';

class TambahData extends StatefulWidget {
  const TambahData({Key? key}) : super(key: key);

  @override
  _TambahDataState createState() => _TambahDataState();
}

class _TambahDataState extends State<TambahData> {
  final namaController = TextEditingController();
  final bahanController = TextEditingController();
  final langkahController = TextEditingController();

  Future postData(String nama, String bahan, String langkah_pembuatan) async {
    String url = Platform.isAndroid
        ? 'http://10.98.5.159/api_uts/index.php'
        : 'http://localhost/api_uts/index.php';
    // String url = "http://10.98.5.159/api_mobile/index.php";
    Map<String, String> headers = {'Content-Type': 'application/json'};
    String jsonBody =
        '{"nama_makanan": "$nama", "bahan": "$bahan", "langkah_pembuatan": "$langkah_pembuatan"}';
    var response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonBody,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to add data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Data Resep'),
      ),
      drawer: const SideMenu(),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextField(
              controller: namaController,
              decoration: const InputDecoration(
                hintText: 'Nama Makanan',
              ),
            ),
            TextField(
              controller: bahanController,
              decoration: const InputDecoration(
                hintText: 'Bahan',
              ),
            ),
            TextField(
              controller: langkahController,
              decoration: const InputDecoration(
                hintText: 'Langkah Pembuatan',
              ),
            ),
            ElevatedButton(
              child: const Text('Tambah Resep'),
              onPressed: () {
                String nama = namaController.text;
                String bahan = bahanController.text;
                String langkah = langkahController.text;
                // print(nama);
                postData(nama, bahan, langkah).then((result) {
                  //print(result['pesan']);
                  if (result['pesan'] == 'berhasil') {
                    showDialog(
                        context: context,
                        builder: (context) {
                          //var namauser2 = namauser;
                          return AlertDialog(
                            title: const Text('Data berhasil di tambah'),
                            content: const Text('ok'),
                            actions: [
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const ListData(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        });
                  }
                  setState(() {});
                });
              },
            ),
          ],
        ),

        // ],
        // ),
        // ),
      ),
    );
  }
}
