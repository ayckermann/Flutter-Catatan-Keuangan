import 'package:catatan_keuangan/model/akun.dart';
import 'package:catatan_keuangan/model/transaksi.dart';
import 'package:catatan_keuangan/tools/styles.dart';
import 'package:catatan_keuangan/tools/formater.dart';
import 'package:catatan_keuangan/view/login_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:catatan_keuangan/view/tambah_view.dart';
import 'package:catatan_keuangan/components/list_item.dart';

class HomeView extends StatefulWidget {
  const HomeView({
    super.key,
  });

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Akun akun = Akun(
    uid: '',
    nama: '',
    saldo: 0,
    email: '',
    docId: '',
  ); // null safety sebelum fetch dari firebase di initState

  void logout() async {
    final navigator = Navigator.of(context);
    try {
      await _auth.signOut();
    } catch (e) {
      print(e);
    }

    navigator.pushReplacement(
      MaterialPageRoute(builder: (context) {
        return LoginView();
      }),
    );
  }

  Future<void> getAkun() async {
    final User? user = _auth.currentUser;
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('akun')
          .where('uid', isEqualTo: user!.uid)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        var userData = querySnapshot.docs.first.data() as Map<String, dynamic>;
        setState(() {
          akun = Akun(
              uid: userData['uid'],
              nama: userData['nama'],
              saldo: userData['saldo'],
              email: userData['email'],
              docId: userData['docId']);
        });
      } else {
        print('Document not found!');
      }
    } catch (e) {
      final snackbar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getTransaksi() {
    try {
      return _firestore
          .collection('transaksi')
          .where('uid', isEqualTo: akun.uid)
          .orderBy('tanggal', descending: true)
          .snapshots();
    } catch (e) {
      final snackbar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
      return Stream.error(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getAkun();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Hi ${akun.nama}!",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: 'Poppins-bold',
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        logout();
                      },
                      icon: const Icon(
                        Icons.logout_rounded,
                        color: headerColor,
                      ),
                    ),
                  ],
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
                      const Text(
                        'Saldo anda saat ini',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: famSemi,
                        ),
                      ),
                      Text(
                        numFormat.format(akun.saldo),
                        style: const TextStyle(
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
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: getTransaksi(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        List<Transaksi> listTransaksi =
                            snapshot.data!.docs.map((document) {
                          final data = document.data();
                          final String nama = data['nama'];
                          final DateTime tanggal = data['tanggal'].toDate();
                          final int nominal = data['nominal'];
                          final bool jenis = data['jenis'];
                          final String kategori = data['kategori'];

                          final String deskripsi = data['deskripsi'] ?? '';
                          final String gambar = data['gambar'] ?? '';

                          return Transaksi(
                            nama: nama,
                            tanggal: tanggal,
                            nominal: nominal,
                            jenis: jenis,
                            kategori: kategori,
                            deskripsi: deskripsi,
                            gambar: gambar,
                          );
                        }).toList();

                        return ListView.builder(
                          itemCount: listTransaksi.length,
                          padding: const EdgeInsets.all(10),
                          itemBuilder: (context, index) {
                            return ListItem(
                              transaksi: listTransaksi[index],
                              transaksiDocId: snapshot.data!.docs[index].id,
                              akunDocId: akun.docId,
                            );
                          },
                        );
                      }),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TambahPage(
                          akunDocId: akun.docId,
                        ))).then((value) => setState(() {
                  getAkun();
                }));
          },
          backgroundColor: primaryColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: const Icon(Icons.add),
        ));
  }
}
