import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/models/biodiversity_survey.dart';
import 'package:kekoldi_surveys/pages/add_survey/leaders_input_field.dart';
import 'package:kekoldi_surveys/pages/add_survey/participants_input_field.dart';
import 'package:kekoldi_surveys/pages/add_survey/scribe_input_field.dart';
import 'package:kekoldi_surveys/pages/add_survey/trail_input_field.dart';
import 'package:kekoldi_surveys/pages/home/home_page.dart';
import 'package:kekoldi_surveys/widgets/page_scaffold.dart';

class EditSurveyPage extends StatefulWidget {
  final BiodiversitySurvey survey;

  const EditSurveyPage({super.key, required this.survey});

  @override
  State<EditSurveyPage> createState() => _EditSurveyPageState();
}

class _EditSurveyPageState extends State<EditSurveyPage> {
  late String selectedTrail = widget.survey.trail;
  late List<String> leaders = widget.survey.leaders;
  late String scribe = widget.survey.scribe;
  late List<String?> participants = widget.survey.participants;

  List<String> get formattedLeaders =>
      List.from(leaders.map((leader) => leader.trim()));
  List<String> get formattedParticipants => List.from(participants
      .where((participant) => participant != null && participant.isNotEmpty)
      .map((participant) => participant!.trim()));

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

  Future<void> updateSurvey() async {
    await widget.survey.update(
        updatedTrail: selectedTrail,
        updatedLeaders: leaders,
        updatedScribe: scribe,
        updatedParticipants: formattedParticipants);

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
      title: 'Edit Survey',
      fabLabel: const Row(
        children: [Text('Save Changes'), Icon(Icons.save_alt)],
      ),
      isFabValid: valid,
      onFabPress: updateSurvey,
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
