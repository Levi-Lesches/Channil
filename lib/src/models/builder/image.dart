import "dart:typed_data";
import "package:flutter/material.dart";

import "package:channil/data.dart";
import "package:channil/services.dart";

abstract class ImageUploader with ChangeNotifier {
  final String filename;
  final CloudStorageDir Function() getDir;
  ImageState state = const ImageStateEmpty(); 
  
  ImageUploader({
    required this.filename,
    required this.getDir,
  });

  void startLoading() {
    state = const ImageStateLoading(null);
    notifyListeners();
  }

  void _onTaskUpdate(TaskSnapshot snapshot) {
    if (snapshot.state == TaskState.error) {
      state = const ImageStateError("Could not upload photo");
    } else {
      state = ImageStateLoading(snapshot.progress);
    }
    notifyListeners();
  }

  void setImage(ChannilImage? image) {
    state = image == null ? const ImageStateEmpty() : ImageStateOk(image);
    notifyListeners();
  }

  ChannilImage? getImage() => switch(state) {
    ImageStateOk(image: final image) => image,
    _ => null,
  };

  Future<void> uploadImage(Uint8List data) async {
    state = const ImageStateLoading(null);
    notifyListeners();
    try {
      final image = await services.cloudStorage.uploadImage(
        dir: getDir(),
        data: data,
        filename: filename,
        onProgress: _onTaskUpdate,
      );
      setImage(image);
    } catch (error) {
      state = const ImageStateError("Could not upload photo");
      notifyListeners();
    }
  }

  Future<void> onTap();
}

class SingleImageUploader extends ImageUploader {
  SingleImageUploader({
    required super.filename,
    required super.getDir,
  });

  @override
  Future<void> onTap() async {
    final file = await services.files.pickImage();
    if (file == null) return;
    await uploadImage(file);
  }
}

class MultipleImageUploader extends ImageUploader {
  static Future<void> uploadMultiple({
    required List<MultipleImageUploader> models, 
    required List<Uint8List> images, 
    required int startIndex,
  }) async {
    if (images.isEmpty) return;
    if (images.length == 1) {  // simply replace the image
      await models[startIndex].uploadImage(images.first);
    } else {  // replace every image in the set
      // Set each model to loading
      for (var index = 0; index < images.length; index++) {
        if (index >= models.length) break;
        models[index].startLoading();
      }
      // Load each image one by one
      for (final (index, image) in images.enumerate) {
        if (index >= models.length) break;
        await models[index].uploadImage(image);
      }
    }
  }
  
  final ValueChanged<List<Uint8List>> handleMultiple;
  MultipleImageUploader({
    required super.filename,
    required super.getDir,
    required this.handleMultiple,
  });

  @override
  Future<void> onTap() async {
    final files = await services.files.pickImages();
    if (files == null) return;
    handleMultiple(files);
  }
}

sealed class ImageState {
  const ImageState();
}

class ImageStateEmpty extends ImageState {
  const ImageStateEmpty();
}

class ImageStateLoading extends ImageState {
  final double? progress;
  const ImageStateLoading(this.progress);
}

class ImageStateError extends ImageState {
  final String errorText;
  const ImageStateError(this.errorText);
}

class ImageStateOk extends ImageState {
  final ChannilImage image;
  const ImageStateOk(this.image);
}
