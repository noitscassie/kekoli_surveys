import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/models/species.dart';

class SelectableSpeciesListItem extends StatelessWidget {
  final Species species;
  final Function(Species value) onSelect;

  const SelectableSpeciesListItem(
      {super.key, required this.species, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onSelect(species),
      child: ListTile(
        title: Text(species.name),
        trailing: const Icon(Icons.arrow_forward_outlined),
      ),
    );
  }
}
