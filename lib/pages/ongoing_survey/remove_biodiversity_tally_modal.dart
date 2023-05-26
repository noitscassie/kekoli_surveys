import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/models/biodiversity_survey.dart';
import 'package:kekoldi_surveys/models/sighting.dart';
import 'package:kekoldi_surveys/widgets/shared/remove_tally_modal.dart';

class RemoveBiodiversityTallyModal extends StatelessWidget {
  final BiodiversitySurvey survey;
  final List<Sighting> sightings;
  final Function(BiodiversitySurvey survey) onChangeSurvey;

  const RemoveBiodiversityTallyModal(
      {super.key,
      required this.survey,
      required this.sightings,
      required this.onChangeSurvey});

  Sighting get sighting => sightings.last;

  void _onConfirm(BuildContext context) {
    survey.removeSighting(sighting);
    onChangeSurvey(survey);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return RemoveTallyModal(
      sightings: sightings,
      fields: survey.configuration.fields,
      onConfirm: () => _onConfirm(context),
    );
  }
}
