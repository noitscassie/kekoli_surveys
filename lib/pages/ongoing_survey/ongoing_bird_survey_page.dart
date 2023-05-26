import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/constants/csv_export_types.dart';
import 'package:kekoldi_surveys/constants/survey_state.dart';
import 'package:kekoldi_surveys/models/bird_survey.dart';
import 'package:kekoldi_surveys/models/bird_survey_segment.dart';
import 'package:kekoldi_surveys/pages/add_weather/add_weather_page.dart';
import 'package:kekoldi_surveys/pages/export_survey/export_bird_survey_page.dart';
import 'package:kekoldi_surveys/pages/home/home_page.dart';
import 'package:kekoldi_surveys/pages/ongoing_bird_segment/ongoing_bird_segment_page.dart';
import 'package:kekoldi_surveys/pages/ongoing_survey/confirm_start_bird_segment_modal.dart';
import 'package:kekoldi_surveys/pages/select_export_type/select_export_type_page.dart';
import 'package:kekoldi_surveys/pages/view_bird_segment/view_bird_segment_page.dart';
import 'package:kekoldi_surveys/utils/time_utils.dart';
import 'package:kekoldi_surveys/widgets/data_tile.dart';
import 'package:kekoldi_surveys/widgets/page_scaffold.dart';
import 'package:kekoldi_surveys/widgets/partly_bolded_text.dart';
import 'package:kekoldi_surveys/widgets/selectable_list_item.dart';

class OngoingBirdSurveyPage extends StatefulWidget {
  final BirdSurvey survey;

  const OngoingBirdSurveyPage({super.key, required this.survey});

  @override
  State<OngoingBirdSurveyPage> createState() => _OngoingBirdSurveyPageState();
}

class _OngoingBirdSurveyPageState extends State<OngoingBirdSurveyPage> {
  late BirdSurvey _statefulSurvey = widget.survey;

  String get participantsString => [
        ..._statefulSurvey.leaders.map((String leader) => '$leader (leader)'),
        '${_statefulSurvey.scribe} (scribe)',
        ..._statefulSurvey.participants
      ].join(', ');

  bool _segmentUnlocked(index) =>
      index == 0 ||
      _statefulSurvey.segments[index - 1].state == SurveyState.completed;

  Future<void> _onAddWeather(String weather) async {
    await _statefulSurvey.setWeather(weather);

    setState(() {
      _statefulSurvey = _statefulSurvey;
    });

    if (context.mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => const HomePage(
            initialTabIndex: 1,
          ),
        ),
      );
    }
  }

  void _navigateToAddWeatherPage() =>
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) =>
              AddWeatherPage(onAddWeather: _onAddWeather)));

  void _navigateToViewSegmentPage(BirdSurveySegment segment) =>
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => ViewBirdSegmentPage(
            survey: _statefulSurvey,
            segment: segment,
          ),
        ),
      );

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
            '${_statefulSurvey.type.segmentName} ${segment.name} cannot be started until the previous ${_statefulSurvey.type.segmentName.toLowerCase()} has been completed.'),
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

    if (_statefulSurvey.weather == null) {
      return 'Add Weather';
    }

    return 'Export Data';
  }

  IconData get _fabIcon {
    if (_inProgressSegment != null) {
      return Icons.arrow_right_alt;
    }

    if (_nextSegment != null) {
      return Icons.arrow_right_alt;
    }

    if (_statefulSurvey.weather == null) {
      return Icons.sunny;
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

    if (_statefulSurvey.weather == null) {
      return () => _navigateToAddWeatherPage();
    }

    return () {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => SelectExportTypePage(
            onContinue: (ExportType exportType) => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => ExportBirdSurveyPage(
                  survey: widget.survey,
                  exportType: exportType,
                ),
              ),
            ),
          ),
        ),
      );
    };
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title:
          '${_statefulSurvey.type.title} ${_statefulSurvey.trail}${_statefulSurvey.startAt == null ? '' : ', ${DateFormats.ddmmyyyy(_statefulSurvey.startAt!)}'}',
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DataTile(
                  data: _statefulSurvey.totalObservations.toString(),
                  label: 'Total Observations',
                ),
                DataTile(
                  data: _statefulSurvey.uniqueSpecies.toString(),
                  label: 'Unique Species',
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              participantsString,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontStyle: FontStyle.italic),
            ),
          ),
          if (_statefulSurvey.weather != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
              child: PartlyBoldedText(
                  style: Theme.of(context).textTheme.bodyMedium,
                  textParts: [
                    RawText('Weather was '),
                    RawText(_statefulSurvey.weather!.toLowerCase(), bold: true),
                  ]),
            ),
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
