import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/db/db.dart';
import 'package:kekoldi_surveys/models/input_field_config.dart';
import 'package:kekoldi_surveys/pages/survey_format/modify_input_field.dart';
import 'package:kekoldi_surveys/widgets/page_scaffold.dart';

class SurveyFormatPage extends StatefulWidget {
  const SurveyFormatPage({super.key});

  @override
  State<SurveyFormatPage> createState() => _SurveyFormatPageState();
}

class _SurveyFormatPageState extends State<SurveyFormatPage> {
  final Db _db = Db();
  List<InputFieldConfig> fields = [];

  Future<void> loadFields() async {
    final config = await _db.getSurveyConfiguration();
    setState(() {
      fields = config.fields;
    });
  }

  void addField() {
    final newFields = [
      ...fields,
      InputFieldConfig.text(label: 'Untitled Field')
    ];

    setState(() {
      fields = newFields;
    });
  }

  void updateField(InputFieldConfig updatedField) {
    final newFields = fields
        .map((InputFieldConfig field) =>
            field.id == updatedField.id ? updatedField : field)
        .toList();

    setState(() {
      fields = newFields;
    });
  }

  void deleteField(InputFieldConfig fieldToDelete) {
    final newFields = fields
        .whereNot((InputFieldConfig field) => fieldToDelete.id == field.id)
        .toList();

    setState(() {
      fields = newFields;
    });

    Navigator.of(context).pop();
  }

  Future<void> onFabPress(BuildContext context) async {
    final config = await _db.getSurveyConfiguration();
    config.fields = fields;
    await _db.updateSurveyConfiguration(config);

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
    loadFields();
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
        title: 'Survey Format',
        fabLabel: const Row(
          children: [Text('Save Survey Format'), Icon(Icons.save_alt)],
        ),
        onFabPress: () => onFabPress(context),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 100),
          child: ListView(
            children: [
              ...fields.mapIndexed((index, field) => ModifyInputField(
                    key: Key(field.id),
                    index: index,
                    field: field,
                    onChange: updateField,
                    onDelete: deleteField,
                  )),
              Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: GestureDetector(
                      onTap: addField,
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(right: 16),
                            child: Icon(Icons.add),
                          ),
                          Text(
                            'Add new field',
                            style: Theme.of(context).textTheme.bodyLarge,
                          )
                        ],
                      )))
            ],
          ),
        ));
  }
}