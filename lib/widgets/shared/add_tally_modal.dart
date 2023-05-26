import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/models/input_field_config.dart';
import 'package:kekoldi_surveys/models/sighting.dart';
import 'package:kekoldi_surveys/widgets/dialogs/dialog_scaffold.dart';
import 'package:kekoldi_surveys/widgets/dialogs/primary_cta.dart';
import 'package:kekoldi_surveys/widgets/partly_bolded_text.dart';

class AddTallyModal extends StatefulWidget {
  final List<InputFieldConfig> fields;
  final Sighting sighting;
  final Function(int quantity) onConfirm;

  const AddTallyModal({
    super.key,
    required this.sighting,
    required this.onConfirm,
    required this.fields,
  });

  @override
  State<AddTallyModal> createState() => _AddTallyModalState();
}

class _AddTallyModalState extends State<AddTallyModal> {
  static const maxTallies = 50;

  int quantity = 1;

  void _updateQuantity(int? newQuantity) => setState(() {
        if (newQuantity != null) {
          quantity = newQuantity;
        }
      });

  void _onConfirm() {
    widget.onConfirm(quantity);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return DialogScaffold(
      title: 'Add ${widget.sighting.species} tally?',
      primaryCta: PrimaryCta(text: 'Add', onTap: _onConfirm),
      children: [
        ...widget.sighting
            .orderedData(widget.fields)
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
        Row(
          children: [
            Text(
              'Tallies to add: ',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            DropdownButton<int>(
              value: quantity,
              items: List.generate(
                  maxTallies,
                  (int index) => DropdownMenuItem(
                      value: index + 1, child: Text((index + 1).toString()))),
              onChanged: _updateQuantity,
            ),
          ],
        )
      ],
    );
  }
}
