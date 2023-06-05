import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/models/bird_survey.dart';
import 'package:kekoldi_surveys/models/bird_survey_segment.dart';
import 'package:kekoldi_surveys/models/sighting.dart';
import 'package:kekoldi_surveys/pages/add_sighting_details/add_bird_sighting_details.dart';
import 'package:kekoldi_surveys/pages/bird_segment/add_bird_tally_modal.dart';
import 'package:kekoldi_surveys/pages/bird_segment/remove_bird_tally_modal.dart';
import 'package:kekoldi_surveys/pages/edit_species/edit_bird_species_page.dart';
import 'package:kekoldi_surveys/widgets/page_scaffold.dart';
import 'package:kekoldi_surveys/widgets/shared/sighting_lists/sightings_list.dart';
import 'package:kekoldi_surveys/widgets/shared/sighting_lists/sightings_stats.dart';
import 'package:kekoldi_surveys/widgets/shared/sighting_options_sheet.dart';

class BirdSegmentScaffold extends StatefulWidget {
  final BirdSurvey survey;
  final BirdSurveySegment segment;
  final String title;
  final Widget? fabLabel;
  final VoidCallback? onFabPress;
  final List<Widget> actions;

  const BirdSegmentScaffold({
    super.key,
    required this.survey,
    required this.segment,
    required this.title,
    this.fabLabel,
    this.onFabPress,
    this.actions = const [],
  });

  @override
  State<BirdSegmentScaffold> createState() => _BirdSegmentScaffoldState();
}

class _BirdSegmentScaffoldState extends State<BirdSegmentScaffold> {
  late BirdSurveySegment _statefulSegment = widget.segment;

  void _updateSegment(BirdSurveySegment segment) => setState(
        () {
          _statefulSegment = segment;
        },
      );

  void _onIncrement(Sighting sighting) => showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => AddBirdTallyModal(
          sighting: sighting,
          survey: widget.survey,
          onChangeSegment: _updateSegment,
          segment: widget.segment,
        ),
      );

  void _onDecrement(List<Sighting> sightings) => showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => RemoveBirdTallyModal(
          survey: widget.survey,
          sightings: sightings,
          onChangeSegment: _updateSegment,
          segment: widget.segment,
        ),
      );

  void _navigateToAddSightingDetailsPage(String species) =>
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => AddBirdSightingDetailsPage(
            survey: widget.survey,
            segment: _statefulSegment,
            species: species,
          ),
        ),
      );

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
        ),
      );

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: widget.title,
      fabLabel: widget.fabLabel,
      onFabPress: widget.onFabPress,
      actions: widget.actions,
      child: SightingsList.editable(
        sightings: _statefulSegment.sightings,
        header: SightingsStats(
          sightings: _statefulSegment.sightings,
        ),
        onOptionsTap: _showBottomSheet,
        onIncrement: _onIncrement,
        onDecrement: _onDecrement,
        onAddNew: _navigateToAddSightingDetailsPage,
      ),
    );
  }
}
