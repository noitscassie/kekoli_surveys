import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/constants/species.dart';
import 'package:kekoldi_surveys/models/biodiversity_survey.dart';
import 'package:kekoldi_surveys/models/sighting.dart';
import 'package:kekoldi_surveys/pages/edit_sighting_details/edit_biodiversity_sighting_details_page.dart';
import 'package:kekoldi_surveys/widgets/shared/species_selector.dart';

class EditBiodiversitySpeciesPage extends StatelessWidget {
  final List<Sighting> sightings;
  final BiodiversitySurvey survey;

  const EditBiodiversitySpeciesPage({
    super.key,
    required this.survey,
    required this.sightings,
  });

  void navigateToEditDetails(BuildContext context, String species) async {
    for (var sighting in sightings) {
      sighting.update({'species': species});
    }

    await survey.updateSightings(sightings);

    if (context.mounted) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) =>
              EditBiodiversitySightingDetailsPage(
                survey: survey,
                sightings: sightings,
              )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SpeciesSelector(
      pageTitle: 'Choose a species',
      initialSearchTerm: sightings.last.species,
      onSelect: (String species) => navigateToEditDetails(context, species),
      species: biodiversitySpecies,
    );
  }
}
