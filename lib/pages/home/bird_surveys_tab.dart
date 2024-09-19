import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/db/db.dart';
import 'package:kekoldi_surveys/models/bird_survey.dart';
import 'package:kekoldi_surveys/pages/home/bird_survey_tile.dart';
import 'package:kekoldi_surveys/widgets/fading_list_view.dart';

class BirdSurveysTab extends StatelessWidget {
  final Db _db = Db();

  List<BirdSurvey> get _surveys => _db
      .getBirdSurveys()
      .sortedBy((BirdSurvey survey) => survey.createdAt)
      .reversed
      .toList();

  BirdSurveysTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FadingListView(
        top: false,
        bottom: true,
        padTop: false,
        children:
            List.from(_surveys.map((survey) => BirdSurveyTile(survey: survey))),
      ),
    );
  }
}
