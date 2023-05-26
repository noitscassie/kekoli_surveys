import 'package:csv/csv.dart';
import 'package:dartx/dartx.dart';
import 'package:kekoldi_surveys/constants/csv_export_types.dart';
import 'package:kekoldi_surveys/constants/default_csv_columns.dart';
import 'package:kekoldi_surveys/models/biodiversity_survey.dart';
import 'package:kekoldi_surveys/models/csv_column.dart';
import 'package:kekoldi_surveys/models/input_field_config.dart';
import 'package:kekoldi_surveys/models/sighting.dart';

class BiodiversityCsvGenerator {
  final ExportType exportType;
  final BiodiversitySurvey survey;

  BiodiversityCsvGenerator({
    required this.exportType,
    required this.survey,
  });

  String generate() {
    final rows = [
      _headers,
      ..._sightingRows,
    ];

    return const ListToCsvConverter().convert(rows);
  }

  List<String> get _headers {
    switch (exportType) {
      case ExportType.formatted:
        return _columns.map((CsvColumn column) => column.header).toList();
      case ExportType.raw:
        return [
          'Species',
          ..._dataFields,
        ];
      case ExportType.species:
        return [
          'Species',
        ];
    }
  }

  List<List<String>> get _sightingRows {
    switch (exportType) {
      case ExportType.formatted:
        return survey.orderedSightings.map((Sighting sighting) {
          return _columns.map((CsvColumn column) {
            switch (column.field) {
              case speciesString:
                return sighting.species;
              default:
                return sighting.data[column.field]?.toString() ?? '';
            }
          }).toList();
        }).toList();
      case ExportType.raw:
        return survey.orderedSightings.map((Sighting sighting) {
          return [
            sighting.species,
            ..._dataFields
                .map((String field) => sighting.data[field]?.toString() ?? ''),
          ];
        }).toList();
      case ExportType.species:
        return survey.sightings
            .map((Sighting sighting) => sighting.species)
            .distinct()
            .sorted()
            .map((String species) => [species])
            .toList();
    }
  }

  List<CsvColumn> get _columns => survey.configuration.csvColumns;

  List<String> get _dataFields => survey.configuration.fields
      .map((InputFieldConfig field) => field.label)
      .toList();
}
