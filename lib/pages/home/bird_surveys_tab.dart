import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/db/db.dart';
import 'package:kekoldi_surveys/models/bird_survey.dart';
import 'package:kekoldi_surveys/pages/home/bird_survey_tile.dart';

class BirdSurveysTab extends StatelessWidget {
  final Db _db = Db();

  BirdSurveysTab({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BirdSurvey>>(
      future: _db.getBirdSurveys(),
      builder:
          (BuildContext context, AsyncSnapshot<List<BirdSurvey>> snapshot) {
        if (snapshot.hasData) {
          final surveys = snapshot.data!
              .sortedBy((BirdSurvey survey) => survey.createdAt)
              .reversed;

          return Center(
            child: ListView(
              children: List.from(
                  surveys.map((survey) => BirdSurveyTile(survey: survey))),
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
