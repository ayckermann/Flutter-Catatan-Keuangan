import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:catatan_keuangan/tools/styles.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class TambahPage extends StatefulWidget {
  final String akunDocId;
  const TambahPage({super.key, required this.akunDocId});

  @override
  State<TambahPage> createState() => _TambahPageState();
}

class _TambahPageState extends State<TambahPage> {
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

  Future<void> addTransaksi() async {
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

      String url = await uploadImage();

      await transaksiCollection.add({
        'nama': namaController.text,
        'tanggal': timestamp,
        'nominal': int.parse(nominalController.text),
        'jenis': jenisController,
        'kategori': kategoriController,
        'deskripsi': deskripsiController.text,
        'gambar': url,
        'uid': _auth.currentUser!.uid,
      });
      updateSaldo();
      Navigator.pop(context);
    } catch (e) {
      final snackbar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

  Future<String> uploadImage() async {
    if (file == null) return '';

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

  Future<void> updateSaldo() {
    var ref = _firestore.collection('akun').doc(widget.akunDocId);

    int saldo = int.parse(nominalController.text);
    if (!jenisController) {
      saldo *= -1;
    }
    return ref.update({'saldo': FieldValue.increment(saldo)});
  }

  @override
  Widget build(BuildContext context) {
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
          'Tambah Transaksi',
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
                'Transaksi Baru',
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
                    onChanged: (value) =>
                        setState(() => jenisController = value as bool),
                  ),
                  const SizedBox(height: 20),
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
                    onChanged: (value) =>
                        setState(() => kategoriController = value as String),
                  ),
                  SizedBox(height: 20),

                  //masukan file
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      imagePreview(),
                      IconButton(
                        onPressed: () {
                          uploadDialog(context);
                        },
                        icon: const Icon(Icons.attach_file),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(secondaryColor),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
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
                      color: secondaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextButton(
                      onPressed: () {
                        addTransaksi();
                      },
                      child: Text('Tambah Transaksi', style: textButton),
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

  Image imagePreview() {
    if (file == null) {
      return Image.asset('assets/no-picture.jpg', width: 200, height: 200);
    } else {
      return Image.file(File(file!.path), width: 200, height: 200);
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
