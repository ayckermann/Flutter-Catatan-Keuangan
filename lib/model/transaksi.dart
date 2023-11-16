import 'package:flutter/material.dart';

class Kategori {
  String nama;
  String gambar;

  Kategori(this.nama, this.gambar);
}

final listKategori = [
  Kategori('Transfer Keluar', 'TransferKeluarCategory.png'),
  Kategori('Transfer Masuk', 'TransferMasukCategory.png'),
  Kategori('Tiket', 'TiketCategory.png'),
  Kategori('TopUp', 'TopUpCategory.png'),
  Kategori('Tagihan', 'TagihanCategory.png'),
];

class Transaksi {
  final String nama;
  final DateTime tanggal;
  final int nominal;
  final bool jenis; // true = +   false = -
  final Kategori kategori;
  final String deskripsi;

  Transaksi({
    required this.nama,
    required this.tanggal,
    required this.nominal,
    required this.jenis,
    required this.kategori,
    this.deskripsi = '',
  });
}

var transaksiList = [
  Transaksi(
    nama: 'Top Up Steam Wallet Card',
    tanggal: DateTime(2023, 10, 13),
    nominal: 600000,
    jenis: false,
    kategori: listKategori[3],
    deskripsi: 'Top Up SWC 600K',
  ),
  Transaksi(
    nama: 'Transfer BCA',
    tanggal: DateTime(2023, 10, 5),
    nominal: 1000000,
    jenis: true,
    kategori: listKategori[1],
    deskripsi: 'Ini deskripsi',
  ),
  Transaksi(
    nama: 'Tagihan Listrik',
    tanggal: DateTime(2023, 9, 5),
    nominal: 350000,
    jenis: false,
    kategori: listKategori[4],
    deskripsi: 'Ini deskripsi',
  ),
  Transaksi(
    nama: 'Transfer Mandiri',
    tanggal: DateTime(2023, 7, 19),
    nominal: 500000,
    jenis: false,
    kategori: listKategori[0],
    deskripsi: 'Ini deskripsi',
  ),
  Transaksi(
    nama: 'Tiket Pesawat',
    tanggal: DateTime(2023, 4, 15),
    nominal: 1500000,
    jenis: false,
    kategori: listKategori[2],
    deskripsi: 'Ini deskripsi',
  ),
];
