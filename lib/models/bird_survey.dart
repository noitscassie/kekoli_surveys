import 'dart:convert';

import 'package:dartx/dartx.dart';
import 'package:flutter/foundation.dart';
import 'package:kekoldi_surveys/constants/survey_state.dart';
import 'package:kekoldi_surveys/db/db.dart';
import 'package:kekoldi_surveys/models/bird_survey_segment.dart';
import 'package:uuid/uuid.dart';

enum BirdSurveyType {
  pointCount(prettyName: 'Point Count'),
  transect(prettyName: 'Transect');

  const BirdSurveyType({required this.prettyName});

  final String prettyName;

  static byPrettyName(String prettyName) => BirdSurveyType.values
      .firstOrNullWhere((BirdSurveyType type) => type.prettyName == prettyName);
}

class BirdSurvey with DiagnosticableTreeMixin {
  final String id;
  final DateTime createdAt;
  List<String> leaders;
  String scribe;
  List<String> participants;
  String trail;
  BirdSurveyType type;
  DateTime? date;
  String? weather;
  List<BirdSurveySegment> segments;

  static final Db _db = Db();

  BirdSurvey(
      {required this.trail,
      required this.leaders,
      required this.scribe,
      required this.participants,
      required this.type,
      required this.segments,
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
        }));

  static Future<BirdSurvey> create(
      {required String trail,
      required List<String> leaders,
      required String scribe,
      required List<String> participants,
      required BirdSurveyType type,
      required List<BirdSurveySegment> segments}) async {
    final survey = BirdSurvey(
      trail: trail,
      leaders: leaders,
      scribe: scribe,
      participants: participants,
      type: type,
      segments: segments,
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
      };

  String toJson() => jsonEncode(attributes);

  Future<void> updateSegment(BirdSurveySegment updatedSegment) async {
    segments = List.from(segments.map((segment) =>
        segment.id == updatedSegment.id ? updatedSegment : segment));

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
    properties.add(DiagnosticsProperty<DateTime?>('date', date));
    properties.add(StringProperty('weather', weather));
    properties.add(IterableProperty<BirdSurveySegment>('segments', segments));
  }
}
