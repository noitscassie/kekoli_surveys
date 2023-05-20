import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/models/survey.dart';
import 'package:kekoldi_surveys/pages/edit_survey/edit_survey_page.dart';
import 'package:kekoldi_surveys/pages/home/delete_survey_modal.dart';
import 'package:kekoldi_surveys/pages/ongoing_survey/ongoing_survey_page.dart';
import 'package:kekoldi_surveys/widgets/bottom_sheet_options.dart';

class UnstartedBottomSheet extends StatelessWidget {
  final Survey survey;

  const UnstartedBottomSheet({super.key, required this.survey});

  @override
  Widget build(BuildContext context) {
    return BottomSheetOptions(
      options: [
        BottomSheetOption(
          text: 'Start Survey',
          onPress: () {
            survey.start();
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        OngoingSurveyPage(survey: survey)),
                (route) => false);
          },
          leadingIcon: Icons.start,
        ),
        BottomSheetOption(
          text: 'Edit Survey',
          onPress: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) =>
                    EditSurveyPage(survey: survey)));
          },
          leadingIcon: Icons.edit,
        ),
        BottomSheetOption(
          text: 'Delete Survey',
          onPress: () {
            Navigator.of(context).pop();
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) =>
                    DeleteSurveyModal(survey: survey));
          },
          leadingIcon: Icons.delete_forever,
        ),
      ],
    );
  }
}
