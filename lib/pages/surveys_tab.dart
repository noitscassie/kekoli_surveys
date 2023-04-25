import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/models/survey.dart';
import 'package:kekoldi_surveys/widgets/survey_tile.dart';

class SurveysTab extends StatelessWidget {
  final List<Survey> surveys;

  const SurveysTab({super.key, required this.surveys});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        children:
            List.from(surveys.map((survey) => SurveyTile(survey: survey))),
      ),
    );
  }
}
