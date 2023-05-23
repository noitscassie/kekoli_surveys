import 'package:flutter/foundation.dart';

class BirdSurveySegment with DiagnosticableTreeMixin {
  String name;

  BirdSurveySegment({required this.name});

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('name', name));
  }
}
