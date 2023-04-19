import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/constants/trails.dart';
import 'package:kekoldi_surveys/models/survey.dart';
import 'package:kekoldi_surveys/utils/string_utils.dart';
import 'package:kekoldi_surveys/widgets/survey_form_field.dart';

class NewSurveyForm extends StatefulWidget {
  final Function(Survey survey) onCreateSurvey;

  const NewSurveyForm({super.key, required this.onCreateSurvey});

  @override
  State<NewSurveyForm> createState() => _NewSurveyFormState();
}

class _NewSurveyFormState extends State<NewSurveyForm> {
  String selectedTrail = 'Ocelot';
  List<String> leaders = [];
  String scribe = '';
  List<String> participants = [];

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height / 4,
        maxHeight: MediaQuery.of(context).size.height / 1.5,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Start a new survey',
                style: Theme.of(context).textTheme.headlineSmall),
            ListView(
              shrinkWrap: true,
              children: [
                DropdownButtonFormField<String>(
                    value: selectedTrail,
                    items: List.from(trails.map((String trail) =>
                        DropdownMenuItem(value: trail, child: Text(trail)))),
                    onChanged: (String? newTrail) {
                      setState(() {
                        selectedTrail = newTrail!;
                      });
                    }),
                if (leaders.length < 2)
                  SurveyFormField(
                      labelText: 'Add survey leader',
                      onConfirmation: (String value) =>
                          setState(() => leaders.add(value))),
                if (leaders.isNotEmpty)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          'This survey is being led by \n${formatStringListAsBullets(leaders)}'),
                      Expanded(
                          child: IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.change_circle)))
                    ],
                  ),
                if (scribe.isEmpty)
                  SurveyFormField(
                      labelText: 'Add survey scribe',
                      onConfirmation: (String value) =>
                          setState(() => scribe = value)),
                if (scribe.isNotEmpty)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('The scribe for this survey is $scribe'),
                      Expanded(
                          child: IconButton(
                              onPressed: () {
                                setState(() {
                                  scribe = '';
                                });
                              },
                              icon: const Icon(Icons.change_circle)))
                    ],
                  ),
                SurveyFormField(
                    labelText: 'Add new participant',
                    onConfirmation: (String value) =>
                        setState(() => participants.add(value))),
                if (participants.isNotEmpty)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          'Taking part in this survey is...\n${formatStringListAsBullets(participants)}'),
                      Expanded(
                          child: IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.change_circle)))
                    ],
                  ),
              ],
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  widget.onCreateSurvey(Survey(
                      startAt: DateTime.now(),
                      trail: selectedTrail,
                      leaders: leaders,
                      scribe: scribe));
                },
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Start Survey'),
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
