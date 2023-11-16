import 'package:catatan_keuangan/model/transaksi.dart';
import 'package:catatan_keuangan/tools/styles.dart';
import 'package:catatan_keuangan/tools/formater.dart';
import 'package:flutter/material.dart';
import 'package:catatan_keuangan/view/tambah_view.dart';
import 'package:catatan_keuangan/components/list_item.dart';

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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Hi, Gosling',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: 'Poppins-bold',
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.logout_rounded,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  alignment: Alignment.topLeft,
                  child: const Text(
                    'Catatan Keuangan',
                    style: TextStyle(
                        color: headerColor, fontSize: 20, fontFamily: famBold),
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  padding: EdgeInsets.all(20),
                  height: 170,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: headerColor),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Saldo anda saat ini',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: famSemi,
                        ),
                      ),
                      Text(
                        numFormat.format(15000000),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                          fontFamily: 'Poppins-bold',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                Expanded(
                  child: ListView.builder(
                    itemCount: transaksiList.length,
                    padding: const EdgeInsets.all(10),
                    itemBuilder: (context, index) {
                      return ListItem(
                        transaksi: transaksiList[index],
                      );
                    },
                  ),
                ),
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
