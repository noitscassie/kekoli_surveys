import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/models/sighting.dart';
import 'package:kekoldi_surveys/models/survey.dart';
import 'package:kekoldi_surveys/pages/ongoing_survey/ongoing_survey_page.dart';
import 'package:kekoldi_surveys/widgets/partly_bolded_text.dart';

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
            widget.sighting.species,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          ...widget.sighting.attributes.entries.mapIndexed(
            (index, entry) => Padding(
              padding: const EdgeInsets.only(top: 8),
              child: PartlyBoldedText(
                style: Theme.of(context).textTheme.bodyMedium,
                textParts: [
                  RawText('${entry.key}: ', bold: true),
                  RawText(entry.value),
                ],
              ),
            ),
          )
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
