import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/constants/survey_state.dart';
import 'package:kekoldi_surveys/models/bird_survey.dart';
import 'package:kekoldi_surveys/models/bird_survey_segment.dart';
import 'package:kekoldi_surveys/models/sighting.dart';
import 'package:kekoldi_surveys/pages/add_sighting_details/add_bird_sighting_details.dart';
import 'package:kekoldi_surveys/pages/bird_segment/add_bird_tally_modal.dart';
import 'package:kekoldi_surveys/pages/bird_segment/confirm_segment_complete_modal.dart';
import 'package:kekoldi_surveys/pages/bird_segment/ongoing_bird_segment_page.dart';
import 'package:kekoldi_surveys/pages/bird_segment/remove_bird_tally_modal.dart';
import 'package:kekoldi_surveys/pages/bird_segment/unstarted_bird_segment_page.dart';
import 'package:kekoldi_surveys/pages/bird_segment/view_bird_segment_page.dart';
import 'package:kekoldi_surveys/pages/choose_species/choose_bird_species_page.dart';
import 'package:kekoldi_surveys/pages/edit_species/edit_bird_species_page.dart';
import 'package:kekoldi_surveys/widgets/shared/sighting_options_sheet.dart';

class BirdSegmentPage extends StatefulWidget {
  static const name = 'BirdSegmentPage';
  final BirdSurvey survey;
  final BirdSurveySegment segment;

  const BirdSegmentPage({
    super.key,
    required this.survey,
    required this.segment,
  });

  @override
  State<BirdSegmentPage> createState() => _BirdSegmentPageState();
}

class _BirdSegmentPageState extends State<BirdSegmentPage> {
  late BirdSurveySegment _statefulSegment = widget.segment;
  late Timer _timer;
  late Duration _timeElapsed =
      DateTime.now().difference(widget.segment.startAt!);

  void _completeSegment() => showDialog(
        context: context,
        builder: (BuildContext context) => ConfirmSegmentCompleteModal(
          survey: widget.survey,
          segment: _statefulSegment,
        ),
      );

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

  void _navigateToChooseSpeciesPage() => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => ChooseBirdSpeciesPage(
            survey: widget.survey,
            segment: widget.segment,
          ),
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

  void _updateSegmentDuration() => setState(
        () {
          _timeElapsed = DateTime.now().difference(_statefulSegment.startAt!);
        },
      );

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
    switch (widget.segment.state) {
      case SurveyState.unstarted:
        return UnstartedBirdSegmentPage(
          survey: widget.survey,
          segment: widget.segment,
        );
      case SurveyState.inProgress:
        return OngoingBirdSegmentPage(
          survey: widget.survey,
          segment: widget.segment,
        );
      case SurveyState.completed:
        return ViewBirdSegmentPage(
          survey: widget.survey,
          segment: widget.segment,
        );
    }
  }
}
