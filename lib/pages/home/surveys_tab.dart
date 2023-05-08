import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/db/db.dart';
import 'package:kekoldi_surveys/models/survey.dart';
import 'package:kekoldi_surveys/widgets/survey_tile.dart';

class SurveysTab extends StatelessWidget {
  final Db _db = Db();

  SurveysTab({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Survey>>(
      future: _db.getSurveys(),
      builder: (BuildContext context, AsyncSnapshot<List<Survey>> snapshot) {
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
    );
  }
}
