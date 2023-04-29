import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/models/survey.dart';
import 'package:kekoldi_surveys/pages/choose_species/choose_species_page.dart';
import 'package:kekoldi_surveys/utils/date_formats.dart';
import 'package:kekoldi_surveys/widgets/page_scaffold.dart';

class OngoingSurveyPage extends StatelessWidget {
  final Survey survey;
  const OngoingSurveyPage({super.key, required this.survey});

  void navigateToChooseSpeciesPage(BuildContext context) =>
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) =>
              ChooseSpeciesPage(survey: survey)));

  @override
  Widget build(BuildContext context) {
    print(survey.sightings);
    return PageScaffold(
        title:
            '${survey.trail} Survey, ${DateFormats.ddmmyyyy(survey.startAt!)}',
        fabLabel: Row(
          children: const [Text('Add New Sighting'), Icon(Icons.add)],
        ),
        onFabPress: () => navigateToChooseSpeciesPage(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView(
              shrinkWrap: true,
              children: List.from(survey.sightings
                  .map((sighting) => Text(sighting.species.name))),
            ),
          ],
        ));
  }
}
