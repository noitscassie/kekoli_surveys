import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/constants/csv_export_types.dart';
import 'package:kekoldi_surveys/widgets/form_item.dart';
import 'package:kekoldi_surveys/widgets/page_scaffold.dart';
import 'package:kekoldi_surveys/widgets/radio_buttons.dart';

class SelectExportTypePage extends StatefulWidget {
  final Function(ExportType exportType) onContinue;

  const SelectExportTypePage({
    super.key,
    required this.onContinue,
  });

  @override
  State<SelectExportTypePage> createState() => _SelectExportTypePageState();
}

class _SelectExportTypePageState extends State<SelectExportTypePage> {
  ExportType? exportType;

  bool get isFabValid => exportType != null;

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: 'Export Type',
      fabLabel: const Row(
        children: [Text('Choose Recipient'), Icon(Icons.arrow_right_alt)],
      ),
      isFabValid: isFabValid,
      onFabPress: () => widget.onContinue(exportType!),
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: FormItem(
            label: 'Select CSV Format',
            child: RadioButtons<ExportType>(
              options: [
                RadioButtonOption(
                    value: ExportType.formatted,
                    label: 'Formatted Data',
                    subtitle:
                        'Best for the biodiversity spreadsheet, formatted as configured in the settings for this survey'),
                RadioButtonOption(
                    value: ExportType.raw,
                    label: 'Raw Data',
                    subtitle:
                        'Get all the raw data, just in case the formatted data is misconfigured'),
                RadioButtonOption(
                    value: ExportType.species,
                    label: 'Species Only',
                    subtitle: 'Good for the incidentals'),
              ],
              selectedOption: exportType,
              onChange: (ExportType newExportType) {
                setState(() {
                  exportType = newExportType;
                });
              },
            ),
          ),
        )
      ]),
    );
  }
}
