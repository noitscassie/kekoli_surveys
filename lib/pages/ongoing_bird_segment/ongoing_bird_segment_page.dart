import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/models/bird_survey.dart';
import 'package:kekoldi_surveys/models/bird_survey_segment.dart';
import 'package:kekoldi_surveys/widgets/page_scaffold.dart';

class OngoingBirdSegmentPage extends StatelessWidget {
  final BirdSurvey survey;
  final BirdSurveySegment segment;

  const OngoingBirdSegmentPage({
    super.key,
    required this.survey,
    required this.segment,
  });

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: '${survey.type.prettyName} ${segment.name}',
      child: Text('hello there'),
    );
  }
}
