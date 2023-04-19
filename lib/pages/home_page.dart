import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/models/survey.dart';
import 'package:kekoldi_surveys/widgets/new_survey_form.dart';

class HomePage extends StatelessWidget {
  final Function(Survey survey) onCreateSurvey;

  const HomePage({super.key, required this.onCreateSurvey});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      NewSurveyForm(onCreateSurvey: onCreateSurvey)),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Start New Survey'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
