import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/models/sighting.dart';
import 'package:kekoldi_surveys/utils/string_utils.dart';

class SightingListItem extends StatelessWidget {
  final Sighting sighting;

  const SightingListItem({super.key, required this.sighting});

  Map<String, String> get presentAttributes => sighting.displayAttributes
      .filter((entry) => entry.value != Sighting.unknown);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            sighting.species,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Text(
            sightingAttributesString(presentAttributes),
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(fontStyle: FontStyle.italic, fontSize: 12),
          ),
          if (sighting.data['comments']?.isNotEmpty == true)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                sighting.data['comments']!,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(fontStyle: FontStyle.italic, fontSize: 12),
              ),
            )
        ],
      ),
    );
  }
}
