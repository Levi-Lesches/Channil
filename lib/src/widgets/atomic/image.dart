import "package:flutter/material.dart";
import "package:flutter/foundation.dart";

import "package:channil/data.dart";
import "package:channil/models.dart";
import "package:channil/widgets.dart";

Widget loadImage(BuildContext context, ImageState state) => switch(state) {
  ImageStateEmpty() => Text(
    "Select a photo", 
    textAlign: TextAlign.center,
    style: context.textTheme.titleLarge,    
  ),
  ImageStateLoading(progress: final progress) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      CircularProgressIndicator(
        value: progress,
      ),
      const SizedBox(height: 4),
      if (progress == null) const Text("Pending...") 
      else const Text("Uploading..."),
    ],
  ),
  ImageStateError(errorText: final errorText) => Text(
    errorText,
    textAlign: TextAlign.center,
    style: context.textTheme.bodyLarge?.copyWith(color: context.colorScheme.error),
  ),
  ImageStateOk(image: final image) => InkWell(
    onTap: () => zoom(context, image),
    child: Image.network(
      key: ValueKey(image.url),
      image.url, 
      fit: BoxFit.cover, 
      height: double.infinity, 
      width: double.infinity,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child; 
        if (loadingProgress.expectedTotalBytes == null) return const CircularProgressIndicator();
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              value: loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!,
            ),
            const SizedBox(height: 4),
            const Text("Downloading..."),
          ],
        );
      },
      errorBuilder: (context, error, stackTrace) => Text("Could not load image", style: TextStyle(color: context.colorScheme.error)),
    ),
  ),
};

void zoom(BuildContext context, ChannilImage image) => showDialog<void>(
  context: context,
  builder: (context) => AlertDialog(
    content: InteractiveViewer(maxScale: 5, child: Image.network(image.url)),
    actions: [
      TextButton(
        onPressed: () => context.pop(),
        child: const Text("Close"),
      ),
    ],
  ),
);

class ChannilImageViewer extends ReactiveWidget<ChannilImageViewModel> {
  final ChannilImage image;
  final double aspectRatio;
  const ChannilImageViewer(this.image, {this.aspectRatio = 1});

  bool get hasCaption => image.caption != null;

  @override
  ChannilImageViewModel createModel() => ChannilImageViewModel.view(image);

  @override
  Widget build(BuildContext context, ChannilImageViewModel model) => Card(
    elevation: 8,
    child: Column(children: [
      AspectRatio(
        aspectRatio: aspectRatio, 
        child: loadImage(context, model.state),
      ),
      if (hasCaption) 
        // const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(image.caption!, style: context.textTheme.headlineSmall),
        ),
        // const SizedBox(height: 8),
      // ],
    ],),
  );
}

class ChannilImagePicker extends ReusableReactiveWidget<ImageUploader> {
  final ProfileBuilder<dynamic> profileModel;
  final TextEditingController? captionController;
  final AsyncCallback? onPressedOverride;
  const ChannilImagePicker(
    super.model, {
      required this.profileModel,
      this.captionController,
      this.onPressedOverride,
    }
  );
  
  bool get hasCaption => captionController != null;

  @override
  Widget build(BuildContext context, ImageUploader model) => Center(child: SizedBox(
    height: hasCaption ? 300 : 200, 
    child: Card(
      child: Column(children: [
        Expanded(child: InkWell(
          onTap: () async {
            if (onPressedOverride != null) {
              await onPressedOverride!();
            }
            await model.onTap();
          },
          child: Center(child: loadImage(context, model.state)),
        ),),
        if (model.getImage() != null) TextButton(
          onPressed: () => model.setImage(null),
          child: const Text("Clear"), 
        ),
        if (hasCaption) ...[
          const SizedBox(height: 12),
          ChannilTextField(
            controller: captionController!, 
            hint: "Caption",
          ),
        ],
      ],),
    ),
  ),);
}
