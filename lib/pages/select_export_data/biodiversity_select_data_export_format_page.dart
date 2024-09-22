import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/constants/default_csv_columns.dart';
import 'package:kekoldi_surveys/db/db.dart';
import 'package:kekoldi_surveys/models/csv_column.dart';
import 'package:kekoldi_surveys/models/input_field_config.dart';
import 'package:kekoldi_surveys/pages/select_export_data/column_field.dart';
import 'package:kekoldi_surveys/widgets/add_new_item.dart';
import 'package:kekoldi_surveys/widgets/dialogs/dialog_scaffold.dart';
import 'package:kekoldi_surveys/widgets/dialogs/primary_cta.dart';
import 'package:kekoldi_surveys/widgets/fading_widget.dart';
import 'package:kekoldi_surveys/widgets/page_scaffold.dart';
import 'package:kekoldi_surveys/widgets/text_header.dart';

class BiodiversitySelectDataExportFormatPage extends StatefulWidget {
  const BiodiversitySelectDataExportFormatPage({super.key});

  @override
  State<BiodiversitySelectDataExportFormatPage> createState() =>
      _BiodiversitySelectDataExportFormatPageState();
}

class _BiodiversitySelectDataExportFormatPageState
    extends State<BiodiversitySelectDataExportFormatPage> {
  List<String?> get _dataOptions => [
        null,
        speciesString,
        ..._fields,
      ];

  final Db _db = Db();
  List<CsvColumn> _columns = [];
  List<String> _fields = [];
  bool _expandFinalField = false;

  void _openResetToDefaultsDialog() => showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => DialogScaffold(
          title: 'Reset to defaults?',
          primaryCta: PrimaryCta(text: 'Reset', onTap: _resetFieldsToDefaults),
          children: const [
            Text(
              'Are you sure you want to reset the current biodiversity data export format to its default setting?',
            )
          ],
        ),
      );

  Future<void> _resetFieldsToDefaults() async {
    final config = _db.getSurveyConfiguration();
    config.csvColumns = defaultBiodiversityCsvColumns;

    _db.updateSurveyConfiguration(config);

    if (context.mounted) {
      const snackBar = SnackBar(
        duration: Duration(seconds: 2),
        content: Text('Successfully reset data export format'),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      Navigator.of(context).pop();
      Navigator.of(context).pop();
    }
  }

  Future<void> _loadData() async {
    final config = _db.getSurveyConfiguration();

    setState(() {
      _columns = config.csvColumns;
      _fields =
          config.fields.map((InputFieldConfig field) => field.label).toList();
    });
  }

  void _updateColumn(CsvColumn updatedColumn) {
    final newColumns = _columns
        .map((CsvColumn column) =>
            column.id == updatedColumn.id ? updatedColumn : column)
        .toList();

    setState(() {
      _columns = newColumns;
    });
  }

  Future<void> _onFabPress() async {
    final config = _db.getSurveyConfiguration();
    config.csvColumns = _columns;
    _db.updateSurveyConfiguration(config);

    if (context.mounted) {
      const snackBar = SnackBar(
        duration: Duration(seconds: 4),
        content: Text('Saved data export format successfully'),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      Navigator.of(context).pop();
    }
  }

  void _addNewField() => setState(
        () {
          _columns = [
            ..._columns,
            CsvColumn(
              header: 'New Column',
            )
          ];
          _expandFinalField = true;
        },
      );

  void _onReorder(int oldIndex, int newIndex) => setState(() {
        if (oldIndex < newIndex) {
          newIndex -= 1;
        }

        final item = _columns.removeAt(oldIndex);

        _columns.insert(newIndex, item);
      });

  void _onDelete(CsvColumn columnToDelete) => setState(() {
        _columns = _columns
            .whereNot((column) => column.id == columnToDelete.id)
            .toList();
      });

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
        title: 'Select Data Format',
        actions: [
          IconButton(
            onPressed: _openResetToDefaultsDialog,
            icon: const Icon(Icons.refresh),
          ),
        ],
        fabLabel: const Row(
          children: [
            Text('Save Export Format'),
            Icon(Icons.save_alt),
          ],
        ),
        onFabPress: _onFabPress,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            children: [
              const TextHeader(
                text:
                    'Use this page to change the format of exported data for biodiversity surveys.\n'
                    'Order each item to match the order of columns on your spreadsheet, and then choose which field you want that column to be populated with.\n'
                    'Once you\'re done, hit the save button below, and the updated export format will be used for all future surveys. You can hit the refresh button in the top right corner to reset this to the default settings at any time.',
              ),
              Expanded(
                child: FadingWidget(
                  top: true,
                  bottom: true,
                  padTop: false,
                  child: ReorderableListView(
                    padding: const EdgeInsets.only(bottom: 50),
                    onReorder: _onReorder,
                    footer: AddNewItem(
                      key: const Key('add_new_data_export_column_tile'),
                      text: 'Add new export field',
                      onTap: _addNewField,
                    ),
                    children: [
                      ..._columns.mapIndexed(
                        (int index, CsvColumn column) => ColumnField(
                          key: Key('data_export_format_tile_${column.id}'),
                          column: column,
                          index: index,
                          options: _dataOptions,
                          onChange: _updateColumn,
                          onDelete: () => _onDelete(column),
                          initiallyExpanded: _expandFinalField &&
                              (index + 1) == _columns.length,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
