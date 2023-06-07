import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/models/bird_survey.dart';
import 'package:kekoldi_surveys/models/bird_survey_segment.dart';
import 'package:kekoldi_surveys/widgets/page_scaffold.dart';

class UnstartedBirdSegmentPage extends StatelessWidget {
  final BirdSurvey survey;
  final BirdSurveySegment segment;

  const UnstartedBirdSegmentPage({
    super.key,
    required this.survey,
    required this.segment,
  });

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: '${survey.type.title} ${segment.name}',
      child: const Text('Segment not yet started.'),
    );
  }
}
