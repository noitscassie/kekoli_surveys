import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/db/db.dart';
import 'package:kekoldi_surveys/models/biodiversity_survey.dart';
import 'package:kekoldi_surveys/pages/home/biodiversity_survey_tile.dart';
import 'package:kekoldi_surveys/widgets/fading_list_view.dart';

class BiodiversitySurveysTab extends StatelessWidget {
  final Db _db = Db();

  BiodiversitySurveysTab({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BiodiversitySurvey>>(
      future: _db.getBiodiversitySurveys(),
      builder: (BuildContext context,
          AsyncSnapshot<List<BiodiversitySurvey>> snapshot) {
        if (snapshot.hasData) {
          final surveys = snapshot.data!
              .sortedBy((BiodiversitySurvey survey) => survey.createdAt)
              .reversed;

          return Center(
            child: FadingListView(
              top: false,
              bottom: true,
              padTop: false,
              children: List.from(surveys
                  .map((survey) => BiodiversitySurveyTile(survey: survey))),
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
