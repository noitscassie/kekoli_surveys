import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/models/bird_survey.dart';
import 'package:kekoldi_surveys/models/bird_survey_segment.dart';
import 'package:kekoldi_surveys/pages/bird_segment/bird_segment_scaffold.dart';
import 'package:kekoldi_surveys/pages/choose_species/choose_bird_species_page.dart';

enum OverflowMenuOption {
  addObservation(label: 'Add Observation');

  const OverflowMenuOption({
    required this.label,
  });

  final String label;
}

class ViewBirdSegmentPage extends StatefulWidget {
  final BirdSurvey survey;
  final BirdSurveySegment segment;

  const ViewBirdSegmentPage({
    super.key,
    required this.survey,
    required this.segment,
  });

  @override
  State<ViewBirdSegmentPage> createState() => _ViewBirdSegmentPageState();
}

class _ViewBirdSegmentPageState extends State<ViewBirdSegmentPage> {
  void _handleOverflowMenuOptionTap(OverflowMenuOption option) {
    switch (option) {
      case OverflowMenuOption.addObservation:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => ChooseBirdSpeciesPage(
              survey: widget.survey,
              segment: widget.segment,
            ),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BirdSegmentScaffold(
      survey: widget.survey,
      segment: widget.segment,
      title:
          '${widget.survey.type.segmentName} ${widget.segment.name} Observations',
      actions: [
        PopupMenuButton<OverflowMenuOption>(
          onSelected: _handleOverflowMenuOptionTap,
          itemBuilder: (BuildContext otherContext) => OverflowMenuOption.values
              .map(
                (OverflowMenuOption option) => PopupMenuItem(
                  value: option,
                  child: Text(option.label),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
