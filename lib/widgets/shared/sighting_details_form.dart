import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/constants/default_survey_fields.dart';
import 'package:kekoldi_surveys/models/input_field_config.dart';
import 'package:kekoldi_surveys/models/survey_configuration.dart';
import 'package:kekoldi_surveys/widgets/page_scaffold.dart';

class SightingDetailsForm extends StatelessWidget {
  final String species;
  final Widget fabLabel;
  final VoidCallback onFabPress;
  final Map<String, dynamic> attributes;
  final Function(String key, String value) onAttributeChange;

  final _surveyConfig = SurveyConfiguration(defaultSurveyFields);

  SightingDetailsForm({
    super.key,
    required this.species,
    required this.fabLabel,
    required this.onFabPress,
    required this.attributes,
    required this.onAttributeChange,
  });

  bool get _valid => _surveyConfig.fields.all((InputFieldConfig config) =>
      !config.required || attributes[config.label]?.isNotEmpty == true);

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
        title: species,
        fabLabel: Row(
          children: [
            Text('Add $species'),
            const Icon(Icons.add),
          ],
        ),
        isFabValid: _valid,
        onFabPress: onFabPress,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 100),
          child: ListView(
            children: _surveyConfig.fields
                .map((InputFieldConfig config) => config.inputField(
                    value: attributes[config.label],
                    onChange: (String value) =>
                        onAttributeChange(config.label, value)))
                .toList(),
          ),
        ));
  }
}
