import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/constants/csv_export_types.dart';
import 'package:kekoldi_surveys/models/biodiversity_survey.dart';
import 'package:kekoldi_surveys/pages/biodiversity_survey/biodiversity_survey_scaffold.dart';
import 'package:kekoldi_surveys/pages/choose_species/choose_biodiversity_species_page.dart';
import 'package:kekoldi_surveys/pages/export_survey/export_biodiversity_survey_page.dart';
import 'package:kekoldi_surveys/pages/select_export_type/select_export_type_page.dart';
import 'package:kekoldi_surveys/utils/time_utils.dart';
import 'package:kekoldi_surveys/widgets/partly_bolded_text.dart';

enum OverflowMenuOption {
  addObservation(label: 'Add Observation');

  const OverflowMenuOption({
    required this.label,
  });

  final String label;
}

class ViewBiodiversitySurveyPage extends StatefulWidget {
  final BiodiversitySurvey survey;
  const ViewBiodiversitySurveyPage({
    super.key,
    required this.survey,
  });

  @override
  State<ViewBiodiversitySurveyPage> createState() =>
      _ViewBiodiversitySurveyPageState();
}

class _ViewBiodiversitySurveyPageState
    extends State<ViewBiodiversitySurveyPage> {
  String get _participantsString => [
        ...widget.survey.leaders.map((String leader) => '$leader (leader)'),
        '${widget.survey.scribe} (scribe)',
        ...widget.survey.participants
      ].join(', ');

  void _onFabPress() => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => SelectExportTypePage(
            onContinue: _navigateToExportSurveyPage,
          ),
        ),
      );

  void _navigateToExportSurveyPage(ExportType exportType) =>
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => ExportBiodiversitySurveyPage(
            survey: widget.survey,
            exportType: exportType,
          ),
        ),
      );

  void _handleOverflowMenuOptionTap(OverflowMenuOption option) {
    switch (option) {
      case OverflowMenuOption.addObservation:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => ChooseBiodiversitySpeciesPage(
              survey: widget.survey,
            ),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BiodiversitySurveyScaffold(
      survey: widget.survey,
      title:
          '${widget.survey.trail} Survey ${DateFormats.ddmmyyyy(widget.survey.startAt!)}',
      fabLabel: const Row(
        children: [
          Text('Export Data'),
          Icon(Icons.download),
        ],
      ),
      onFabPress: _onFabPress,
      actions: [
        PopupMenuButton<OverflowMenuOption>(
          onSelected: _handleOverflowMenuOptionTap,
          itemBuilder: (BuildContext otherContext) => OverflowMenuOption.values
              .map(
                (OverflowMenuOption option) => PopupMenuItem(
                  value: option,
                  child: Text(option.label),
                ),
              )
              .toList(),
        )
      ],
      sortSelectorSibling: Padding(
        padding: const EdgeInsets.only(right: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _participantsString,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontStyle: FontStyle.italic),
            ),
            if (widget.survey.weather != null)
              PartlyBoldedText(
                style: Theme.of(context).textTheme.bodyMedium,
                textParts: [
                  RawText('Weather was '),
                  RawText(widget.survey.weather!.toLowerCase(), bold: true),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
