import 'dart:convert';

import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/models/sighting.dart';
import 'package:kekoldi_surveys/models/survey.dart';
import 'package:kekoldi_surveys/pages/add_sighting_details/add_sighting_details_page.dart';
import 'package:kekoldi_surveys/pages/ongoing_survey/modify_tally_modal.dart';
import 'package:kekoldi_surveys/pages/ongoing_survey/species_sightings_list.dart';
import 'package:kekoldi_surveys/widgets/selectable_list_item.dart';

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
            survey: widget.survey,
          ));

  void onDecrement(List<Sighting> sightings) {
    final sighting = sightings.last;
    final title =
        'Remove ${sighting.species}${sightings.length == 1 ? '' : ' tally'}?';

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => ModifyTallyModal(
              sighting: sighting,
              onConfirm: () {
                widget.survey.removeSighting(sighting);
                widget.onChangeSurvey(widget.survey);

                Navigator.of(context).pop();
              },
              title: title,
              primaryCta: 'Remove',
              survey: widget.survey,
            ));
  }

  void navigateToChooseSpeciesPage() =>
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => AddSightingDetailsPage(
                survey: widget.survey,
                species: widget.speciesName,
              )));

  Map<String, List<Sighting>> get groupedSightings => widget.sightings
      .groupBy((sighting) => jsonEncode(sighting.displayAttributes));

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        widget.speciesName,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 18),
      ),
      childrenPadding: const EdgeInsets.symmetric(horizontal: 15),
      expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ...groupedSightings.entries.mapIndexed(
          (index, entry) => Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
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
              onIncrement: () => onIncrement(entry.value.last.duplicate()),
              onDecrement: () => onDecrement(entry.value),
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
