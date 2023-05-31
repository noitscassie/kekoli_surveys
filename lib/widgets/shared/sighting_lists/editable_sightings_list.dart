import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/models/sighting.dart';
import 'package:kekoldi_surveys/widgets/data_tile.dart';
import 'package:kekoldi_surveys/widgets/expandable_list/expandable_list_item.dart';
import 'package:kekoldi_surveys/widgets/fading_list_view.dart';
import 'package:kekoldi_surveys/widgets/shared/species_list_count_and_tallies.dart';

enum ViewStyle {
  chronological(label: 'Sort chronologically'),
  groupedBySpecies(label: 'Sort by species');

  const ViewStyle({required this.label});

  final String label;
}

class EditableSightingsList extends StatefulWidget {
  final List<Sighting> sightings;
  final Function(List<Sighting> sightings) onOptionsTap;
  final Function(Sighting sighting) onIncrement;
  final Function(List<Sighting> sightings) onDecrement;
  final Function(String species) onAddNew;

  const EditableSightingsList({
    super.key,
    required this.sightings,
    required this.onOptionsTap,
    required this.onIncrement,
    required this.onDecrement,
    required this.onAddNew,
  });

  @override
  State<EditableSightingsList> createState() => _EditableSightingsListState();
}

class _EditableSightingsListState extends State<EditableSightingsList> {
  ViewStyle _selectedViewStyle = ViewStyle.groupedBySpecies;

  void _onSelectSort(ViewStyle? viewStyle) {
    if (viewStyle != null) {
      setState(() {
        _selectedViewStyle = viewStyle;
      });
    }
  }

  List<ExpandableListItem> get _groupedBySpecies => [
        ...widget.sightings
            .groupBy((sighting) => sighting.species)
            .entries
            .sortedBy((entry) => entry.key)
            .mapIndexed(
              (index, entry) => ExpandableListItem(
                title: entry.key,
                children: [
                  ...entry.value
                      .groupBy((sighting) => sighting.attributesString)
                      .entries
                      .sortedBy((entry) => entry.key)
                      .map(
                        (entry) => ExpandableListItemChild(
                          title: entry.key,
                          subtitle: 'Tap for options',
                          onTap: () => widget.onOptionsTap(entry.value),
                          trailing: SpeciesListCountAndTallies(
                            count: entry.value.length.toString(),
                            onIncrement: () =>
                                widget.onIncrement(entry.value.last),
                            onDecrement: () => widget.onDecrement(entry.value),
                          ),
                        ),
                      ),
                  ExpandableListItemChild(
                    title: 'Add new ${entry.key} observation',
                    trailing: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Icon(Icons.add),
                    ),
                    onTap: () => widget.onAddNew(entry.key),
                  ),
                ],
              ),
            )
      ];

  List<ExpandableListItem> get _chronological => [
        ...widget.sightings.sortedBy((sighting) => sighting.seenAt).mapIndexed(
              (int index, Sighting sighting) => ExpandableListItem(
                title: sighting.species,
                subtitle: sighting.attributesString,
              ),
            )
      ];

  List<ExpandableListItem> get _sightingsList {
    switch (_selectedViewStyle) {
      case ViewStyle.chronological:
        return _chronological;
      case ViewStyle.groupedBySpecies:
        return _groupedBySpecies;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            DataTile(
              data: widget.sightings.length.toString(),
              label: 'Total Observations',
            ),
            DataTile(
              data: widget.sightings
                  .map((Sighting sighting) => sighting.species)
                  .distinct()
                  .length
                  .toString(),
              label: 'Unique Species',
            ),
          ],
        ),
        if (widget.sightings.isNotEmpty)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              DropdownMenu<ViewStyle>(
                initialSelection: _selectedViewStyle,
                trailingIcon: const Icon(Icons.sort),
                onSelected: _onSelectSort,
                menuStyle:
                    const MenuStyle(visualDensity: VisualDensity.standard),
                textStyle: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontStyle: FontStyle.italic),
                dropdownMenuEntries: [
                  ...ViewStyle.values.map(
                    (ViewStyle viewStyle) => DropdownMenuEntry(
                      value: viewStyle,
                      label: viewStyle.label,
                    ),
                  ),
                ],
              )
            ],
          ),
        Expanded(
          child: FadingListView(
            children: _sightingsList,
          ),
        ),
      ],
    );
  }
}
