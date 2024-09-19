import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/constants/default_biodiversity_sighting_fields.dart';
import 'package:kekoldi_surveys/db/db.dart';
import 'package:kekoldi_surveys/models/input_field_config.dart';
import 'package:kekoldi_surveys/pages/survey_format/modify_input_field.dart';
import 'package:kekoldi_surveys/widgets/add_new_item.dart';
import 'package:kekoldi_surveys/widgets/dialogs/dialog_scaffold.dart';
import 'package:kekoldi_surveys/widgets/dialogs/primary_cta.dart';
import 'package:kekoldi_surveys/widgets/page_scaffold.dart';
import 'package:kekoldi_surveys/widgets/text_header.dart';

class SurveyFormatPage extends StatefulWidget {
  const SurveyFormatPage({super.key});

  @override
  State<SurveyFormatPage> createState() => _SurveyFormatPageState();
}

class _SurveyFormatPageState extends State<SurveyFormatPage> {
  final Db _db = Db();
  List<InputFieldConfig> fields = [];

  void _openResetToDefaultsDialog() => showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => DialogScaffold(
          title: 'Reset to defaults?',
          primaryCta: PrimaryCta(text: 'Reset', onTap: _resetFieldsToDefaults),
          children: const [
            Text(
              'Are you sure you want to reset all the current biodiversity survey fields to their defaults?',
            )
          ],
        ),
      );

  Future<void> _resetFieldsToDefaults() async {
    final config = _db.getSurveyConfiguration();
    config.fields = defaultBiodiversitySightingFields;

    _db.updateSurveyConfiguration(config);

    if (context.mounted) {
      const snackBar = SnackBar(
        duration: Duration(seconds: 2),
        content: Text('Successfully reset biodiversity fields'),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      Navigator.of(context).pop();
      Navigator.of(context).pop();
    }
  }

  Future<void> _loadFields() async {
    final config = _db.getSurveyConfiguration();
    setState(() {
      fields = config.fields;
    });
  }

  void _addField() {
    final newFields = [
      ...fields,
      InputFieldConfig.text(label: 'Untitled Field')
    ];

    setState(() {
      fields = newFields;
    });
  }

  void _updateField(InputFieldConfig updatedField) {
    final newFields = fields
        .map((InputFieldConfig field) =>
            field.id == updatedField.id ? updatedField : field)
        .toList();

    setState(() {
      fields = newFields;
    });
  }

  void _deleteField(InputFieldConfig fieldToDelete) {
    final newFields = fields
        .whereNot((InputFieldConfig field) => fieldToDelete.id == field.id)
        .toList();

    setState(() {
      fields = newFields;
    });

    Navigator.of(context).pop();
  }

  Future<void> _onFabPress() async {
    final config = _db.getSurveyConfiguration();
    config.fields = fields;
    _db.updateSurveyConfiguration(config);

    if (context.mounted) {
      const snackBar = SnackBar(
        duration: Duration(seconds: 4),
        content: Text('Saved survey format successfully'),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    super.initState();
    _loadFields();
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold.withScrollableChildren(
      title: 'Survey Format',
      actions: [
        IconButton(
          onPressed: _openResetToDefaultsDialog,
          icon: const Icon(Icons.refresh),
        ),
      ],
      fabLabel: const Row(
        children: [Text('Save Survey Format'), Icon(Icons.save_alt)],
      ),
      onFabPress: _onFabPress,
      header: const TextHeader(
          text:
              'Use this page to change the data that is collected on each species during a survey.\n'
              'Once you\'re done, hit the save button below, and the updated format will be used for all future surveys.\n'
              'You can hit the refresh button in the top right corner to reset this to the default settings at any time.'),
      children: [
        ...fields.mapIndexed(
          (index, field) => ModifyInputField(
            key: Key(field.id),
            index: index,
            field: field,
            onChange: _updateField,
            onDelete: _deleteField,
          ),
        ),
        AddNewItem(
          text: 'Add new field',
          onTap: _addField,
        ),
      ],
    );
  }
}
