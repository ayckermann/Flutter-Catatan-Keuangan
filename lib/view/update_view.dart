import 'dart:io';

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

  TextEditingController namaController = TextEditingController();
  TextEditingController tanggalController = TextEditingController();
  TextEditingController nominalController = TextEditingController();
  bool jenisController = true;
  String kategoriController = '';
  TextEditingController deskripsiController = TextEditingController();

  ImagePicker picker = ImagePicker();
  XFile? file;

  Future<void> updateTransaksi(
      String akunDocId, String transaksiDocId, Transaksi transaksi) async {
    try {
      if (namaController.text.isEmpty ||
          namaController.text == "" ||
          tanggalController.text.isEmpty ||
          tanggalController.text == "" ||
          nominalController.text.isEmpty ||
          nominalController.text == "" ||
          kategoriController.isEmpty ||
          kategoriController == "") {
        throw ("Please fill requied field");
      }
      CollectionReference transaksiCollection =
          _firestore.collection('transaksi');
      // Parse the string to DateTime
      DateTime parsedDateTime =
          DateFormat('yyyy-MM-DD hh:mm').parse(tanggalController.text);

      // Convert DateTime to Firestore Timestamp
      Timestamp timestamp = Timestamp.fromDate(parsedDateTime);

      String newUrl = await uploadImage(transaksi.gambar);

      await transaksiCollection.doc(transaksiDocId).update({
        'nama': namaController.text,
        'tanggal': timestamp,
        'nominal': int.parse(nominalController.text),
        'jenis': jenisController,
        'kategori': kategoriController,
        'deskripsi': deskripsiController.text,
        'gambar': newUrl,
        'uid': _auth.currentUser!.uid,
        // ignore: invalid_return_type_for_catch_error
      });

      int deficitSaldo = int.parse(nominalController.text) - transaksi.nominal;
      updateSaldo(akunDocId, deficitSaldo);
      Navigator.pop(context);
    } catch (e) {
      final snackbar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

  Future<String> uploadImage(String url) async {
    if (file == null) return '';

    deleteOldImage(url);

    String uniqueFilename = DateTime.now().millisecondsSinceEpoch.toString();

    Reference dirUpload =
        _storage.ref().child('upload/${_auth.currentUser!.uid}');
    Reference storedDir = dirUpload.child(uniqueFilename);

    try {
      await storedDir.putFile(File(file!.path));

      return await storedDir.getDownloadURL();
    } catch (e) {
      return '';
    }
  }

  Future<void> deleteOldImage(String url) async {
    if (url != '') {
      await _storage.refFromURL(url).delete();
    }
  }

  Future<void> updateSaldo(String akunDocId, int saldo) {
    var ref = _firestore.collection('akun').doc(akunDocId);

    if (!jenisController) {
      saldo *= -1;
    }
    return ref.update({'saldo': FieldValue.increment(saldo)});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // setValue();
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final Transaksi transaksi = arguments['transaksi'];
    final String akunDocId = arguments['akunDocId'];
    final String transaksiDocId = arguments['transaksiDocId'];

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
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Edit Transaksi',
          style: titleAppBar,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
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
                          borderRadius: BorderRadius.all(Radius.circular(10))),
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
                          borderRadius: BorderRadius.all(Radius.circular(10))),
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
                          borderRadius: BorderRadius.all(Radius.circular(10))),
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
                          borderRadius: BorderRadius.all(Radius.circular(10))),
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
                  // DropdownButtonFormField(
                  //   decoration: const InputDecoration(
                  //     hintText: 'Kategori',
                  //     hintStyle: textRegular,
                  //     border: OutlineInputBorder(
                  //         borderRadius: BorderRadius.all(Radius.circular(10))),
                  //   ),
                  //   items: const [
                  //     DropdownMenuItem(
                  //       value: "Transfer Keluar",
                  //       child: Text('Transfer Keluar', style: textRegular),
                  //     ),
                  //     DropdownMenuItem(
                  //       value: "Transfer Masuk",
                  //       child: Text('Transfer Masuk', style: textRegular),
                  //     ),
                  //     DropdownMenuItem(
                  //       value: "Tiket",
                  //       child: Text('Tiket', style: textRegular),
                  //     ),
                  //     DropdownMenuItem(
                  //       value: "TopUp",
                  //       child: Text('TopUp', style: textRegular),
                  //     ),
                  //     DropdownMenuItem(
                  //       value: "Tagihan",
                  //       child: Text('Tagihan', style: textRegular),
                  //     ),
                  //   ],
                  //   value: kategoriController,
                  //   onChanged: (value) =>
                  //       setState(() => kategoriController = value as String),
                  // ),

                  const SizedBox(height: 20),
                  TextField(
                    controller: deskripsiController,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      hintText: 'Deskripsi',
                      hintStyle: textRegular,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                  ),
                  SizedBox(height: 20),
                  //masukkan file
                  Container(
                    child: DottedBorder(
                      dashPattern: [6, 3, 0, 3],
                      borderType: BorderType.RRect,
                      radius: Radius.circular(10),
                      color: Colors.black54,
                      child: Row(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(height: 20),
                              imagePreview(transaksi.gambar),
                              Container(
                                margin: EdgeInsets.all(20),
                                width: 100,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(0, 150, 199, 1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    uploadDialog(context);
                                  },
                                  child: Text('Choose Image',
                                      style: TextStyle(
                                          fontFamily: famSemi,
                                          color: Colors.white,
                                          fontSize: 10)),
                                ),
                              ),
                            ],
                          ),
                        ],
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
                        updateTransaksi(akunDocId, transaksiDocId, transaksi);
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
