import 'package:flutter/material.dart';

class ScribeInputField extends StatelessWidget {
  final Function(String value) onChange;

  const ScribeInputField({super.key, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: TextFormField(
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
    );
  }
}
