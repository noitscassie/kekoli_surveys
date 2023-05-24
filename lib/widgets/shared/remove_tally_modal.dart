import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/models/input_field_config.dart';
import 'package:kekoldi_surveys/models/sighting.dart';
import 'package:kekoldi_surveys/widgets/dialogs/dialog_scaffold.dart';
import 'package:kekoldi_surveys/widgets/dialogs/primary_cta.dart';
import 'package:kekoldi_surveys/widgets/partly_bolded_text.dart';

class RemoveTallyModal extends StatelessWidget {
  final List<Sighting> sightings;
  final List<InputFieldConfig> fields;
  final VoidCallback onConfirm;

  const RemoveTallyModal({
    super.key,
    required this.sightings,
    required this.fields,
    required this.onConfirm,
  });

  Sighting get sighting => sightings.last;

  void _onConfirm(BuildContext context) {
    onConfirm();

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return DialogScaffold(
      title:
          'Remove ${sighting.species}${sightings.length == 1 ? '' : ' tally'}?',
      primaryCta: PrimaryCta(
        text: 'Remove',
        onTap: () => _onConfirm(context),
      ),
      children: [
        ...sighting
            .orderedData(fields)
            .entries
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
    );
  }
}
