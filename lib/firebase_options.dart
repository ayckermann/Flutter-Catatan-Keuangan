// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBXeoy0Sv7_-UyFyKZyi0GdbtEb-ukLycM',
    appId: '1:1016534318562:web:4a58d33cc41078f33bcdbb',
    messagingSenderId: '1016534318562',
    projectId: 'catatan-keuangan-285aa',
    authDomain: 'catatan-keuangan-285aa.firebaseapp.com',
    storageBucket: 'catatan-keuangan-285aa.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBUrq1PlrpZl-XdUXVWXkKbBbHnjkKCwmY',
    appId: '1:1016534318562:android:2468f40540b87d9b3bcdbb',
    messagingSenderId: '1016534318562',
    projectId: 'catatan-keuangan-285aa',
    storageBucket: 'catatan-keuangan-285aa.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDLzpd87q84bDomQO2QOTJM0vpYzLkE-ik',
    appId: '1:1016534318562:ios:058cc629fff066fd3bcdbb',
    messagingSenderId: '1016534318562',
    projectId: 'catatan-keuangan-285aa',
    storageBucket: 'catatan-keuangan-285aa.appspot.com',
    iosBundleId: 'com.example.catatanKeuangan',
  );
}
