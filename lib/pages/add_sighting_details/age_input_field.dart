import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/widgets/form_item.dart';
import 'package:kekoldi_surveys/widgets/radio_buttons.dart';

class AgeInputField extends StatelessWidget {
  final String currentAge;
  final Function(String observationType) onChange;

  const AgeInputField(
      {super.key, required this.onChange, required this.currentAge});

  @override
  Widget build(BuildContext context) {
    return FormItem(
      label: 'Age',
      child: RadioButtons(
        options: const ['Adult', 'Juvenile', 'Unknown'],
        onChange: (String value) => onChange(value),
        selectedOption: currentAge,
      ),
    );
  }
}
