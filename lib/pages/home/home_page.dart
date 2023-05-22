import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/db/db.dart';
import 'package:kekoldi_surveys/models/survey.dart';
import 'package:kekoldi_surveys/pages/add_survey/add_survey_page.dart';
import 'package:kekoldi_surveys/pages/settings/settings_page.dart';
import 'package:kekoldi_surveys/widgets/page_scaffold.dart';
import 'package:kekoldi_surveys/widgets/survey_tile.dart';

class HomePage extends StatelessWidget {
  final Db _db = Db();

  HomePage({super.key});

  void _navigateToSettingsPage(BuildContext context) =>
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => const SettingsPage()));

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
        title: 'Surveys',
        actions: [
          IconButton(
              onPressed: () => _navigateToSettingsPage(context),
              icon: const Icon(Icons.settings))
        ],
        fabLabel: const Row(
          children: [Text('Create New Survey'), Icon(Icons.add)],
        ),
        onFabPress: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => const AddSurveyPage())),
        child: FutureBuilder<List<BiodiversitySurvey>>(
          future: _db.getBiodiveristySurveys(),
          builder: (BuildContext context,
              AsyncSnapshot<List<BiodiversitySurvey>> snapshot) {
            if (snapshot.hasData) {
              final surveys = snapshot.data!
                  .sortedBy((BiodiversitySurvey survey) => survey.createdAt)
                  .reversed;

              return Center(
                child: ListView(
                  children: List.from(
                      surveys.map((survey) => SurveyTile(survey: survey))),
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}
