import 'package:flutter/material.dart';

class SelectableSpeciesListItem extends StatelessWidget {
  final String species;
  final Function(String value) onSelect;

  const SelectableSpeciesListItem(
      {super.key, required this.species, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onSelect(species),
      child: ListTile(
        title: Text(species),
        trailing: const Icon(Icons.arrow_forward_outlined),
      ),
    );
  }
}
