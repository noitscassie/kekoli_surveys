import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/widgets/bottom_sheet_options.dart';

class SightingOptionsSheet extends StatelessWidget {
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onEdit;

  const SightingOptionsSheet(
      {super.key,
      required this.onIncrement,
      required this.onDecrement,
      required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return BottomSheetOptions(options: [
      BottomSheetOption(
          text: 'Add Tally',
          leadingIcon: Icons.exposure_plus_1,
          onPress: () {
            Navigator.of(context).pop();
            onIncrement();
          }),
      BottomSheetOption(
          text: 'Remove Tally',
          leadingIcon: Icons.exposure_minus_1,
          onPress: () {
            Navigator.of(context).pop();
            onDecrement();
          }),
      BottomSheetOption(
          text: 'Edit',
          leadingIcon: Icons.edit,
          onPress: () {
            Navigator.of(context).pop();
            onEdit();
          }),
    ]);
  }
}
