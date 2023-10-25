import 'package:catatan_keuangan/model/transaksi.dart';
import 'package:flutter/material.dart';
import 'package:catatan_keuangan/view/detail_view.dart';
import 'styles.dart';
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
            transaksi.kategoriGambar,
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
            transaksi.tanggal,
            style: const TextStyle(
                color: Colors.grey,
                fontSize: 10,
                fontFamily: 'Poppins-Regular'),
          ),
          trailing: transaksi.jenis
              ? Text(
                  transaksi.changes,
                  style: TextStyle(
                    fontFamily: 'Poppins-semiBold',
                    fontSize: 14,
                    color: pemasukanColor,
                  ),
                )
              : Text(
                  transaksi.changes,
                  style: TextStyle(
                    fontFamily: 'Poppins-semiBold',
                    fontSize: 14,
                    color: pengeluaranColor,
                  ),
                ),
        ),
      ),
      // child: Column(
      //   children: [
      //     Container(
      //       height: 65,
      //       padding: EdgeInsets.all(10),
      //       margin: const EdgeInsets.symmetric(vertical: 10),
      //       decoration: const BoxDecoration(
      //         color: Colors.white,
      //         borderRadius: BorderRadius.all(Radius.circular(15)),
      //         boxShadow: [
      //           BoxShadow(
      //             color: Colors.grey,
      //             offset: Offset(3.0, 4.0),
      //             blurRadius: 2.0,
      //           ),
      //         ],
      //       ),
      //       child: Row(
      //         crossAxisAlignment: CrossAxisAlignment.center,
      //         children: [
      //           Image.asset(
      //             transaksi.kategoriGambar,
      //             height: 40,
      //             width: 40,
      //           ),
      //           const SizedBox(
      //             width: 10,
      //           ),
      //           Container(
      //             padding: EdgeInsets.only(left: 5),
      //             child: Column(
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               children: [
      //                 Text(
      //                   transaksi.nama,
      //                   style: const TextStyle(
      //                     fontSize: 14,
      //                     fontFamily: 'Poppins-Bold',
      //                   ),
      //                 ),
      //                 Text(
      //                   transaksi.tanggal,
      //                   style: const TextStyle(
      //                       color: Colors.grey,
      //                       fontSize: 10,
      //                       fontFamily: 'Poppins-Regular'),
      //                 ),
      //               ],
      //             ),
      //           ),
      //           Expanded(
      //             child: Container(
      //               alignment: Alignment.centerRight,
      //               child: transaksi.jenis
      //                   ? Text(
      //                       transaksi.changes,
      //                       style: TextStyle(
      //                         fontFamily: 'Poppins-semiBold',
      //                         fontSize: 14,
      //                         color: pemasukanColor,
      //                       ),
      //                     )
      //                   : Text(
      //                       transaksi.changes,
      //                       style: TextStyle(
      //                         fontFamily: 'Poppins-semiBold',
      //                         fontSize: 14,
      //                         color: pengeluaranColor,
      //                       ),
      //                     ),
      //             ),
      //           )
      //         ],
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}
