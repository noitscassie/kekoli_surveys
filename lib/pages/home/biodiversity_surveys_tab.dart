import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/db/db.dart';
import 'package:kekoldi_surveys/models/biodiversity_survey.dart';
import 'package:kekoldi_surveys/pages/home/biodiversity_survey_tile.dart';
import 'package:kekoldi_surveys/widgets/fading_list_view.dart';

class BiodiversitySurveysTab extends StatelessWidget {
  final Db _db = Db();

  List<BiodiversitySurvey> get _surveys => _db
      .getBiodiversitySurveys()
      .sortedBy((BiodiversitySurvey survey) => survey.createdAt)
      .reversed
      .toList();

  BiodiversitySurveysTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FadingListView(
        top: false,
        bottom: true,
        padTop: false,
        children: List.from(
          _surveys.map(
            (survey) => BiodiversitySurveyTile(survey: survey),
          ),
        ),
      ),
    );
  }
}
