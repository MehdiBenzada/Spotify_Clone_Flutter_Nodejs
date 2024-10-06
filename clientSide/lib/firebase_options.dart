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
        return macos;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB0zeJL9OC91Z02X6a72DbOCFm4sO93bFg',
    appId: '1:444866212667:web:236db8e31554376842bd1e',
    messagingSenderId: '444866212667',
    projectId: 'test-4cbff',
    authDomain: 'test-4cbff.firebaseapp.com',
    storageBucket: 'test-4cbff.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDbMK8cn7z7NgcIddsJvw_Yq5qfnLSvd9M',
    appId: '1:444866212667:android:d55bdfe0347ca0cc42bd1e',
    messagingSenderId: '444866212667',
    projectId: 'test-4cbff',
    storageBucket: 'test-4cbff.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCAoxrVbEWZKJO32nxBqi-ermHJAQKbq_U',
    appId: '1:444866212667:ios:63944111cba3c83042bd1e',
    messagingSenderId: '444866212667',
    projectId: 'test-4cbff',
    storageBucket: 'test-4cbff.appspot.com',
    iosBundleId: 'com.example.spotifyCloneFr.RunnerTests',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCAoxrVbEWZKJO32nxBqi-ermHJAQKbq_U',
    appId: '1:444866212667:ios:63944111cba3c83042bd1e',
    messagingSenderId: '444866212667',
    projectId: 'test-4cbff',
    storageBucket: 'test-4cbff.appspot.com',
    iosBundleId: 'com.example.spotifyCloneFr.RunnerTests',
  );
}
