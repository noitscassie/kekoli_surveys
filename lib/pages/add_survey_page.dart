import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/widgets/leaders_input_field.dart';
import 'package:kekoldi_surveys/widgets/participants_input_field.dart';
import 'package:kekoldi_surveys/widgets/scribe_input_field.dart';
import 'package:kekoldi_surveys/widgets/survey_item_form_field_wrapper.dart';
import 'package:kekoldi_surveys/widgets/trail_input_field.dart';

class AddSurveyPage extends StatefulWidget {
  const AddSurveyPage({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('Add New Survey'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            SurveyItemFormFieldWrapper(
                key: const Key('0'),
                label: 'Select a trail',
                child: TrailInputField(onChange: (value) {
                  setState(() {
                    selectedTrail = value;
                  });
                })),
            SurveyItemFormFieldWrapper(
              key: const Key('1'),
              label: 'Add leader(s)',
              child: LeadersInputField(
                onChange: (value) {
                  setState(() {
                    leaders = value;
                  });
                },
                value: leaders,
              ),
            ),
            SurveyItemFormFieldWrapper(
              key: const Key('2'),
              label: 'Add a scribe',
              child: ScribeInputField(
                onChange: (value) {
                  setState(() {
                    scribe = value;
                  });
                },
              ),
            ),
            SurveyItemFormFieldWrapper(
              key: const Key('3'),
              label: 'Add participants',
              child: ParticipantsInputField(
                onChange: (value) {
                  setState(() {
                    participants = value;
                  });
                },
                value: participants,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
