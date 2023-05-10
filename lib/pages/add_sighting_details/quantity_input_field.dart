import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/widgets/form_item.dart';

class QuantityInputField extends StatelessWidget {
  final String initialValue;
  final Function(String quantity) onChange;

  const QuantityInputField(
      {super.key, required this.onChange, required this.initialValue});

  @override
  Widget build(BuildContext context) {
    return FormItem(
      label: 'Quantity',
      child: TextFormField(
        initialValue: initialValue,
        keyboardType: TextInputType.number,
        onChanged: (String value) => onChange(value),
      ),
    );
  }
}
