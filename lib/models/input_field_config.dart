import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:kekoldi_surveys/widgets/shared/multiline_text_input_field.dart';
import 'package:kekoldi_surveys/widgets/shared/number_input_field.dart';
import 'package:kekoldi_surveys/widgets/shared/radio_buttons_input_field.dart';
import 'package:kekoldi_surveys/widgets/shared/select_dropdown_input_field.dart';
import 'package:kekoldi_surveys/widgets/shared/text_input_field.dart';

enum FieldType {
  text,
  multilineText,
  number,
  radioButtons,
  select,
}

class InputFieldConfig with DiagnosticableTreeMixin {
  final String label;
  final FieldType type;
  final String defaultValue;
  final List<String> options;
  final bool required;

  InputFieldConfig.text(
      {required this.label, this.defaultValue = '', this.required = false})
      : type = FieldType.text,
        options = [];

  InputFieldConfig.multilineText(
      {required this.label, this.defaultValue = '', this.required = false})
      : type = FieldType.multilineText,
        options = [];

  InputFieldConfig.number(
      {required this.label, this.defaultValue = '1', this.required = false})
      : type = FieldType.number,
        options = [];

  InputFieldConfig.radioButtons(
      {required this.label,
      required this.options,
      this.defaultValue = '',
      this.required = false})
      : type = FieldType.radioButtons;

  InputFieldConfig.select(
      {required this.label,
      required this.options,
      this.defaultValue = '',
      this.required = false})
      : type = FieldType.select;

  InputFieldConfig.fromJson(Map<String, dynamic> json)
      : label = json['label'],
        type = FieldType.values.byName(json['type']),
        defaultValue = json['defaultValue'],
        options = List<String>.from(json['options']),
        required = json['required'];

  String toJson() => jsonEncode(attributes);

  Map<String, dynamic> get attributes => {
        'label': label,
        'type': type.name,
        'defaultValue': defaultValue,
        'options': options,
        'required': required,
      };

  Widget inputField({required Function(String value) onChange, String? value}) {
    final fieldValue = value ?? defaultValue;

    switch (type) {
      case FieldType.text:
        return TextInputField(
          label: label,
          value: fieldValue,
          onChange: onChange,
        );
      case FieldType.multilineText:
        return MultilineTextInputField(
          label: label,
          value: fieldValue,
          onChange: onChange,
        );
      case FieldType.number:
        return NumberInputField(
          label: label,
          value: fieldValue,
          onChange: onChange,
        );
      case FieldType.radioButtons:
        return RadioButtonsInputField(
            label: label,
            value: fieldValue,
            options: options,
            onChange: onChange);
      case FieldType.select:
        return SelectDropdownInputField(
            label: label,
            value: fieldValue,
            options: options,
            onChange: onChange);
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('label', label));
    properties.add(EnumProperty<FieldType>('type', type));
    properties.add(StringProperty('defaultValue', defaultValue));
    properties.add(IterableProperty<String>('options', options));
    properties.add(DiagnosticsProperty<bool>('required', required));
  }
}
