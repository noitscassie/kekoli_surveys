import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/constants/bird_species.dart';
import 'package:kekoldi_surveys/models/bird_survey.dart';
import 'package:kekoldi_surveys/models/bird_survey_segment.dart';
import 'package:kekoldi_surveys/models/sighting.dart';
import 'package:kekoldi_surveys/pages/edit_sighting_details/edit_bird_sighting_details_page.dart';
import 'package:kekoldi_surveys/widgets/shared/species_selector.dart';

class EditBirdSpeciesPage extends StatelessWidget {
  final List<Sighting> sightings;
  final BirdSurvey survey;
  final BirdSurveySegment segment;

  const EditBirdSpeciesPage({
    super.key,
    required this.survey,
    required this.sightings,
    required this.segment,
  });

  void _navigateToEditDetails(BuildContext context, String species) {
    for (var sighting in sightings) {
      sighting.update({'species': species});
    }

    segment.updateSightings(sightings);
    survey.updateSegment(segment);

    if (context.mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => EditBirdSightingDetailsPage(
            survey: survey,
            sightings: sightings,
            segment: segment,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SpeciesSelector(
      pageTitle: 'Choose a species',
      initialSearchTerm: sightings.last.species,
      onSelect: (String species) => _navigateToEditDetails(context, species),
      species: birdSpecies,
    );
  }
}
