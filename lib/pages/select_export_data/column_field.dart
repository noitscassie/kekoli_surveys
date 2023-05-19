import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/models/csv_column.dart';

class ColumnField extends StatelessWidget {
  final int index;
  final List<String?> options;
  final CsvColumn column;
  final Function(CsvColumn column) onChange;

  const ColumnField(
      {super.key,
      required this.column,
      required this.index,
      required this.options,
      required this.onChange});

  final inputPadding = const EdgeInsets.symmetric(vertical: 16, horizontal: 12);

  void onHeaderChange(String value) {
    column.header = value;

    onChange(column);
  }

  void onFieldChange(String? value) {
    column.field = value;

    onChange(column);
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(column.header),
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
                  onChanged: onHeaderChange,
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
                onChanged: onFieldChange,
              )
            ],
          ),
        )
      ],
    );
  }
}
