import 'package:csv/csv.dart';
import 'package:dartx/dartx.dart';
import 'package:kekoldi_surveys/constants/csv_export_types.dart';
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
                  _stringNumberOrEmpty(group.lessThan30Count),
                  _stringNumberOrEmpty(group.moreThan30Count),
                  _stringNumberOrEmpty(group.flyoverCount),
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
                  _stringNumberOrEmpty(group.lessThan30Under3MinsCount),
                  _stringNumberOrEmpty(group.moreThan30Under3MinsCount),
                  _stringNumberOrEmpty(group.flyoverUnder3MinsCount),
                  _stringNumberOrEmpty(group.lessThan30Over3MinsCount),
                  _stringNumberOrEmpty(group.moreThan30Over3MinsCount),
                  _stringNumberOrEmpty(group.flyoverOver3MinsCount),
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

  List<CsvColumn> get _columns => survey.configuration.csvColumns;

  List<String> get _dataFields => survey.configuration.fields
      .map((InputFieldConfig field) => field.label)
      .toList();

  String _stringNumberOrEmpty(int count) => count == 0 ? '' : count.toString();
}
