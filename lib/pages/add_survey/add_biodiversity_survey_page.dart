import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/constants/biodiversity_trails.dart';
import 'package:kekoldi_surveys/db/db.dart';
import 'package:kekoldi_surveys/models/biodiversity_survey.dart';
import 'package:kekoldi_surveys/pages/add_survey/leaders_input_field.dart';
import 'package:kekoldi_surveys/pages/add_survey/participants_input_field.dart';
import 'package:kekoldi_surveys/pages/add_survey/scribe_input_field.dart';
import 'package:kekoldi_surveys/pages/add_survey/trail_input_field.dart';
import 'package:kekoldi_surveys/pages/home/home_page.dart';
import 'package:kekoldi_surveys/widgets/page_scaffold.dart';

class AddBiodiversitySurveyPage extends StatefulWidget {
  final String? initialTrail;

  const AddBiodiversitySurveyPage({super.key, this.initialTrail});

  @override
  State<AddBiodiversitySurveyPage> createState() =>
      _AddBiodiversitySurveyPageState();
}

class _AddBiodiversitySurveyPageState extends State<AddBiodiversitySurveyPage> {
  late String selectedTrail =
      widget.initialTrail ?? defaultBiodiversityTrails.first;

  List<String> leaders = [
    '',
  ];
  String scribe = '';
  List<String?> participants = [''];

  List<String> get formattedLeaders =>
      List.from(leaders.map((leader) => leader.trim()));
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
      selectedTrail.isNotEmpty &&
      leaders.any((leader) => leader.isNotEmpty) &&
      scribe.isNotEmpty &&
      participants.whereNotNull().any((participant) => participant.isNotEmpty);

  final Db _db = Db();

  Future<void> createSurvey() async {
    final configuration = await _db.getSurveyConfiguration();

    await BiodiversitySurvey.create(
      trail: selectedTrail,
      leaders: leaders,
      scribe: scribe,
      participants: formattedParticipants,
      configuration: configuration,
    );

    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => const HomePage()),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: 'Add New Survey',
      fabLabel: const Row(
        children: [Text('Add Survey'), Icon(Icons.add)],
      ),
      isFabValid: valid,
      onFabPress: createSurvey,
      child: ListView(
        controller: _controller,
        children: [
          TrailInputField(
              onChange: (value) {
                setState(() {
                  selectedTrail = value;
                });
              },
              initialTrail: selectedTrail),
          LeadersInputField(
            onChange: (value) {
              setState(() {
                leaders = value;
              });
            },
            value: leaders,
          ),
          ScribeInputField(
            onChange: (value) {
              setState(() {
                scribe = value;
              });
            },
            value: scribe,
          ),
          ParticipantsInputField(
            onChange: (value) {
              setState(() {
                participants = value;
              });
              _scrollToBottom();
            },
            value: participants,
            onAddNewParticipant: _scrollToBottom,
          ),
        ],
      ),
    );
  }
}
