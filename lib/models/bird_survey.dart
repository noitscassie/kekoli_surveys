import 'dart:convert';

import 'package:dartx/dartx.dart';
import 'package:flutter/foundation.dart';
import 'package:kekoldi_surveys/db/db.dart';
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

  static final Db _db = Db();

  BirdSurvey(
      {required this.trail,
      required this.leaders,
      required this.scribe,
      required this.participants,
      required this.type,
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
        createdAt = DateTime.parse(json['createdAt']);

  static Future<BirdSurvey> create(
      {required String trail,
      required List<String> leaders,
      required String scribe,
      required List<String> participants,
      required BirdSurveyType type}) async {
    final survey = BirdSurvey(
        trail: trail,
        leaders: leaders,
        scribe: scribe,
        participants: participants,
        type: type);

    _db.createBirdSurvey(survey);

    return survey;
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
      };

  String toJson() => jsonEncode(attributes);
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
  }
}
