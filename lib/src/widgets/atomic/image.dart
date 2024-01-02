import "dart:async";
import "package:flutter/material.dart";

import "package:channil/widgets.dart";
import "package:channil/data.dart";

class ImagePicker extends StatefulWidget {
  final ImageWithCaption? image;
  final VoidCallback onTap;
  final ValueChanged<String> onChanged;
  
  const ImagePicker({
    required this.image, 
    required this.onTap,
    required this.onChanged,
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
    if (image != null) controller.text = image!.caption;
    controller.addListener(onChanged);
  }

  @override
  void dispose() {
    controller.removeListener(onChanged);
    super.dispose();
  }

  @override
  void didUpdateWidget(ImagePicker oldWidget) {
    image = widget.image;
    Timer.run(() => controller.text = image?.caption ?? "");
    super.didUpdateWidget(oldWidget);
  }

  void onChanged() {
    widget.onChanged(controller.text);
  }
  
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: widget.onTap,
    child: SizedBox(
      height: 225, 
      width: 150, 
      child: image == null  
        ? Card(color: context.colorScheme.primaryContainer)
        : Card(
          child: Column(
            children: [
              Image.network(image!.imageUrl, height: 150, width: 150),
              const Spacer(),
              ChannilTextField(controller: controller, hint: "Caption"),
            ],
          ),
        ),
    ),
  );
}
