import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/constants/survey_state.dart';
import 'package:kekoldi_surveys/models/bird_survey.dart';
import 'package:kekoldi_surveys/pages/home/bird_survey_bottom_sheet.dart';
import 'package:kekoldi_surveys/widgets/shared/survey_tile.dart';

class BirdSurveyTile extends StatelessWidget {
  final BirdSurvey survey;

  const BirdSurveyTile({super.key, required this.survey});

  String get _surveyState {
    switch (survey.state) {
      case SurveyState.unstarted:
        return 'Unstarted';
      case SurveyState.inProgress:
        return 'In progress';
      case SurveyState.completed:
        return 'Finished';
    }
  }

  void onTap(BuildContext context) =>
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => BirdSurveyBottomSheet(survey: survey),
    );

  @override
  Widget build(BuildContext context) {
    return SurveyTile(
      title: 'Bird ${survey.type.title} ${survey.trail}',
      subtitle: _surveyState,
      leaders: survey.leaders,
      scribe: survey.scribe,
      participants: survey.participants,
      onTap: () => onTap(context),
    );
  }
}
