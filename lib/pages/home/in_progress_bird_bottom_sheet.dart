import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/models/bird_survey.dart';
import 'package:kekoldi_surveys/pages/home/delete_bird_survey_modal.dart';
import 'package:kekoldi_surveys/widgets/bottom_sheet_options.dart';

class InProgressBirdBottomSheet extends StatelessWidget {
  final BirdSurvey survey;

  const InProgressBirdBottomSheet({super.key, required this.survey});

  @override
  Widget build(BuildContext context) {
    return BottomSheetOptions(
      options: [
        BottomSheetOption(
          text: 'View ${survey.type.prettyName}',
          onPress: () {
            // Navigator.of(context).pushAndRemoveUntil(
            //     MaterialPageRoute(
            //         builder: (BuildContext context) =>
            //             OngoingSurveyPage(survey: survey)),
            //         (route) => false);
          },
          leadingIcon: Icons.start,
        ),
        BottomSheetOption(
          text: 'Edit ${survey.type.prettyName}',
          onPress: () {
            // Navigator.of(context).pop();
            // Navigator.of(context).push(MaterialPageRoute(
            //     builder: (BuildContext context) =>
            //         EditSurveyPage(survey: survey)));
          },
          leadingIcon: Icons.edit,
        ),
        BottomSheetOption(
          text: 'Delete ${survey.type.prettyName}',
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
