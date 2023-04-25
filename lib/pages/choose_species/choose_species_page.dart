import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/constants/amphibians.dart';
import 'package:kekoldi_surveys/constants/birds.dart';
import 'package:kekoldi_surveys/constants/mammals.dart';
import 'package:kekoldi_surveys/constants/reptiles.dart';
import 'package:kekoldi_surveys/models/species.dart';
import 'package:kekoldi_surveys/models/survey.dart';
import 'package:kekoldi_surveys/pages/add_sighting_details/add_sighting_details_page.dart';
import 'package:kekoldi_surveys/pages/choose_species/selectable_species_list_item.dart';

class ChooseSpeciesPage extends StatefulWidget {
  const ChooseSpeciesPage({super.key, required this.survey});

  final Survey survey;

  @override
  State<ChooseSpeciesPage> createState() => _ChooseSpeciesPageState();
}

class _ChooseSpeciesPageState extends State<ChooseSpeciesPage> {
  List<Species> get allSpecies =>
      [...mammals, ...amphibians, ...reptiles, ...birds];

  List<Species> get visibleSpecies => (searchTerm.isEmpty
          ? allSpecies
          : List.from(allSpecies.where(
              (Species species) => species.matchesSearchTerm(searchTerm))))
      .sortedBy((species) => species.name)
      .cast();

  String searchTerm = '';

  void navigateToAddDetails(Species species) =>
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => AddSightingDetailsPage(
                survey: widget.survey,
                species: species,
              )));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose a species'),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: TextField(
                autofocus: true,
                autocorrect: false,
                decoration:
                    const InputDecoration(hintText: 'Search for a species'),
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
                    .map((Species species) => SelectableSpeciesListItem(
                          species: species,
                          onSelect: (Species species) =>
                              navigateToAddDetails(species),
                        ))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
