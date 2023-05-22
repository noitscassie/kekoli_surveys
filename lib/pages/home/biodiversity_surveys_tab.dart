import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/db/db.dart';
import 'package:kekoldi_surveys/models/survey.dart';
import 'package:kekoldi_surveys/widgets/survey_tile.dart';

class BiodiversitySurveysTab extends StatelessWidget {
  final Db _db = Db();

  BiodiversitySurveysTab({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BiodiversitySurvey>>(
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
    );
  }
}
