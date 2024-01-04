import "package:file_picker/file_picker.dart";

import "service.dart";

class FilesService extends Service {
  @override
  Future<void> init() async { }

  @override
  Future<void> dispose() async { }

  Future<String?> pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      dialogTitle: "Pick an image",
      type: FileType.image,
      allowCompression: false,
    );
    if (result == null) return null;
    return result.paths.first!;
  }

  Future<List<String>?> pickImages() async {
    final result = await FilePicker.platform.pickFiles(
      dialogTitle: "Pick your profile pictures",
      type: FileType.image,
      allowMultiple: true,
    );
    if (result == null) return null;
    return [
      for (final path in result.paths) path!,
    ];
  }
}
