import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/constants/survey_state.dart';
import 'package:kekoldi_surveys/models/biodiversity_survey.dart';
import 'package:kekoldi_surveys/pages/biodiversity_survey/ongoing_biodiversity_survey_page.dart';
import 'package:kekoldi_surveys/pages/biodiversity_survey/unstarted_biodiversity_survey_page.dart';
import 'package:kekoldi_surveys/pages/biodiversity_survey/view_biodiversity_survey_page.dart';

class BiodiversitySurveyPage extends StatefulWidget {
  final BiodiversitySurvey survey;

  const BiodiversitySurveyPage({
    super.key,
    required this.survey,
  });

  @override
  State<BiodiversitySurveyPage> createState() => _BiodiversitySurveyPageState();
}

class _BiodiversitySurveyPageState extends State<BiodiversitySurveyPage> {
  late BiodiversitySurvey _statefulSurvey = widget.survey;

  void _updateSurvey(BiodiversitySurvey survey) => setState(() {
        _statefulSurvey = survey;
      });

  @override
  Widget build(BuildContext context) {
    switch (_statefulSurvey.state) {
      case SurveyState.unstarted:
        return UnstartedBiodiversitySurveyPage(
          survey: _statefulSurvey,
          onSurveyChange: _updateSurvey,
        );
      case SurveyState.inProgress:
        return OngoingBiodiversitySurveyPage(
          survey: _statefulSurvey,
        );
      case SurveyState.completed:
        return ViewBiodiversitySurveyPage(
          survey: _statefulSurvey,
          onSurveyChange: _updateSurvey,
        );
    }
  }
}
