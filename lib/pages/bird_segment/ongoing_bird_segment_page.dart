import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/models/bird_survey.dart';
import 'package:kekoldi_surveys/models/bird_survey_segment.dart';
import 'package:kekoldi_surveys/pages/bird_segment/bird_segment_scaffold.dart';
import 'package:kekoldi_surveys/pages/bird_segment/confirm_segment_complete_modal.dart';
import 'package:kekoldi_surveys/pages/choose_species/choose_bird_species_page.dart';
import 'package:kekoldi_surveys/utils/time_utils.dart';

class OngoingBirdSegmentPage extends StatefulWidget {
  static const name = 'OngoingBirdSegmentPage';
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
  late Timer _timer;
  late Duration _timeElapsed =
      DateTime.now().difference(widget.segment.startAt!);

  void _completeSegment() => showDialog(
        context: context,
        builder: (BuildContext context) => ConfirmSegmentCompleteModal(
          survey: widget.survey,
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

  void _updateSegmentDuration() => setState(
        () {
          _timeElapsed = DateTime.now().difference(widget.segment.startAt!);
        },
      );

  @override
  void initState() {
    super.initState();
    setState(() {
      _timer = Timer.periodic(
        const Duration(seconds: 1),
        (timer) => _updateSegmentDuration(),
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BirdSegmentScaffold(
      survey: widget.survey,
      segment: widget.segment,
      title:
          '${widget.survey.type.title} ${widget.segment.name} ${TimeFormats.timeMinutesAndSeconds(_timeElapsed)}',
      fabLabel: const Row(
        children: [
          Text('Add New Bird'),
          Icon(Icons.add),
        ],
      ),
      onFabPress: _navigateToChooseSpeciesPage,
      actions: [
        IconButton(
          onPressed: _completeSegment,
          icon: const Icon(Icons.check),
        )
      ],
    );
  }
}
