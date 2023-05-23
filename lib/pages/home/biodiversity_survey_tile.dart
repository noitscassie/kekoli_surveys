import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/constants/survey_state.dart';
import 'package:kekoldi_surveys/models/biodiversity_survey.dart';
import 'package:kekoldi_surveys/pages/home/completed_bottom_sheet.dart';
import 'package:kekoldi_surveys/pages/home/in_progress_bottom_sheet.dart';
import 'package:kekoldi_surveys/pages/home/unstarted_bottom_sheet.dart';
import 'package:kekoldi_surveys/pages/ongoing_survey/ongoing_survey_page.dart';
import 'package:kekoldi_surveys/pages/view_survey/view_survey_page.dart';
import 'package:kekoldi_surveys/utils/time_utils.dart';
import 'package:kekoldi_surveys/widgets/partly_bolded_text.dart';

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
              return UnstartedBottomSheet(survey: widget.survey);
            case SurveyState.inProgress:
              return InProgressBottomSheet(survey: widget.survey);
            case SurveyState.completed:
              return CompletedBottomSheet(survey: widget.survey);
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
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: InkWell(
        onTap: onTap,
        child: Material(
          elevation: 8,
          color: Colors.transparent,
          child: Card(
            color: Theme.of(context).colorScheme.surface,
            shape: const RoundedRectangleBorder(
              side: BorderSide(
                style: BorderStyle.none,
              ),
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${widget.survey.trail} Survey',
                          style: Theme.of(context).textTheme.headlineSmall),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              surveyState,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Text('Tap for options',
                                style: Theme.of(context).textTheme.bodySmall),
                          ],
                        ),
                      ),
                      PartlyBoldedText(
                          style: Theme.of(context).textTheme.bodySmall,
                          textParts: [
                            RawText('Led by '),
                            RawText(widget.survey.leaders.join(' and '),
                                bold: true)
                          ]),
                      PartlyBoldedText(
                        style: Theme.of(context).textTheme.bodySmall,
                        textParts: [
                          RawText('Scribed by '),
                          RawText(widget.survey.scribe, bold: true)
                        ],
                      ),
                      PartlyBoldedText(
                          style: Theme.of(context).textTheme.bodySmall,
                          textParts: [
                            RawText('Participated in by '),
                            RawText(widget.survey.participants.join(', '),
                                bold: true),
                          ]),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
