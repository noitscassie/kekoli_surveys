import 'package:flutter/material.dart';

class SelectableSpeciesListItem extends StatelessWidget {
  final String text;
  final Function(String value) onSelect;

  const SelectableSpeciesListItem(
      {super.key, required this.text, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onSelect(text),
      child: ListTile(
        title: Text(text),
        trailing: const Icon(Icons.arrow_forward_outlined),
      ),
    );
  }
}