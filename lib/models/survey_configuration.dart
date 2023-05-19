import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:kekoldi_surveys/constants/default_csv_columns.dart';
import 'package:kekoldi_surveys/constants/default_survey_fields.dart';
import 'package:kekoldi_surveys/models/csv_column.dart';
import 'package:kekoldi_surveys/models/input_field_config.dart';

final defaultSurveyConfiguration =
    SurveyConfiguration(defaultSurveyFields, defaultCsvColumns);

class SurveyConfiguration with DiagnosticableTreeMixin {
  List<InputFieldConfig> fields;
  List<CsvColumn> csvColumns;

  SurveyConfiguration(this.fields, this.csvColumns);

  SurveyConfiguration.fromJson(Map<String, dynamic> json)
      : fields = List<InputFieldConfig>.from(json['fields'].map((field) =>
            InputFieldConfig.fromJson(
                field.runtimeType == String ? jsonDecode(field) : field))),
        csvColumns = List<CsvColumn>.from(json['csvColumns'].map((column) =>
            CsvColumn.fromJson(
                column.runtimeType == String ? jsonDecode(column) : column)));

  String toJson() => jsonEncode(attributes);

  Map<String, dynamic> get attributes => {
        'fields':
            fields.map((InputFieldConfig field) => field.toJson()).toList(),
        'csvColumns':
            csvColumns.map((CsvColumn column) => column.toJson()).toList(),
      };

  Map<String, String> get asAttributes =>
      {for (var config in fields) config.label: config.defaultValue};
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty<InputFieldConfig>('fields', fields));
  }
}
