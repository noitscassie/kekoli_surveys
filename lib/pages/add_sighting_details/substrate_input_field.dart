import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/constants/substrates.dart';
import 'package:kekoldi_surveys/widgets/form_item.dart';

class SubstrateInputField extends StatelessWidget {
  final String currentSubstrate;
  final Function(String observationType) onChange;

  const SubstrateInputField(
      {super.key, required this.onChange, required this.currentSubstrate});

  @override
  Widget build(BuildContext context) {
    return FormItem(
      label: 'Substrate',
      child: DropdownButtonFormField<String>(
          value: currentSubstrate,
          items: List.from(substrates.sorted().map((String substrate) =>
              DropdownMenuItem(value: substrate, child: Text(substrate)))),
          onChanged: (String? newSubstrate) {
            if (newSubstrate == null) return;

            onChange(newSubstrate);
          }),
    );
  }
}
