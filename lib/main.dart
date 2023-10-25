import 'package:catatan_keuangan/view/register_view.dart';
import 'package:flutter/material.dart';
import 'package:catatan_keuangan/view/home_view.dart';
import 'package:catatan_keuangan/view/login_view.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catatan Keuangan',
      theme: ThemeData(),
      home: HomeView(),
    );
  }
}
