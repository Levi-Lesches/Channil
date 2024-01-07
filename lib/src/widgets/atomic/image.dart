import "package:flutter/material.dart";
import "package:flutter/foundation.dart";

import "package:channil/models.dart";
import "package:channil/widgets.dart";

class ImagePicker extends ReusableReactiveWidget<ImageUploader> {
  final ProfileBuilder<dynamic> profileModel;
  final TextEditingController? captionController;
  final AsyncCallback? onPressedOverride;
  const ImagePicker(
    super.model, {
      required this.profileModel,
      this.captionController,
      this.onPressedOverride,
    }
  );
  
  bool get hasCaption => captionController != null;
  
  Widget getChild(BuildContext context, ImageState state) => switch(state) {
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
    ImageStateOk(image: final image) => Image.network(
      image.url, 
      fit: BoxFit.cover, 
      height: 150, 
      width: 150,
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
  };
  
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
          child: Center(child: getChild(context, model.state)),
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
