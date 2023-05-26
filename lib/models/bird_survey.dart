import 'dart:convert';

import 'package:dartx/dartx.dart';
import 'package:flutter/foundation.dart';
import 'package:kekoldi_surveys/constants/survey_state.dart';
import 'package:kekoldi_surveys/db/db.dart';
import 'package:kekoldi_surveys/models/bird_survey_segment.dart';
import 'package:kekoldi_surveys/models/sighting.dart';
import 'package:kekoldi_surveys/models/survey_configuration.dart';
import 'package:uuid/uuid.dart';

enum BirdSurveyType {
  pointCount(
    title: 'Point Count',
    segmentName: 'Point',
    snakeCaseName: 'point_count',
  ),
  transect(
    title: 'Transect',
    segmentName: 'Transect',
    snakeCaseName: 'transect',
  );

  const BirdSurveyType({
    required this.title,
    required this.segmentName,
    required this.snakeCaseName,
  });

  final String title;
  final String segmentName;
  final String snakeCaseName;

  static byTitle(String title) => BirdSurveyType.values
      .firstOrNullWhere((BirdSurveyType type) => type.title == title);
}

class BirdSurvey with DiagnosticableTreeMixin {
  final String id;
  final DateTime createdAt;
  List<String> leaders;
  String scribe;
  List<String> participants;
  String trail;
  BirdSurveyType type;
  String? weather;
  List<BirdSurveySegment> segments;
  final SurveyConfiguration configuration;

  static final Db _db = Db();

  BirdSurvey(
      {required this.trail,
      required this.leaders,
      required this.scribe,
      required this.participants,
      required this.type,
      required this.segments,
      required this.configuration,
      this.weather})
      : id = const Uuid().v4(),
        createdAt = DateTime.now();

  BirdSurvey.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        trail = json['trail'],
        leaders = List<String>.from(json['leaders']),
        scribe = json['scribe'],
        participants = List<String>.from(json['participants']),
        type = BirdSurveyType.values.byName(json['type']),
        weather = json['weather'],
        createdAt = DateTime.parse(json['createdAt']),
        segments = List<BirdSurveySegment>.from(
            (json['segments'] ?? []).map((segment) {
          return BirdSurveySegment.fromJson(
              segment.runtimeType == String ? jsonDecode(segment) : segment);
        })),
        configuration = json['configuration'] == null
            ? BirdSurveyType.values.byName(json['type']) ==
                    BirdSurveyType.transect
                ? defaultBirdTransectSurveyConfiguration
                : defaultBirdPointCountSurveyConfiguration
            : SurveyConfiguration.fromJson(
                json['configuration'].runtimeType == String
                    ? jsonDecode(json['configuration'])
                    : json['configuration']);

  static Future<BirdSurvey> create(
      {required String trail,
      required List<String> leaders,
      required String scribe,
      required List<String> participants,
      required BirdSurveyType type,
      required List<BirdSurveySegment> segments,
      required SurveyConfiguration configuration}) async {
    final survey = BirdSurvey(
      trail: trail,
      leaders: leaders,
      scribe: scribe,
      participants: participants,
      type: type,
      segments: segments,
      configuration: configuration,
    );

    _db.createBirdSurvey(survey);

    return survey;
  }

  SurveyState get state {
    if (segments.all((segment) => segment.state == SurveyState.completed)) {
      return SurveyState.completed;
    }

    if (segments.all((segment) => segment.state == SurveyState.unstarted)) {
      return SurveyState.unstarted;
    }

    return SurveyState.inProgress;
  }

  Map<String, dynamic> get attributes => {
        'id': id,
        'weather': weather,
        'leaders': leaders,
        'scribe': scribe,
        'participants': participants,
        'trail': trail,
        'createdAt': createdAt.toIso8601String(),
        'type': type.name,
        'segments': List.from(segments.map((segment) => segment.toJson())),
        'configuration': configuration.toJson(),
      };

  String toJson() => jsonEncode(attributes);

  List<Sighting> get allSightings =>
      segments.map((segment) => segment.sightings).flatten().toList();

  List<Sighting> get orderedSightings =>
      allSightings.sortedBy((Sighting sighting) => sighting.seenAt).toList();

  int get uniqueSpecies =>
      allSightings.map((sighting) => sighting.species).distinct().length;

  int get totalObservations => allSightings.length;

  DateTime? get startAt => segments
      .map((segment) => segment.startAt)
      .whereNotNull()
      .sorted()
      .firstOrNull;

  DateTime? get endAt => segments
      .map((segment) => segment.endAt)
      .whereNotNull()
      .sorted()
      .reversed
      .firstOrNull;

  List<String> get allParticipants => [
        ...leaders,
        scribe,
        ...participants,
      ];

  Future<void> update(
      {String? updatedTrail,
      BirdSurveyType? updatedType,
      List<String>? updatedLeaders,
      String? updatedScribe,
      List<String>? updatedParticipants}) async {
    trail = updatedTrail ?? trail;
    type = updatedType ?? type;
    leaders = updatedLeaders ?? leaders;
    scribe = updatedScribe ?? scribe;
    participants = updatedParticipants ?? participants;

    _db.updateBirdSurvey(this);
  }

  Future<void> updateSegment(BirdSurveySegment updatedSegment) async {
    segments = List.from(segments.map((segment) =>
        segment.id == updatedSegment.id ? updatedSegment : segment));

    _db.updateBirdSurvey(this);
  }

  Future<void> setWeather(String newWeather) async {
    weather = newWeather;

    _db.updateBirdSurvey(this);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('id', id));
    properties.add(DiagnosticsProperty<DateTime>('createdAt', createdAt));
    properties.add(IterableProperty<String>('leaders', leaders));
    properties.add(StringProperty('scribe', scribe));
    properties.add(IterableProperty<String>('participants', participants));
    properties.add(StringProperty('trail', trail));
    properties.add(EnumProperty<BirdSurveyType>('type', type));
    properties.add(StringProperty('weather', weather));
    properties.add(DiagnosticsProperty<DateTime?>('startAt', startAt));
    properties.add(DiagnosticsProperty<DateTime?>('endAt', endAt));
    properties.add(IterableProperty<BirdSurveySegment>('segments', segments));
  }
}
