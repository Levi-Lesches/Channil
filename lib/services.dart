import "src/services/firebase.dart";
import "src/services/service.dart";

class Services extends Service {
  final firebase = FirebaseService();

  @override
  Future<void> init() async {
    await firebase.init();
  }

  @override
  Future<void> dispose() async {
    await firebase.dispose();
  }
}

final services = Services();
