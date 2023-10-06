import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:utsmobile/edit_data.dart';
import 'package:utsmobile/read_data.dart';
// import 'package:utsmobile/read_data.dart';
import 'package:utsmobile/sidemenu.dart';
import 'package:utsmobile/tambah_data.dart';

class ListData extends StatefulWidget {
  const ListData({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ListDataState createState() => _ListDataState();
}

class _ListDataState extends State<ListData> {
  List<Map<String, String>> dataResep = [];
  String url = Platform.isAndroid
      ? 'http://10.98.5.159/api_uts/index.php'
      : 'http://localhost/api_uts/index.php';
  // String url = "http://10.98.5.159/api_mobile/index.php";
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      try {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          dataResep = data
              .map((item) => {
                    'langkah_pembuatan': item['langkah_pembuatan'] as String,
                    'nama_makanan': item['nama_makanan'] as String,
                    'bahan': item['bahan'] as String,
                    'id': item['id'].toString(), // Convert id to String
                  })
              .toList();
        });
      } catch (e) {
        print('Failed to parse JSON: $e');
      }
    } else {
      print('Failed to load data: ${response.statusCode}');
      throw Exception('Failed to load data');
    }
  }

  Future deleteData(int id) async {
    final response = await http.delete(Uri.parse('$url?id=$id'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to delete data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Data Resep'),
      ),
      drawer: const SideMenu(),
      body: Column(children: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const TambahData(),
              ),
            );
          },
          child: const Text('Tambah Data Resep'),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: dataResep.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(dataResep[index]['nama_makanan']!),
                subtitle: Text(
                    'Bahan: ${dataResep[index]['bahan']} \n Langkah Pembuatan : ${dataResep[index]['langkah_pembuatan']}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.visibility),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ReadData(
                                id: dataResep[index]['id'].toString(),
                                nama_makanan: dataResep[index]['nama_makanan'] as String,
                                bahan: dataResep[index]['bahan']
                                    as String,
                                    langkah_pembuatan: dataResep[index]['langkah_pembuatan'] as String,)));
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        // lihatMahasiswa(aindex);
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => EditData(
                                id: dataResep[index]['id'].toString(),
                                nama_makanan: dataResep[index]['nama_makanan'] as String,
                                bahan: dataResep[index]['bahan']
                                    as String,
                                    langkah_pembuatan: dataResep[index]['langkah_pembuatan'] as String)));
                        //editMahasiswa(index);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        deleteData(int.parse(dataResep[index]['id']!))
                            .then((result) {
                          if (result['pesan'] == 'berhasil') {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Data berhasil di hapus'),
                                    content: const Text('ok'),
                                    actions: [
                                      TextButton(
                                        child: const Text('OK'),
                                        onPressed: () {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const ListData(),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  );
                                });
                          }
                        });
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        )
      ]),
    );
  }
}
