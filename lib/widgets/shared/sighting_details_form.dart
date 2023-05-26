import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/models/input_field_config.dart';
import 'package:kekoldi_surveys/widgets/page_scaffold.dart';

class SightingDetailsForm extends StatelessWidget {
  final String species;
  final List<InputFieldConfig> fields;
  final Widget fabLabel;
  final VoidCallback onFabPress;
  final Map<String, dynamic> attributes;
  final Function(String key, String value) onAttributeChange;

  const SightingDetailsForm({
    super.key,
    required this.fields,
    required this.species,
    required this.fabLabel,
    required this.onFabPress,
    required this.attributes,
    required this.onAttributeChange,
  });

  bool get _valid => fields.all((InputFieldConfig config) =>
      !config.required || attributes[config.label]?.isNotEmpty == true);

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
        title: species,
        fabLabel: fabLabel,
        isFabValid: _valid,
        onFabPress: onFabPress,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 100),
          child: ListView(
            children: fields
                .map((InputFieldConfig config) => config.inputField(
                    value: attributes[config.label],
                    onChange: (dynamic value) =>
                        onAttributeChange(config.label, value)))
                .toList(),
          ),
        ));
  }
}
