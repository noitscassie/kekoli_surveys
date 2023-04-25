import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/constants/trails.dart';
import 'package:kekoldi_surveys/widgets/form_item.dart';

class TrailInputField extends StatelessWidget {
  final Function(String value) onChange;

  TrailInputField({super.key, required this.onChange});

  final String selectedTrail = trails[0];

  @override
  Widget build(BuildContext context) {
    return FormItem(
      label: 'Select a trail',
      child: DropdownButtonFormField<String>(
          value: selectedTrail,
          items: List.from(trails.map((String trail) =>
              DropdownMenuItem(value: trail, child: Text(trail)))),
          onChanged: (String? newTrail) {
            onChange(newTrail!);
          }),
    );
  }
}
