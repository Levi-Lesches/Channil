import "dart:typed_data";

import "package:file_picker/file_picker.dart";

import "service.dart";

class FilesService extends Service {
  @override
  Future<void> init() async { }

  @override
  Future<void> dispose() async { }

  Future<Uint8List?> pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      dialogTitle: "Select an image",
      type: FileType.image,
      withData: true,
    );
    if (result == null) return null;
    if (result.files.isEmpty) return null;
    return result.files.first.bytes!;
  }

  Future<List<Uint8List>?> pickImages() async {
    final result = await FilePicker.platform.pickFiles(
      dialogTitle: "Select images",
      type: FileType.image,
      allowMultiple: true,
      withData: true,
      readSequential: true,
    );
    if (result == null) return null;
    return [
      for (final file in result.files) file.bytes!,
    ];
  }
}
