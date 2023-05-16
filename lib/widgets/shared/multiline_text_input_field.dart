import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/widgets/form_item.dart';

class MultilineTextInputField extends StatelessWidget {
  final String label;
  final String value;
  final Function(String value) onChange;

  const MultilineTextInputField(
      {super.key,
      required this.label,
      required this.value,
      required this.onChange});

  @override
  Widget build(BuildContext context) {
    return FormItem(
      label: label,
      child: TextFormField(
        initialValue: value,
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.sentences,
        minLines: 4,
        maxLines: 10,
        onChanged: onChange,
      ),
    );
  }
}
