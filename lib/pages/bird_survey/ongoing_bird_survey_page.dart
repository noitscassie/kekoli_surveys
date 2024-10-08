import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/constants/csv_export_types.dart';
import 'package:kekoldi_surveys/constants/survey_state.dart';
import 'package:kekoldi_surveys/models/bird_survey.dart';
import 'package:kekoldi_surveys/models/bird_survey_segment.dart';
import 'package:kekoldi_surveys/pages/add_weather/add_weather_page.dart';
import 'package:kekoldi_surveys/pages/biodiversity_survey/confirm_start_bird_segment_modal.dart';
import 'package:kekoldi_surveys/pages/bird_segment/bird_segment_page.dart';
import 'package:kekoldi_surveys/pages/export_survey/export_bird_survey_page.dart';
import 'package:kekoldi_surveys/pages/select_export_type/select_export_type_page.dart';
import 'package:kekoldi_surveys/utils/time_utils.dart';
import 'package:kekoldi_surveys/widgets/data_tile.dart';
import 'package:kekoldi_surveys/widgets/page_scaffold.dart';
import 'package:kekoldi_surveys/widgets/partly_bolded_text.dart';
import 'package:kekoldi_surveys/widgets/selectable_list_item.dart';

enum OverflowMenuOption {
  editWeatherData(
    label: 'Edit Weather Data',
  );

  const OverflowMenuOption({
    required this.label,
  });

  final String label;
}

class OngoingBirdSurveyPage extends StatefulWidget {
  static const name = 'OngoingBirdSurveyPage';
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

  void _onAddWeather(
    String weather,
    String endTemperature,
    String rainfall,
  ) {
    _statefulSurvey.setWeather(
      newWeather: weather,
      newEndTemperature: endTemperature,
      newRainfall: rainfall,
    );

    setState(() {
      _statefulSurvey = _statefulSurvey;
    });

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => OngoingBirdSurveyPage(
            survey: _statefulSurvey,
          ),
        ),
      );
    }
  }

  void _navigateToAddWeatherPage() => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => AddWeatherPage(
            onAddWeather: _onAddWeather,
          ),
        ),
      );

  void _navigateToSegmentPage(BirdSurveySegment segment) =>
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => BirdSegmentPage(
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
          return _navigateToSegmentPage(segment);
        case SurveyState.completed:
          _navigateToSegmentPage(segment);
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
      return () => _navigateToSegmentPage(_inProgressSegment!);
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

  void _handleOverflowMenuOptionTap(OverflowMenuOption option) {
    switch (option) {
      case OverflowMenuOption.editWeatherData:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => AddWeatherPage(
              onAddWeather: _onAddWeather,
              description: _statefulSurvey.weather,
              endTemperature: _statefulSurvey.endTemperature,
              rainfall: _statefulSurvey.rainfall,
            ),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold.withScrollableChildren(
      title:
          '${_statefulSurvey.type.title} ${_statefulSurvey.trail}${_statefulSurvey.startAt == null ? '' : ', ${DateFormats.ddmmyyyy(_statefulSurvey.startAt!)}'}',
      actions: _statefulSurvey.state == SurveyState.completed
          ? [
              PopupMenuButton<OverflowMenuOption>(
                onSelected: _handleOverflowMenuOptionTap,
                itemBuilder: (BuildContext otherContext) =>
                    OverflowMenuOption.values
                        .map(
                          (OverflowMenuOption option) => PopupMenuItem(
                            value: option,
                            child: Text(option.label),
                          ),
                        )
                        .toList(),
              )
            ]
          : [],
      fabLabel: Row(
        children: [
          Text(_fabText),
          Icon(_fabIcon),
        ],
      ),
      onFabPress: _onFabPress,
      backButtonToHomeTab: 1,
      children: [
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
        if (_statefulSurvey.weather?.isNotEmpty == true)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
            child: PartlyBoldedText(
              style: Theme.of(context).textTheme.bodyMedium,
              textParts: [
                RawText('Weather: '),
                RawText(_statefulSurvey.weather!, bold: true),
              ],
            ),
          ),
        if (_statefulSurvey.startTemperature?.isNotEmpty == true)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: PartlyBoldedText(
              style: Theme.of(context).textTheme.bodyMedium,
              textParts: [
                RawText('Start temperature: '),
                RawText('${_statefulSurvey.startTemperature!}℃', bold: true),
              ],
            ),
          ),
        if (_statefulSurvey.endTemperature?.isNotEmpty == true)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: PartlyBoldedText(
              style: Theme.of(context).textTheme.bodyMedium,
              textParts: [
                RawText('End temperature: '),
                RawText('${_statefulSurvey.endTemperature!}℃', bold: true),
              ],
            ),
          ),
        if (_statefulSurvey.rainfall?.isNotEmpty == true)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: PartlyBoldedText(
              style: Theme.of(context).textTheme.bodyMedium,
              textParts: [
                RawText('Rainfall: '),
                RawText('${_statefulSurvey.rainfall!}cm', bold: true),
              ],
            ),
          ),
        ..._statefulSurvey.segments.mapIndexed(
          (index, segment) => SelectableListItem(
            title:
                '${_statefulSurvey.type.title} ${segment.name} - ${segment.state.prettyName}',
            subtitle: segment.state == SurveyState.completed
                ? '${segment.totalObservations} observations, ${segment.uniqueSpecies} unique species'
                : null,
            onSelect: (String _) => _onSegmentTap(segment, index),
            icon: _segmentIcon(segment, index),
          ),
        )
      ],
    );
  }
}
