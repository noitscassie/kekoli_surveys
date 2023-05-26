import 'package:kekoldi_surveys/constants/bird_sighting_distances.dart';
import 'package:kekoldi_surveys/models/input_field_config.dart';

const distanceField = 'Distance';

final List<InputFieldConfig> defaultBirdSightingFields = [
  InputFieldConfig.radioButtons(
    label: distanceField,
    options:
        BirdSightingDistance.values.map((type) => type.prettyName).toList(),
    defaultValue: '',
    required: true,
    sortOptions: false,
  ),
];
