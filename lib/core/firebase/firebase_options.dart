import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  DefaultFirebaseOptions._();

  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not configured for this platform yet.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDi6Er5j6PzrRduzrDitVZrIJJFnaqbU08',
    appId: '1:249586231317:android:f3db0f06856e9e354bc61c',
    messagingSenderId: '249586231317',
    projectId: 'walima-a779e',
    storageBucket: 'walima-a779e.firebasestorage.app',
  );
}
