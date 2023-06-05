import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/widgets/bottom_sheet_options.dart';

class SightingOptionsSheet extends StatelessWidget {
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onEditMostRecent;
  final VoidCallback onEditAll;

  const SightingOptionsSheet({
    super.key,
    required this.onIncrement,
    required this.onDecrement,
    required this.onEditMostRecent,
    required this.onEditAll,
  });

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
          text: 'Edit Most Recent',
          leadingIcon: Icons.edit,
          onPress: () {
            Navigator.of(context).pop();
            onEditMostRecent();
          }),
      BottomSheetOption(
          text: 'Edit All',
          leadingIcon: Icons.all_inclusive,
          onPress: () {
            Navigator.of(context).pop();
            onEditAll();
          }),
    ]);
  }
}
