import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/models/survey.dart';
import 'package:kekoldi_surveys/pages/ongoing_survey/ongoing_survey_page.dart';
import 'package:kekoldi_surveys/utils/date_formats.dart';

class SurveyTile extends StatefulWidget {
  final Survey survey;

  const SurveyTile({super.key, required this.survey});

  @override
  State<SurveyTile> createState() => _SurveyTileState();
}

class _SurveyTileState extends State<SurveyTile> {
  void startSurveyAndNavigate() {
    widget.survey.start();
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) =>
            OngoingSurveyPage(survey: widget.survey)));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
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
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: 'Led by ',
                            style: Theme.of(context).textTheme.bodySmall),
                        TextSpan(
                            text: widget.survey.leaders.join(' and '),
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(fontWeight: FontWeight.bold))
                      ]),
                    ),
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text: 'Scribed by ',
                          style: Theme.of(context).textTheme.bodySmall),
                      TextSpan(
                          text: widget.survey.scribe,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(fontWeight: FontWeight.bold)),
                    ])),
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text: 'Participated in by ',
                          style: Theme.of(context).textTheme.bodySmall),
                      TextSpan(
                          text: widget.survey.participants.join(', '),
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(fontWeight: FontWeight.bold)),
                    ])),
                  ],
                ),
                IconButton(
                  icon: Icon(
                    Icons.play_circle_fill,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  padding: EdgeInsets.zero,
                  onPressed: startSurveyAndNavigate,
                  iconSize: 60,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
