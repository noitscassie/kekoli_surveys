import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/models/survey.dart';
import 'package:kekoldi_surveys/pages/home/completed_bottom_sheet.dart';
import 'package:kekoldi_surveys/pages/home/in_progress_bottom_sheet.dart';
import 'package:kekoldi_surveys/pages/home/unstarted_bottom_sheet.dart';
import 'package:kekoldi_surveys/pages/ongoing_survey/ongoing_survey_page.dart';
import 'package:kekoldi_surveys/pages/view_survey/view_survey_page.dart';
import 'package:kekoldi_surveys/utils/time_utils.dart';
import 'package:kekoldi_surveys/widgets/partly_bolded_text.dart';

class SurveyTile extends StatefulWidget {
  final Survey survey;

  const SurveyTile({super.key, required this.survey});

  @override
  State<SurveyTile> createState() => _SurveyTileState();
}

class _SurveyTileState extends State<SurveyTile> {
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap,
        child: Material(
          color: Colors.transparent,
          elevation: 8,
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
                        child: Text(
                          widget.survey.startAt == null
                              ? 'Unstarted'
                              : 'On ${DateFormats.ddmmyyyy(widget.survey.startAt!)}',
                          style: Theme.of(context).textTheme.bodySmall,
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
