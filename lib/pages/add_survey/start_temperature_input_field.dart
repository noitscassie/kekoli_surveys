import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/widgets/form_item.dart';

class StartTemperatureInputField extends StatelessWidget {
  final String value;
  final Function(String value) onChange;

  const StartTemperatureInputField({
    super.key,
    required this.onChange,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return FormItem(
      label: 'Start Temperature (℃)',
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: TextFormField(
          initialValue: value,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: const UnderlineInputBorder(),
            labelText: 'Temperature',
            labelStyle: Theme.of(context).textTheme.bodySmall,
          ),
          onChanged: onChange,
        ),
      ),
    );
  }
}
