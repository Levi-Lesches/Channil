import "package:flutter/material.dart";

class DropdownSelect<T> extends StatelessWidget {
  final Widget title;
  final Iterable<T> items;
  final Set<T> selectedItems;
  // final bool Function(T) isSelected;
  final void Function(T, {required bool isSelected}) onChanged;
  final String Function(T) getName;
  const DropdownSelect({
    required this.items,
    // required this.isSelected,
    required this.title,
    required this.selectedItems,
    required this.onChanged,
    required this.getName,
  });

  @override
  Widget build(BuildContext context) => ExpansionTile(
    title: title,
    subtitle: Text("Selected: ${selectedItems.length}"),
    children: [
      for (final item in items) CheckboxListTile(
        // key: ValueKey("${getName(item)}, ${selectedItems.contains(item)}"),
        title: Text(getName(item)),
        value: selectedItems.contains(item),
        // value: isSelected(item),
        onChanged: (isSelected) {
          if (isSelected == null) return;
          onChanged(item, isSelected: isSelected);
        },
      ),
    ],
  );
}
