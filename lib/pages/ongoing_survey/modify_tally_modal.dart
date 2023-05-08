import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/models/sighting.dart';
import 'package:kekoldi_surveys/models/survey.dart';
import 'package:kekoldi_surveys/widgets/partly_bolded_text.dart';

class ModifyTallyModal extends StatelessWidget {
  final Survey survey;
  final String title;
  final String primaryCta;
  final VoidCallback onConfirm;
  final Sighting sighting;

  const ModifyTallyModal(
      {super.key,
      required this.sighting,
      required this.onConfirm,
      required this.title,
      required this.primaryCta,
      required this.survey});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          ...sighting.displayAttributes.entries.filter((entry) => entry.value.isNotEmpty).mapIndexed(
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
        ElevatedButton(onPressed: onConfirm, child: Text(primaryCta)),
      ],
    );
  }
}
