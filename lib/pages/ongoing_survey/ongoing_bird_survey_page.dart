import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/constants/survey_state.dart';
import 'package:kekoldi_surveys/models/bird_survey.dart';
import 'package:kekoldi_surveys/models/bird_survey_segment.dart';
import 'package:kekoldi_surveys/pages/ongoing_bird_segment/ongoing_bird_segment_page.dart';
import 'package:kekoldi_surveys/pages/ongoing_survey/confirm_start_bird_segment_modal.dart';
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
  late final BirdSurvey _statefulSurvey = widget.survey;

  bool _segmentUnlocked(index) =>
      index == 0 ||
      _statefulSurvey.segments[index - 1].state == SurveyState.completed;

  void _navigateToViewSegmentPage(BirdSurveySegment segment) => null;
  // Navigator.of(context).push(
  //   MaterialPageRoute(
  //     builder: (BuildContext context) => OngoingBirdSegmentPage(
  //       survey: statefulSurvey,
  //       segment: segment,
  //     ),
  //   ),
  // );

  void _navigateToOngoingSegmentPage(BirdSurveySegment segment) =>
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => OngoingBirdSegmentPage(
            survey: _statefulSurvey,
            segment: segment,
          ),
        ),
      );

  void _startSegment(BirdSurveySegment segment) => showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => ConfirmStartBirdSegmentModal(
          survey: _statefulSurvey,
          segment: segment,
        ),
      );

  void _onSegmentTap(BirdSurveySegment segment, int index) {
    if (_segmentUnlocked(index)) {
      switch (segment.state) {
        case SurveyState.unstarted:
          return _startSegment(segment);
        case SurveyState.inProgress:
          return _navigateToOngoingSegmentPage(segment);
        case SurveyState.completed:
          _navigateToViewSegmentPage(segment);
      }
    } else {
      final snackBar = SnackBar(
        duration: const Duration(seconds: 2),
        content: Text(
            '${_statefulSurvey.type.title} ${segment.name} cannot be started until the previous ${_statefulSurvey.type.title.toLowerCase()} has been completed.'),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  IconData _segmentIcon(BirdSurveySegment segment, int index) {
    if (segment.state == SurveyState.completed) {
      return Icons.check;
    }

    return _segmentUnlocked(index) ? Icons.arrow_right_alt : Icons.lock;
  }

  BirdSurveySegment? get _nextSegment => _statefulSurvey.segments
      .firstWhereOrNull((segment) => segment.state == SurveyState.unstarted);

  BirdSurveySegment? get _inProgressSegment => _statefulSurvey.segments
      .firstWhereOrNull((segment) => segment.state == SurveyState.inProgress);

  String get _fabText {
    if (_inProgressSegment != null) {
      return 'View Ongoing ${_statefulSurvey.type.segmentName}';
    }

    if (_nextSegment != null) {
      return 'Start Next ${_statefulSurvey.type.segmentName}';
    }

    return 'Export Data'; // TODO: data export
  }

  IconData get _fabIcon {
    if (_inProgressSegment != null) {
      return Icons.arrow_right_alt;
    }

    if (_nextSegment != null) {
      return Icons.arrow_right_alt;
    }

    return Icons.download;
  }

  VoidCallback get _onFabPress {
    if (_inProgressSegment != null) {
      return () => _navigateToOngoingSegmentPage(_inProgressSegment!);
    }

    if (_nextSegment != null) {
      return () => _startSegment(_nextSegment!);
    }

    return () {}; // TODO: data export
  }

  @override
  Widget build(BuildContext context) {
    print(_statefulSurvey.segments);
    return PageScaffold(
      title:
          '${_statefulSurvey.type.title} ${_statefulSurvey.trail}, ${DateFormats.ddmmyyyy(DateTime.now())}',
      fabLabel: Row(
        children: [
          Text(_fabText),
          Icon(_fabIcon),
        ],
      ),
      onFabPress: _onFabPress,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 100),
        child: ListView(children: [
          ..._statefulSurvey.segments
              .mapIndexed((index, segment) => SelectableListItem(
                    text:
                        '${_statefulSurvey.type.title} ${segment.name} - ${segment.state.prettyName}',
                    onSelect: (String _) => _onSegmentTap(segment, index),
                    icon: _segmentIcon(segment, index),
                  ))
        ]),
      ),
    );
  }
}
