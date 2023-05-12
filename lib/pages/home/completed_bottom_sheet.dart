import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/models/survey.dart';
import 'package:kekoldi_surveys/pages/edit_survey/edit_survey_page.dart';
import 'package:kekoldi_surveys/pages/view_survey/view_survey_page.dart';
import 'package:kekoldi_surveys/widgets/bottom_sheet_options.dart';

class CompletedBottomSheet extends StatelessWidget {
  final Survey survey;

  const CompletedBottomSheet({super.key, required this.survey});

  @override
  Widget build(BuildContext context) {
    return BottomSheetOptions(
      options: [
        BottomSheetOption(
            text: 'View Survey',
            onPress: () => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        ViewSurveyPage(survey: survey)),
                (route) => false),
            leadingIcon: Icons.start,
            trailingIcon: Icons.arrow_right_alt),
        BottomSheetOption(
            text: 'Edit Survey',
            onPress: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) =>
                      EditSurveyPage(survey: survey)));
            },
            leadingIcon: Icons.edit,
            trailingIcon: Icons.arrow_right_alt),
      ],
    );
  }
}
