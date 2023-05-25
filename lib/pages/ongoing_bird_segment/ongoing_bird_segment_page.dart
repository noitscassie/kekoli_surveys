import 'dart:async';

import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/models/bird_survey.dart';
import 'package:kekoldi_surveys/models/bird_survey_segment.dart';
import 'package:kekoldi_surveys/models/sighting.dart';
import 'package:kekoldi_surveys/pages/choose_species/choose_bird_species_page.dart';
import 'package:kekoldi_surveys/pages/edit_species/edit_bird_species_page.dart';
import 'package:kekoldi_surveys/pages/ongoing_bird_segment/add_bird_tally_modal.dart';
import 'package:kekoldi_surveys/pages/ongoing_bird_segment/remove_bird_tally_modal.dart';
import 'package:kekoldi_surveys/pages/ongoing_survey/sighting_options_sheet.dart';
import 'package:kekoldi_surveys/utils/time_utils.dart';
import 'package:kekoldi_surveys/widgets/expandable_list/expandable_list_item.dart';
import 'package:kekoldi_surveys/widgets/page_scaffold.dart';
import 'package:kekoldi_surveys/widgets/shared/species_list_count_and_tallies.dart';

class OngoingBirdSegmentPage extends StatefulWidget {
  final BirdSurvey survey;
  final BirdSurveySegment segment;

  const OngoingBirdSegmentPage({
    super.key,
    required this.survey,
    required this.segment,
  });

  @override
  State<OngoingBirdSegmentPage> createState() => _OngoingBirdSegmentPageState();
}

class _OngoingBirdSegmentPageState extends State<OngoingBirdSegmentPage> {
  late BirdSurveySegment _statefulSegment = widget.segment;
  late Timer _timer;
  Duration _timeElapsed = Duration.zero;

  void _completeSegment() {}

  void _updateSegment(BirdSurveySegment segment) => setState(() {
        _statefulSegment = segment;
      });

  void _onIncrement(Sighting sighting) => showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AddBirdTallyModal(
            sighting: sighting,
            survey: widget.survey,
            onChangeSegment: _updateSegment,
            segment: widget.segment,
          ));

  void _onDecrement(List<Sighting> sightings) => showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => RemoveBirdTallyModal(
            survey: widget.survey,
            sightings: sightings,
            onChangeSegment: _updateSegment,
            segment: widget.segment,
          ));

  void _navigateToChooseSpeciesPage() =>
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => ChooseBirdSpeciesPage(
              survey: widget.survey, segment: widget.segment)));

  void _onEdit(List<Sighting> sightings) => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => EditBirdSpeciesPage(
            survey: widget.survey,
            sightings: sightings,
            segment: widget.segment,
          ),
        ),
      );

  void _showBottomSheet(List<Sighting> sightings) => showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => SightingOptionsSheet(
            onIncrement: () => _onIncrement(sightings.last),
            onDecrement: () => _onDecrement(sightings),
            onEditMostRecent: () => _onEdit([sightings.last]),
            onEditAll: () => _onEdit(sightings),
          ));

  void _updateSegmentDuration() => setState(() {
        _timeElapsed = DateTime.now().difference(_statefulSegment.startAt!);
      });

  @override
  void initState() {
    super.initState();
    setState(() {
      _timer = Timer.periodic(
          const Duration(seconds: 1), (timer) => _updateSegmentDuration());
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title:
          '${widget.survey.type.title} ${widget.segment.name} ${TimeFormats.timeMinutesAndSeconds(_timeElapsed)}',
      fabLabel: const Row(
        children: [
          Text('Add New Bird'),
          Icon(Icons.add),
        ],
      ),
      onFabPress: _navigateToChooseSpeciesPage,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 100),
        child: ListView(
          children: [
            ...widget.segment.sightings
                .groupBy((sighting) => sighting.species)
                .entries
                .sortedBy((entry) => entry.key)
                .mapIndexed(
                  (index, entry) => ExpandableListItem(
                    title: entry.key,
                    children: List.from(
                      entry.value
                          .groupBy((sighting) => sighting.attributesString)
                          .entries
                          .sortedBy((entry) => entry.key)
                          .map(
                            (entry) => ExpandableListItemChild(
                                title: entry.key,
                                subtitle: 'Tap for options',
                                onTap: () => _showBottomSheet(entry.value),
                                trailing: SpeciesListCountAndTallies(
                                  count: entry.value.length.toString(),
                                  onIncrement: () =>
                                      _onIncrement(entry.value.last),
                                  onDecrement: () => _onDecrement(entry.value),
                                )),
                          ),
                    ),
                  ),
                )
          ],
        ),
      ),
    );
  }
}
