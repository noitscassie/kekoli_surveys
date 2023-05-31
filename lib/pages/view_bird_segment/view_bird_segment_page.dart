import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/models/bird_survey.dart';
import 'package:kekoldi_surveys/models/bird_survey_segment.dart';
import 'package:kekoldi_surveys/widgets/page_scaffold.dart';
import 'package:kekoldi_surveys/widgets/shared/sighting_lists/sightings_list.dart';
import 'package:kekoldi_surveys/widgets/shared/sighting_lists/sightings_stats.dart';

class ViewBirdSegmentPage extends StatelessWidget {
  final BirdSurvey survey;
  final BirdSurveySegment segment;

  const ViewBirdSegmentPage({
    super.key,
    required this.survey,
    required this.segment,
  });

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: '${survey.type.segmentName} ${segment.name} Observations',
      child: SightingsList.fixed(
        sightings: segment.sightings,
        header: SightingsStats(
          sightings: segment.sightings,
        ),
      ),
    );
  }
}
