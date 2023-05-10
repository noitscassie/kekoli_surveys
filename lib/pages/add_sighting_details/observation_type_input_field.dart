import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/widgets/form_item.dart';
import 'package:kekoldi_surveys/widgets/radio_buttons.dart';

class ObservationTypeInputField extends StatelessWidget {
  final String currentObservationType;
  final Function(String observationType) onChange;

  const ObservationTypeInputField(
      {super.key,
      required this.onChange,
      required this.currentObservationType});

  @override
  Widget build(BuildContext context) {
    return FormItem(
      label: 'Type Of Observation',
      child: RadioButtons(
        options: const ['Audio', 'Audio + Visual', 'Visual'],
        onChange: (String value) => onChange(value),
        selectedOption: currentObservationType,
      ),
    );
  }
}
