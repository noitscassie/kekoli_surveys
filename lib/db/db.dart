import 'dart:convert';

import 'package:dartx/dartx.dart';
import 'package:kekoldi_surveys/constants/biodiversity_trails.dart';
import 'package:kekoldi_surveys/constants/bird_survey_trails.dart';
import 'package:kekoldi_surveys/models/biodiversity_survey.dart';
import 'package:kekoldi_surveys/models/bird_survey.dart';
import 'package:kekoldi_surveys/models/bird_survey_trail.dart';
import 'package:kekoldi_surveys/models/survey_configuration.dart';
import 'package:localstorage/localstorage.dart';

class Db {
  static const filePath = 'kekoldi_surveys.json';
  static const _biodiversitySurveysKey = 'biodiversitySurveys';
  static const _biodiversitySurveyConfigurationKey =
      '_biodiversitySurveyConfiguration';
  static const _biodiversityTrailsKey = 'biodiversityTrails';
  static const _birdSurveysKey = 'birdSurveys';
  static const _birdTrailsKey = 'birdTrails';

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

    final surveys = await getBiodiversitySurveys();
    final updatedSurveys = List.from(surveys.map(
        (BiodiversitySurvey loadedSurvey) => loadedSurvey.id == survey.id
            ? survey.toJson()
            : loadedSurvey.toJson()));

    _insert(_biodiversitySurveysKey, updatedSurveys);
  }

  Future<void> deleteBiodiversitySurvey(BiodiversitySurvey survey) async {
    await _ready;

    final surveys = await getBiodiversitySurveys();
    final updatedSurveys = List.from(surveys
        .whereNot(
            (BiodiversitySurvey loadedSurvey) => loadedSurvey.id == survey.id)
        .map((survey) => survey.toJson()));

    _insert(_biodiversitySurveysKey, updatedSurveys);
  }

  Future<List<BiodiversitySurvey>> getBiodiversitySurveys() async {
    await _ready;
    final surveysData = _storage.getItem(_biodiversitySurveysKey) ?? [];

    final surveysJson = List.from(surveysData
        .map((json) => json.runtimeType == String ? jsonDecode(json) : json));

    return List.from(
        surveysJson.map((json) => BiodiversitySurvey.fromJson(json)));
  }

  Future<BiodiversitySurvey> getBiodiversitySurvey(String id) async {
    await _ready;

    final surveys = await getBiodiversitySurveys();
    final BiodiversitySurvey survey =
        surveys.firstWhere((BiodiversitySurvey survey) => survey.id == id);

    return survey;
  }

  Future<List<BirdSurvey>> getBirdSurveys() async {
    await _ready;

    final surveysData = _storage.getItem(_birdSurveysKey) ?? [];

    final surveysJson = List.from(surveysData
        .map((json) => json.runtimeType == String ? jsonDecode(json) : json));

    return List.from(surveysJson.map((json) => BirdSurvey.fromJson(json)));
  }

  Future<BirdSurvey> getBirdSurvey(String id) async {
    await _ready;

    final surveys = await getBirdSurveys();
    final BirdSurvey survey =
        surveys.firstWhere((BirdSurvey survey) => survey.id == id);

    return survey;
  }

  Future<void> createBirdSurvey(BirdSurvey survey) async {
    await _ready;

    final surveysData = _storage.getItem(_birdSurveysKey) ?? [];
    final surveys = [...surveysData, survey.toJson()];

    _insert(_birdSurveysKey, surveys);
  }

  Future<void> updateBirdSurvey(BirdSurvey survey) async {
    await _ready;

    final surveys = await getBirdSurveys();
    final updatedSurveys = List.from(surveys.map((BirdSurvey loadedSurvey) =>
        loadedSurvey.id == survey.id
            ? survey.toJson()
            : loadedSurvey.toJson()));

    _insert(_birdSurveysKey, updatedSurveys);
  }

  Future<void> deleteBirdSurvey(BirdSurvey survey) async {
    await _ready;

    final surveys = await getBirdSurveys();
    final updatedSurveys = List.from(surveys
        .whereNot((BirdSurvey loadedSurvey) => loadedSurvey.id == survey.id)
        .map((survey) => survey.toJson()));

    _insert(_birdSurveysKey, updatedSurveys);
  }

  Future<SurveyConfiguration> getSurveyConfiguration() async {
    await _ready;

    final configData = _storage.getItem(_biodiversitySurveyConfigurationKey);

    if (configData == null) {
      final config = defaultBiodiversitySurveyConfiguration;
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
      _insert(_biodiversityTrailsKey, defaultBiodiversityTrails);

      return defaultBiodiversityTrails;
    } else {
      return List<String>.from(trails);
    }
  }

  Future<void> updateBiodiversityTrails(List<String> trails) async {
    await _ready;

    _insert(_biodiversityTrailsKey, trails);
  }

  Future<List<BirdSurveyTrail>> getBirdTrails() async {
    await _ready;

    final trails = _storage.getItem(_birdTrailsKey);

    if (trails == null) {
      final defaultTrails = defaultBirdSurveyTrails;
      _insert(_birdTrailsKey, defaultTrails);

      return defaultTrails;
    } else {
      if (trails.runtimeType == List<BirdSurveyTrail>) {
        return trails;
      }

      return List<BirdSurveyTrail>.from(
        trails.map(
          (json) => BirdSurveyTrail.fromJson(
            jsonDecode(json),
          ),
        ),
      );
    }
  }

  Future<void> updateBirdTrails(List<BirdSurveyTrail> trails) async {
    await _ready;

    _insert(_birdTrailsKey, trails.map((trail) => trail.toJson()).toList());
  }

  void _insert(String key, dynamic data) => _storage.setItem(key, data);
}
