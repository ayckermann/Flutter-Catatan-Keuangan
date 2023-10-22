import 'package:flutter/material.dart';
import 'package:catatan_keuangan/styles.dart';

class UpdatePage extends StatelessWidget {
  const UpdatePage({super.key});

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
              Text(
                'Update Transaksi',
                style: textBold,
              ),
              SizedBox(
                height: 30,
              ),
              //form
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
                  //pilih tanggal
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Tanggal',
                      hintStyle: textRegular,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Nominal',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      suffixIcon: Icon(Icons.attach_money),
                    ),
                  ),
                  SizedBox(height: 20),
                  //dropdown katagori
                  DropdownButtonFormField(
                    decoration: InputDecoration(
                      hintText: 'Kategori',
                      hintStyle: textRegular,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                    items: [
                      DropdownMenuItem(
                        child: Text(
                          'Pemasukan',
                          style: textRegular,
                        ),
                        value: 'Pemasukan',
                      ),
                      DropdownMenuItem(
                        child: Text(
                          'Pengeluaran',
                          style: textRegular,
                        ),
                        value: 'Pengeluaran',
                      ),
                    ],
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
                      child: Text('Update Transaksi', style: textButton),
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
