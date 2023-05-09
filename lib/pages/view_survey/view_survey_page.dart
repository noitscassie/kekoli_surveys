import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/models/sighting.dart';
import 'package:kekoldi_surveys/models/survey.dart';
import 'package:kekoldi_surveys/pages/export_survey/export_survey_page.dart';
import 'package:kekoldi_surveys/pages/view_survey/sighting_list_item.dart';
import 'package:kekoldi_surveys/utils/time_utils.dart';
import 'package:kekoldi_surveys/widgets/data_tile.dart';
import 'package:kekoldi_surveys/widgets/page_scaffold.dart';
import 'package:kekoldi_surveys/widgets/partly_bolded_text.dart';

class ViewSurveyPage extends StatelessWidget {
  final Survey survey;
  const ViewSurveyPage({super.key, required this.survey});

  String get participantsString => [
        ...survey.leaders.map((String leader) => '$leader (leader)'),
        '${survey.scribe} (scribe)',
        ...survey.participants
      ].join(', ');

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: '${survey.trail} Survey, ${DateFormats.ddmmyyyy(survey.startAt!)}',
      fabLabel: Row(
        children: const [Text('Export Data'), Icon(Icons.download)],
      ),
      onFabPress: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => ExportSurveyPage(survey: survey))),
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DataTile(
                    data: survey.sightings.length.toString(),
                    label: 'Total Observations'),
                DataTile(
                    data: survey.sightings
                        .map((Sighting sighting) => sighting.species)
                        .distinct()
                        .length
                        .toString(),
                    label: 'Unique Species'),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  DataTile(
                      data: TimeFormats.timeHoursAndMinutes(survey.startAt!),
                      label: 'Start Time'),
                  DataTile(
                      data: TimeFormats.timeHoursAndMinutes(survey.endAt!),
                      label: 'End Time'),
                  DataTile(
                      data: TimeFormats.hmFromMinutes(survey.lengthInMinutes()),
                      label: 'Duration'),
                ],
              ),
            ),
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
                  RawText(survey.weather!.toLowerCase(), bold: true),
                ]),
            Expanded(
              child: ListView(
                children: List.from(survey.sightings
                    .sortedBy((Sighting sighting) => sighting.species)
                    .map((Sighting sighting) =>
                        SightingListItem(sighting: sighting))),
              ),
            )
          ],
        ),
      ),
    );
  }
}
