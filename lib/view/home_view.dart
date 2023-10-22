import 'package:catatan_keuangan/styles.dart';
import 'package:catatan_keuangan/view/update_view.dart';
import 'package:flutter/material.dart';
import 'package:catatan_keuangan/view/tambah_view.dart';
import 'package:catatan_keuangan/view/detail_view.dart';

class HomeView extends StatefulWidget {
  HomeView({
    super.key,
  });

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Hi, Gosling',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: 'Poppins-bold',
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  child: Row(
                    children: [
                      Text(
                        'Catatan Keuangan',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 20,
                          fontFamily: 'Poppins-bold',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  height: 170,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: primaryColor),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Saldo Anda saat ini',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Poppins-semiBold',
                        ),
                      ),
                      Text(
                        'Rp 15.000.000',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                          fontFamily: 'Poppins-bold',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailPage()));
                        },
                        onLongPress: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext) {
                                return AlertDialog(
                                  title: Text('Pilih Aksi'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        // Tambahkan kode untuk mengedit transaksi di sini
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: ((context) =>
                                                    UpdatePage())));
                                      },
                                      child: Text('Edit'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        // Tambahkan kode untuk menghapus transaksi di sini
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Hapus'),
                                    ),
                                  ],
                                );
                              });
                        },
                        child: Container(
                          height: 65,
                          padding: EdgeInsets.all(10),
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                offset: Offset(3.0, 4.0),
                                blurRadius: 2.0,
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/TopUpCategory.png',
                                height: 40,
                                width: 40,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Top Up Steam Wallet Card',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'Poppins-Bold',
                                      ),
                                    ),
                                    Text(
                                      '13 Oktober 2023',
                                      style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 10,
                                          fontFamily: 'Poppins-Regular'),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    '-Rp600.000',
                                    style: TextStyle(
                                      fontFamily: 'Poppins-semiBold',
                                      fontSize: 14,
                                      color: pengeluaranColor,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => TambahPage()));
          },
          child: Icon(Icons.add),
          backgroundColor: primaryColor,
        ));
  }
}
