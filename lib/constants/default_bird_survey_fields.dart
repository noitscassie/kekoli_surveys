import 'package:kekoldi_surveys/constants/bird_survey_trails.dart';
import 'package:kekoldi_surveys/models/bird_survey.dart';
import 'package:kekoldi_surveys/models/bird_survey_trail.dart';
import 'package:kekoldi_surveys/models/input_field_config.dart';

const trailField = 'Trail';
const surveyTypeField = 'Survey Type';
const leadersField = 'Add Leader(s)';
const scribeField = 'Add Scribe';
const participantsField = 'Add Participants';

List<InputFieldConfig> defaultBirdSurveyFields(List<BirdSurveyTrail> trails) {
  final trailsToUse = trails.isEmpty ? defaultBirdSurveyTrails : trails;

  return [
    InputFieldConfig.select(
      label: trailField,
      options: trailsToUse.map((trail) => trail.name).toList(),
      defaultValue: trailsToUse.first.name,
      required: true,
      sortOptions: false,
    ),
    InputFieldConfig.radioButtons(
      label: surveyTypeField,
      options: BirdSurveyType.values.map((type) => type.title).toList(),
      defaultValue: '',
      required: true,
      sortOptions: true,
    ),
    InputFieldConfig.multifieldText(
      label: leadersField,
      defaultValue: [''],
      required: true,
      newItemText: 'Add New Leader',
      maxItems: 2,
    ),
    InputFieldConfig.text(
      label: scribeField,
      defaultValue: '',
      required: true,
    ),
    InputFieldConfig.multifieldText(
      label: participantsField,
      defaultValue: [''],
      required: true,
      newItemText: 'Add New Participant',
    ),
  ];
}
