import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/constants/default_bird_survey_fields.dart';
import 'package:kekoldi_surveys/db/db.dart';
import 'package:kekoldi_surveys/models/bird_survey.dart';
import 'package:kekoldi_surveys/models/bird_survey_segment.dart';
import 'package:kekoldi_surveys/models/bird_survey_trail.dart';
import 'package:kekoldi_surveys/models/input_field_config.dart';
import 'package:kekoldi_surveys/models/survey_configuration.dart';
import 'package:kekoldi_surveys/pages/home/home_page.dart';
import 'package:kekoldi_surveys/widgets/page_scaffold.dart';
import 'package:kekoldi_surveys/widgets/shared/bird_survey_form.dart';

class AddBirdSurveyPage extends StatefulWidget {
  const AddBirdSurveyPage({super.key});

  @override
  State<AddBirdSurveyPage> createState() => _AddBirdSurveyPageState();
}

class _AddBirdSurveyPageState extends State<AddBirdSurveyPage> {
  final _db = Db();

  late Map<String, dynamic> attributes = {
    for (var config in _fields) config.label: config.defaultValue
  };

  void onAttributeChange(String key, dynamic value) => setState(() {
        attributes[key] = value;
      });

  String get trail => attributes[trailField];
  String get surveyType => attributes[surveyTypeField];
  List<String?> get leaders => attributes[leadersField];
  String get scribe => attributes[scribeField];
  List<String?> get participants => attributes[participantsField];
  String get startTemperature => attributes[startTemperatureField];

  List<BirdSurveySegment> get segments => (_trails
              .firstOrNullWhere((loadedTrail) => loadedTrail.name == trail)
              ?.segments ??
          [])
      .map((String segment) => BirdSurveySegment(name: segment))
      .toList();

  List<BirdSurveyTrail> _trails = [];

  List<String> get formattedLeaders =>
      List.from(leaders.whereNotNull().map((leader) => leader.trim()));
  List<String> get formattedParticipants => List.from(participants
      .whereNotNull()
      .where((participant) => participant.isNotEmpty)
      .map((participant) => participant.trim()));

  bool get _valid =>
      trail.isNotEmpty &&
      surveyType.isNotEmpty &&
      leaders.whereNotNull().any((leader) => leader.isNotEmpty) &&
      scribe.isNotEmpty &&
      participants.whereNotNull().any((participant) => participant.isNotEmpty);

  List<InputFieldConfig> get _fields => defaultBirdSurveyFields(_trails);

  Future<void> _onFabPress() async {
    final configuration =
        BirdSurveyType.byTitle(surveyType) == BirdSurveyType.transect
            ? defaultBirdTransectSurveyConfiguration
            : defaultBirdPointCountSurveyConfiguration;

    await BirdSurvey.create(
      trail: trail,
      leaders: formattedLeaders,
      scribe: scribe,
      participants: formattedParticipants,
      type: BirdSurveyType.byTitle(surveyType),
      segments: segments,
      configuration: configuration,
      startTemperature: startTemperature,
    );

    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (BuildContext context) => const HomePage(
                    initialTabIndex: 1,
                  )),
          (route) => false);
    }
  }

  Future<void> _loadTrails() async {
    final trails = await _db.getBirdTrails();

    setState(() {
      _trails = trails;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadTrails();
  }

  @override
  Widget build(BuildContext context) {
    if (_trails.isEmpty) {
      return const PageScaffold(
        title: 'Add New Survey',
        child: CircularProgressIndicator(),
      );
    } else {
      return BirdSurveyForm(
        title: 'Add Survey',
        fields: _fields,
        fabLabel: const Row(
          children: [
            Text('Add Survey'),
            Icon(Icons.add),
          ],
        ),
        isFabValid: _valid,
        onFabPress: _onFabPress,
        attributes: attributes,
        onAttributeChange: onAttributeChange,
      );
    }
  }
}
