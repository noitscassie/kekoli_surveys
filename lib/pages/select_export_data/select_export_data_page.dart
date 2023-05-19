import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/constants/default_csv_columns.dart';
import 'package:kekoldi_surveys/db/db.dart';
import 'package:kekoldi_surveys/models/csv_column.dart';
import 'package:kekoldi_surveys/models/input_field_config.dart';
import 'package:kekoldi_surveys/pages/select_export_data/column_field.dart';
import 'package:kekoldi_surveys/widgets/page_scaffold.dart';

class SelectExportDataPage extends StatefulWidget {
  const SelectExportDataPage({super.key});

  @override
  State<SelectExportDataPage> createState() => _SelectExportDataPageState();
}

class _SelectExportDataPageState extends State<SelectExportDataPage> {
  List<String?> get dataOptions => [
        null,
        speciesString,
        ...fields,
      ];

  final Db _db = Db();
  List<CsvColumn> columns = [];
  List<String> fields = [];

  Future<void> loadColumns() async {
    final config = await _db.getSurveyConfiguration();

    setState(() {
      columns = config.csvColumns;
      fields =
          config.fields.map((InputFieldConfig field) => field.label).toList();
    });
  }

  void updateColumn(CsvColumn updatedColumn) {
    final newColumns = columns
        .map((CsvColumn column) =>
            column.id == updatedColumn.id ? updatedColumn : column)
        .toList();

    setState(() {
      columns = newColumns;
    });
  }

  Future<void> onFabPress() async {
    final config = await _db.getSurveyConfiguration();
    config.csvColumns = columns;
    await _db.updateSurveyConfiguration(config);

    if (context.mounted) {
      const snackBar = SnackBar(
        duration: Duration(seconds: 4),
        content: Text('Saved data export format successfully'),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    super.initState();
    loadColumns();
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
        title: 'Select Data Format',
        fabLabel: const Row(
          children: [Text('Save Export Format'), Icon(Icons.save_alt)],
        ),
        onFabPress: onFabPress,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 100),
            child: ReorderableListView(
              children: List.from(columns
                  .mapIndexed((int index, CsvColumn column) => ColumnField(
                        key: Key('data_export_format_tile_${column.id}'),
                        column: column,
                        index: index,
                        options: dataOptions,
                        onChange: updateColumn,
                      ))),
              onReorder: (int oldIndex, int newIndex) {
                setState(() {
                  if (oldIndex < newIndex) {
                    newIndex -= 1;
                  }
                  final item = columns.removeAt(oldIndex);
                  columns.insert(newIndex, item);
                });
              },
            ),
          ),
        ));
  }
}
