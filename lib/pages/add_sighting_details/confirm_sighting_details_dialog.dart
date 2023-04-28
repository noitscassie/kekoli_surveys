import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/models/sighting.dart';
import 'package:kekoldi_surveys/models/survey.dart';
import 'package:kekoldi_surveys/pages/ongoing_survey/ongoing_survey_page.dart';

class ConfirmSightingDetailsDialog extends StatefulWidget {
  final Survey survey;
  final Sighting sighting;

  const ConfirmSightingDetailsDialog(
      {super.key, required this.sighting, required this.survey});

  @override
  State<ConfirmSightingDetailsDialog> createState() =>
      _ConfirmSightingDetailsDialogState();
}

class _ConfirmSightingDetailsDialogState
    extends State<ConfirmSightingDetailsDialog> {
  void addSighting() {
    widget.survey.addSighting(widget.sighting);

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (BuildContext context) =>
                OngoingSurveyPage(survey: widget.survey)),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.sighting.species.name,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: 'Quantity: ',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
                TextSpan(
                    text: widget.sighting.quantity.toString(),
                    style: Theme.of(context).textTheme.bodyMedium)
              ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: 'Height: ',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
                TextSpan(
                    text: widget.sighting.height,
                    style: Theme.of(context).textTheme.bodyMedium)
              ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: 'Substrate: ',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
                TextSpan(
                    text: widget.sighting.substrate,
                    style: Theme.of(context).textTheme.bodyMedium)
              ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: 'Sex: ',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
                TextSpan(
                    text: widget.sighting.sex,
                    style: Theme.of(context).textTheme.bodyMedium)
              ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: 'Observation Type: ',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
                TextSpan(
                    text: widget.sighting.observationType,
                    style: Theme.of(context).textTheme.bodyMedium)
              ]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: 'Age: ',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
                TextSpan(
                    text: widget.sighting.age,
                    style: Theme.of(context).textTheme.bodyMedium)
              ]),
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
            onPressed: addSighting, child: const Text('Add Sighting')),
      ],
    );
  }
}
