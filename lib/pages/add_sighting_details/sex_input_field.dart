import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/widgets/form_item.dart';
import 'package:kekoldi_surveys/widgets/radio_buttons.dart';

class SexInputField extends StatelessWidget {
  final String currentSex;
  final Function(String height) onChange;

  const SexInputField(
      {super.key, required this.onChange, required this.currentSex});

  @override
  Widget build(BuildContext context) {
    return FormItem(
      label: 'Sex',
      child: RadioButtons(
        options: const ['Female', 'Male', 'Mixed', 'Unknown'],
        onChange: (String value) => onChange(value),
        selectedOption: currentSex,
      ),
    );
  }
}
