import 'dart:io';

import 'package:catatan_keuangan/model/akun.dart';
import 'package:catatan_keuangan/model/transaksi.dart';
import 'package:catatan_keuangan/tools/formater.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:catatan_keuangan/tools/styles.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class UpdatePage extends StatefulWidget {
  const UpdatePage({
    super.key,
  });

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  bool _isLoading = false;

  TextEditingController namaController = TextEditingController();
  TextEditingController tanggalController = TextEditingController();
  TextEditingController nominalController = TextEditingController();
  bool jenisController = true;
  String kategoriController = '';
  TextEditingController deskripsiController = TextEditingController();

  ImagePicker picker = ImagePicker();
  XFile? file;

  Future<void> updateTransaksi(Transaksi transaksi, Akun akun) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String nama = namaController.text;
      String tanggal = tanggalController.text;
      String nominal = nominalController.text;
      String kategori = kategoriController;
      String deskripsi = deskripsiController.text;
      bool jenis = jenisController;

      if (nama == '' ||
          tanggal == '' ||
          nominal == '' ||
          kategori == '' ||
          nama.isEmpty ||
          tanggal.isEmpty ||
          nominal.isEmpty ||
          kategori.isEmpty) {
        throw ("Please fill requied field");
      }

      DateTime parsedDateTime =
          DateFormat('yyyy-MM-DD hh:mm').parse(tanggalController.text);

      // Parse DateTime to Timestamp
      Timestamp timestamp = Timestamp.fromDate(parsedDateTime);

      CollectionReference transaksiCollection =
          _firestore.collection('transaksi');

      String url = transaksi.gambar;
      if (file != null) {
        url = await uploadImage(file, transaksi.gambar);
      }

      await transaksiCollection.doc(transaksi.docId).update({
        'nama': nama,
        'tanggal': timestamp,
        'nominal': int.parse(nominal),
        'jenis': jenis,
        'kategori': kategori,
        'deskripsi': deskripsi,
        'gambar': url,
        'uid': _auth.currentUser!.uid, // sebenarnya tidak perlu diupdat  e
        'docId': transaksi.docId, // sebenarnya tidak perlu diupdate
      });

      // jika nominal diubah maka saldo juga akan berubah
      // perubahannya adalah selisih antara nominal baru dan nominal lama
      int change = int.parse(nominal) - transaksi.nominal;

      updateSaldo(jenis: jenis, nominal: change, akun: akun);

      Navigator.popAndPushNamed(context, '/home');
    } catch (e) {
      final snackbar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> updateSaldo({
    required bool jenis,
    required int nominal,
    required Akun akun,
  }) async {
    final docRef = await _firestore.collection('akun').doc(akun.docId);

    int saldo = nominal;

    if (!jenis) {
      saldo *= -1;
    }
    docRef.update({'saldo': FieldValue.increment(saldo)});
  }

  Future<String> uploadImage(XFile? file, String url) async {
    // Jika file kosong maka tidak perlu upload
    if (file == null) return '';

    //jika url tidak kosong maka hapus gambar lama
    if (url != '') {
      try {
        await _storage.refFromURL(url).delete();
      } catch (e) {
        return '';
      }
    }

    String uniqueFilename = DateTime.now().millisecondsSinceEpoch.toString();

    Reference dirUpload =
        _storage.ref().child('upload/${_auth.currentUser!.uid}');
    Reference storedDir = dirUpload.child(uniqueFilename);

    try {
      await storedDir.putFile(File(file.path));

      return await storedDir.getDownloadURL();
    } catch (e) {
      return '';
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final Transaksi transaksi = arguments['transaksi'];
    final Akun akun = arguments['akun'];

    setState(() {
      namaController.text = transaksi.nama;
      tanggalController.text = dateFormat.format(transaksi.tanggal);
      nominalController.text = transaksi.nominal.toString();
      jenisController = transaksi.jenis;
      kategoriController = transaksi.kategori;
      deskripsiController.text = transaksi.deskripsi;
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: headerColor,
        title: const Text(
          'Edit Transaksi',
          style: titleAppBar,
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
                child: Column(
                  children: [
                    const Text(
                      'Update Transaksi',
                      style: textBold,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Column(
                      children: [
                        TextField(
                          controller: namaController,
                          decoration: const InputDecoration(
                            hintText: 'Nama Transaksi',
                            hintStyle: textRegular,
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                          ),
                        ),
                        const SizedBox(height: 20),
                        DateTimePicker(
                          type: DateTimePickerType.dateTime,
                          dateMask: 'MMMM dd, yyyy hh:mm a',
                          controller: tanggalController,
                          decoration: const InputDecoration(
                            hintText: 'Tanggal',
                            hintStyle: textRegular,
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                        ),

                        const SizedBox(height: 20),
                        TextField(
                          controller: nominalController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'Nominal',
                            hintStyle: textRegular,
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            suffixIcon: Icon(Icons.attach_money),
                          ),
                        ),
                        const SizedBox(height: 20),
                        //dropdown katagori
                        DropdownButtonFormField(
                          decoration: const InputDecoration(
                            hintText: 'Jenis',
                            hintStyle: textRegular,
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: true,
                              child: Text('Pemasukan', style: textRegular),
                            ),
                            DropdownMenuItem(
                              value: false,
                              child: Text('Pengeluaran', style: textRegular),
                            )
                          ],
                          value: jenisController,
                          onChanged: (value) =>
                              setState(() => jenisController = value as bool),
                        ),
                        SizedBox(height: 20),
                        // dropdown katagori
                        DropdownButtonFormField(
                          decoration: const InputDecoration(
                            hintText: 'Kategori',
                            hintStyle: textRegular,
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: "Transfer Keluar",
                              child:
                                  Text('Transfer Keluar', style: textRegular),
                            ),
                            DropdownMenuItem(
                              value: "Transfer Masuk",
                              child: Text('Transfer Masuk', style: textRegular),
                            ),
                            DropdownMenuItem(
                              value: "Tiket",
                              child: Text('Tiket', style: textRegular),
                            ),
                            DropdownMenuItem(
                              value: "TopUp",
                              child: Text('TopUp', style: textRegular),
                            ),
                            DropdownMenuItem(
                              value: "Tagihan",
                              child: Text('Tagihan', style: textRegular),
                            ),
                          ],
                          value: kategoriController,
                          onChanged: (value) => setState(
                              () => kategoriController = value as String),
                        ),

                        const SizedBox(height: 20),
                        TextField(
                          controller: deskripsiController,
                          maxLines: 5,
                          decoration: const InputDecoration(
                            hintText: 'Deskripsi',
                            hintStyle: textRegular,
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                          ),
                        ),
                        SizedBox(height: 20),
                        //masukkan file
                        Container(
                          width: double.infinity,
                          child: DottedBorder(
                            dashPattern: [6, 3, 0, 3],
                            borderType: BorderType.RRect,
                            radius: Radius.circular(10),
                            color: Colors.black54,
                            child: Center(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(height: 20),
                                  imagePreview(transaksi.gambar),
                                  Container(
                                    margin: EdgeInsets.all(20),
                                    width: 100,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color:
                                          const Color.fromRGBO(0, 150, 199, 1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: TextButton(
                                      onPressed: () {
                                        uploadDialog(context);
                                      },
                                      child: const Text(
                                        'Choose Image',
                                        style: TextStyle(
                                          fontFamily: famSemi,
                                          color: Colors.white,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 50),
                        Container(
                          width: double.infinity,
                          height: 50,
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(0, 150, 199, 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextButton(
                            onPressed: () {
                              updateTransaksi(transaksi, akun);
                            },
                            child: Text('Edit Transaksi', style: textButton),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Image imagePreview(String url) {
    if (file != null) {
      return Image.file(File(file!.path), width: 320, height: 180);
    } else {
      if (url != '') {
        return Image.network(url, width: 320, height: 180);
      }
      return Image.asset('assets/image.png', width: 320, height: 180);
    }
  }

  Future<dynamic> uploadDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext) {
          return AlertDialog(
            title: Text('Pilih Aksi'),
            actions: [
              TextButton(
                onPressed: () async {
                  XFile? upload =
                      await picker.pickImage(source: ImageSource.camera);

                  setState(() {
                    file = upload;
                  });

                  Navigator.of(context).pop();
                },
                child: const Icon(Icons.camera_alt),
              ),
              TextButton(
                onPressed: () async {
                  XFile? upload =
                      await picker.pickImage(source: ImageSource.gallery);
                  setState(() {
                    file = upload;
                  });

                  Navigator.of(context).pop();
                },
                child: const Icon(Icons.photo_library),
              ),
            ],
          );
        });
  }
}
