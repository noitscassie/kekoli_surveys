import 'dart:convert';

import 'package:kekoldi_surveys/models/survey.dart';
import 'package:kekoldi_surveys/models/survey_configuration.dart';
import 'package:localstorage/localstorage.dart';

class Db {
  static const filePath = 'kekoldi_surveys.json';
  static const _surveysKey = 'surveys';
  static const _surveyConfigurationKey = 'surveyConfiguration';

  final _storage = LocalStorage(filePath);

  Future<bool> get _ready => _storage.ready;

  Future<void> createSurvey(Survey survey) async {
    await _ready;

    final surveysData = _storage.getItem(_surveysKey) ?? [];
    final surveys = [...surveysData, survey.toJson()];

    _insert(_surveysKey, surveys);
  }

  Future<void> updateSurvey(Survey survey) async {
    await _ready;

    final surveys = await getSurveys();
    final updatedSurveys = List.from(surveys.map((Survey loadedSurvey) =>
        loadedSurvey.id == survey.id
            ? survey.toJson()
            : loadedSurvey.toJson()));

    _insert(_surveysKey, updatedSurveys);
  }

  Future<List<Survey>> getSurveys() async {
    await _ready;
    final surveysData = _storage.getItem(_surveysKey) ?? [];

    final surveysJson = List.from(surveysData.map((json) => jsonDecode(json)));

    return List.from(surveysJson.map((json) => Survey.fromJson(json)));
  }

  Future<Survey> getSurvey(String id) async {
    await _ready;

    final surveys = await getSurveys();
    final Survey survey =
        surveys.firstWhere((Survey survey) => survey.id == id);

    return survey;
  }

  Future<SurveyConfiguration> getSurveyConfiguration() async {
    await _ready;

    final configData = _storage.getItem(_surveyConfigurationKey);

    if (configData == null) {
      final config = defaultSurveyConfiguration;
      _insert(_surveyConfigurationKey, config.toJson());

      return config;
    } else {
      return SurveyConfiguration.fromJson(jsonDecode(configData));
    }
  }

  Future<void> updateSurveyConfiguration(
      SurveyConfiguration configuration) async {
    await _ready;

    _insert(_surveyConfigurationKey, configuration.toJson());
  }

  Future<void> _insert(String key, dynamic data) async {
    _storage.setItem(key, data);
  }
}
