import 'package:flutter/material.dart';
import 'package:catatan_keuangan/styles.dart';
import 'package:catatan_keuangan/view/update_view.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
              'Detail Transaksi',
              style: titleAppBar,
            ),
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
                child: Text('Transaksi Keluar',
                    textAlign: TextAlign.center, style: textBold),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                child: Image.asset(
                  'assets/detail.jpg',
                ),
              ),
              Container(
                decoration: BoxDecoration(border: Border.all(width: 1)),
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Text('Rp 600.000',
                    textAlign: TextAlign.center, style: price),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          'Top Up Steam Wallet Code',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 18,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1,
                                    color: Color.fromRGBO(0, 150, 199, 1)),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Text(
                                'Top-Up e-Wallet',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Color.fromRGBO(0, 150, 199, 1)),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
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
                                '13 Oktober 2023',
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        // keterangan transaksi
                      ],
                    ),
                    Icon(
                      Icons.account_balance_wallet,
                      size: 40,
                      color: Color.fromRGBO(0, 150, 199, 1),
                    ),
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
                  SizedBox(
                    height: 18,
                  ),
                  Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed vitae nunc eget nunc aliquet ultricies. Sed vitae nunc eget nunc aliquet ultricies.',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 14,
                    ),
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
