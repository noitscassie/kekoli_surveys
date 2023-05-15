import 'dart:convert';

import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/models/sighting.dart';
import 'package:kekoldi_surveys/utils/string_utils.dart';
import 'package:kekoldi_surveys/widgets/bottom_sheet_options.dart';

class SpeciesSightingsList extends StatelessWidget {
  final String json;
  final VoidCallback onEdit;
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

  Map<String, dynamic> get attributes => jsonDecode(json);

  Map<String, dynamic> get presentAttributes =>
      attributes.filter((entry) => entry.value != Sighting.unknown);

  String get attributeString =>
      sightingAttributesString(presentAttributes, includeComments: true);

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
                    attributeString,
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
                      icon: Icons.exposure_minus_1, onTap: onDecrement),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: CircleAvatar(
                        radius: 25,
                        child: Text(
                          sightings.length.toString(),
                          style: Theme.of(context).textTheme.headlineSmall,
                        )),
                  ),
                  _modifyTallyIcon(
                      icon: Icons.exposure_plus_1, onTap: onIncrement),
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
