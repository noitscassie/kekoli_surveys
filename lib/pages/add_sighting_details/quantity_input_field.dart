import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/widgets/form_item.dart';

class QuantityInputField extends StatelessWidget {
  final Function(int? quantity) onChange;

  const QuantityInputField({super.key, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return FormItem(
      label: 'Quantity',
      child: TextFormField(
        keyboardType: TextInputType.number,
        onChanged: (String value) =>
            onChange(value.isEmpty ? null : value.toInt()),
      ),
    );
  }
}
