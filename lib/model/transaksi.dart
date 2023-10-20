class Transaksi {
  String nama;
  String tanggal;
  String nominal;
  String kategori;

  Transaksi({
    required this.nama,
    required this.tanggal,
    required this.nominal,
    required this.kategori,
  });
}

var makananList = [
  Transaksi(
    nama: 'Top Up Steam Wallet Card',
    tanggal: '13 Oktober 2023',
    nominal: '-Rp600.000',
    kategori: 'assets/TopUpCategory.png',
  ),
  Transaksi(
    nama: 'Transfer BCA',
    tanggal: '5 Oktober 2023',
    nominal: '+Rp1.000.000',
    kategori: 'assets/TransferMasukCategory.png',
  ),
];
