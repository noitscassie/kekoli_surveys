import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/constants/amphibians.dart';
import 'package:kekoldi_surveys/constants/birds.dart';
import 'package:kekoldi_surveys/constants/mammals.dart';
import 'package:kekoldi_surveys/constants/reptiles.dart';
import 'package:kekoldi_surveys/models/species.dart';
import 'package:kekoldi_surveys/models/survey.dart';

class ChooseSpeciesPage extends StatefulWidget {
  const ChooseSpeciesPage({super.key, required this.survey});

  final Survey survey;

  @override
  State<ChooseSpeciesPage> createState() => _ChooseSpeciesPageState();
}

class _ChooseSpeciesPageState extends State<ChooseSpeciesPage> {
  List<Species> get allSpecies =>
      [...mammals, ...amphibians, ...reptiles, ...birds];

  List<Species> get visibleSpecies => searchTerm.isEmpty
      ? allSpecies
      : List.from(allSpecies
          .where((Species species) => species.matchesSearchTerm(searchTerm)));

  String searchTerm = '';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: TextField(
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      fillColor: Theme.of(context).colorScheme.onInverseSurface,
                      filled: true,
                      hintText: 'Search for a species'),
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
                      .map((Species species) => Text(species.name))),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          label: Row(
            children: const [
              Text('Add Details'),
              Icon(Icons.arrow_forward_outlined)
            ],
          ),
          onPressed: () {},
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
