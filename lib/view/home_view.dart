import 'package:catatan_keuangan/model/akun.dart';
import 'package:catatan_keuangan/model/transaksi.dart';
import 'package:catatan_keuangan/tools/styles.dart';
import 'package:catatan_keuangan/tools/formater.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

  bool _isLoading = false;

  void logout() async {
    final navigator = Navigator.of(context);
    final scaffold = ScaffoldMessenger.of(context);
    setState(() {
      _isLoading = true;
    });

    try {
      await _auth.signOut();

      navigator.pushReplacementNamed('/login');
    } catch (e) {
      final snackbar = SnackBar(content: Text(e.toString()));
      scaffold.showSnackBar(snackbar);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final akunCollection = _firestore
        .collection('akun')
        .where('uid', isEqualTo: _auth.currentUser!.uid)
        .limit(1);

    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                              stream: akunCollection.snapshots(),
                              builder: (context, snapshot) {
                                String nama =
                                    snapshot.data?.docs[0]['nama'] ?? '';
                                return Text(
                                  "Hi $nama!",
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontFamily: 'Poppins-bold',
                                  ),
                                );
                              }),
                          IconButton(
                            onPressed: logout,
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
                              color: headerColor,
                              fontSize: 20,
                              fontFamily: famBold),
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
                            StreamBuilder(
                                stream: akunCollection.snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }
                                  int saldo =
                                      snapshot.data?.docs[0]['saldo'] ?? 0;
                                  return Text(
                                    numFormat.format(saldo),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 35,
                                      fontFamily: 'Poppins-bold',
                                    ),
                                  );
                                }),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),
                      Expanded(
                        child: StreamBuilder<
                                QuerySnapshot<Map<String, dynamic>>>(
                            stream: _firestore
                                .collection('transaksi')
                                .where('uid', isEqualTo: _auth.currentUser!.uid)
                                .orderBy('tanggal', descending: true)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }

                              List<Transaksi> listTransaksi =
                                  snapshot.data!.docs.map((e) {
                                return Transaksi(
                                  docId: e['docId'],
                                  uid: e['uid'],
                                  nama: e['nama'],
                                  kategori: e['kategori'],
                                  deskripsi: e['deskripsi'],
                                  tanggal: e['tanggal'].toDate(),
                                  nominal: e['nominal'],
                                  jenis: e['jenis'],
                                  gambar: e['gambar'],
                                );
                              }).toList();

                              return ListView.builder(
                                itemCount: listTransaksi.length,
                                padding: const EdgeInsets.all(10),
                                itemBuilder: (context, index) {
                                  return StreamBuilder(
                                      stream: _firestore
                                          .collection('akun')
                                          .where('uid',
                                              isEqualTo: _auth.currentUser!.uid)
                                          .limit(1)
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return const Center(
                                              child:
                                                  CircularProgressIndicator());
                                        }
                                        return ListItem(
                                          transaksi: listTransaksi[index],
                                          akun: Akun(
                                            uid: snapshot.data!.docs[0]['uid'],
                                            nama: snapshot.data!.docs[0]
                                                ['nama'],
                                            saldo: snapshot.data!.docs[0]
                                                ['saldo'],
                                            email: snapshot.data!.docs[0]
                                                ['email'],
                                            docId: snapshot.data!.docs[0]
                                                ['docId'],
                                          ),
                                        );
                                      });
                                },
                              );
                            }),
                      ),
                    ],
                  ),
                ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            QuerySnapshot querySnapshot = await akunCollection.get();

            Akun akun = Akun(
                uid: querySnapshot.docs[0]['uid'],
                nama: querySnapshot.docs[0]['nama'],
                saldo: querySnapshot.docs[0]['saldo'],
                email: querySnapshot.docs[0]['email'],
                docId: querySnapshot.docs[0]['docId']);
            Navigator.pushNamed(context, '/tambah', arguments: {'akun': akun});
          },
          backgroundColor: primaryColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: const Icon(Icons.add),
        ));
  }
}
