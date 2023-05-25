import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/models/bird_survey.dart';
import 'package:kekoldi_surveys/models/bird_survey_segment.dart';
import 'package:kekoldi_surveys/pages/ongoing_bird_segment/ongoing_bird_segment_page.dart';
import 'package:kekoldi_surveys/widgets/dialogs/dialog_scaffold.dart';
import 'package:kekoldi_surveys/widgets/dialogs/primary_cta.dart';

class ConfirmStartBirdSegmentModal extends StatelessWidget {
  final BirdSurvey survey;
  final BirdSurveySegment segment;

  const ConfirmStartBirdSegmentModal({
    super.key,
    required this.survey,
    required this.segment,
  });

  Future<void> _startSegment(BuildContext context) async {
    segment.start(survey);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => OngoingBirdSegmentPage(
          survey: survey,
          segment: segment,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DialogScaffold(
        title: 'Start Next ${survey.type.segmentName}?',
        primaryCta: PrimaryCta(
          text: 'Start ${survey.type.segmentName}',
          onTap: () => _startSegment(context),
        ),
        children: [
          Text(
              'Do you want to start ${survey.type.segmentName} ${segment.name}?')
        ]);
  }
}
