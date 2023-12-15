import 'package:catatan_keuangan/components/kategori_icon.dart';
import 'package:catatan_keuangan/model/akun.dart';
import 'package:catatan_keuangan/model/transaksi.dart';
import 'package:catatan_keuangan/tools/formater.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import '../tools/styles.dart';

class ListItem extends StatefulWidget {
  final Transaksi transaksi;
  final Akun akun;

  ListItem({
    super.key,
    required this.transaksi,
    required this.akun,
  });

  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  void delete(BuildContext buildContext) async {
    try {
      await _firestore
          .collection("transaksi")
          .doc(widget.transaksi.docId)
          .delete();

      if (widget.transaksi.gambar != '') {
        await _storage.refFromURL(widget.transaksi.gambar).delete();
      }
      Navigator.pop(buildContext);
    } catch (e) {
      final snackbar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
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
            Navigator.pushNamed(context, '/detail', arguments: {
              'transaksi': widget.transaksi,
              'akun': widget.akun,
            });
          },
          onLongPress: () {
            showDialog(
                context: context,
                builder: (buildContext) {
                  return AlertDialog(
                    title: Text('Pilih Aksi'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          // Tambahkan kode untuk mengedit transaksi di sini
                          Navigator.popAndPushNamed(
                            buildContext,
                            '/update',
                            arguments: {
                              'transaksi': widget.transaksi,
                              'akun': widget.akun,
                            },
                          );
                        },
                        child: Text('Edit'),
                      ),
                      TextButton(
                        onPressed: () {
                          delete(buildContext);
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
