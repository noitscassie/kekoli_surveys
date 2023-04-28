import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/constants/heights.dart';
import 'package:kekoldi_surveys/widgets/form_item.dart';

class HeightInputField extends StatelessWidget {
  final String currentHeight;
  final Function(String height) onChange;

  const HeightInputField(
      {super.key, required this.currentHeight, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return FormItem(
      label: 'Height',
      child: DropdownButtonFormField<String>(
          value: currentHeight,
          items: List.from(heights.map((String height) =>
              DropdownMenuItem(value: height, child: Text(height)))),
          onChanged: (String? newHeight) {
            if (newHeight == null) return;

            onChange(newHeight);
          }),
    );
  }
}
