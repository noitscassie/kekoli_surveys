import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/constants/survey_state.dart';
import 'package:kekoldi_surveys/models/bird_survey.dart';
import 'package:kekoldi_surveys/models/bird_survey_segment.dart';
import 'package:kekoldi_surveys/pages/ongoing_bird_segment/ongoing_bird_segment_page.dart';
import 'package:kekoldi_surveys/utils/time_utils.dart';
import 'package:kekoldi_surveys/widgets/page_scaffold.dart';
import 'package:kekoldi_surveys/widgets/selectable_list_item.dart';

class OngoingBirdSurveyPage extends StatefulWidget {
  final BirdSurvey survey;

  const OngoingBirdSurveyPage({super.key, required this.survey});

  @override
  State<OngoingBirdSurveyPage> createState() => _OngoingBirdSurveyPageState();
}

class _OngoingBirdSurveyPageState extends State<OngoingBirdSurveyPage> {
  late BirdSurvey statefulSurvey = widget.survey;

  void _onCompleteSurvey() {}

  bool _segmentUnlocked(index) =>
      index == 0 ||
      statefulSurvey.segments[index - 1].state == SurveyState.completed;

  void _onSegmentTap(BirdSurveySegment segment, int index) {
    if (_segmentUnlocked(index)) {
      segment.start(statefulSurvey);

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => OngoingBirdSegmentPage(
            survey: statefulSurvey,
            segment: segment,
          ),
        ),
      );
    } else {
      final snackBar = SnackBar(
        duration: const Duration(seconds: 2),
        content: Text(
            '${statefulSurvey.type.prettyName} ${segment.name} cannot be started until the previous ${statefulSurvey.type.prettyName.toLowerCase()} has been completed.'),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title:
          '${statefulSurvey.type.prettyName} ${statefulSurvey.trail}, ${DateFormats.ddmmyyyy(DateTime.now())}',
      fabLabel: const Row(
        children: [
          Text('Add New Bird'),
          Icon(Icons.add),
        ],
      ),
      onFabPress: () {},
      actions: [
        IconButton(
          onPressed: _onCompleteSurvey,
          icon: const Icon(Icons.check),
        )
      ],
      child: Padding(
        padding: const EdgeInsets.only(bottom: 100),
        child: ListView(children: [
          ...statefulSurvey.segments
              .mapIndexed((index, segment) => SelectableListItem(
                    text:
                        '${statefulSurvey.type.prettyName} ${segment.name} - ${segment.state.prettyName}',
                    onSelect: (String _) => _onSegmentTap(segment, index),
                    icon: _segmentUnlocked(index)
                        ? Icons.arrow_right_alt
                        : Icons.lock,
                  ))
        ]),
      ),
    );
  }
}
