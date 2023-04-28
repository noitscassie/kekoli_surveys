import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/models/survey.dart';
import 'package:kekoldi_surveys/pages/choose_species/choose_species_page.dart';
import 'package:kekoldi_surveys/utils/date_formats.dart';

class OngoingSurveyPage extends StatelessWidget {
  final Survey survey;
  const OngoingSurveyPage({super.key, required this.survey});

  @override
  Widget build(BuildContext context) {
    print(survey.sightings);
    return Scaffold(
      appBar: AppBar(
          title: Text(
              '${survey.trail} Survey, ${DateFormats.ddmmyyyy(survey.startAt!)}')),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Padding(
            padding: EdgeInsets.only(top: 16),
            child: Center(
              child: Text(
                'Hello there',
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Row(
          children: const [Text('Add New Sighting'), Icon(Icons.add)],
        ),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) =>
                  ChooseSpeciesPage(survey: survey)));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
