import 'dart:convert';

import 'package:dartx/dartx.dart';
import 'package:kekoldi_surveys/constants/trails.dart';
import 'package:kekoldi_surveys/models/survey.dart';
import 'package:kekoldi_surveys/models/survey_configuration.dart';
import 'package:localstorage/localstorage.dart';

class Db {
  static const filePath = 'kekoldi_surveys.json';
  static const _biodiversitySurveysKey = 'biodiversitySurveys';
  static const _biodiversitySurveyConfigurationKey =
      '_biodiversitySurveyConfiguration';
  static const _biodiversityTrailsKey = 'biodiversityTrails';

  final _storage = LocalStorage(filePath);

  Future<bool> get _ready => _storage.ready;

  Future<void> createBiodiversitySurvey(BiodiversitySurvey survey) async {
    await _ready;

    final surveysData = _storage.getItem(_biodiversitySurveysKey) ?? [];
    final surveys = [...surveysData, survey.toJson()];

    _insert(_biodiversitySurveysKey, surveys);
  }

  Future<void> updateBiodiversitySurvey(BiodiversitySurvey survey) async {
    await _ready;

    final surveys = await getBiodiveristySurveys();
    final updatedSurveys = List.from(surveys.map(
        (BiodiversitySurvey loadedSurvey) => loadedSurvey.id == survey.id
            ? survey.toJson()
            : loadedSurvey.toJson()));

    _insert(_biodiversitySurveysKey, updatedSurveys);
  }

  Future<void> deleteBiodiversitySurvey(BiodiversitySurvey survey) async {
    await _ready;

    final surveys = await getBiodiveristySurveys();
    final updatedSurveys = List.from(surveys.whereNot(
        (BiodiversitySurvey loadedSurvey) => loadedSurvey.id == survey.id));

    _insert(_biodiversitySurveysKey, updatedSurveys);
  }

  Future<List<BiodiversitySurvey>> getBiodiveristySurveys() async {
    await _ready;
    final surveysData = _storage.getItem(_biodiversitySurveysKey) ?? [];

    final surveysJson = List.from(surveysData
        .map((json) => json.runtimeType == String ? jsonDecode(json) : json));

    return List.from(
        surveysJson.map((json) => BiodiversitySurvey.fromJson(json)));
  }

  Future<BiodiversitySurvey> getBiodiversitySurvey(String id) async {
    await _ready;

    final surveys = await getBiodiveristySurveys();
    final BiodiversitySurvey survey =
        surveys.firstWhere((BiodiversitySurvey survey) => survey.id == id);

    return survey;
  }

  Future<SurveyConfiguration> getSurveyConfiguration() async {
    await _ready;

    final configData = _storage.getItem(_biodiversitySurveyConfigurationKey);

    if (configData == null) {
      final config = defaultSurveyConfiguration;
      _insert(_biodiversitySurveyConfigurationKey, config.toJson());

      return config;
    } else {
      return SurveyConfiguration.fromJson(jsonDecode(configData));
    }
  }

  Future<void> updateSurveyConfiguration(
      SurveyConfiguration configuration) async {
    await _ready;

    _insert(_biodiversitySurveyConfigurationKey, configuration.toJson());
  }

  Future<List<String>> getBiodiversityTrails() async {
    await _ready;

    final trails = _storage.getItem(_biodiversityTrailsKey);

    if (trails == null) {
      _insert(_biodiversitySurveyConfigurationKey, defaultTrails);

      return defaultTrails;
    } else {
      return trails;
    }
  }

  Future<void> updateBiodiversityTrails(List<String> trails) async {
    await _ready;

    _insert(_biodiversityTrailsKey, trails);
  }

  void _insert(String key, dynamic data) => _storage.setItem(key, data);
}
