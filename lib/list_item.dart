import 'package:flutter/material.dart';
import 'package:catatan_keuangan/view/detail_view.dart';
import 'styles.dart';
import 'package:catatan_keuangan/view/update_view.dart';

class ListItem extends StatelessWidget {
  final String nama;
  final String tanggal;
  final String nominal;
  final bool jenis;
  final String kategori;
  final String kategoriGambar;
  final String deskripsi;
  final String changes;

  const ListItem({
    super.key,
    required this.nama,
    required this.tanggal,
    required this.nominal,
    required this.jenis,
    required this.kategori,
    required this.kategoriGambar,
    required this.deskripsi,
    required this.changes,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailPage(
                nama: nama,
                tanggal: tanggal,
                nominal: nominal,
                jenis: jenis,
                kategori: kategori,
                kategoriGambar: kategoriGambar,
                deskripsi: deskripsi,
                changes: changes,
              ),
            ),
          );
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
                                builder: ((context) => UpdatePage())));
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
        child: Column(
          children: [
            Container(
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
                    kategoriGambar,
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
                          nama,
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'Poppins-Bold',
                          ),
                        ),
                        Text(
                          tanggal,
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
                      child: jenis
                          ? Text(
                              changes,
                              style: TextStyle(
                                fontFamily: 'Poppins-semiBold',
                                fontSize: 14,
                                color: pemasukanColor,
                              ),
                            )
                          : Text(
                              changes,
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
          ],
        ));
  }
}
