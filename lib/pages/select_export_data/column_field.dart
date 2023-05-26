import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/models/csv_column.dart';
import 'package:kekoldi_surveys/widgets/dialogs/danger_cta.dart';
import 'package:kekoldi_surveys/widgets/dialogs/dialog_scaffold.dart';

class ColumnField extends StatelessWidget {
  final int index;
  final List<String?> options;
  final CsvColumn column;
  final Function(CsvColumn column) onChange;
  final VoidCallback onDelete;
  final bool initiallyExpanded;

  const ColumnField({
    super.key,
    required this.column,
    required this.index,
    required this.options,
    required this.onChange,
    required this.onDelete,
    this.initiallyExpanded = false,
  });

  final inputPadding = const EdgeInsets.symmetric(vertical: 16, horizontal: 12);

  void _onDeleteFieldPress(BuildContext context) => showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => DialogScaffold(
          title: 'Delete ${column.header} Column?',
          primaryCta: DangerCta(
            text: 'Delete Column',
            onTap: () {
              onDelete();
              Navigator.of(context).pop();
            },
          ),
          children: [
            Text(
                'Are you sure you want to remove the ${column.header} column from the survey data export?')
          ],
        ),
      );

  void _onHeaderChange(String value) {
    column.header = value;

    onChange(column);
  }

  void _onFieldChange(String? value) {
    column.field = value;

    onChange(column);
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        column.header,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      initiallyExpanded: initiallyExpanded,
      childrenPadding: const EdgeInsets.symmetric(horizontal: 8),
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: TextFormField(
                  initialValue: column.header,
                  decoration: InputDecoration(
                      labelText: 'Column Name', contentPadding: inputPadding),
                  onChanged: _onHeaderChange,
                ),
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                    labelText: 'Observation Field',
                    contentPadding: inputPadding),
                padding: const EdgeInsets.only(bottom: 8),
                value: column.field,
                items: options.map((String? dataOption) {
                  return DropdownMenuItem<String>(
                      value: dataOption,
                      child: Text(dataOption ?? '(Leave blank)'));
                }).toList(),
                onChanged: _onFieldChange,
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).colorScheme.error)),
                      onPressed: () => _onDeleteFieldPress(context),
                      child: Text(
                        'Remove Column',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.surface),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
