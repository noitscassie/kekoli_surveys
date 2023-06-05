import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/models/bird_survey.dart';
import 'package:kekoldi_surveys/models/bird_survey_segment.dart';
import 'package:kekoldi_surveys/models/sighting.dart';
import 'package:kekoldi_surveys/pages/biodiversity_survey/ongoing_bird_survey_page.dart';
import 'package:kekoldi_surveys/pages/ongoing_bird_segment/ongoing_bird_segment_page.dart';
import 'package:kekoldi_surveys/widgets/dialogs/dialog_scaffold.dart';
import 'package:kekoldi_surveys/widgets/dialogs/primary_cta.dart';
import 'package:kekoldi_surveys/widgets/partly_bolded_text.dart';

class ConfirmBirdSightingDetailsDialog extends StatelessWidget {
  final BirdSurvey survey;
  final BirdSurveySegment segment;
  final Sighting sighting;

  const ConfirmBirdSightingDetailsDialog({
    super.key,
    required this.survey,
    required this.segment,
    required this.sighting,
  });

  void _addSighting(BuildContext context) {
    segment.addSighting(sighting);
    survey.updateSegment(segment);

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (BuildContext context) => OngoingBirdSegmentPage(
            survey: survey,
            segment: segment,
          ),
        ),
        (route) => route.settings.name == OngoingBirdSurveyPage.name);
  }

  @override
  Widget build(BuildContext context) {
    return DialogScaffold(
      title: sighting.species,
      primaryCta:
          PrimaryCta(text: 'Add Sighting', onTap: () => _addSighting(context)),
      children: [
        ...sighting
            .orderedData(survey.configuration.fields)
            .entries
            .filter((entry) => entry.value.isNotEmpty)
            .mapIndexed(
              (index, entry) => Padding(
                padding: const EdgeInsets.only(top: 8),
                child: PartlyBoldedText(
                  style: Theme.of(context).textTheme.bodyMedium,
                  textParts: [
                    RawText('${entry.key}: ', bold: true),
                    RawText(entry.value),
                  ],
                ),
              ),
            )
      ],
    );
  }
}
