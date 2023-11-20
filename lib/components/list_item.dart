import 'package:catatan_keuangan/components/kategori_icon.dart';
import 'package:catatan_keuangan/model/transaksi.dart';
import 'package:catatan_keuangan/tools/formater.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:catatan_keuangan/view/detail_view.dart';
import '../tools/styles.dart';
import 'package:catatan_keuangan/view/update_view.dart';

class ListItem extends StatefulWidget {
  final Transaksi transaksi;
  final String transaksiDocId;
  final String akunDocId;

  const ListItem({
    super.key,
    required this.transaksi,
    required this.transaksiDocId,
    required this.akunDocId,
  });

  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  Future<void> delete() async {
    await _firestore
        .collection("transaksi")
        .doc(widget.transaksiDocId)
        .delete();

    if (widget.transaksi.gambar != '') {
      await _storage.refFromURL(widget.transaksi.gambar).delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 8,
        shadowColor: Colors.grey[100],
        color: Colors.white,
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          splashColor: Colors.blue[100],
          leading: kategoriIcon(widget.transaksi.kategori),
          title: Text(
            widget.transaksi.nama,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'Poppins-Bold',
            ),
          ),
          subtitle: Text(
            dateFormat.format(widget.transaksi.tanggal),
            style: const TextStyle(
                color: Colors.grey,
                fontSize: 10,
                fontFamily: 'Poppins-Regular'),
          ),
          trailing: Text(
            numFormat.format(widget.transaksi.nominal),
            style: TextStyle(
              fontFamily: 'Poppins-semiBold',
              fontSize: 14,
              color: widget.transaksi.jenis ? pemasukanColor : pengeluaranColor,
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailPage(
                  transaksi: widget.transaksi,
                  transaksiDocId: widget.transaksiDocId,
                  akunDocId: widget.akunDocId,
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
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => UpdatePage(
                                        transaksi: widget.transaksi,
                                        akunDocId: widget.akunDocId,
                                        transaksiDocId: widget.transaksiDocId,
                                      ))));
                        },
                        child: Text('Edit'),
                      ),
                      TextButton(
                        onPressed: () {
                          delete();

                          Navigator.of(context).pop();
                        },
                        child: Text('Hapus'),
                      ),
                    ],
                  );
                });
          },
        ),
      ),
    );
  }
}
