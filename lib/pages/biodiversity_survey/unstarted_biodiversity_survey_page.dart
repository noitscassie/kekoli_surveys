import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/models/biodiversity_survey.dart';
import 'package:kekoldi_surveys/utils/time_utils.dart';
import 'package:kekoldi_surveys/widgets/dialogs/dialog_scaffold.dart';
import 'package:kekoldi_surveys/widgets/dialogs/primary_cta.dart';
import 'package:kekoldi_surveys/widgets/page_scaffold.dart';

class UnstartedBiodiversitySurveyPage extends StatelessWidget {
  final BiodiversitySurvey survey;
  final Function(BiodiversitySurvey survey) onSurveyChange;

  const UnstartedBiodiversitySurveyPage({
    super.key,
    required this.survey,
    required this.onSurveyChange,
  });

  void _onStartSurveyTap(BuildContext context) => showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => DialogScaffold(
            title: 'Start Survey?',
            primaryCta: PrimaryCta(
              text: 'Start',
              onTap: () => _startSurvey(context),
            ),
            children: [
              Text(
                  'The time is ${TimeFormats.timeHoursAndMinutes(DateTime.now())}. Do you want to start the ${survey.trail} survey?'),
            ],
          ));

  void _startSurvey(BuildContext context) {
    Navigator.of(context).pop();
    survey.start();

    onSurveyChange(survey);
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: '${survey.trail} Survey',
      fabLabel: const Row(
        children: [
          Text('Start Survey'),
          Icon(Icons.start),
        ],
      ),
      onFabPress: () => _onStartSurveyTap(context),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Hit the button below to start the survey'),
            Padding(
              padding: EdgeInsets.only(top: 24),
              child: Icon(
                Icons.arrow_downward,
                size: 40,
              ),
            )
          ],
        ),
      ),
    );
  }
}
