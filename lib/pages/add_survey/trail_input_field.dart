import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/constants/trails.dart';
import 'package:kekoldi_surveys/widgets/form_item.dart';

class TrailInputField extends StatelessWidget {
  final String initialTrail;
  final Function(String value) onChange;

  const TrailInputField(
      {super.key, required this.onChange, required this.initialTrail});

  @override
  Widget build(BuildContext context) {
    return FormItem(
      label: 'Select a trail',
      child: DropdownButtonFormField<String>(
          value: initialTrail,
          items: List.from(trails.map((String trail) =>
              DropdownMenuItem(value: trail, child: Text(trail)))),
          onChanged: (String? newTrail) {
            if (newTrail != null) {
              onChange(newTrail);
            }
          }),
    );
  }
}
