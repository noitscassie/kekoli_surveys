import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/db/db.dart';
import 'package:kekoldi_surveys/models/survey.dart';
import 'package:kekoldi_surveys/pages/add_survey/add_survey_page.dart';
import 'package:kekoldi_surveys/widgets/page_scaffold.dart';
import 'package:kekoldi_surveys/widgets/survey_tile.dart';

class HomePage extends StatelessWidget {
  final Db _db = Db();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
        title: 'Surveys',
        fabLabel: const Row(
          children: [Text('Create New Survey'), Icon(Icons.add)],
        ),
        onFabPress: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => const AddSurveyPage())),
        child: FutureBuilder<List<Survey>>(
          future: _db.getSurveys(),
          builder:
              (BuildContext context, AsyncSnapshot<List<Survey>> snapshot) {
            if (snapshot.hasData) {
              final surveys = snapshot.data as List<Survey>;

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
