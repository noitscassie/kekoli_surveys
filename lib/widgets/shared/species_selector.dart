import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/widgets/page_scaffold.dart';
import 'package:kekoldi_surveys/widgets/selectable_list_item.dart';

class SpeciesSelector extends StatefulWidget {
  final String pageTitle;
  final String initialSearchTerm;
  final Function(String species) onSelect;
  final List<String> species;

  const SpeciesSelector(
      {super.key,
      this.initialSearchTerm = '',
      required this.onSelect,
      required this.pageTitle,
      required this.species});

  @override
  State<SpeciesSelector> createState() => _SpeciesSelectorState();
}

class _SpeciesSelectorState extends State<SpeciesSelector> {
  late String searchTerm = widget.initialSearchTerm;

  late List<String> allSpecies = widget.species;

  bool matchesSearchTerm(String species) {
    final searchableName = species.toLowerCase();
    final dashAgnosticName = searchableName.replaceAll('-', ' ');
    final searchableInitials = searchableName
        .replaceAll('-', ' ')
        .split(' ')
        .map((String word) => word.split('')[0])
        .join();

    return searchableName.contains(searchTerm.toLowerCase()) ||
        dashAgnosticName.contains(searchTerm.toLowerCase()) ||
        searchableInitials.contains(searchTerm.toLowerCase());
  }

  List<String> get visibleSpecies => (searchTerm.isEmpty
          ? allSpecies
          : List.from(
              allSpecies.where((String species) => matchesSearchTerm(species))))
      .sorted()
      .cast();

  @override
  Widget build(BuildContext context) {
    return PageScaffold.withScrollableChildren(
      title: widget.pageTitle,
      header: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: TextFormField(
          initialValue: searchTerm,
          autofocus: true,
          autocorrect: false,
          decoration: const InputDecoration(
              hintText: 'Search by full name or initials...'),
          onChanged: (String? newValue) {
            setState(() {
              searchTerm = newValue ?? '';
            });
          },
        ),
      ),
      children: [
        ...visibleSpecies.map((String species) => SelectableListItem(
              title: species,
              onSelect: widget.onSelect,
            )),
        if (visibleSpecies.isEmpty)
          SelectableListItem(
            title: searchTerm,
            onSelect: (String species) => widget.onSelect(searchTerm),
            icon: Icons.add,
          )
      ],
    );
  }
}
