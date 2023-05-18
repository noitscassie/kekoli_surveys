import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/models/sighting.dart';
import 'package:kekoldi_surveys/widgets/bottom_sheet_options.dart';

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
    return InkWell(
      onTap: () => showModalBottomSheet(
          context: context,
          builder: (BuildContext context) => BottomSheetOptions(options: [
                BottomSheetOption(
                    text: 'Add Tally',
                    leadingIcon: Icons.exposure_plus_1,
                    onPress: () {
                      Navigator.of(context).pop();
                      widget.onIncrement();
                    }),
                BottomSheetOption(
                    text: 'Remove Tally',
                    leadingIcon: Icons.exposure_minus_1,
                    onPress: () {
                      Navigator.of(context).pop();
                      widget.onDecrement();
                    }),
                BottomSheetOption(
                    text: 'Edit Most Recent',
                    leadingIcon: Icons.edit,
                    onPress: () {
                      Navigator.of(context).pop();
                      widget.onEdit([widget.sightings.last]);
                    }),
                BottomSheetOption(
                    text: 'Edit All',
                    leadingIcon: Icons.all_inclusive,
                    onPress: () {
                      Navigator.of(context).pop();
                      widget.onEdit(widget.sightings);
                    }),
              ])),
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
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _modifyTallyIcon(
                      icon: Icons.exposure_minus_1, onTap: widget.onDecrement),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: CircleAvatar(
                        radius: 25,
                        child: Text(
                          widget.sightings.length.toString(),
                          style: Theme.of(context).textTheme.headlineSmall,
                        )),
                  ),
                  _modifyTallyIcon(
                      icon: Icons.exposure_plus_1, onTap: widget.onIncrement),
                ],
              ),
              Text(
                'Count',
                style: Theme.of(context).textTheme.bodySmall,
              )
            ],
          )
        ],
      ),
    );
  }
}
