import "package:firebase_core/firebase_core.dart";
import "package:channil/firebase_options.dart";

import "service.dart";

class FirebaseService extends Service {
  @override
  Future<void> init() => Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  @override
  Future<void> dispose() async { }
}
