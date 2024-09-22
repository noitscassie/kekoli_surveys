import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:kekoldi_surveys/pages/error_details/error_details_page.dart';
import 'package:kekoldi_surveys/pages/home/home_page.dart';
import 'package:kekoldi_surveys/utils/email_sender_helper.dart';
import 'package:kekoldi_surveys/widgets/page_scaffold.dart';
import 'package:kekoldi_surveys/widgets/text_header.dart';
import 'package:path_provider/path_provider.dart';

class ExportAllPage extends StatefulWidget {
  const ExportAllPage({super.key});

  @override
  State<ExportAllPage> createState() => _ExportAllPageState();
}

class _ExportAllPageState extends State<ExportAllPage> {
  String emailAddress = '';

  Future<void> _emailFile() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filepath = '${directory.path}/kekoldi_surveys.json';

      final Email email = Email(
        body: 'Survey data attached',
        subject: 'Kèköldi Survey Data Export',
        recipients: [emailAddress],
        attachmentPaths: [filepath],
      );

      FlutterEmailSender.send(email);

      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (BuildContext context) => const HomePage(),
          ),
          (route) => false,
        );
      }
    } catch (e, s) {
      if (mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => ErrorDetailsPage(
              exception: e,
              stacktrace: s,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold.withScrollableChildren(
      title: 'Export All Data',
      header: const TextHeader(
          text: 'Enter an email address to export all the raw survey data.'),
      fabLabel: const Row(
        children: [
          Text('Send Email'),
          Icon(Icons.email),
        ],
      ),
      isFabValid: EmailSenderHelper.isEmailValid(emailAddress),
      onFabPress: _emailFile,
      children: [
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
          ),
        ),
      ],
    );
  }
}
