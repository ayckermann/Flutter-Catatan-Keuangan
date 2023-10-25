class Transaksi {
  final String nama;
  final String tanggal;
  final String nominal;
  final bool jenis;
  final String kategori;
  final String kategoriGambar;
  final String deskripsi;
  final String changes;


  Transaksi({
    required this.nama,
    required this.tanggal,
    required this.nominal,
    required this.jenis,
    required this.kategori,
    required this.kategoriGambar,
    required this.deskripsi,
    required this.changes,
  });
}

var transaksiList = [
  Transaksi(
    nama: 'Top Up Steam Wallet Card',
    tanggal: '13 Oktober 2023',
    nominal: 'Rp 600.000',
    jenis: false,
    kategori: 'Top Up e-wallet',
    kategoriGambar: 'assets/TopUpCategory.png',
    deskripsi: 'Top Up SWC 600K',
    changes: '-Rp600.000',
  ),
  Transaksi(
    nama: 'Transfer BCA',
    tanggal: '5 Oktober 2023',
    nominal: 'Rp 1.000.000',
    jenis: true,
    kategori: 'Tranfer (Masuk)',
    kategoriGambar: 'assets/TransferMasukCategory.png',
    deskripsi: 'Ini deskripsi',
    changes: '+Rp1.000.000',
  ),
];
