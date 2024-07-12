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
    apiKey: 'AIzaSyC2oSr-7GXkobMnuMHhN3wQMc5R_6jxbzg',
    appId: '1:574525399129:web:f530b2e22662d79f4c1148',
    messagingSenderId: '574525399129',
    projectId: 'nile-quest-7d381',
    authDomain: 'nile-quest-7d381.firebaseapp.com',
    storageBucket: 'nile-quest-7d381.appspot.com',
    measurementId: 'G-MWM1SD8EBP',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBSq9gLC3Q-8UNK_iPmA6M4IlPsHkaNM0c',
    appId: '1:574525399129:android:002b6c322b1ef3394c1148',
    messagingSenderId: '574525399129',
    projectId: 'nile-quest-7d381',
    storageBucket: 'nile-quest-7d381.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDp3UUyw4W-tzcKCUQ73w9ASFRDBpJ3Sy0',
    appId: '1:574525399129:ios:a3adfdfb343d69c64c1148',
    messagingSenderId: '574525399129',
    projectId: 'nile-quest-7d381',
    storageBucket: 'nile-quest-7d381.appspot.com',
    iosBundleId: 'com.example.nileQuest',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDp3UUyw4W-tzcKCUQ73w9ASFRDBpJ3Sy0',
    appId: '1:574525399129:ios:b11800448015b2804c1148',
    messagingSenderId: '574525399129',
    projectId: 'nile-quest-7d381',
    storageBucket: 'nile-quest-7d381.appspot.com',
    iosBundleId: 'com.example.nileQuest.RunnerTests',
  );
}