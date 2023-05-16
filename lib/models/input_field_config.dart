import 'package:flutter/cupertino.dart';
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

class InputFieldConfig {
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
}
