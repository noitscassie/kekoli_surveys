import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class BirdSurveyTrail with DiagnosticableTreeMixin {
  final String id;
  String name;
  List<String> segments;

  BirdSurveyTrail({
    required this.name,
    required this.segments,
  }) : id = const Uuid().v4();

  BirdSurveyTrail.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        segments = List<String>.from(json['segments']);

  Map<String, dynamic> get attributes => {
        'id': id,
        'name': name,
        'segments': segments,
      };

  Map<String, dynamic> toJson() => attributes;
}
