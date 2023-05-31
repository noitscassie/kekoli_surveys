import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/constants/survey_state.dart';
import 'package:kekoldi_surveys/models/biodiversity_survey.dart';
import 'package:kekoldi_surveys/pages/home/biodiversity_survey_bottom_sheet.dart';
import 'package:kekoldi_surveys/utils/time_utils.dart';
import 'package:kekoldi_surveys/widgets/shared/survey_tile.dart';

class BiodiversitySurveyTile extends StatefulWidget {
  final BiodiversitySurvey survey;

  const BiodiversitySurveyTile({super.key, required this.survey});

  @override
  State<BiodiversitySurveyTile> createState() => _BiodiversitySurveyTileState();
}

class _BiodiversitySurveyTileState extends State<BiodiversitySurveyTile> {
  void _onTap() => showModalBottomSheet(
        context: context,
        builder: (BuildContext context) =>
            BiodiversitySurveyBottomSheet(survey: widget.survey),
      );

  String get _surveyState {
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
      subtitle: _surveyState,
      leaders: widget.survey.leaders,
      scribe: widget.survey.scribe,
      participants: widget.survey.participants,
      onTap: _onTap,
    );
  }
}
