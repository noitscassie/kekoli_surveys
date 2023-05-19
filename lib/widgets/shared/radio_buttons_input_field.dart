import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/widgets/form_item.dart';
import 'package:kekoldi_surveys/widgets/radio_buttons.dart';

class RadioButtonsInputField<T> extends StatelessWidget {
  final String label;
  final T value;
  final List<RadioButtonOption<T>> options;
  final Function(T value) onChange;

  const RadioButtonsInputField(
      {super.key,
      required this.label,
      required this.value,
      required this.options,
      required this.onChange});

  @override
  Widget build(BuildContext context) {
    return FormItem(
      label: label,
      child: RadioButtons<T>(
        options: options,
        onChange: onChange,
        selectedOption: value,
      ),
    );
  }
}
