import 'dart:io';

import 'package:csv/csv.dart';
import 'package:kekoldi_surveys/constants/columns.dart';
import 'package:kekoldi_surveys/models/sighting.dart';
import 'package:kekoldi_surveys/models/survey.dart';
import 'package:kekoldi_surveys/utils/time_utils.dart';
import 'package:path_provider/path_provider.dart';

class CsvUtil {
  static Future<String> generateFromSurvey(Survey survey) async {
    final headers = columns;

    // empty rows match auto-populated fields on the google sheet
    final sightingRows = survey.sightings.map((Sighting sighting) => [
          sighting.species,
          '',
          '',
          '',
          '',
          '',
          '',
          '',
          sighting.data['quantity'],
          sighting.data['height'],
          sighting.data['substrate'],
          sighting.data['sex'],
          sighting.data['age'],
          sighting.data['observationType'],
        ]);

    final rows = [
      headers,
      ...sightingRows,
    ];

    String csv = const ListToCsvConverter().convert(rows);

    final Directory directory = await getApplicationDocumentsDirectory();

    final directoryPath = directory.path;

    final filename =
        '${survey.trail.toLowerCase()}_survey_${DateFormats.ddmmyyyyNoBreaks(survey.startAt!)}';

    final filepath = '$directoryPath/$filename.csv';

    final file = File(filepath);

    file.createSync(recursive: true);
    await file.writeAsString(csv);

    return file.path;
  }
}
