import 'dart:convert';

import 'package:dartx/dartx.dart';
import 'package:flutter/foundation.dart';
import 'package:kekoldi_surveys/db/db.dart';
import 'package:kekoldi_surveys/models/sighting.dart';
import 'package:kekoldi_surveys/utils/time_utils.dart';
import 'package:uuid/uuid.dart';

enum SurveyState { unstarted, inProgress, completed }

class Survey with DiagnosticableTreeMixin {
  final String id;
  DateTime? startAt;
  DateTime? endAt;
  String? weather;
  List<String> leaders;
  String scribe;
  List<String> participants;
  String trail;
  SurveyState state;
  List<Sighting> sightings;

  static final Db _db = Db();

  Survey(
      {required this.trail,
      required this.leaders,
      required this.scribe,
      required this.participants,
      this.startAt,
      this.endAt,
      this.weather,
      this.state = SurveyState.unstarted,
      this.sightings = const []})
      : id = const Uuid().v4();

  Survey.fromJson(Map<String, dynamic> json)
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
        weather = json['weather'];

  static Future<Survey> create(
      {required String trail,
      required List<String> leaders,
      required String scribe,
      required List<String> participants}) async {
    final survey = Survey(
        trail: trail,
        leaders: leaders,
        scribe: scribe,
        participants: participants);

    _db.createSurvey(survey);

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
            List.from(sightings.map((Sighting sighting) => sighting.toJson()))
      };

  String get filename =>
      '${trail.toLowerCase()}_survey_${DateFormats.ddmmyyyyNoBreaks(startAt ?? DateTime.now())}';

  int get totalObservations => sightings.length;
  int get uniqueSpecies =>
      sightings.map((Sighting sighting) => sighting.species).distinct().length;

  int lengthInMinutes({fromNow = false}) =>
      (fromNow ? DateTime.now() : endAt!).difference(startAt!).inMinutes;

  Future<void> update(
      {String? updatedTrail,
      List<String>? updatedLeaders,
      String? updatedScribe,
      List<String>? updatedParticipants}) async {
    trail = updatedTrail ?? trail;
    leaders = updatedLeaders ?? leaders;
    scribe = updatedScribe ?? scribe;
    participants = updatedParticipants ?? participants;

    _db.updateSurvey(this);
  }

  Future<void> updateSighting(Sighting updatedSighting) async {
    final updatedSightings = List<Sighting>.from(sightings.map(
        (Sighting sighting) =>
            sighting.id == updatedSighting.id ? updatedSighting : sighting));

    sightings = updatedSightings;

    _db.updateSurvey(this);
  }

  Future<void> start() async {
    startAt = DateTime.now();
    state = SurveyState.inProgress;

    _db.updateSurvey(this);
  }

  Future<void> end() async {
    endAt = DateTime.now();
    state = SurveyState.completed;

    _db.updateSurvey(this);
  }

  Future<void> setWeather(String newWeather) async {
    weather = newWeather;

    _db.updateSurvey(this);
  }

  Future<void> addSighting(Sighting sighting) async {
    sightings = [sighting, ...sightings];

    _db.updateSurvey(this);
  }

  Future<void> removeSighting(Sighting sightingToRemove) async {
    sightings = List.from(sightings
        .whereNot((Sighting sighting) => sighting.id == sightingToRemove.id));

    _db.updateSurvey(this);
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
  }
}
