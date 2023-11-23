import 'package:catatan_keuangan/components/kategori_icon.dart';
import 'package:catatan_keuangan/model/transaksi.dart';
import 'package:catatan_keuangan/tools/formater.dart';
import 'package:catatan_keuangan/view/home_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:catatan_keuangan/tools/styles.dart';
import 'package:catatan_keuangan/view/update_view.dart';

class DetailPage extends StatefulWidget {
  final Transaksi transaksi;
  final String transaksiDocId;
  final String akunDocId;

  const DetailPage({
    super.key,
    required this.transaksi,
    required this.transaksiDocId,
    required this.akunDocId,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  Future<void> delete() async {
    await _firestore
        .collection("transaksi")
        .doc(widget.transaksiDocId)
        .delete();

    if (widget.transaksi.gambar != '') {
      await _storage.refFromURL(widget.transaksi.gambar).delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Detail Transaksi', style: titleAppBar),
            centerTitle: true,
            backgroundColor: headerColor,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            )),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 40),
                child: widget.transaksi.jenis
                    ? const Text('Transaksi Masuk',
                        textAlign: TextAlign.center, style: textBold)
                    : const Text('Transaksi Keluar',
                        textAlign: TextAlign.center, style: textBold),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                child: widget.transaksi.gambar == ''
                    ? Image.asset('assets/no-picture.jpg')
                    : Image.network(widget.transaksi.gambar
                        // url,
                        ),
              ),
              Container(
                  decoration: const BoxDecoration(
                    border: Border.symmetric(
                        horizontal: BorderSide(width: 5, color: headerColor)),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(numFormat.format(widget.transaksi.nominal),
                      textAlign: TextAlign.center,
                      style:
                          widget.transaksi.jenis ? priceMasuk : priceKeluar)),
              Container(
                margin: const EdgeInsets.only(top: 10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.transaksi.nama,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: secondaryColor),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Text(
                                widget.transaksi.kategori,
                                style: const TextStyle(
                                    fontSize: 12, color: secondaryColor),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Text(
                                dateFormat.format(widget.transaksi.tanggal),
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    kategoriIcon(widget.transaksi.kategori),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: Column(children: [
                  const Text(
                    'Deskripsi Transaksi',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    widget.transaksi.deskripsi,
                    textAlign: TextAlign.start,
                    style: const TextStyle(fontSize: 14),
                  ),
                ]),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                //edit dan hapus
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(0, 150, 199, 1),
                        borderRadius: BorderRadius.circular(30)),
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: TextButton(
                      onPressed: () {
                        //arahakan ke halaman detail
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UpdatePage(
                              transaksi: widget.transaksi,
                              akunDocId: widget.akunDocId,
                              transaksiDocId: widget.transaksiDocId,
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        'Edit',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(0, 150, 199, 1),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: TextButton(
                      onPressed: () {
                        delete();
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Hapus',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 32,
              ),
            ],
          ),
        ));
  }
}
