import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/models/bird_survey.dart';
import 'package:kekoldi_surveys/models/bird_survey_segment.dart';
import 'package:kekoldi_surveys/pages/bird_survey/ongoing_bird_survey_page.dart';
import 'package:kekoldi_surveys/widgets/dialogs/dialog_scaffold.dart';
import 'package:kekoldi_surveys/widgets/dialogs/primary_cta.dart';

class ConfirmSegmentCompleteModal extends StatelessWidget {
  final BirdSurvey survey;
  final BirdSurveySegment segment;

  const ConfirmSegmentCompleteModal({
    super.key,
    required this.survey,
    required this.segment,
  });

  Future<void> _completeSegment(BuildContext context) async {
    segment.end(survey);
    await survey.updateSegment(segment);

    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (BuildContext context) =>
              OngoingBirdSurveyPage(survey: survey),
        ),
        (route) => route.settings.name == '/',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DialogScaffold(
        title: 'Complete ${survey.type.segmentName} ${segment.name}?',
        primaryCta: PrimaryCta(
            text: 'Complete ${survey.type.segmentName}',
            onTap: () => _completeSegment(context)),
        children: [
          Text(
              'Do you want to finish Bird ${survey.type.segmentName} ${segment.name}?')
        ]);
  }
}
