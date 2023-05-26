import 'package:csv/csv.dart';
import 'package:dartx/dartx.dart';
import 'package:kekoldi_surveys/constants/csv_export_types.dart';
import 'package:kekoldi_surveys/constants/default_bird_sighting_fields.dart';
import 'package:kekoldi_surveys/constants/default_csv_columns.dart';
import 'package:kekoldi_surveys/models/bird_survey.dart';
import 'package:kekoldi_surveys/models/bird_survey_segment.dart';
import 'package:kekoldi_surveys/models/csv_column.dart';
import 'package:kekoldi_surveys/models/input_field_config.dart';
import 'package:kekoldi_surveys/models/sighting.dart';
import 'package:kekoldi_surveys/utils/bird_survey_segment_grouper.dart';
import 'package:kekoldi_surveys/utils/time_utils.dart';

class BirdCsvGenerator {
  final ExportType exportType;
  final BirdSurvey survey;

  BirdCsvGenerator({
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
          survey.type.segmentName,
          '${survey.type.segmentName} Start At',
          'Species',
          'Observed At',
          ..._dataFields,
        ];
      case ExportType.species:
        return [
          'Species',
          '${survey.type.segmentName}s',
        ];
    }
  }

  List<List<String>> get _sightingRows {
    switch (exportType) {
      case ExportType.formatted:
        return survey.type == BirdSurveyType.transect
            ? _formattedTransectSightingRows
            : _formattedPointCountSightingRows;
      case ExportType.raw:
        return _rawSightingRows;
      case ExportType.species:
        return survey.allSightings
            .map((Sighting sighting) => sighting.species)
            .distinct()
            .sorted()
            .map((String species) => [
                  species,
                  survey.segments
                      .where((BirdSurveySegment segment) => segment.sightings
                          .map((Sighting sighting) => sighting.species)
                          .contains(species))
                      .map((BirdSurveySegment segment) => segment.name)
                      .sorted()
                      .join(' ')
                ])
            .toList();
    }
  }

  List<List<String>> get _formattedTransectSightingRows => survey.segments
      .map(
        (segment) {
          final grouper = BirdSurveySegmentGrouper(segment);
          return grouper.groupsForTransect
              .map(
                (group) => [
                  segment.name,
                  segment.startAt != null
                      ? TimeFormats.timeHoursAndMinutes(segment.startAt!)
                      : '',
                  group.species,
                  '',
                  '',
                  '',
                  '',
                  '',
                  '',
                  '',
                  '',
                  group.lessThan30Count.toString(),
                  group.moreThan30Count.toString(),
                  group.flyoverCount.toString(),
                ],
              )
              .toList();
        },
      )
      .flatten()
      .toList();

  List<List<String>> get _formattedPointCountSightingRows => survey.segments
      .map(
        (segment) {
          final grouper = BirdSurveySegmentGrouper(segment);
          return grouper.groupsForPointCount
              .map(
                (group) => [
                  segment.name,
                  segment.startAt != null
                      ? TimeFormats.timeHoursAndMinutes(segment.startAt!)
                      : '',
                  group.species,
                  '',
                  '',
                  '',
                  '',
                  '',
                  '',
                  '',
                  '',
                  group.lessThan30Under3MinsCount.toString(),
                  group.moreThan30Under3MinsCount.toString(),
                  group.flyoverUnder3MinsCount.toString(),
                  group.lessThan30Over3MinsCount.toString(),
                  group.moreThan30Over3MinsCount.toString(),
                  group.flyoverOver3MinsCount.toString(),
                ],
              )
              .toList();
        },
      )
      .flatten()
      .toList();

  List<List<String>> get _rawSightingRows => survey.segments
      .map(
        (segment) => segment.sightings
            .sortedBy((sighting) => sighting.seenAt)
            .map(
              (sighting) => [
                segment.name,
                segment.startAt != null
                    ? TimeFormats.timeHoursAndMinutes(segment.startAt!)
                    : '',
                sighting.species,
                TimeFormats.timeHoursAndMinutes(sighting.seenAt),
                ...sighting.data.values.map((value) => value.toString()),
              ],
            )
            .toList(),
      )
      .flatten()
      .toList();

  List<CsvColumn> get _columns => survey.type == BirdSurveyType.transect
      ? defaultBirdTransectColumns
      : defaultBirdPointCountColumns;

  List<String> get _dataFields => defaultBirdSightingFields
      .map((InputFieldConfig field) => field.label)
      .toList();
}
