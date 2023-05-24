import 'dart:convert';

import 'package:dartx/dartx.dart';
import 'package:flutter/foundation.dart';
import 'package:kekoldi_surveys/constants/survey_state.dart';
import 'package:kekoldi_surveys/models/sighting.dart';
import 'package:uuid/uuid.dart';

class BirdSurveySegment with DiagnosticableTreeMixin {
  final String id;
  final String name;
  List<Sighting> sightings;
  DateTime? startAt;
  DateTime? endAt;

  BirdSurveySegment({required this.name, this.sightings = const []})
      : id = const Uuid().v4();

  BirdSurveySegment.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        startAt =
            json['startAt'] == null ? null : DateTime.parse(json['startAt']),
        endAt = json['endAt'] == null ? null : DateTime.parse(json['endAt']),
        sightings = List<Sighting>.from(
          (json['sightings'] ?? []).map((sighting) => Sighting.fromMap(
              sighting.runtimeType == String
                  ? jsonDecode(sighting)
                  : sighting)),
        );

  Map<String, dynamic> get attributes => {
        'id': id,
        'name': name,
        'sightings':
            List.from(sightings.map((Sighting sighting) => sighting.toJson())),
        'startAt': startAt?.toIso8601String(),
        'endAt': endAt?.toIso8601String(),
      };

  SurveyState get state {
    if (startAt == null) return SurveyState.unstarted;
    if (endAt == null) return SurveyState.inProgress;

    return SurveyState.completed;
  }

  String toJson() => jsonEncode(attributes);

  void start() => startAt = DateTime.now();

  void end() => endAt = DateTime.now();

  void addSighting(Sighting sighting) => sightings = [sighting, ...sightings];

  void addSightings(List<Sighting> newSightings) =>
      sightings = [...newSightings, ...sightings];

  void removeSighting(Sighting sightingToRemove) => sightings = List.from(
        sightings.whereNot(
            (Sighting sighting) => sighting.id == sightingToRemove.id),
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('name', name));
    properties.add(StringProperty('id', id));
    properties.add(IterableProperty<Sighting>('sightings', sightings));
    properties.add(DiagnosticsProperty<DateTime?>('startAt', startAt));
    properties.add(DiagnosticsProperty<DateTime?>('endAt', endAt));
  }
}
