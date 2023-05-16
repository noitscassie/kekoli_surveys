import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/widgets/form_item.dart';
import 'package:kekoldi_surveys/widgets/radio_buttons.dart';

class RadioButtonsInputField extends StatelessWidget {
  final String label;
  final String value;
  final List<String> options;
  final Function(String value) onChange;

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
      child: RadioButtons(
        options: options,
        onChange: onChange,
        selectedOption: value,
      ),
    );
  }
}
