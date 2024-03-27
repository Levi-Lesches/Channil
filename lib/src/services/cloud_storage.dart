export "package:firebase_storage/firebase_storage.dart";

import "dart:async";
import "dart:typed_data";

import "package:firebase_storage/firebase_storage.dart";

import "package:channil/data.dart";
import "service.dart";
  
typedef CloudStorageDir = Reference;
  
extension TaskSnapshotUtils on TaskSnapshot {
  double get progress => bytesTransferred / totalBytes;
}
  
class CloudStorageService extends Service {
  late final firebase = FirebaseStorage.instance;
  late final root = firebase.ref();

  Reference getAssetsDir({required UserID uid, required bool isBusiness}) => 
    root.child("userAssets/$uid/${isBusiness ? 'business' : 'athlete'}");

  @override
  Future<void> init() async { }

  @override
  Future<void> dispose() async { }

  Future<ChannilImage> uploadImage({
    required CloudStorageDir dir,
    required Uint8List data,
    required String filename,
    required void Function(TaskSnapshot) onProgress,
  }) async {
    final file = dir.child("images/$filename");
    final task = file.putData(data);
    final subscription = task.snapshotEvents.listen(onProgress, cancelOnError: true);
    await task.snapshotEvents.first;
    await task.timeout(const Duration(seconds: 10));
    await subscription.cancel();
    await Future<void>.delayed(const Duration(milliseconds: 250));
    final url = await file.getDownloadURL();
    return ChannilImage(url: url);
  }
}
