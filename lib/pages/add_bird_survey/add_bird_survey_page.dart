import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/constants/bird_survey_trails.dart';
import 'package:kekoldi_surveys/constants/default_bird_survey_fields.dart';
import 'package:kekoldi_surveys/models/bird_survey.dart';
import 'package:kekoldi_surveys/models/bird_survey_segment.dart';
import 'package:kekoldi_surveys/models/input_field_config.dart';
import 'package:kekoldi_surveys/pages/home/home_page.dart';
import 'package:kekoldi_surveys/widgets/page_scaffold.dart';

class AddBirdSurveyPage extends StatefulWidget {
  const AddBirdSurveyPage({super.key});

  @override
  State<AddBirdSurveyPage> createState() => _AddBirdSurveyPageState();
}

class _AddBirdSurveyPageState extends State<AddBirdSurveyPage> {
  late Map<String, dynamic> attributes = {
    for (var config in _fields) config.label: config.defaultValue
  };

  void onAttributeChange(String key, String value) => setState(() {
        attributes[key] = value;
      });

  String get trail => attributes[trailField];
  String get surveyType => attributes[surveyTypeField];
  List<String?> get leaders => attributes[leadersField];
  String get scribe => attributes[scribeField];
  List<String?> get participants => attributes[participantsField];
  List<BirdSurveySegment> get segments => (defaultBirdSurveyTrails
              .firstOrNullWhere((loadedTrail) => loadedTrail.name == trail)
              ?.segments ??
          [])
      .map((String segment) => BirdSurveySegment(name: segment))
      .toList();

  List<String> get formattedLeaders =>
      List.from(leaders.whereNotNull().map((leader) => leader.trim()));
  List<String> get formattedParticipants => List.from(participants
      .whereNotNull()
      .where((participant) => participant.isNotEmpty)
      .map((participant) => participant.trim()));

  final ScrollController _controller = ScrollController();

  void _scrollToBottom() => _controller.animateTo(
        _controller.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.fastOutSlowIn,
      );

  bool get valid =>
      trail.isNotEmpty &&
      surveyType.isNotEmpty &&
      leaders.whereNotNull().any((leader) => leader.isNotEmpty) &&
      scribe.isNotEmpty &&
      participants.whereNotNull().any((participant) => participant.isNotEmpty);

  List<InputFieldConfig> get _fields => defaultBirdSurveyFields;

  void _onFieldChange(int index, String key, dynamic value) {
    setState(() {
      attributes[key] = value;
    });

    if (index + 1 == _fields.length) {
      _scrollToBottom();
    }
  }

  Future<void> _onFabPress() async {
    await BirdSurvey.create(
      trail: trail,
      leaders: formattedLeaders,
      scribe: scribe,
      participants: formattedParticipants,
      type: BirdSurveyType.byTitle(surveyType),
      segments: segments,
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

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: 'Add New Survey',
      fabLabel: const Row(
        children: [
          Text('Add Survey'),
          Icon(Icons.add),
        ],
      ),
      isFabValid: valid,
      onFabPress: _onFabPress,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 100),
        child: ListView(
          controller: _controller,
          children: [
            ..._fields.mapIndexed(
                (int index, InputFieldConfig field) => field.inputField(
                      value: attributes[field.label],
                      onChange: (dynamic value) =>
                          _onFieldChange(index, field.label, value),
                    )),
          ],
        ),
      ),
    );
  }
}
