import 'package:flutter/material.dart';

Widget kategoriIcon(String kategori) {
  String url = '';

  switch (kategori) {
    case "Transfer Keluar":
      url = 'assets/TransferKeluarCategory.png';
      break;
    case "Transfer Masuk":
      url = 'assets/TransferMasukCategory.png';
      break;
    case "Tiket":
      url = 'assets/TiketCategory.png';
      break;
    case "TopUp":
      url = 'assets/TopUpCategory.png';
      break;
    case "Tagihan":
      url = 'assets/TagihanCategory.png';
      break;
    default:
      url = '';
  }

  return Image.asset(
    url,
  );
}
