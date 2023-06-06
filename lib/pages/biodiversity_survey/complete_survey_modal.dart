import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/models/biodiversity_survey.dart';
import 'package:kekoldi_surveys/pages/add_weather/add_weather_page.dart';
import 'package:kekoldi_surveys/pages/biodiversity_survey/biodiversity_survey_page.dart';
import 'package:kekoldi_surveys/utils/time_utils.dart';

class CompleteSurveyModal extends StatefulWidget {
  final BiodiversitySurvey survey;
  final Function(BiodiversitySurvey survey) onChangeSurvey;

  const CompleteSurveyModal(
      {super.key, required this.survey, required this.onChangeSurvey});

  @override
  State<CompleteSurveyModal> createState() => _CompleteSurveyModalState();
}

class _CompleteSurveyModalState extends State<CompleteSurveyModal> {
  int get surveyLength =>
      DateTime.now().difference(widget.survey.startAt!).inMinutes;

  void _onAddWeather(
    String weather,
    String endTemperature,
    String rainfall,
  ) {
    widget.survey.setWeather(
      newWeather: weather,
      newEndTemperature: endTemperature,
      newRainfall: rainfall,
    );
    widget.onChangeSurvey(widget.survey);

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (BuildContext context) => BiodiversitySurveyPage(
          survey: widget.survey,
        ),
      ),
      (route) => route.settings.name == '/',
    );
  }

  void onComplete(BuildContext context) {
    widget.survey.end();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => AddWeatherPage(
          onAddWeather: _onAddWeather,
        ),
      ),
    );
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
              'Survey has been running for ${TimeFormats.hoursAndMinutesFromMinutes(widget.survey.lengthInMinutes(fromNow: true))}',
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
