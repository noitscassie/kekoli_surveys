import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/models/biodiversity_survey.dart';
import 'package:kekoldi_surveys/models/sighting.dart';
import 'package:kekoldi_surveys/widgets/shared/add_tally_modal.dart';

class AddBiodiversityTallyModal extends StatelessWidget {
  final BiodiversitySurvey survey;
  final Sighting sighting;
  final Function(BiodiversitySurvey survey) onChangeSurvey;

  const AddBiodiversityTallyModal({
    super.key,
    required this.survey,
    required this.sighting,
    required this.onChangeSurvey,
  });

  void _onConfirm(int quantity) {
    final sightings = List.generate(quantity, (_) => sighting.duplicate());

    survey.addSightings(sightings);
    onChangeSurvey(survey);
  }

  @override
  Widget build(BuildContext context) {
    return AddTallyModal(
      sighting: sighting,
      onConfirm: _onConfirm,
      fields: survey.configuration.fields,
    );
  }
}
