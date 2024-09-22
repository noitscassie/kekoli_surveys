import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:kekoldi_surveys/constants/csv_export_types.dart';
import 'package:kekoldi_surveys/models/biodiversity_survey.dart';
import 'package:kekoldi_surveys/pages/error_details/error_details_page.dart';
import 'package:kekoldi_surveys/pages/export_survey/export_survey_page.dart';
import 'package:kekoldi_surveys/pages/home/home_page.dart';
import 'package:kekoldi_surveys/utils/biodiversity_csv_generator.dart';
import 'package:kekoldi_surveys/utils/email_sender_helper.dart';
import 'package:kekoldi_surveys/utils/file_util.dart';
import 'package:kekoldi_surveys/utils/time_utils.dart';
import 'package:open_file/open_file.dart';

class ExportBiodiversitySurveyPage extends StatefulWidget {
  final ExportType exportType;
  final BiodiversitySurvey survey;

  const ExportBiodiversitySurveyPage({
    super.key,
    required this.survey,
    required this.exportType,
  });

  @override
  State<ExportBiodiversitySurveyPage> createState() =>
      _ExportBiodiversitySurveyPageState();
}

class _ExportBiodiversitySurveyPageState
    extends State<ExportBiodiversitySurveyPage> {
  late final BiodiversityCsvGenerator _csvGenerator = BiodiversityCsvGenerator(
      exportType: widget.exportType, survey: widget.survey);
  late final FileUtil _fileUtil = FileUtil();

  Future<String> _generateFile() async {
    final csv = _csvGenerator.generate();

    final filename =
        '${widget.survey.trail.toLowerCase()}_survey_${DateFormats.ddmmyyyyNoBreaks(widget.survey.startAt!)}';

    final filepath =
        await _fileUtil.writeFileToDocuments(csv: csv, filename: filename);

    return filepath;
  }

  Future<void> _emailFile(String emailAddress) async {
    try {
      final filepath = await _generateFile();

      final Email email = Email(
        body: EmailSenderHelper.biodiversityBody(survey: widget.survey),
        subject:
            '${widget.survey.trail} Survey ${DateFormats.ddmmyyyy(widget.survey.startAt!)}',
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

  Future<void> _openFile() async {
    final filepath = await _generateFile();

    OpenFile.open(filepath);

    if (mounted) {
      const snackBar = SnackBar(
        duration: Duration(seconds: 2),
        content: Text('CSV downloaded to Files app'),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ExportSurveyPage(
      title: 'Export Survey Data',
      onSendEmail: _emailFile,
      onDownload: _openFile,
    );
  }
}
