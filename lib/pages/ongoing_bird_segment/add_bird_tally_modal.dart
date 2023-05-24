import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/constants/default_bird_sighting_fields.dart';
import 'package:kekoldi_surveys/models/bird_survey.dart';
import 'package:kekoldi_surveys/models/bird_survey_segment.dart';
import 'package:kekoldi_surveys/models/sighting.dart';
import 'package:kekoldi_surveys/widgets/shared/add_tally_modal.dart';

class AddBirdTallyModal extends StatelessWidget {
  final BirdSurvey survey;
  final BirdSurveySegment segment;
  final Sighting sighting;
  final Function(BirdSurvey survey) onChangeSurvey;

  const AddBirdTallyModal({
    super.key,
    required this.survey,
    required this.segment,
    required this.sighting,
    required this.onChangeSurvey,
  });

  void _onConfirm(int quantity) {
    final sightings = List.generate(quantity, (_) => sighting.duplicate());

    segment.addSightings(sightings);
    survey.updateSegment(segment);
    onChangeSurvey(survey);
  }

  @override
  Widget build(BuildContext context) {
    return AddTallyModal(
      sighting: sighting,
      onConfirm: _onConfirm,
      fields: defaultBirdSightingFields,
    );
  }
}
