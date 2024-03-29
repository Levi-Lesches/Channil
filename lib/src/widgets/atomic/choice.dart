import "package:channil/main.dart";
import "package:flutter/material.dart";

import "package:channil/widgets.dart";

class ChannilChoice extends StatelessWidget {
  final String name;
  final ImageProvider? image;
  final bool isPicked;
  final ValueChanged<bool> onChanged;
  const ChannilChoice({
    required this.name,
    required this.isPicked,
    required this.onChanged,
    this.image,
  });

  @override
  Widget build(BuildContext context) => Card(
    color: isPicked ? channilColor : context.colorScheme.surface,
    child: InkWell(
      onTap: () => onChanged(!isPicked),
      child: Container(
        alignment: Alignment.center,
        child: image == null 
          ? Text(
            name, 
            style: context.textTheme.bodyMedium?.copyWith(
              color: isPicked ? Colors.white : null,
            ),
          ) 
          : ListTile(
            title: Text(name, style: context.textTheme.bodyMedium?.copyWith(
              color: isPicked ? Colors.white : null,
            ),),
            leading: Image(
              image: image!, 
              fit: BoxFit.cover, 
              color: !isPicked ? null : Colors.white,
            ),
            selected: isPicked,
            selectedTileColor: channilColor,
            selectedColor: Colors.white,
          ),
      ),
    ),
  );
}
