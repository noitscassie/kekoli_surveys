import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/widgets/form_item.dart';

class SelectDropdownInputField extends StatelessWidget {
  final String label;
  final String value;
  final List<String> options;
  final Function(String value) onChange;

  const SelectDropdownInputField({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return FormItem(
      label: label,
      child: DropdownButtonFormField<String>(
          value: value,
          items: options
              .map((String option) =>
                  DropdownMenuItem(value: option, child: Text(option)))
              .toList(),
          onChanged: (String? newValue) {
            if (newValue == null) return;

            onChange(newValue);
          }),
    );
  }
}
