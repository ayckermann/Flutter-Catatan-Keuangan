import 'dart:io';

import 'package:catatan_keuangan/model/transaksi.dart';
import 'package:catatan_keuangan/tools/formater.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:catatan_keuangan/tools/styles.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class UpdatePage extends StatefulWidget {
  final String akunDocId;
  final String transaksiDocId;
  final Transaksi transaksi;
  const UpdatePage(
      {super.key,
      required this.transaksi,
      required this.akunDocId,
      required this.transaksiDocId});

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
  TextEditingController fileController = TextEditingController();

  ImagePicker picker = ImagePicker();
  XFile? file;

  Future<String> uploadImage() async {
    if (file == null) return '';

    deleteOldImage();

    String uniqueFilename = DateTime.now().millisecondsSinceEpoch.toString();

    Reference dirUpload =
        _storage.ref().child('upload/${_auth.currentUser!.uid}');
    Reference storedDir = dirUpload.child(uniqueFilename);

    try {
      await storedDir.putFile(File(file!.path));

      return await storedDir.getDownloadURL();
    } catch (e) {
      print(e);
      return '';
    }
  }

  Future<void> deleteOldImage() async {
    if (widget.transaksi.gambar != '') {
      await _storage.refFromURL(widget.transaksi.gambar).delete();
    }
  }

  Future<void> updateSaldo() {
    var ref = _firestore.collection('akun').doc(widget.akunDocId);

    int saldo = int.parse(nominalController.text) - widget.transaksi.nominal;

    if (!jenisController) {
      saldo *= -1;
    }
    return ref.update({'saldo': FieldValue.increment(saldo)});
  }

  void setValue() async {
    setState(() {
      namaController.text = widget.transaksi.nama;
      tanggalController.text = dateFormat.format(widget.transaksi.tanggal);
      nominalController.text = widget.transaksi.nominal.toString();
      jenisController = widget.transaksi.jenis;
      kategoriController = widget.transaksi.kategori;
      deskripsiController.text = widget.transaksi.deskripsi;
      fileController.text = widget.transaksi.gambar;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setValue();
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference transaksiCollection =
        _firestore.collection('transaksi');

    Future<void> updateTransaksi() async {
      // Parse the string to DateTime
      DateTime parsedDateTime =
          DateFormat('yyyy-MM-DD hh:mm').parse(tanggalController.text);

      // Convert DateTime to Firestore Timestamp
      Timestamp timestamp = Timestamp.fromDate(parsedDateTime);

      String url = await uploadImage();

      await transaksiCollection.doc(widget.transaksiDocId).update({
        'nama': namaController.text,
        'tanggal': timestamp,
        'nominal': int.parse(nominalController.text),
        'jenis': jenisController,
        'kategori': kategoriController,
        'deskripsi': deskripsiController.text,
        'gambar': url,
        'uid': _auth.currentUser!.uid,
        // ignore: invalid_return_type_for_catch_error
      }).catchError((error) => print("Failed to add user: $error"));
    }

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
                  //dropdown katagori
                  DropdownButtonFormField(
                    decoration: const InputDecoration(
                      hintText: 'Kategori',
                      hintStyle: textRegular,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: "Transfer Keluar",
                        child: Text('Transfer Keluar', style: textRegular),
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
                    onChanged: (value) =>
                        setState(() => kategoriController = value as String),
                  ),
                  SizedBox(height: 20),
                  //masukkan file
                  TextField(
                    decoration: const InputDecoration(
                        hintText: 'Masukkan File',
                        hintStyle: textRegular,
                        suffixIcon: Icon(Icons.attach_file),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
                    controller: fileController,
                    readOnly: true,
                    onTap: () {
                      uploadDialog(context);
                    },
                  ),
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
                        updateTransaksi();
                        updateSaldo();
                        Navigator.pop(context);
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
                    fileController.text = file!.name;
                  });

                  Navigator.of(context).pop();
                },
                child: Text('Camera'),
              ),
              TextButton(
                onPressed: () async {
                  XFile? upload =
                      await picker.pickImage(source: ImageSource.gallery);
                  setState(() {
                    file = upload;
                    fileController.text = file!.name;
                  });

                  Navigator.of(context).pop();
                },
                child: Text('Gallery'),
              ),
            ],
          );
        });
  }
}
