import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/constants/survey_state.dart';
import 'package:kekoldi_surveys/models/biodiversity_survey.dart';
import 'package:kekoldi_surveys/pages/home/completed_biodiversity_bottom_sheet.dart';
import 'package:kekoldi_surveys/pages/home/in_progress_biodiversity_bottom_sheet.dart';
import 'package:kekoldi_surveys/pages/home/unstarted_biodiversity_bottom_sheet.dart';
import 'package:kekoldi_surveys/pages/ongoing_survey/ongoing_survey_page.dart';
import 'package:kekoldi_surveys/pages/view_survey/view_survey_page.dart';
import 'package:kekoldi_surveys/utils/time_utils.dart';
import 'package:kekoldi_surveys/widgets/shared/survey_tile.dart';

class BiodiversitySurveyTile extends StatefulWidget {
  final BiodiversitySurvey survey;

  const BiodiversitySurveyTile({super.key, required this.survey});

  @override
  State<BiodiversitySurveyTile> createState() => _BiodiversitySurveyTileState();
}

class _BiodiversitySurveyTileState extends State<BiodiversitySurveyTile> {
  void onTap() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          switch (widget.survey.state) {
            case SurveyState.unstarted:
              return UnstartedBiodiversityBottomSheet(survey: widget.survey);
            case SurveyState.inProgress:
              return InProgressBiodiversityBottomSheet(survey: widget.survey);
            case SurveyState.completed:
              return CompletedBiodiversityBottomSheet(survey: widget.survey);
          }
        });
  }

  void navigateToOngoingSurvey() =>
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) =>
              OngoingSurveyPage(survey: widget.survey)));

  void viewSurveyDetails() => Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) =>
          ViewSurveyPage(survey: widget.survey)));

  String get surveyState {
    switch (widget.survey.state) {
      case SurveyState.unstarted:
        return 'Unstarted';
      case SurveyState.inProgress:
        return 'In progress - started on ${DateFormats.ddmmyyyy(widget.survey.startAt!)}';
      case SurveyState.completed:
        return 'Finished on ${DateFormats.ddmmyyyy(widget.survey.endAt!)}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SurveyTile(
      title: '${widget.survey.trail} Survey',
      subtitle: surveyState,
      leaders: widget.survey.leaders,
      scribe: widget.survey.scribe,
      participants: widget.survey.participants,
      onTap: onTap,
    );
  }
}
