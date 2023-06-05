import 'dart:convert';

import 'package:dartx/dartx.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:kekoldi_surveys/widgets/radio_buttons.dart';
import 'package:kekoldi_surveys/widgets/shared/multifield_text_input_field.dart';
import 'package:kekoldi_surveys/widgets/shared/multiline_text_input_field.dart';
import 'package:kekoldi_surveys/widgets/shared/number_input_field.dart';
import 'package:kekoldi_surveys/widgets/shared/radio_buttons_input_field.dart';
import 'package:kekoldi_surveys/widgets/shared/select_dropdown_input_field.dart';
import 'package:kekoldi_surveys/widgets/shared/text_input_field.dart';
import 'package:uuid/uuid.dart';

enum FieldType {
  text,
  multilineText,
  number,
  radioButtons,
  select,
  multifieldText,
}

class InputFieldConfig<T> with DiagnosticableTreeMixin {
  final String id;
  String label;
  FieldType type;
  dynamic defaultValue;
  List<String?> options;
  bool required;
  bool sortOptions;
  String newItemText;
  int? maxItems;

  static const typesRequiringOptions = [
    FieldType.radioButtons,
    FieldType.select
  ];

  InputFieldConfig.text(
      {required this.label, this.defaultValue = '', this.required = false})
      : type = FieldType.text,
        options = [],
        sortOptions = true,
        newItemText = '',
        id = const Uuid().v4();

  InputFieldConfig.multilineText(
      {required this.label, this.defaultValue = '', this.required = false})
      : type = FieldType.multilineText,
        options = [],
        sortOptions = true,
        newItemText = '',
        id = const Uuid().v4();

  InputFieldConfig.number(
      {required this.label, this.defaultValue = '1', this.required = false})
      : type = FieldType.number,
        options = [],
        sortOptions = true,
        newItemText = '',
        id = const Uuid().v4();

  InputFieldConfig.radioButtons(
      {required this.label,
      required this.options,
      this.defaultValue = '',
      this.required = false,
      this.sortOptions = true})
      : type = FieldType.radioButtons,
        newItemText = '',
        id = const Uuid().v4();

  InputFieldConfig.select(
      {required this.label,
      required this.options,
      this.defaultValue = '',
      this.required = false,
      this.sortOptions = true})
      : type = FieldType.select,
        newItemText = '',
        id = const Uuid().v4();

  InputFieldConfig.multifieldText({
    required this.label,
    required this.newItemText,
    this.defaultValue = const [''],
    this.required = false,
    this.maxItems,
  })  : type = FieldType.multifieldText,
        options = [],
        sortOptions = true,
        id = const Uuid().v4();

  InputFieldConfig.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        label = json['label'],
        type = FieldType.values.byName(json['type']),
        defaultValue = json['defaultValue'],
        options = List<String>.from(
          (json['options'] ?? []).where((option) => option != null),
        ),
        required = json['required'],
        sortOptions = json['sortOptions'] ?? true,
        newItemText = json['newItemText'] ?? '';

  bool get requiresOptions => typesRequiringOptions.contains(type);

  String toJson() => jsonEncode(attributes);

  Map<String, dynamic> get attributes => {
        'id': id,
        'label': label,
        'type': type.name,
        'defaultValue': defaultValue,
        'options': options,
        'required': required,
        'sortOptions': sortOptions,
        'newItemText': newItemText,
      };

  Widget inputField(
      {required Function(dynamic value) onChange, dynamic value}) {
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
        return RadioButtonsInputField<String>(
          label: label,
          value: fieldValue,
          options: (sortOptions ? options.whereNotNull().sorted() : options)
              .whereNotNull()
              .map((value) => value.toString())
              .map((String value) =>
                  RadioButtonOption(value: value, label: value))
              .toList(),
          onChange: onChange,
        );
      case FieldType.select:
        return SelectDropdownInputField(
          label: label,
          value: fieldValue,
          options: (sortOptions ? options.whereNotNull().sorted() : options)
              .whereNotNull()
              .toList(),
          onChange: onChange,
        );
      case FieldType.multifieldText:
        return MultifieldTextInputField(
          label: label,
          value: fieldValue,
          onChange: onChange,
          newItemText: newItemText,
          maxItems: maxItems,
        );
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('label', label));
    properties.add(EnumProperty<FieldType>('type', type));
    properties.add(StringProperty('defaultValue', defaultValue));
    properties.add(IterableProperty<String>('options', options.whereNotNull()));
    properties.add(DiagnosticsProperty<bool>('required', required));
    properties.add(StringProperty('id', id));
  }
}
