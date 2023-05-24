import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/models/sighting.dart';
import 'package:kekoldi_surveys/pages/ongoing_survey/sighting_options_sheet.dart';
import 'package:kekoldi_surveys/widgets/shared/species_list_count_and_tallies.dart';

class SpeciesSightingsList extends StatefulWidget {
  final String json;
  final Function(List<Sighting> sightings) onEdit;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final List<Sighting> sightings;

  const SpeciesSightingsList(
      {super.key,
      required this.sightings,
      required this.onIncrement,
      required this.onDecrement,
      required this.json,
      required this.onEdit});

  @override
  State<SpeciesSightingsList> createState() => _SpeciesSightingsListState();
}

class _SpeciesSightingsListState extends State<SpeciesSightingsList> {
  late Sighting sighting = widget.sightings.last;

  Map<String, dynamic> get attributes => sighting.data;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showModalBottomSheet(
          context: context,
          builder: (BuildContext context) => SightingOptionsSheet(
              onIncrement: widget.onIncrement,
              onDecrement: widget.onDecrement,
              onEditMostRecent: () => widget.onEdit([widget.sightings.last]),
              onEditAll: () => widget.onEdit(widget.sightings))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sighting.attributesString,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Tap for options',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(fontStyle: FontStyle.italic),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SpeciesListCountAndTallies(
            count: widget.sightings.length.toString(),
            onIncrement: widget.onIncrement,
            onDecrement: widget.onDecrement,
          ),
        ],
      ),
    );
  }
}
