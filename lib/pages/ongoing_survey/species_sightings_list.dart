import 'dart:convert';

import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/models/sighting.dart';

class SpeciesSightingsList extends StatelessWidget {
  final String json;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final List<Sighting> sightings;

  const SpeciesSightingsList(
      {super.key,
      required this.sightings,
      required this.onIncrement,
      required this.onDecrement,
      required this.json});

  Map<String, dynamic> get attributes => jsonDecode(json);

  Map<String, dynamic> get presentAttributes =>
      attributes.filter((entry) => entry.value != Sighting.unknown);

  String get attributeString {
    final quantity = presentAttributes[Sighting.quantityTitle];
    final location = [
      presentAttributes[Sighting.heightTitle],
      presentAttributes[Sighting.substrateTitle],
    ].whereNotNull().join(' ');
    final sex = presentAttributes[Sighting.sexTitle];
    final observation = presentAttributes[Sighting.observationTitle];
    final age = presentAttributes[Sighting.ageTitle];

    return [quantity, location, sex, age, observation]
        .whereNotNull()
        .join(', ');
  }

  Widget _totalTallyCount(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: CircleAvatar(
                  radius: 25,
                  child: Text(
                    sightings.length.toString(),
                    style: Theme.of(context).textTheme.headlineSmall,
                  )),
            ),
          ],
        ),
      );

  Widget _modifyTallyIcon(
          {required VoidCallback onTap, required IconData icon}) =>
      InkWell(
        onTap: onTap,
        child: CircleAvatar(
            radius: 15,
            child: Icon(
              icon,
              size: 15,
            )),
      );

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: Text(
            attributeString,
          ),
        ),
        Column(
          // key: Key('${widget.speciesName}_${index}_tally'),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _modifyTallyIcon(
                    onTap: onDecrement, icon: Icons.exposure_minus_1),
                _totalTallyCount(context),
                _modifyTallyIcon(
                    onTap: onIncrement, icon: Icons.exposure_plus_1),
              ],
            ),
            Text(
              'Count',
              style: Theme.of(context).textTheme.bodySmall,
            )
          ],
        )
      ],
    );
  }
}
