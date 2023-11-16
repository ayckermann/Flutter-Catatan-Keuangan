import 'package:catatan_keuangan/model/transaksi.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:catatan_keuangan/tools/styles.dart';

class TambahPage extends StatelessWidget {
  const TambahPage({super.key});

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
        title: Text(
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
              Text(
                'Transaksi Baru',
                style: textBold,
              ),
              SizedBox(
                height: 30,
              ),
              Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Nama Transaksi',
                      hintStyle: textRegular,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                  ),
                  SizedBox(height: 20),
                  DateTimePicker(
                      decoration: InputDecoration(
                        hintText: 'Tanggal',
                        hintStyle: textRegular,
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now()),
                  SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Nominal',
                      hintStyle: textRegular,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      suffixIcon: Icon(Icons.attach_money),
                    ),
                  ),
                  SizedBox(height: 20),
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
                          child: Text('Pengeluaran', style: textRegular),
                          value: true,
                        ),
                        DropdownMenuItem(
                          child: Text('Pemasukan', style: textRegular),
                          value: false,
                        )
                      ],
                      onChanged: (value) {}),
                  SizedBox(height: 20),
                  //dropdown katagori
                  DropdownButtonFormField(
                    decoration: const InputDecoration(
                      hintText: 'Kategori',
                      hintStyle: textRegular,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                    items: listKategori.map((data) {
                      return DropdownMenuItem(
                        value: data,
                        child: Text(data.nama, style: textRegular),
                      );
                    }).toList(),
                    onChanged: (value) {},
                  ),
                  SizedBox(height: 20),
                  //masukkan file
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Masukkan File',
                      hintStyle: textRegular,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      suffixIcon: Icon(Icons.attach_file),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: 'Keterangan',
                      hintStyle: textRegular,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                  ),
                  SizedBox(height: 50),
                  Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(0, 150, 199, 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextButton(
                      onPressed: () {},
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
}
