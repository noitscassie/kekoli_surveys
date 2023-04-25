import 'package:flutter/material.dart';

class RadioButtons extends StatelessWidget {
  final String selectedOption;
  final List<String> options;
  final Function(String value) onChange;

  const RadioButtons(
      {super.key,
      required this.options,
      required this.onChange,
      required this.selectedOption});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.from(options.map((option) => ListTile(
            onTap: () => onChange(option),
            title: Text(option),
            contentPadding: EdgeInsets.zero,
            leading: Radio<String?>(
              value: option,
              groupValue: selectedOption,
              onChanged: (String? value) {
                if (value == null) return;

                onChange(value);
              },
              activeColor: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ))),
    );
  }
}
