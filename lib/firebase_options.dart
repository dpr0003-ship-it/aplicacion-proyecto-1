// Archivo de opciones de Firebase generado automáticamente
// Reemplaza los valores con los de tu proyecto si es necesario
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError('No configurado para web');
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError('No configurado para esta plataforma');
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'REEMPLAZA_CON_TU_API_KEY',
    appId: 'REEMPLAZA_CON_TU_APP_ID',
    messagingSenderId: 'REEMPLAZA_CON_TU_MESSAGING_SENDER_ID',
    projectId: 'REEMPLAZA_CON_TU_PROJECT_ID',
    storageBucket: 'REEMPLAZA_CON_TU_STORAGE_BUCKET',
  );
}
