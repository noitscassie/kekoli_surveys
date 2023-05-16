import 'package:dartx/dartx.dart';
import 'package:kekoldi_surveys/constants/heights.dart';
import 'package:kekoldi_surveys/constants/substrates.dart';
import 'package:kekoldi_surveys/models/input_field_config.dart';
import 'package:kekoldi_surveys/models/sighting.dart';

class SurveyConfiguration {
  final List<InputFieldConfig> fields = [
    InputFieldConfig.number(label: 'Quantity', required: true),
    InputFieldConfig.select(
        label: 'Height',
        options: heights,
        defaultValue: Sighting.unknown,
        required: true),
    InputFieldConfig.select(
        label: 'Substrate',
        options: substrates.sorted(),
        defaultValue: Sighting.unknown,
        required: true),
    InputFieldConfig.radioButtons(
        label: 'Sex',
        options: ['Female', 'Male', 'Mixed', Sighting.unknown],
        defaultValue: Sighting.unknown,
        required: true),
    InputFieldConfig.radioButtons(
        label: 'Age',
        options: ['Adult', 'Sub-Adult', 'Juvenile', Sighting.unknown],
        defaultValue: Sighting.unknown,
        required: true),
    InputFieldConfig.radioButtons(
        label: 'Type Of Observation',
        options: ['Audio', 'Audio+Visual', 'Visual'],
        required: true),
    InputFieldConfig.multilineText(label: 'Comments'),
  ];

  Map<String, String> get asAttributes =>
      {for (var config in fields) config.label: config.defaultValue};
}
