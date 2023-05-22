import 'dart:convert';

import 'package:dartx/dartx.dart';
import 'package:flutter/foundation.dart';
import 'package:kekoldi_surveys/db/db.dart';
import 'package:kekoldi_surveys/models/sighting.dart';
import 'package:kekoldi_surveys/models/survey_configuration.dart';
import 'package:kekoldi_surveys/utils/time_utils.dart';
import 'package:uuid/uuid.dart';

enum SurveyState { unstarted, inProgress, completed }

class BiodiversitySurvey with DiagnosticableTreeMixin {
  final String id;
  final DateTime createdAt;
  DateTime? startAt;
  DateTime? endAt;
  String? weather;
  List<String> leaders;
  String scribe;
  List<String> participants;
  String trail;
  SurveyState state;
  List<Sighting> sightings;
  final SurveyConfiguration configuration;

  static final Db _db = Db();

  BiodiversitySurvey(
      {required this.trail,
      required this.leaders,
      required this.scribe,
      required this.participants,
      required this.configuration,
      this.startAt,
      this.endAt,
      this.weather,
      this.state = SurveyState.unstarted,
      this.sightings = const []})
      : id = const Uuid().v4(),
        createdAt = DateTime.now();

  BiodiversitySurvey.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        trail = json['trail'],
        leaders = List<String>.from(json['leaders']),
        scribe = json['scribe'],
        participants = List<String>.from(json['participants']),
        startAt =
            json['startAt'] == 'null' ? null : DateTime.parse(json['startAt']),
        endAt = json['endAt'] == 'null' ? null : DateTime.parse(json['endAt']),
        state = SurveyState.values.byName(json['state']),
        sightings = List<Sighting>.from((json['sightings'] ?? []).map(
            (sighting) => Sighting.fromMap(sighting.runtimeType == String
                ? jsonDecode(sighting)
                : sighting))),
        weather = json['weather'],
        configuration = SurveyConfiguration.fromJson(
            json['configuration'].runtimeType == String
                ? jsonDecode(json['configuration'])
                : json['configuration']),
        createdAt = DateTime.parse(json['createdAt']);

  static Future<BiodiversitySurvey> create(
      {required String trail,
      required List<String> leaders,
      required String scribe,
      required List<String> participants,
      required SurveyConfiguration configuration}) async {
    final survey = BiodiversitySurvey(
        trail: trail,
        leaders: leaders,
        scribe: scribe,
        participants: participants,
        configuration: configuration);

    _db.createBiodiversitySurvey(survey);

    return survey;
  }

  String toJson() => jsonEncode(attributes);

  Map<String, dynamic> get attributes => {
        'id': id,
        'startAt': startAt.toString(),
        'endAt': endAt.toString(),
        'weather': weather,
        'leaders': leaders,
        'scribe': scribe,
        'participants': participants,
        'trail': trail,
        'state': state.name,
        'sightings':
            List.from(sightings.map((Sighting sighting) => sighting.toJson())),
        'configuration': configuration.toJson(),
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

  int lengthInMinutes({fromNow = false}) =>
      (fromNow ? DateTime.now() : endAt ?? DateTime.now())
          .difference(startAt!)
          .inMinutes;

  Future<void> update(
      {String? updatedTrail,
      List<String>? updatedLeaders,
      String? updatedScribe,
      List<String>? updatedParticipants}) async {
    trail = updatedTrail ?? trail;
    leaders = updatedLeaders ?? leaders;
    scribe = updatedScribe ?? scribe;
    participants = updatedParticipants ?? participants;

    _db.updateBiodiversitySurvey(this);
  }

  Future<void> updateSighting(Sighting updatedSighting) async {
    final updatedSightings = List<Sighting>.from(sightings.map(
        (Sighting sighting) =>
            sighting.id == updatedSighting.id ? updatedSighting : sighting));

    sightings = updatedSightings;

    _db.updateBiodiversitySurvey(this);
  }

  Future<void> updateSightings(List<Sighting> updatedSightings) async {
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

  Future<void> start() async {
    startAt = DateTime.now();
    state = SurveyState.inProgress;

    _db.updateBiodiversitySurvey(this);
  }

  Future<void> end() async {
    endAt = DateTime.now();
    state = SurveyState.completed;

    _db.updateBiodiversitySurvey(this);
  }

  Future<void> setWeather(String newWeather) async {
    weather = newWeather;

    _db.updateBiodiversitySurvey(this);
  }

  Future<void> addSighting(Sighting sighting) async {
    sightings = [sighting, ...sightings];

    _db.updateBiodiversitySurvey(this);
  }

  Future<void> addSightings(List<Sighting> newSightings) async {
    sightings = [...newSightings, ...sightings];

    _db.updateBiodiversitySurvey(this);
  }

  Future<void> removeSighting(Sighting sightingToRemove) async {
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
  }
}
