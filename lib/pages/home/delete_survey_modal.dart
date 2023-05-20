import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/db/db.dart';
import 'package:kekoldi_surveys/models/survey.dart';
import 'package:kekoldi_surveys/pages/home/home_page.dart';

class DeleteSurveyModal extends StatelessWidget {
  final Db _db = Db();
  final Survey survey;

  DeleteSurveyModal({super.key, required this.survey});

  Future<void> _deleteSurvey(BuildContext context) async {
    await _db.deleteSurvey(survey);

    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => HomePage()),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Delete ${survey.trail} survey?',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text(
                'Are you sure you want to delete this survey? This cannot be undone.',
              ),
            ),
          ]),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Back',
            )),
        ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    Theme.of(context).colorScheme.error)),
            onPressed: () => _deleteSurvey(context),
            child: Text(
              'Delete Survey',
              style: TextStyle(color: Theme.of(context).colorScheme.surface),
            )),
      ],
    );
  }
}
