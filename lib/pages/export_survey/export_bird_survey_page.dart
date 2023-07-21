import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:kekoldi_surveys/constants/csv_export_types.dart';
import 'package:kekoldi_surveys/models/bird_survey.dart';
import 'package:kekoldi_surveys/pages/export_survey/export_survey_page.dart';
import 'package:kekoldi_surveys/pages/home/home_page.dart';
import 'package:kekoldi_surveys/utils/bird_csv_generator.dart';
import 'package:kekoldi_surveys/utils/email_sender_helper.dart';
import 'package:kekoldi_surveys/utils/file_util.dart';
import 'package:kekoldi_surveys/utils/time_utils.dart';
import 'package:open_file/open_file.dart';

class ExportBirdSurveyPage extends StatefulWidget {
  final ExportType exportType;
  final BirdSurvey survey;

  const ExportBirdSurveyPage({
    super.key,
    required this.survey,
    required this.exportType,
  });

  @override
  State<ExportBirdSurveyPage> createState() => _ExportBirdSurveyPageState();
}

class _ExportBirdSurveyPageState extends State<ExportBirdSurveyPage> {
  late final BirdCsvGenerator _csvGenerator =
      BirdCsvGenerator(exportType: widget.exportType, survey: widget.survey);
  late final FileUtil _fileUtil = FileUtil();

  Future<String> _generateFile() async {
    final csv = _csvGenerator.generate();

    final filename =
        'bird_${widget.survey.type.snakeCaseName}_${widget.survey.trail}_${DateFormats.ddmmyyyyNoBreaks(widget.survey.startAt!)}';

    final filepath =
        await _fileUtil.writeFileToDocuments(csv: csv, filename: filename);

    return filepath;
  }

  Future<void> generateAndEmailCsv(String emailAddress) async {
    final filepath = await _generateFile();

    final Email email = Email(
      body: EmailSenderHelper.birdSurveyBody(widget.survey),
      subject:
          'Bird ${widget.survey.type.title} ${widget.survey.trail} ${DateFormats.ddmmyyyy(widget.survey.startAt!)}',
      recipients: [emailAddress],
      attachmentPaths: [filepath],
    );

    FlutterEmailSender.send(email);

    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (BuildContext context) => const HomePage(
            initialTabIndex: 1,
          ),
        ),
        (route) => false,
      );
    }
  }

  Future<void> _openFile() async {
    final filepath = await _generateFile();

    OpenFile.open(filepath);
  }

  @override
  Widget build(BuildContext context) {
    return ExportSurveyPage(
      title: 'Export Survey Data',
      onSendEmail: generateAndEmailCsv,
      onDownload: _openFile,
    );
  }
}
