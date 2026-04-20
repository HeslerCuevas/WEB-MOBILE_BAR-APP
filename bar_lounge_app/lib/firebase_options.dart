import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
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
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD6hlx1IHC_Ws8ad94QSOTB7c20lOgFZdc',
    appId: '1:776133621872:android:aef122818d21d76e435cb5',
    messagingSenderId: '776133621872',
    projectId: 'my-app-bar-unique',
    storageBucket: 'my-app-bar-unique.firebasestorage.app',
  );
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAHmktRSwGgIeogJOj9GXTIatW0zeZxjJU',
    appId: '1:776133621872:web:62fdd7c16ee04b19435cb5',
    messagingSenderId: '776133621872',
    projectId: 'my-app-bar-unique',
    authDomain: 'my-app-bar-unique.firebaseapp.com',
    storageBucket: 'my-app-bar-unique.firebasestorage.app',
  );
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBjF211z1NP25C9TdrXYBSO5xAaW-Ccfrw',
    appId: '1:776133621872:ios:f13c6a66e7de62f1435cb5',
    messagingSenderId: '776133621872',
    projectId: 'my-app-bar-unique',
    storageBucket: 'my-app-bar-unique.firebasestorage.app',
    iosBundleId: 'com.nocturnal.barLoungeApp',
  );
}