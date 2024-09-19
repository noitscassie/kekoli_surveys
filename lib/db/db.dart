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

  final _storage = localStorage;

  void reset() => _storage.clear();

  void createBiodiversitySurvey(BiodiversitySurvey survey) {
    final existingSurveys = getBiodiversitySurveys();
    final surveys = [...existingSurveys, survey];

    _insert(_biodiversitySurveysKey, surveys);
  }

  void updateBiodiversitySurvey(BiodiversitySurvey survey) {
    final surveys = getBiodiversitySurveys();
    final updatedSurveys = List.from(
      surveys.map(
        (BiodiversitySurvey loadedSurvey) =>
            loadedSurvey.id == survey.id ? survey : loadedSurvey,
      ),
    );

    _insert(_biodiversitySurveysKey, updatedSurveys);
  }

  void deleteBiodiversitySurvey(BiodiversitySurvey survey) {
    final surveys = getBiodiversitySurveys();
    final updatedSurveys = List.from(surveys.whereNot(
        (BiodiversitySurvey loadedSurvey) => loadedSurvey.id == survey.id));

    _insert(_biodiversitySurveysKey, updatedSurveys);
  }

  List<BiodiversitySurvey> getBiodiversitySurveys() {
    final surveys = _fetch(_biodiversitySurveysKey) ?? [];

    return List.from(surveys.map((json) => BiodiversitySurvey.fromJson(json)));
  }

  BiodiversitySurvey getBiodiversitySurvey(String id) {
    final surveys = getBiodiversitySurveys();
    final BiodiversitySurvey survey =
        surveys.firstWhere((BiodiversitySurvey survey) => survey.id == id);

    return survey;
  }

  List<BirdSurvey> getBirdSurveys() {
    final surveys = _fetch(_birdSurveysKey) ?? [];

    return List.from(surveys.map((json) => BirdSurvey.fromJson(json)));
  }

  BirdSurvey getBirdSurvey(String id) {
    final surveys = getBirdSurveys();
    final BirdSurvey survey =
        surveys.firstWhere((BirdSurvey survey) => survey.id == id);

    return survey;
  }

  void createBirdSurvey(BirdSurvey survey) {
    final existingSurveys = getBirdSurveys();
    final surveys = [...existingSurveys, survey];

    _insert(_birdSurveysKey, surveys);
  }

  void updateBirdSurvey(BirdSurvey survey) {
    final surveys = getBirdSurveys();
    final updatedSurveys = List.from(surveys.map((BirdSurvey loadedSurvey) =>
        loadedSurvey.id == survey.id ? survey : loadedSurvey));

    _insert(_birdSurveysKey, updatedSurveys);
  }

  void deleteBirdSurvey(BirdSurvey survey) {
    final surveys = getBirdSurveys();
    final updatedSurveys = List.from(surveys
        .whereNot((BirdSurvey loadedSurvey) => loadedSurvey.id == survey.id));

    _insert(_birdSurveysKey, updatedSurveys);
  }

  SurveyConfiguration getSurveyConfiguration() {
    final configData = _fetch(_biodiversitySurveyConfigurationKey);

    if (configData == null) {
      final config = defaultBiodiversitySurveyConfiguration;
      _insert(_biodiversitySurveyConfigurationKey, config);

      return config;
    } else {
      return SurveyConfiguration.fromJson(configData);
    }
  }

  void updateSurveyConfiguration(SurveyConfiguration configuration) {
    _insert(_biodiversitySurveyConfigurationKey, configuration);
  }

  List<String> getBiodiversityTrails() {
    final trails = _fetch(_biodiversityTrailsKey);

    if (trails == null) {
      _insert(_biodiversityTrailsKey, defaultBiodiversityTrails);

      return defaultBiodiversityTrails;
    } else {
      return List<String>.from(trails);
    }
  }

  void updateBiodiversityTrails(List<String> trails) =>
      _insert(_biodiversityTrailsKey, trails);

  List<BirdSurveyTrail> getBirdTrails() {
    final trails = _fetch(_birdTrailsKey);

    if (trails == null) {
      final defaultTrails = defaultBirdSurveyTrails;
      _insert(_birdTrailsKey, defaultTrails);

      return defaultTrails;
    } else {
      return List<BirdSurveyTrail>.from(
        trails.map((json) => BirdSurveyTrail.fromJson(json)),
      );
    }
  }

  void updateBirdTrails(List<BirdSurveyTrail> trails) =>
      _insert(_birdTrailsKey, trails);

  void _insert(String key, dynamic data) =>
      _storage.setItem(key, jsonEncode(data));

  dynamic _fetch(String key) {
    final data = _storage.getItem(key);
    if (data == null) {
      return null;
    } else {
      final decoded = jsonDecode(data);

      if (decoded.runtimeType == List) {
        try {
          return List.from(decoded.map((json) => jsonDecode(json)));
        } catch (_) {
          return decoded;
        }
      } else {
        return decoded;
      }
    }
  }
}
