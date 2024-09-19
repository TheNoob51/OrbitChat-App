// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyDLQdW9eJdB7pGpaHZjR1KbbjpWX2_qpnU',
    appId: '1:963838749290:web:520f74b86f1cd36196f813',
    messagingSenderId: '963838749290',
    projectId: 'devfolio-genblacks',
    authDomain: 'devfolio-genblacks.firebaseapp.com',
    storageBucket: 'devfolio-genblacks.appspot.com',
    measurementId: 'G-B0ZS9V2HL8',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAJEUq-Id6xZiWVaQEAsCdzlHNuCpvF_So',
    appId: '1:963838749290:android:99d5e03d236a86e396f813',
    messagingSenderId: '963838749290',
    projectId: 'devfolio-genblacks',
    storageBucket: 'devfolio-genblacks.appspot.com',
  );
}
