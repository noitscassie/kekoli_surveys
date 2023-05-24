import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/models/biodiversity_survey.dart';
import 'package:kekoldi_surveys/pages/add_sighting_details/add_sighting_details_page.dart';
import 'package:kekoldi_surveys/widgets/shared/species_selector.dart';

class ChooseSpeciesPage extends StatelessWidget {
  final BiodiversitySurvey survey;

  const ChooseSpeciesPage({super.key, required this.survey});

  void navigateToAddDetails(BuildContext context, String species) =>
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => AddSightingDetailsPage(
                survey: survey,
                species: species,
              )));

  @override
  Widget build(BuildContext context) {
    return SpeciesSelector(
        pageTitle: 'Choose a species',
        onSelect: (String species) => navigateToAddDetails(context, species));
  }
}
