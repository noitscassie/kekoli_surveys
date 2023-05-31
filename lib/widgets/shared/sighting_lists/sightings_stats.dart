import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/models/sighting.dart';
import 'package:kekoldi_surveys/widgets/data_tile.dart';

class SightingsStats extends StatelessWidget {
  final List<Sighting> sightings;

  const SightingsStats({
    super.key,
    required this.sightings,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        DataTile(
          data: sightings.length.toString(),
          label: 'Total Observations',
        ),
        DataTile(
          data: sightings
              .map((Sighting sighting) => sighting.species)
              .distinct()
              .length
              .toString(),
          label: 'Unique Species',
        ),
      ],
    );
  }
}
