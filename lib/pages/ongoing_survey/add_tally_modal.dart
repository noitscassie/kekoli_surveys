import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/models/biodiversity_survey.dart';
import 'package:kekoldi_surveys/models/sighting.dart';
import 'package:kekoldi_surveys/widgets/partly_bolded_text.dart';

class AddTallyModal extends StatefulWidget {
  final BiodiversitySurvey survey;
  final Sighting sighting;
  final Function(BiodiversitySurvey survey) onChangeSurvey;

  const AddTallyModal(
      {super.key,
      required this.survey,
      required this.sighting,
      required this.onChangeSurvey});

  @override
  State<AddTallyModal> createState() => _AddTallyModalState();
}

class _AddTallyModalState extends State<AddTallyModal> {
  static const maxTallies = 50;

  int quantity = 1;

  void onConfirm() {
    final sightings =
        List.generate(quantity, (_) => widget.sighting.duplicate());
    widget.survey.addSightings(sightings);
    widget.onChangeSurvey(widget.survey);

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
            'Add ${widget.sighting.species} tally?',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          ...widget.sighting
              .orderedData(widget.survey)
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
                          value: index + 1,
                          child: Text((index + 1).toString()))),
                  onChanged: (int? newQuantity) => setState(() {
                        if (newQuantity != null) {
                          quantity = newQuantity;
                        }
                      })),
            ],
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
        ElevatedButton(onPressed: onConfirm, child: const Text('Add')),
      ],
    );
  }
}
