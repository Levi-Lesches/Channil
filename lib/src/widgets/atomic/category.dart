import "package:channil/widgets.dart";
import "package:flutter/material.dart";

import "package:channil/data.dart";

class CategoryPicker extends StatelessWidget {
  final ValueChanged<bool> onChanged;
  final bool isPicked;
  final DealCategory category;
  const CategoryPicker({
    required this.category,
    required this.isPicked,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) => Card(
    child: Stack(children: [
      Column(children: [
        Expanded(flex: 3, child: Image.network(category.imageUrl, fit: BoxFit.cover)),
        const Spacer(),
      ],),
      Material(
        color: !isPicked ? Colors.transparent : context.colorScheme.primary.withOpacity(0.75), 
        child: InkWell(onTap: () => onChanged(!isPicked)),
      ),
      Column(children: [
        const Spacer(flex: 3),
        Expanded(child: Center(child: Text(category.displayName, style: context.textTheme.bodyLarge?.copyWith(
          color: isPicked ? context.colorScheme.onPrimary : null,
        ),),),),
      ],),
      if (isPicked) Center(
        child: Icon(Icons.check_circle, size: 48, color: context.colorScheme.onPrimaryContainer),
      ),
    ],),
  );
}
