import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/constants/csv_export_types.dart';
import 'package:kekoldi_surveys/models/biodiversity_survey.dart';
import 'package:kekoldi_surveys/models/sighting.dart';
import 'package:kekoldi_surveys/pages/export_survey/export_biodiversity_survey_page.dart';
import 'package:kekoldi_surveys/pages/select_export_type/select_export_type_page.dart';
import 'package:kekoldi_surveys/pages/view_survey/hero_quantity.dart';
import 'package:kekoldi_surveys/utils/time_utils.dart';
import 'package:kekoldi_surveys/widgets/expandable_list/expandable_list_item.dart';
import 'package:kekoldi_surveys/widgets/fading_list_view.dart';
import 'package:kekoldi_surveys/widgets/page_scaffold.dart';
import 'package:kekoldi_surveys/widgets/partly_bolded_text.dart';
import 'package:kekoldi_surveys/widgets/shared/biodiversity_survey_stats.dart';

class ViewSurveyPage extends StatefulWidget {
  final BiodiversitySurvey survey;
  const ViewSurveyPage({super.key, required this.survey});

  @override
  State<ViewSurveyPage> createState() => _ViewSurveyPageState();
}

class _ViewSurveyPageState extends State<ViewSurveyPage> {
  bool _groupSightings = false;

  String get _participantsString => [
        ...widget.survey.leaders.map((String leader) => '$leader (leader)'),
        '${widget.survey.scribe} (scribe)',
        ...widget.survey.participants
      ].join(', ');

  void _onFabPress() => Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) =>
          SelectExportTypePage(onContinue: _navigateToExportSurveyPage)));

  void _navigateToExportSurveyPage(ExportType exportType) =>
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => ExportBiodiversitySurveyPage(
                survey: widget.survey,
                exportType: exportType,
              )));

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title:
          '${widget.survey.trail} Survey ${DateFormats.ddmmyyyy(widget.survey.startAt!)}',
      fabLabel: const Row(
        children: [
          Text('Export Data'),
          Icon(Icons.download),
        ],
      ),
      onFabPress: _onFabPress,
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BiodiversitySurveyStats(survey: widget.survey),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _participantsString,
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
              child: FadingListView(
                children: _groupSightings
                    ? List.from(widget.survey.orderedSightings
                        .groupBy((Sighting sighting) => sighting.species)
                        .entries
                        .map((entry) => ExpandableListItem(
                              title: entry.key,
                              children: entry.value
                                  .groupBy((Sighting sighting) =>
                                      sighting.attributesString)
                                  .entries
                                  .map((entry) => ExpandableListItemChild(
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
