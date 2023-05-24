import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/constants/default_bird_sighting_fields.dart';
import 'package:kekoldi_surveys/models/bird_survey.dart';
import 'package:kekoldi_surveys/models/bird_survey_segment.dart';
import 'package:kekoldi_surveys/models/sighting.dart';
import 'package:kekoldi_surveys/widgets/shared/remove_tally_modal.dart';

class RemoveBirdTallyModal extends StatelessWidget {
  final BirdSurvey survey;
  final BirdSurveySegment segment;
  final List<Sighting> sightings;
  final Function(BirdSurveySegment segment) onChangeSegment;

  const RemoveBirdTallyModal({
    super.key,
    required this.survey,
    required this.sightings,
    required this.onChangeSegment,
    required this.segment,
  });

  Sighting get sighting => sightings.last;

  void _onConfirm(BuildContext context) {
    segment.removeSighting(sighting);
    survey.updateSegment(segment);
    onChangeSegment(segment);
  }

  @override
  Widget build(BuildContext context) {
    return RemoveTallyModal(
      sightings: sightings,
      fields: defaultBirdSightingFields,
      onConfirm: () => _onConfirm(context),
    );
  }
}
