import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/constants/survey_state.dart';
import 'package:kekoldi_surveys/models/bird_survey.dart';
import 'package:kekoldi_surveys/models/bird_survey_segment.dart';
import 'package:kekoldi_surveys/pages/bird_segment/ongoing_bird_segment_page.dart';
import 'package:kekoldi_surveys/pages/bird_segment/unstarted_bird_segment_page.dart';
import 'package:kekoldi_surveys/pages/bird_segment/view_bird_segment_page.dart';

class BirdSegmentPage extends StatefulWidget {
  static const name = 'BirdSegmentPage';
  final BirdSurvey survey;
  final BirdSurveySegment segment;

  const BirdSegmentPage({
    super.key,
    required this.survey,
    required this.segment,
  });

  @override
  State<BirdSegmentPage> createState() => _BirdSegmentPageState();
}

class _BirdSegmentPageState extends State<BirdSegmentPage> {
  @override
  Widget build(BuildContext context) {
    switch (widget.segment.state) {
      case SurveyState.unstarted:
        return UnstartedBirdSegmentPage(
          survey: widget.survey,
          segment: widget.segment,
        );
      case SurveyState.inProgress:
        return OngoingBirdSegmentPage(
          survey: widget.survey,
          segment: widget.segment,
        );
      case SurveyState.completed:
        return ViewBirdSegmentPage(
          survey: widget.survey,
          segment: widget.segment,
        );
    }
  }
}
