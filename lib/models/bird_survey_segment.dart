import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:kekoldi_surveys/constants/survey_state.dart';
import 'package:kekoldi_surveys/models/sighting.dart';

class BirdSurveySegment with DiagnosticableTreeMixin {
  final String name;
  List<Sighting> sightings;
  DateTime? startAt;
  DateTime? endAt;

  BirdSurveySegment({required this.name, this.sightings = const []});

  BirdSurveySegment.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        startAt =
            json['startAt'] == null ? null : DateTime.parse(json['startAt']),
        endAt = json['endAt'] == null ? null : DateTime.parse(json['endAt']),
        sightings = []; // TODO: make this work

  Map<String, dynamic> get attributes => {
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

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('name', name));
  }
}
