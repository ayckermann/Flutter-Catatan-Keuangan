import 'package:catatan_keuangan/model/transaksi.dart';
import 'package:catatan_keuangan/tools/formater.dart';
import 'package:flutter/material.dart';
import 'package:catatan_keuangan/view/detail_view.dart';
import '../tools/styles.dart';
import 'package:catatan_keuangan/view/update_view.dart';

class ListItem extends StatelessWidget {
  final Transaksi transaksi;

  const ListItem({
    super.key,
    required this.transaksi,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPage(
              transaksi: transaksi,
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
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5),
        margin: const EdgeInsets.symmetric(vertical: 5),
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
        child: ListTile(
          leading: Image.asset(
            'assets/${transaksi.kategori.gambar}',
            height: 40,
            width: 40,
          ),
          title: Text(
            transaksi.nama,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'Poppins-Bold',
            ),
          ),
          subtitle: Text(
            dateFormat.format(transaksi.tanggal),
            style: const TextStyle(
                color: Colors.grey,
                fontSize: 10,
                fontFamily: 'Poppins-Regular'),
          ),
          trailing: Text(
            numFormat.format(transaksi.nominal),
            style: TextStyle(
              fontFamily: 'Poppins-semiBold',
              fontSize: 14,
              color: transaksi.jenis ? pemasukanColor : pengeluaranColor,
            ),
          ),
        ),
      ),
    );
  }
}
