import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/main.dart';
import 'package:kekoldi_surveys/models/survey.dart';
import 'package:kekoldi_surveys/pages/add_weather_page.dart';
import 'package:kekoldi_surveys/utils/time_utils.dart';

class CompleteSurveyModal extends StatefulWidget {
  final Survey survey;
  final Function(Survey survey) onChangeSurvey;

  const CompleteSurveyModal(
      {super.key, required this.survey, required this.onChangeSurvey});

  @override
  State<CompleteSurveyModal> createState() => _CompleteSurveyModalState();
}

class _CompleteSurveyModalState extends State<CompleteSurveyModal> {
  // TODO: find out how to get a duration between two datetimes
  Duration get surveyLength => const Duration(hours: 0, minutes: 63);

  void onAddWeather(String weather) {
    widget.survey.setWeather(weather);
    widget.onChangeSurvey(widget.survey);

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (BuildContext context) => const MyHomePage()),
        (route) => false);
  }

  void onComplete(BuildContext context) {
    widget.survey.end();
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => AddWeatherPage(
              survey: widget.survey,
              onAddWeather: onAddWeather,
            )));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Complete ${widget.survey.trail} Survey?',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              'Survey has been running for ${DurationFormats.hoursAndMinutes(surveyLength)}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Back',
            )),
        ElevatedButton(
            onPressed: () => onComplete(context),
            child: const Text('Complete Survey')),
      ],
    );
  }
}
