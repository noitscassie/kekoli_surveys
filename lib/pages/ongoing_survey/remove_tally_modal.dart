import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/models/sighting.dart';
import 'package:kekoldi_surveys/models/survey.dart';
import 'package:kekoldi_surveys/widgets/partly_bolded_text.dart';

class RemoveTallyModal extends StatelessWidget {
  final Survey survey;
  final List<Sighting> sightings;
  final Function(Survey survey) onChangeSurvey;

  const RemoveTallyModal(
      {super.key,
      required this.survey,
      required this.sightings,
      required this.onChangeSurvey});

  Sighting get sighting => sightings.last;

  void onConfirm(BuildContext context) {
    survey.removeSighting(sighting);
    onChangeSurvey(survey);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Remove ${sighting.species}${sightings.length == 1 ? '' : ' tally'}?',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          // TODO: order this in the same order as the form config
          ...sighting.data.entries
              .filter((entry) => entry.value.isNotEmpty)
              .mapIndexed(
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
            onPressed: () => onConfirm(context), child: const Text('Remove')),
      ],
    );
  }
}
