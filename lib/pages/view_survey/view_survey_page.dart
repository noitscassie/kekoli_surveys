import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/models/sighting.dart';
import 'package:kekoldi_surveys/models/survey.dart';
import 'package:kekoldi_surveys/pages/view_survey/sighting_list_item.dart';
import 'package:kekoldi_surveys/utils/time_utils.dart';
import 'package:kekoldi_surveys/widgets/page_scaffold.dart';
import 'package:kekoldi_surveys/widgets/partly_bolded_text.dart';

class ViewSurveyPage extends StatelessWidget {
  final Survey survey;
  const ViewSurveyPage({super.key, required this.survey});

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: '${survey.trail} Survey, ${DateFormats.ddmmyyyy(survey.startAt!)}',
      fabLabel: Row(
        children: const [Text('Export Data'), Icon(Icons.download)],
      ),
      onFabPress: () {},
      isFabValid: false,
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PartlyBoldedText(
                style: Theme.of(context).textTheme.bodyMedium,
                textParts: [
                  RawText('Led by '),
                  RawText(survey.leaders.join(' and '), bold: true)
                ]),
            PartlyBoldedText(
              style: Theme.of(context).textTheme.bodyMedium,
              textParts: [
                RawText('Scribed by '),
                RawText(survey.scribe, bold: true)
              ],
            ),
            PartlyBoldedText(
                style: Theme.of(context).textTheme.bodyMedium,
                textParts: [
                  RawText('Participated in by '),
                  RawText(survey.participants.join(', '), bold: true),
                ]),
            PartlyBoldedText(
                style: Theme.of(context).textTheme.bodyMedium,
                textParts: [
                  RawText('Survey began at '),
                  RawText(TimeFormats.timeHoursAndMinutes(survey.startAt!),
                      bold: true),
                  RawText(' and ended at '),
                  RawText(TimeFormats.timeHoursAndMinutes(survey.endAt!),
                      bold: true),
                  RawText(', lasting for '),
                  RawText(
                      TimeFormats.hoursAndMinutesFromMinutes(
                          survey.lengthInMinutes()),
                      bold: true),
                ]),
            PartlyBoldedText(
                style: Theme.of(context).textTheme.bodyMedium,
                textParts: [
                  RawText('Weather was '),
                  RawText(survey.weather!.toLowerCase(), bold: true),
                ]),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: ListView(
                  // shrinkWrap: true,
                  children: List.from(survey.sightings
                      .sortedBy((Sighting sighting) => sighting.species)
                      .map((Sighting sighting) =>
                          SightingListItem(sighting: sighting))),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
