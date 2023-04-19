import 'package:flutter/material.dart';

class SurveyFormField extends StatelessWidget {
  final String labelText;
  final Function(String text) onConfirmation;

  final TextEditingController _controller = TextEditingController();

  SurveyFormField(
      {super.key, required this.labelText, required this.onConfirmation});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: _controller,
        decoration: InputDecoration(
            border: const UnderlineInputBorder(),
            suffixIcon: IconButton(
              icon: const Icon(Icons.check),
              onPressed: () {
                onConfirmation(_controller.text);
              },
            ),
            labelText: labelText,
            labelStyle: Theme.of(context).textTheme.bodySmall));
  }
}
