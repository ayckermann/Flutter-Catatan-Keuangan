class Transaksi {
  final String nama;
  final String tanggal;
  final String nominal;
  final bool jenis; // true = +   false = -
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
    kategori: 'Transfer (Masuk)',
    kategoriGambar: 'assets/TransferMasukCategory.png',
    deskripsi: 'Ini deskripsi',
    changes: '+Rp1.000.000',
  ),
  Transaksi(
    nama: 'Tagihan Listrik',
    tanggal: '25 September 2023',
    nominal: 'Rp 350.000',
    jenis: true,
    kategori: 'Tagihan',
    kategoriGambar: 'assets/TagihanCategory.png',
    deskripsi: 'Ini deskripsi',
    changes: '-Rp350.000',
  ),
  Transaksi(
    nama: 'Transfer Mandiri',
    tanggal: '10 Juli 2023',
    nominal: 'Rp 500.000',
    jenis: false,
    kategori: 'Transfer (Keluar)',
    kategoriGambar: 'assets/TransferKeluarCategory.png',
    deskripsi: 'Ini deskripsi',
    changes: '-Rp500.000',
  ),
  Transaksi(
    nama: 'Tiket Pesawat',
    tanggal: '15 April 2023',
    nominal: 'Rp 1.500.000',
    jenis: false,
    kategori: 'Tiket',
    kategoriGambar: 'assets/TiketCategory.png',
    deskripsi: 'Ini deskripsi',
    changes: '+Rp1.500.000',
  ),
];
