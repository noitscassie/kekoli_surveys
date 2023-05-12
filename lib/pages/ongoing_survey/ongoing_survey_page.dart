import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/models/sighting.dart';
import 'package:kekoldi_surveys/models/survey.dart';
import 'package:kekoldi_surveys/pages/choose_species/choose_species_page.dart';
import 'package:kekoldi_surveys/pages/ongoing_survey/complete_survey_modal.dart';
import 'package:kekoldi_surveys/pages/ongoing_survey/sighting_tile.dart';
import 'package:kekoldi_surveys/utils/time_utils.dart';
import 'package:kekoldi_surveys/widgets/page_scaffold.dart';

class OngoingSurveyPage extends StatefulWidget {
  final Survey survey;

  const OngoingSurveyPage({super.key, required this.survey});

  @override
  State<OngoingSurveyPage> createState() => _OngoingSurveyPageState();
}

class _OngoingSurveyPageState extends State<OngoingSurveyPage> {
  late Survey statefulSurvey = widget.survey;

  void navigateToChooseSpeciesPage(BuildContext context) =>
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) =>
              ChooseSpeciesPage(survey: statefulSurvey)));

  Map<String, List<Sighting>> get groupedSightings =>
      widget.survey.sightings.groupBy((sighting) => sighting.species);

  void onCompleteSurvey() => showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => CompleteSurveyModal(
            survey: widget.survey,
            onChangeSurvey: updateSurvey,
          ));

  void updateSurvey(Survey survey) {
    setState(() {
      statefulSurvey = survey;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title:
          '${statefulSurvey.trail} Survey, ${DateFormats.ddmmyyyy(statefulSurvey.startAt!)}',
      fabLabel: const Row(
        children: [Text('Add New Sighting'), Icon(Icons.add)],
      ),
      onFabPress: () => navigateToChooseSpeciesPage(context),
      actions: [
        IconButton(onPressed: onCompleteSurvey, icon: const Icon(Icons.check))
      ],
      child: Padding(
        padding: const EdgeInsets.only(bottom: 100),
        child: ListView(children: [
          ...groupedSightings.entries.sortedBy((entry) => entry.key).map(
                (group) => SightingTile(
                  speciesName: group.key,
                  sightings: group.value,
                  survey: statefulSurvey,
                  onChangeSurvey: (Survey survey) => updateSurvey(survey),
                ),
              )
        ]),
      ),
    );
  }
}
