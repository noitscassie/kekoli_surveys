import 'dart:convert';

import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/models/sighting.dart';
import 'package:kekoldi_surveys/models/survey.dart';
import 'package:kekoldi_surveys/pages/ongoing_survey/modify_tally_modal.dart';
import 'package:kekoldi_surveys/pages/ongoing_survey/species_sightings_list.dart';

class SightingTile extends StatefulWidget {
  final Survey survey;
  final String speciesName;
  final List<Sighting> sightings;
  final Function(Survey survey) onChangeSurvey;

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
      builder: (BuildContext context) => ModifyTallyModal(
            sighting: sighting,
            onConfirm: () {
              widget.survey.addSighting(sighting);
              widget.onChangeSurvey(widget.survey);

              Navigator.of(context).pop();
            },
            title: 'Add ${sighting.species} tally?',
            primaryCta: 'Add',
          ));

  void onDecrement(String sightingJson, int numberOfSightings) {
    final sighting = Sighting.fromMap(jsonDecode(sightingJson));

    final title =
        'Remove ${sighting.species}${numberOfSightings == 1 ? '' : ' tally'}?';

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => ModifyTallyModal(
              sighting: Sighting.fromMap(jsonDecode(sightingJson)),
              onConfirm: () {
                widget.survey.removeSightingMatchingJson(sightingJson);
                widget.onChangeSurvey(widget.survey);

                Navigator.of(context).pop();
              },
              title: title,
              primaryCta: 'Remove',
            ));
  }

  Map<String, List<Sighting>> get groupedSightings =>
      widget.sightings.groupBy((sighting) => sighting.toJson());

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(widget.speciesName),
      childrenPadding: const EdgeInsets.symmetric(horizontal: 15),
      expandedAlignment: Alignment.centerLeft,
      children: List.from(groupedSightings.entries.mapIndexed(
        (index, entry) => Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
              border: Border(
                  top: index == 0
                      ? BorderSide.none
                      : BorderSide(
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant))),
          child: SpeciesSightingsList(
            sightings: entry.value,
            key: Key('${entry.key}_sighting_list_${index.toString()}'),
            onIncrement: () =>
                onIncrement(Sighting.fromMap(jsonDecode(entry.key))),
            onDecrement: () => onDecrement(entry.key, entry.value.length),
            json: entry.key,
          ),
        ),
      )),
    );
  }
}
