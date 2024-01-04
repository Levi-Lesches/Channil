import "dart:io";
import "package:flutter/material.dart";

import "package:channil/widgets.dart";
import "package:channil/data.dart";

class ImagePicker extends StatefulWidget {
  final ImageWithCaption? image;
  final VoidCallback onTap;
  final ValueChanged<String> onChanged;
  final bool hasCaption;
  
  const ImagePicker({
    required this.image, 
    required this.onTap,
    required this.onChanged,
    required this.hasCaption,
    super.key,
  });

  @override
  State<ImagePicker> createState() => _ImagePickerState();
}

class _ImagePickerState extends State<ImagePicker> {
  ImageWithCaption? image;
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    image = widget.image;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didUpdateWidget(ImagePicker oldWidget) {
    image = widget.image;
    super.didUpdateWidget(oldWidget);
  }
  
  @override
  Widget build(BuildContext context) => Center(child: SizedBox(
    height: widget.hasCaption ? 250 : 150, 
    width: 150, 
    child: image == null
      ? Card(
        color: context.colorScheme.primaryContainer, 
        child: InkWell(
          onTap: widget.onTap,
          child: Center(
            child: Text(
              "Select a photo", 
              textAlign: TextAlign.center,
              style: context.textTheme.titleLarge?.copyWith(color: context.colorScheme.onPrimaryContainer),
            ),
          ),
        ),
      )
      : Card(
        child: Column(
          children: [
            Expanded(child: InkWell(
              onTap: widget.onTap,
              child: switch (image!.type) {
              ImageType.network => Image.network(
                image!.imageUrl, 
                fit: BoxFit.cover, 
                height: 150, 
                width: 150,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child; 
                  if (loadingProgress.expectedTotalBytes == null) return const LinearProgressIndicator();
                  return LinearProgressIndicator(
                    value: loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!,
                  );
                },
              ),
              ImageType.file => Image.file(File(image!.imageUrl), fit: BoxFit.cover, height: 150, width: 150),
            },),),
            if (widget.hasCaption) ...[
              const SizedBox(height: 12),
              ChannilTextField(
                controller: controller, 
                hint: "Caption",
                onChanged: widget.onChanged,
              ),
            ],
          ],
        ),
      ),
  ),);
}
