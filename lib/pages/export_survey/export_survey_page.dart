import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:kekoldi_surveys/models/survey.dart';
import 'package:kekoldi_surveys/utils/csv_util.dart';
import 'package:kekoldi_surveys/utils/time_utils.dart';
import 'package:kekoldi_surveys/widgets/page_scaffold.dart';

class ExportSurveyPage extends StatefulWidget {
  final Survey survey;

  const ExportSurveyPage({super.key, required this.survey});

  @override
  State<ExportSurveyPage> createState() => _ExportSurveyPageState();
}

class _ExportSurveyPageState extends State<ExportSurveyPage> {
  String emailAddress = '';

  final emailRegex = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

  bool get isEmailValid => emailRegex.hasMatch(emailAddress);

  Future<void> generateAndEmailCsv() async {
    final filepath = await CsvUtil.generateFromSurvey(widget.survey);

    final Email email = Email(
      body: 'Hi from Cassie ✨',
      subject:
          '${widget.survey.trail} Survey ${DateFormats.ddmmyyyy(widget.survey.startAt!)}',
      recipients: [emailAddress],
      attachmentPaths: [filepath],
    );

    FlutterEmailSender.send(email);

    if (context.mounted) {
      final snackBar = SnackBar(
        content: Text('Email sent to $emailAddress'),
        duration: const Duration(seconds: 5),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: 'Export Survey Data',
      fabLabel: const Row(
        children: [Text('Send Email'), Icon(Icons.email)],
      ),
      isFabValid: isEmailValid,
      onFabPress: generateAndEmailCsv,
      child: Column(children: [
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextFormField(
                autofocus: true,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  border: const UnderlineInputBorder(),
                  labelText: 'Email Address',
                  labelStyle: Theme.of(context).textTheme.bodySmall,
                ),
                onChanged: (String value) {
                  setState(() {
                    emailAddress = value;
                  });
                },
              ),
            ))
      ]),
    );
  }
}
