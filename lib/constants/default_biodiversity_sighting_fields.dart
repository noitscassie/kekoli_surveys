import 'package:kekoldi_surveys/constants/heights.dart';
import 'package:kekoldi_surveys/constants/substrates.dart';
import 'package:kekoldi_surveys/models/input_field_config.dart';
import 'package:kekoldi_surveys/models/sighting.dart';

final List<InputFieldConfig> defaultBiodiversitySightingFields = [
  InputFieldConfig.number(
    label: 'Quantity',
    required: true,
  ),
  InputFieldConfig.select(
    label: 'Height',
    options: heights,
    defaultValue: Sighting.unknown,
    required: true,
    sortOptions: false,
  ),
  InputFieldConfig.selectWithFreeformInput(
    label: 'Substrate',
    options: substrates,
    defaultValue: Sighting.unknown,
    required: true,
    sortOptions: true,
  ),
  InputFieldConfig.radioButtons(
    label: 'Sex',
    options: [
      'Female',
      'Male',
      'Mixed',
      Sighting.unknown,
    ],
    defaultValue: Sighting.unknown,
    required: true,
    sortOptions: true,
  ),
  InputFieldConfig.radioButtons(
    label: 'Age',
    options: [
      'Adult',
      'Sub-Adult',
      'Juvenile',
      Sighting.unknown,
    ],
    defaultValue: Sighting.unknown,
    required: true,
    sortOptions: true,
  ),
  InputFieldConfig.radioButtons(
    label: 'Type Of Observation',
    options: [
      'Audio',
      'Audio+Visual',
      'Visual',
    ],
    required: true,
    sortOptions: true,
  ),
  InputFieldConfig.multilineText(
    label: 'Comments',
  ),
];
