import 'dart:convert';

import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/models/biodiversity_survey.dart';
import 'package:kekoldi_surveys/models/sighting.dart';
import 'package:kekoldi_surveys/pages/add_sighting_details/add_sighting_details_page.dart';
import 'package:kekoldi_surveys/pages/edit_species/edit_species_page.dart';
import 'package:kekoldi_surveys/pages/ongoing_survey/add_biodiversity_tally_modal.dart';
import 'package:kekoldi_surveys/pages/ongoing_survey/remove_tally_modal.dart';
import 'package:kekoldi_surveys/pages/ongoing_survey/species_sightings_list.dart';
import 'package:kekoldi_surveys/widgets/selectable_list_item.dart';

class SightingTile extends StatefulWidget {
  final BiodiversitySurvey survey;
  final String speciesName;
  final List<Sighting> sightings;
  final Function(BiodiversitySurvey survey) onChangeSurvey;

  const SightingTile(
      {super.key,
      required this.speciesName,
      required this.sightings,
      required this.survey,
      required this.onChangeSurvey});

  @override
  State<SightingTile> createState() => _SightingTileState();
}

class _SightingTileState extends State<SightingTile> {
  void onIncrement(Sighting sighting) => showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AddBiodiversityTallyModal(
            sighting: sighting,
            survey: widget.survey,
            onChangeSurvey: widget.onChangeSurvey,
          ));

  void onDecrement(List<Sighting> sightings) => showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => RemoveTallyModal(
          survey: widget.survey,
          sightings: sightings,
          onChangeSurvey: widget.onChangeSurvey));

  void onEdit(List<Sighting> sightings) =>
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => EditSpeciesPage(
                survey: widget.survey,
                sightings: sightings,
              )));

  void navigateToChooseSpeciesPage() =>
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => AddSightingDetailsPage(
                survey: widget.survey,
                species: widget.speciesName,
              )));

  Map<String, List<Sighting>> get groupedSightings =>
      widget.sightings.groupBy((sighting) => jsonEncode(sighting.data));

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        widget.speciesName,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 18),
      ),
      childrenPadding: const EdgeInsets.symmetric(horizontal: 20),
      expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ...groupedSightings.entries
            .sortedBy((MapEntry<String, List<Sighting>> entry) => entry.key)
            .mapIndexed(
              (index, entry) => Container(
                padding: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                    border: Border(
                        top: index == 0
                            ? BorderSide.none
                            : BorderSide(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant))),
                child: SpeciesSightingsList(
                  sightings: entry.value,
                  key: Key('${entry.key}_sighting_list_${index.toString()}'),
                  onIncrement: () => onIncrement(entry.value.last),
                  onDecrement: () => onDecrement(entry.value),
                  onEdit: (List<Sighting> sightings) => onEdit(sightings),
                  json: entry.key,
                ),
              ),
            ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: SelectableListItem(
            text: 'Add new ${widget.speciesName} observation',
            onSelect: (String _) => navigateToChooseSpeciesPage(),
            icon: Icons.add,
            padding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }
}
