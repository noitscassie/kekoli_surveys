import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/models/biodiversity_survey.dart';
import 'package:kekoldi_surveys/models/sighting.dart';
import 'package:kekoldi_surveys/pages/ongoing_survey/ongoing_biodiversity_survey_page.dart';
import 'package:kekoldi_surveys/widgets/partly_bolded_text.dart';

class ConfirmSightingDetailsDialog extends StatefulWidget {
  final BiodiversitySurvey survey;
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
                OngoingBiodiversitySurveyPage(survey: widget.survey)),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return DialogScaffold(
      title: widget.sighting.species,
      primaryCta: PrimaryCta(
        text: 'Add Sighting',
        onTap: _addSighting,
      ),
      children: [
        ...widget.sighting
            .orderedData(widget.survey.configuration.fields)
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
            )
      ],
    );
  }
}
