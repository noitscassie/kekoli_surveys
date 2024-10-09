import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/db/db.dart';
import 'package:kekoldi_surveys/models/biodiversity_survey.dart';
import 'package:kekoldi_surveys/pages/home/home_page.dart';
import 'package:kekoldi_surveys/widgets/dialogs/danger_cta.dart';
import 'package:kekoldi_surveys/widgets/dialogs/dialog_scaffold.dart';

class DeleteBiodiversitySurveyModal extends StatelessWidget {
  final Db _db = Db();
  final BiodiversitySurvey survey;

  DeleteBiodiversitySurveyModal({super.key, required this.survey});

  void _deleteSurvey(BuildContext context) {
    _db.deleteBiodiversitySurvey(survey);

    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (BuildContext context) => const HomePage(),
          ),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DialogScaffold(
      title: 'Delete ${survey.trail} survey?',
      primaryCta: DangerCta(
        text: 'Delete Survey',
        onTap: () => _deleteSurvey(context),
      ),
      children: const [
        Text(
            'Are you sure you want to delete this survey? This cannot be undone.')
      ],
    );
  }
}
