import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/models/survey.dart';

class SurveysTab extends StatelessWidget {
  final Function(Survey survey) onCreateSurvey;

  const SurveysTab({super.key, required this.onCreateSurvey});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(),
    );
  }
}
