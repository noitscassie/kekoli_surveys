import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/utils/email_sender_helper.dart';
import 'package:kekoldi_surveys/widgets/page_scaffold.dart';

class ExportSurveyPage extends StatefulWidget {
  final String title;
  final Function(String email) onSendEmail;

  const ExportSurveyPage({
    super.key,
    required this.title,
    required this.onSendEmail,
  });

  @override
  State<ExportSurveyPage> createState() => _ExportSurveyPageState();
}

class _ExportSurveyPageState extends State<ExportSurveyPage> {
  String emailAddress = '';

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: widget.title,
      fabLabel: const Row(
        children: [
          Text('Send Email'),
          Icon(Icons.email),
        ],
      ),
      isFabValid: EmailSenderHelper.isEmailValid(emailAddress),
      onFabPress: () => widget.onSendEmail(emailAddress),
      child: Column(children: [
        Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
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
