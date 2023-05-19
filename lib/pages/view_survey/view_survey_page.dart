import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/models/sighting.dart';
import 'package:kekoldi_surveys/models/survey.dart';
import 'package:kekoldi_surveys/pages/select_export_type/select_export_type_page.dart';
import 'package:kekoldi_surveys/pages/view_survey/hero_quantity.dart';
import 'package:kekoldi_surveys/utils/time_utils.dart';
import 'package:kekoldi_surveys/widgets/expandable_list/expandable_list_item.dart';
import 'package:kekoldi_surveys/widgets/page_scaffold.dart';
import 'package:kekoldi_surveys/widgets/partly_bolded_text.dart';
import 'package:kekoldi_surveys/widgets/shared/survey_stats.dart';

class ViewSurveyPage extends StatefulWidget {
  final Survey survey;
  const ViewSurveyPage({super.key, required this.survey});

  @override
  State<ViewSurveyPage> createState() => _ViewSurveyPageState();
}

class _ViewSurveyPageState extends State<ViewSurveyPage> {
  bool _groupSightings = false;

  String get participantsString => [
        ...widget.survey.leaders.map((String leader) => '$leader (leader)'),
        '${widget.survey.scribe} (scribe)',
        ...widget.survey.participants
      ].join(', ');

  void onFabPress(BuildContext context) =>
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) =>
              SelectExportTypePage(survey: widget.survey)));

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title:
          '${widget.survey.trail} Survey ${DateFormats.ddmmyyyy(widget.survey.startAt!)}',
      fabLabel: const Row(
        children: [Text('Export Data'), Icon(Icons.download)],
      ),
      onFabPress: () => onFabPress(context),
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SurveyStats(survey: widget.survey),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        participantsString,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontStyle: FontStyle.italic),
                      ),
                      PartlyBoldedText(
                          style: Theme.of(context).textTheme.bodyMedium,
                          textParts: [
                            RawText('Weather was '),
                            RawText(widget.survey.weather!.toLowerCase(),
                                bold: true),
                          ]),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Group Sightings?',
                      textAlign: TextAlign.end,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    Switch(
                      value: _groupSightings,
                      onChanged: (bool newValue) {
                        setState(() {
                          _groupSightings = newValue;
                        });
                      },
                    ),
                  ],
                )
              ],
            ),
            Expanded(
              child: ListView(
                children: _groupSightings
                    ? List.from(widget.survey.sightings
                        .groupBy((Sighting sighting) => sighting.species)
                        .entries
                        .map((entry) => ExpandableListItem(
                              title: entry.key,
                              children: entry.value
                                  .groupBy((Sighting sighting) =>
                                      sighting.attributesString)
                                  .entries
                                  .map((entry) => ExandableListItemChild(
                                      title: entry.key,
                                      trailing: HeroQuantity(
                                          quantity:
                                              entry.value.length.toString())))
                                  .toList(),
                            )))
                    : List.from(widget.survey.orderedSightings
                        .map((Sighting sighting) => ExpandableListItem(
                              title: sighting.species,
                              subtitle: sighting.attributesString,
                              children: const [],
                            ))),
              ),
            )
          ],
        ),
      ),
    );
  }
}
