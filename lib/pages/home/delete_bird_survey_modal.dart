import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/db/db.dart';
import 'package:kekoldi_surveys/models/bird_survey.dart';
import 'package:kekoldi_surveys/pages/home/home_page.dart';
import 'package:kekoldi_surveys/widgets/dialogs/danger_cta.dart';
import 'package:kekoldi_surveys/widgets/dialogs/dialog_scaffold.dart';

class DeleteBirdSurveyModal extends StatelessWidget {
  final BirdSurvey survey;

  final Db _db = Db();

  DeleteBirdSurveyModal({super.key, required this.survey});

  Future<void> _deleteSurvey(BuildContext context) async {
    await _db.deleteBirdSurvey(survey);

    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (BuildContext context) => const HomePage(
                    initialTabIndex: 1,
                  )),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DialogScaffold(
      title: 'Delete Bird ${survey.type.prettyName} ${survey.trail}?',
      primaryCta: DangerCta(
        text: 'Delete ${survey.type.prettyName}',
        onTap: () => _deleteSurvey(context),
      ),
      children: [
        Text(
            'Are you sure you want to delete this ${survey.type.prettyName.toLowerCase()}? This cannot be undone.')
      ],
    );
  }
}
