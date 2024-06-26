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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAlfP3kzuantnCcvfQw0p7RsU3a10Xkav8',
    appId: '1:847318552692:android:a1e40d72039ba03355c121',
    messagingSenderId: '847318552692',
    projectId: 'real-estate-d0863',
    storageBucket: 'real-estate-d0863.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDAKJbPsRKbkOgwN91pRYI8UIJsVj_Lz5A',
    appId: '1:847318552692:ios:f80b17094ea0039a55c121',
    messagingSenderId: '847318552692',
    projectId: 'real-estate-d0863',
    storageBucket: 'real-estate-d0863.appspot.com',
    iosClientId: '847318552692-le6t02ajfr3duslvpgkv4987ffucc6aj.apps.googleusercontent.com',
    iosBundleId: 'com.aunsh.realestate',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDAKJbPsRKbkOgwN91pRYI8UIJsVj_Lz5A',
    appId: '1:847318552692:ios:45cf0a9e1a37065255c121',
    messagingSenderId: '847318552692',
    projectId: 'real-estate-d0863',
    storageBucket: 'real-estate-d0863.appspot.com',
    iosClientId: '847318552692-e8bjbvf01t588mdh0aj9m7c2s5md6c5r.apps.googleusercontent.com',
    iosBundleId: 'com.aunsh.realestate.RunnerTests',
  );
}