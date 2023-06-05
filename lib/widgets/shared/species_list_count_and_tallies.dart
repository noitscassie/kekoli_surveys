import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/widgets/shared/hero_quantity.dart';
import 'package:kekoldi_surveys/widgets/shared/modify_tally_icon.dart';

class SpeciesListCountAndTallies extends StatelessWidget {
  final String count;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const SpeciesListCountAndTallies({
    super.key,
    required this.count,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ModifyTallyIcon(
              icon: Icons.exposure_minus_1,
              onTap: onDecrement,
            ),
            // HeroQuantity(quantity: count),
            Padding(
              padding: const EdgeInsets.all(8),
              child: HeroQuantity(
                quantity: count,
              ),
            ),
            ModifyTallyIcon(
              icon: Icons.exposure_plus_1,
              onTap: onIncrement,
            ),
          ],
        ),
        Text(
          'Count',
          style: Theme.of(context).textTheme.bodySmall,
        )
      ],
    );
  }
}
