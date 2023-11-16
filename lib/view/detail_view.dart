import 'package:catatan_keuangan/model/transaksi.dart';
import 'package:catatan_keuangan/tools/formater.dart';
import 'package:flutter/material.dart';
import 'package:catatan_keuangan/tools/styles.dart';
import 'package:catatan_keuangan/view/update_view.dart';

class DetailPage extends StatelessWidget {
  final Transaksi transaksi;

  const DetailPage({
    super.key,
    required this.transaksi,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('Detail Transaksi', style: titleAppBar),
            centerTitle: true,
            backgroundColor: headerColor,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            )),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin: EdgeInsets.only(top: 40),
                child: transaksi.jenis
                    ? Text('Transaksi Masuk',
                        textAlign: TextAlign.center, style: textBold)
                    : Text('Transaksi Keluar',
                        textAlign: TextAlign.center, style: textBold),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                child: Image.asset(
                  'assets/detail.jpg',
                ),
              ),
              Container(
                  decoration: const BoxDecoration(
                    border: Border.symmetric(
                        horizontal:
                            BorderSide(width: 10, color: secondaryColor)),
                  ),
                  margin: EdgeInsets.only(top: 10),
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(numFormat.format(transaksi.nominal),
                      textAlign: TextAlign.center,
                      style: transaksi.jenis ? priceMasuk : priceKeluar)),
              Container(
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          transaksi.nama,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: secondaryColor),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Text(
                                transaksi.kategori.nama,
                                style: TextStyle(
                                    fontSize: 12, color: secondaryColor),
                              ),
                            ),
                            SizedBox(width: 10),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Text(
                                dateFormat.format(transaksi.tanggal),
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                        // keterangan transaksi
                      ],
                    ),
                    Image.asset('assets/${transaksi.kategori.gambar}')
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: Column(children: [
                  Text(
                    'Keterangan Transaksi',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 18),
                  Text(
                    transaksi.deskripsi,
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 14),
                  ),
                ]),
              ),
              SizedBox(
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UpdatePage()));
                      },
                      child: Text(
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
                      color: Color.fromRGBO(0, 150, 199, 1),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        'Hapus',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
