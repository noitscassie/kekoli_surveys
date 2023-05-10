import 'dart:io';

import 'package:csv/csv.dart';
import 'package:kekoldi_surveys/models/sighting.dart';
import 'package:kekoldi_surveys/models/survey.dart';
import 'package:kekoldi_surveys/utils/time_utils.dart';
import 'package:path_provider/path_provider.dart';

class CsvUtil {
  static Future<String> generateFromSurvey(Survey survey) async {
    final headers = [
      'Species',
      '#',
      'Height',
      'Substrate',
      'Sex',
      'Adult/Juvenile',
      'Type of Obs'
    ];

    final sightingRows = survey.sightings.map((Sighting sighting) => [
          sighting.species,
          sighting.quantity,
          sighting.height,
          sighting.substrate,
          sighting.sex,
          sighting.age,
          sighting.observationType,
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

    final thing = file.readAsStringSync();
    print(thing);

    return file.path;
  }
}
