// File generated for admin app Firebase configuration.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
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
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB7bWhQZPlrCviiJXAZnLVxh9TXz9AmnuI',
    appId: '1:478038547951:web:3f1cb0cb6e17566d632a1a',
    messagingSenderId: '478038547951',
    projectId: 'delevery-2',
    authDomain: 'delevery-2.firebaseapp.com',
    storageBucket: 'delevery-2.firebasestorage.app',
    measurementId: 'G-H4585E6SQR',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBmAdGJSchHmQzrEyIFq0HBtY5COlyJJ9U',
    appId: '1:478038547951:android:4a62b9b4ff3d42c2632a1a',
    messagingSenderId: '478038547951',
    projectId: 'delevery-2',
    storageBucket: 'delevery-2.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA6JgETmyp4swLF0iEEMvXKZfnTnuDDF9s',
    appId: '1:478038547951:ios:4f33516c696148fc632a1a',
    messagingSenderId: '478038547951',
    projectId: 'delevery-2',
    storageBucket: 'delevery-2.firebasestorage.app',
    iosBundleId: 'com.example.admin',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA6JgETmyp4swLF0iEEMvXKZfnTnuDDF9s',
    appId: '1:478038547951:ios:4f33516c696148fc632a1a',
    messagingSenderId: '478038547951',
    projectId: 'delevery-2',
    storageBucket: 'delevery-2.firebasestorage.app',
    iosBundleId: 'com.example.admin',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyB7bWhQZPlrCviiJXAZnLVxh9TXz9AmnuI',
    appId: '1:478038547951:web:6644ab99c5169bb0632a1a',
    messagingSenderId: '478038547951',
    projectId: 'delevery-2',
    authDomain: 'delevery-2.firebaseapp.com',
    storageBucket: 'delevery-2.firebasestorage.app',
    measurementId: 'G-JDQ6HKS4FG',
  );
}
