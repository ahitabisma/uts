// ignore_for_file: non_constant_identifier_names, library_private_types_in_public_api

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:utsmobile/list_data.dart';

class EditData extends StatefulWidget {
  final String id;
  final String nama_makanan;
  final String bahan;
  final String langkah_pembuatan;

  const EditData(
      {Key? key,
      required this.id,
      required this.nama_makanan,
      required this.bahan,
      required this.langkah_pembuatan})
      : super(key: key);

  @override
  _EditDataState createState() => _EditDataState();
}

class _EditDataState extends State<EditData> {
  final namaController = TextEditingController();
  final bahanController = TextEditingController();
  final langkahController = TextEditingController();

  Future<bool> editData(String id) async {
    String url = Platform.isAndroid
        ? 'http://10.98.5.159/api_uts/index.php'
        : 'http://localhost/api_uts/index.php';
    Map<String, String> headers = {'Content-Type': 'application/json'};
    String jsonBody =
        '{"id": "${widget.id}", "nama": "${namaController.text}", "bahan": "${bahanController.text}", "langkah_pembuatan": "${langkahController.text}"}';

    var response =
        await http.put(Uri.parse(url), body: jsonBody, headers: headers);
    if (response.statusCode == 200) {
      // Update controller values with edited data
      namaController.text = namaController.text;
      bahanController.text = bahanController.text;
      langkahController.text = langkahController.text;
      return true;
    } else {
      print('Error');
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    namaController.text = widget.nama_makanan;
    bahanController.text = widget.bahan;
    langkahController.text = widget.langkah_pembuatan;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Data Resep'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
              onPressed: () async {
                await editData(widget.id)
                    ? showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Success"),
                            content: const Text("Data berhasil di edit."),
                            actions: <Widget>[
                              TextButton(
                                child: const Text("OK"),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => const ListData()));
                                },
                              ),
                            ],
                          );
                        },
                      )
                    : false;
              },
              child: const Text("Edit"),
            ),
          ],
        ),
      ),
    );
  }
}
