import 'dart:convert';

import 'package:dartx/dartx.dart';
import 'package:flutter/foundation.dart';
import 'package:kekoldi_surveys/constants/survey_state.dart';
import 'package:kekoldi_surveys/db/db.dart';
import 'package:kekoldi_surveys/models/sighting.dart';
import 'package:kekoldi_surveys/models/survey_configuration.dart';
import 'package:kekoldi_surveys/utils/time_utils.dart';
import 'package:uuid/uuid.dart';

class BiodiversitySurvey with DiagnosticableTreeMixin {
  final String id;
  final DateTime createdAt;
  DateTime? startAt;
  DateTime? endAt;
  String? weather;
  String? startTemperature;
  String? endTemperature;
  String? rainfall;
  List<String> leaders;
  String scribe;
  List<String> participants;
  String trail;
  List<Sighting> sightings;
  final SurveyConfiguration configuration;

  static final Db _db = Db();

  BiodiversitySurvey({
    required this.trail,
    required this.leaders,
    required this.scribe,
    required this.participants,
    required this.configuration,
    this.startAt,
    this.endAt,
    this.weather,
    this.startTemperature,
    this.endTemperature,
    this.rainfall,
    this.sightings = const [],
  })  : id = const Uuid().v4(),
        createdAt = DateTime.now();

  BiodiversitySurvey.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        trail = json['trail'],
        leaders = List<String>.from(json['leaders']),
        scribe = json['scribe'],
        participants = List<String>.from(json['participants']),
        startAt =
            json['startAt'] == null ? null : DateTime.parse(json['startAt']),
        endAt = json['endAt'] == null ? null : DateTime.parse(json['endAt']),
        sightings = List<Sighting>.from((json['sightings'] ?? []).map(
            (sighting) => Sighting.fromMap(sighting.runtimeType == String
                ? jsonDecode(sighting)
                : sighting))),
        weather = json['weather'],
        startTemperature = json['startTemperature'],
        endTemperature = json['endTemperature'],
        rainfall = json['rainfall'],
        configuration = SurveyConfiguration.fromJson(
            json['configuration'].runtimeType == String
                ? jsonDecode(json['configuration'])
                : json['configuration']),
        createdAt = DateTime.parse(json['createdAt']);

  static BiodiversitySurvey create({
    required String trail,
    required List<String> leaders,
    required String scribe,
    required List<String> participants,
    required SurveyConfiguration configuration,
    required String startTemperature,
  }) {
    final survey = BiodiversitySurvey(
      trail: trail,
      leaders: leaders,
      scribe: scribe,
      participants: participants,
      configuration: configuration,
      startTemperature: startTemperature,
    );

    _db.createBiodiversitySurvey(survey);

    return survey;
  }

  Map<String, dynamic> toJson() => attributes;

  Map<String, dynamic> get attributes => {
        'id': id,
        'startAt': startAt?.toIso8601String(),
        'endAt': endAt?.toIso8601String(),
        'weather': weather,
        'startTemperature': startTemperature,
        'endTemperature': endTemperature,
        'rainfall': rainfall,
        'leaders': leaders,
        'scribe': scribe,
        'participants': participants,
        'trail': trail,
        'sightings': sightings,
        'configuration': configuration,
        'createdAt': createdAt.toIso8601String(),
      };

  String get filename =>
      '${trail.toLowerCase()}_biodiversity_survey_${DateFormats.ddmmyyyyNoBreaks(startAt ?? DateTime.now())}';

  int get totalObservations => sightings.length;
  int get uniqueSpecies =>
      sightings.map((Sighting sighting) => sighting.species).distinct().length;
  int get totalAbundance =>
      sightings.map((Sighting sighting) => sighting.abundance()).sum();

  List<Sighting> get orderedSightings =>
      sightings.sortedBy((Sighting sighting) => sighting.seenAt).toList();

  List<String> get allParticipants => [
        ...leaders,
        scribe,
        ...participants,
      ];

  SurveyState get state {
    if (startAt == null) return SurveyState.unstarted;
    if (endAt == null) return SurveyState.inProgress;

    return SurveyState.completed;
  }

  int lengthInMinutes({fromNow = false}) =>
      (fromNow ? DateTime.now() : endAt ?? DateTime.now())
          .difference(startAt!)
          .inMinutes;

  void update({
    String? updatedTrail,
    List<String>? updatedLeaders,
    String? updatedScribe,
    List<String>? updatedParticipants,
    String? updatedStartTemperature,
  }) {
    trail = updatedTrail ?? trail;
    leaders = updatedLeaders ?? leaders;
    scribe = updatedScribe ?? scribe;
    participants = updatedParticipants ?? participants;
    startTemperature = updatedStartTemperature ?? startTemperature;

    _db.updateBiodiversitySurvey(this);
  }

  void updateSighting(Sighting updatedSighting) {
    final updatedSightings = List<Sighting>.from(sightings.map(
        (Sighting sighting) =>
            sighting.id == updatedSighting.id ? updatedSighting : sighting));

    sightings = updatedSightings;

    _db.updateBiodiversitySurvey(this);
  }

  void updateSightings(List<Sighting> updatedSightings) {
    final idsToUpdate =
        updatedSightings.map((Sighting sighting) => sighting.id);

    final newSightings = List<Sighting>.from(sightings.map(
        (Sighting sighting) => idsToUpdate.contains(sighting.id)
            ? updatedSightings.firstOrNullWhere((Sighting updatedSighting) =>
                    updatedSighting.id == sighting.id) ??
                sighting
            : sighting));

    sightings = newSightings;

    _db.updateBiodiversitySurvey(this);
  }

  void start() {
    startAt = DateTime.now();

    _db.updateBiodiversitySurvey(this);
  }

  void end() {
    endAt = DateTime.now();

    _db.updateBiodiversitySurvey(this);
  }

  void setWeather({
    String? newWeather,
    String? newEndTemperature,
    String? newRainfall,
  }) {
    weather = newWeather ?? weather;
    endTemperature = newEndTemperature ?? endTemperature;
    rainfall = newRainfall ?? rainfall;

    _db.updateBiodiversitySurvey(this);
  }

  void addSighting(Sighting sighting) {
    sightings = [sighting, ...sightings];

    _db.updateBiodiversitySurvey(this);
  }

  void addSightings(List<Sighting> newSightings) {
    sightings = [...newSightings, ...sightings];

    _db.updateBiodiversitySurvey(this);
  }

  void removeSighting(Sighting sightingToRemove) {
    sightings = List.from(sightings
        .whereNot((Sighting sighting) => sighting.id == sightingToRemove.id));

    _db.updateBiodiversitySurvey(this);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('startAt', startAt.toString()));
    properties.add(StringProperty('endAt', endAt?.toString()));
    properties.add(IterableProperty('leaders', leaders));
    properties.add(StringProperty('scribe', scribe));
    properties.add(IterableProperty('participants', participants));
    properties.add(StringProperty('weather', weather));
    properties.add(StringProperty('trail', trail));
    properties.add(StringProperty('id', id));
    properties.add(EnumProperty<SurveyState>('state', state));
    properties.add(DiagnosticsProperty<SurveyConfiguration>(
        'configuration', configuration));
    properties.add(StringProperty('startTemperature', startTemperature));
    properties.add(StringProperty('endTemperature', endTemperature));
    properties.add(StringProperty('rainfall', rainfall));
  }
}
