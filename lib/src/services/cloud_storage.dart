export "package:firebase_storage/firebase_storage.dart";

import "dart:async";
import "dart:io";
import "package:firebase_storage/firebase_storage.dart";

import "service.dart";
  
extension TaskSnapshotUtils on TaskSnapshot {
  double get progress => bytesTransferred / totalBytes;
}

extension TaskUtils on Task {
  Future<void> monitor(void Function(TaskSnapshot) onProgress) async {
    final subscription = snapshotEvents.listen(onProgress, cancelOnError: true);
    await snapshotEvents.first; 
    await timeout(const Duration(seconds: 10));
    await subscription.cancel();
  }
}
  
class CloudStorageService extends Service {
  late final firebase = FirebaseStorage.instance;
  late final root = firebase.ref();

  @override
  Future<void> init() async { }

  @override
  Future<void> dispose() async { }

  Task uploadImage({
    required String uid, 
    required File localFile,
    required bool isBusiness,
    required String filename,
  }) {
    final cloudFile = root.child("userAssets/$uid/${isBusiness ? 'business' : 'athlete'}/images/$filename");
    return cloudFile.putFile(localFile);
  }

  Future<String> getImageUrl({required String uid, required String filename, required bool isBusiness}) async {
    final file = root.child("userAssets/$uid/${isBusiness ? 'business' : 'athlete'}/images/$filename");
    return file.getDownloadURL();
  }
}
