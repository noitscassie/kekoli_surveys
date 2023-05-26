import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/constants/bird_species.dart';
import 'package:kekoldi_surveys/models/bird_survey.dart';
import 'package:kekoldi_surveys/models/bird_survey_segment.dart';
import 'package:kekoldi_surveys/pages/add_sighting_details/add_bird_sighting_details.dart';
import 'package:kekoldi_surveys/widgets/shared/species_selector.dart';

class ChooseBirdSpeciesPage extends StatelessWidget {
  final BirdSurvey survey;
  final BirdSurveySegment segment;

  const ChooseBirdSpeciesPage(
      {super.key, required this.survey, required this.segment});

  void navigateToAddDetails(BuildContext context, String species) =>
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => AddBirdSightingDetailsPage(
            survey: survey,
            segment: segment,
            species: species,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return SpeciesSelector(
      pageTitle: 'Choose a species',
      onSelect: (String species) => navigateToAddDetails(context, species),
      species: birdSpecies,
    );
  }
}
