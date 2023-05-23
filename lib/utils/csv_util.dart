import 'package:csv/csv.dart';
import 'package:kekoldi_surveys/constants/default_csv_columns.dart';
import 'package:kekoldi_surveys/models/biodiversity_survey.dart';
import 'package:kekoldi_surveys/models/csv_column.dart';
import 'package:kekoldi_surveys/models/input_field_config.dart';
import 'package:kekoldi_surveys/models/sighting.dart';

enum ExportType {
  formatted,
  raw,
  species,
}

class CsvUtil {
  final ExportType exportType;

  CsvUtil(this.exportType);

  String generate(BiodiversitySurvey survey) {
    final rows = [
      _headers(survey),
      ..._sightingRows(survey),
    ];

    return const ListToCsvConverter().convert(rows);
  }

  List<String> _headers(BiodiversitySurvey survey) {
    switch (exportType) {
      case ExportType.formatted:
        return _columns(survey)
            .map((CsvColumn column) => column.header)
            .toList();
      case ExportType.raw:
        return [
          'Species',
          ..._dataFields(survey),
        ];
      case ExportType.species:
        return [
          'Species',
        ];
    }
  }

  List<List<String>> _sightingRows(BiodiversitySurvey survey) {
    switch (exportType) {
      case ExportType.formatted:
        return survey.orderedSightings.map((Sighting sighting) {
          return _columns(survey).map((CsvColumn column) {
            if (column.field == speciesString) {
              return sighting.species;
            } else {
              return sighting.data[column.field]?.toString() ?? '';
            }
          }).toList();
        }).toList();
      case ExportType.raw:
        return survey.orderedSightings.map((Sighting sighting) {
          return [
            sighting.species,
            ..._dataFields(survey)
                .map((String field) => sighting.data[field]?.toString() ?? ''),
          ];
        }).toList();
      case ExportType.species:
        return survey.orderedSightings
            .map((Sighting sighting) => [sighting.species])
            .toList();
    }
  }

  List<CsvColumn> _columns(BiodiversitySurvey survey) =>
      survey.configuration.csvColumns;

  List<String> _dataFields(BiodiversitySurvey survey) =>
      survey.configuration.fields
          .map((InputFieldConfig field) => field.label)
          .toList();
}
