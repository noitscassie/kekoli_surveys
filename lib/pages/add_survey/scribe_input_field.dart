import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/widgets/form_item.dart';

class ScribeInputField extends StatelessWidget {
  final String value;
  final Function(String value) onChange;

  const ScribeInputField(
      {super.key, required this.onChange, required this.value});

  @override
  Widget build(BuildContext context) {
    return FormItem(
      label: 'Add a scribe',
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: TextFormField(
          initialValue: value,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            border: const UnderlineInputBorder(),
            labelText: 'Scribe',
            labelStyle: Theme.of(context).textTheme.bodySmall,
          ),
          onChanged: (String value) {
            onChange(value);
          },
        ),
      ),
    );
  }
}
