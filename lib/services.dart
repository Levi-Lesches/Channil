export  "src/services/auth.dart";
export  "src/services/cloud_storage.dart";

import "src/services/auth.dart";
import "src/services/cloud_storage.dart";
import "src/services/database.dart";
import "src/services/files.dart";
import "src/services/firebase.dart";
import "src/services/service.dart";

class Services extends Service {
  final firebase = FirebaseService();
  final auth = AuthService();
  final cloudStorage = CloudStorageService();
  final files = FilesService();
  final database = DatabaseService();

  @override
  Future<void> init() async {
    await firebase.init();
    await auth.init();
    await cloudStorage.init();
    await files.init();
    await database.init();
  }

  @override
  Future<void> dispose() async {
    await firebase.dispose();
    await auth.dispose();
    await cloudStorage.init();
    await files.init();
    await database.init();
  }
}

final services = Services();
