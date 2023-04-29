import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/models/survey.dart';
import 'package:kekoldi_surveys/pages/add_survey/leaders_input_field.dart';
import 'package:kekoldi_surveys/pages/add_survey/participants_input_field.dart';
import 'package:kekoldi_surveys/pages/add_survey/scribe_input_field.dart';
import 'package:kekoldi_surveys/pages/add_survey/trail_input_field.dart';
import 'package:kekoldi_surveys/widgets/page_scaffold.dart';

class AddSurveyPage extends StatefulWidget {
  final Function(Survey survey) onCreateSurvey;
  const AddSurveyPage({super.key, required this.onCreateSurvey});

  @override
  State<AddSurveyPage> createState() => _AddSurveyPageState();
}

class _AddSurveyPageState extends State<AddSurveyPage> {
  String selectedTrail = 'Ocelot';
  List<String> leaders = [
    '',
  ];
  String scribe = '';
  List<String?> participants = [''];

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

  void createSurvey() => widget.onCreateSurvey(Survey(
      trail: selectedTrail,
      leaders: leaders,
      scribe: scribe,
      participants: formattedParticipants));

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: 'Add New Survey',
      fabLabel: Row(
        children: const [Text('Add Survey'), Icon(Icons.add)],
      ),
      isFabValid: valid,
      onFabPress: createSurvey,
      child: ListView(
        controller: _controller,
        children: [
          TrailInputField(onChange: (value) {
            setState(() {
              selectedTrail = value;
            });
          }),
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
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('Add New Survey'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          controller: _controller,
          children: [
            TrailInputField(onChange: (value) {
              setState(() {
                selectedTrail = value;
              });
            }),
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
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: valid
            ? () => widget.onCreateSurvey(Survey(
                trail: selectedTrail,
                leaders: leaders,
                scribe: scribe,
                participants: formattedParticipants))
            : null,
        label: Row(
          children: const [Text('Add Survey'), Icon(Icons.add)],
        ),
        backgroundColor: valid
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.onError,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
