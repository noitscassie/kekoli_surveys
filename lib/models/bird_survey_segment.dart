import 'dart:convert';

import 'package:flutter/foundation.dart';

class BirdSurveySegment with DiagnosticableTreeMixin {
  String name;

  BirdSurveySegment({required this.name});

  BirdSurveySegment.fromJson(Map<String, dynamic> json) : name = json['name'];

  Map<String, dynamic> get attributes => {
    'name': name,
  };

  String toJson() => jsonEncode(attributes);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('name', name));
  }
}
