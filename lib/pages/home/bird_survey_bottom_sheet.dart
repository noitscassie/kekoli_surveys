import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/models/bird_survey.dart';
import 'package:kekoldi_surveys/pages/bird_survey/ongoing_bird_survey_page.dart';
import 'package:kekoldi_surveys/pages/edit_bird_survey/edit_bird_survey_page.dart';
import 'package:kekoldi_surveys/pages/home/delete_bird_survey_modal.dart';
import 'package:kekoldi_surveys/widgets/bottom_sheet_options.dart';

class BirdSurveyBottomSheet extends StatelessWidget {
  final BirdSurvey survey;

  const BirdSurveyBottomSheet({
    super.key,
    required this.survey,
  });

  @override
  Widget build(BuildContext context) {
    return BottomSheetOptions(
      options: [
        BottomSheetOption(
          text: 'View ${survey.type.title}',
          onPress: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(
              MaterialPageRoute(
                settings: const RouteSettings(name: OngoingBirdSurveyPage.name),
                builder: (BuildContext context) =>
                    OngoingBirdSurveyPage(survey: survey),
              ),
            );
          },
          leadingIcon: Icons.start,
        ),
        BottomSheetOption(
          text: 'Edit ${survey.type.title}',
          onPress: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) =>
                    EditBirdSurveyPage(survey: survey),
              ),
            );
          },
          leadingIcon: Icons.edit,
        ),
        BottomSheetOption(
          text: 'Delete ${survey.type.title}',
          onPress: () {
            Navigator.of(context).pop();
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) =>
                    DeleteBirdSurveyModal(survey: survey));
          },
          leadingIcon: Icons.delete_forever,
        ),
      ],
    );
  }
}
