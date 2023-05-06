import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/constants/amphibians.dart';
import 'package:kekoldi_surveys/constants/birds.dart';
import 'package:kekoldi_surveys/constants/mammals.dart';
import 'package:kekoldi_surveys/constants/reptiles.dart';
import 'package:kekoldi_surveys/models/survey.dart';
import 'package:kekoldi_surveys/pages/add_sighting_details/add_sighting_details_page.dart';
import 'package:kekoldi_surveys/pages/choose_species/selectable_species_list_item.dart';
import 'package:kekoldi_surveys/widgets/page_scaffold.dart';

class ChooseSpeciesPage extends StatefulWidget {
  const ChooseSpeciesPage({super.key, required this.survey});

  final Survey survey;

  @override
  State<ChooseSpeciesPage> createState() => _ChooseSpeciesPageState();
}

class _ChooseSpeciesPageState extends State<ChooseSpeciesPage> {
  List<String> get allSpecies =>
      [...mammals, ...amphibians, ...reptiles, ...birds];

  bool matchesSearchTerm(String species) {
    final searchableName = species.toLowerCase();
    final searchableInitials = searchableName
        .replaceAll('-', ' ')
        .split(' ')
        .map((String word) => word.split('')[0])
        .join();

    return searchableName.contains(searchTerm) ||
        searchableInitials.contains(searchTerm);
  }

  List<String> get visibleSpecies => (searchTerm.isEmpty
          ? allSpecies
          : List.from(
              allSpecies.where((String species) => matchesSearchTerm(species))))
      .sorted()
      .cast();

  String searchTerm = '';

  void navigateToAddDetails(String species) =>
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => AddSightingDetailsPage(
                survey: widget.survey,
                species: species,
              )));

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
        title: 'Choose a species',
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: TextField(
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
            Expanded(
              child: ListView(
                children: List.from(visibleSpecies
                    .map((String species) => SelectableSpeciesListItem(
                          text: species,
                          onSelect: (String species) =>
                              navigateToAddDetails(species),
                        ))),
              ),
            ),
          ],
        ));
  }
}
