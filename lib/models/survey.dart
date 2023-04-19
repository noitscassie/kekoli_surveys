import 'package:flutter/foundation.dart';

class Survey with DiagnosticableTreeMixin {
  final DateTime startAt;
  final DateTime? endAt;
  final String? weather;
  final List<String> leaders;
  final String scribe;
  final List<String> participants;
  final String trail;

  Survey(
      {required this.startAt,
      required this.trail,
      required this.leaders,
      required this.scribe,
      this.endAt,
      this.weather,
      this.participants = const []});

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    // list all the properties of your class here.
    // See the documentation of debugFillProperties for more information.
    properties.add(StringProperty('startAt', startAt.toString()));
    properties.add(StringProperty('endAt', endAt?.toString()));
    properties.add(StringProperty('trail', trail));
    properties.add(IterableProperty('leaders', leaders));
    properties.add(StringProperty('scribe', scribe));
    properties.add(IterableProperty('participants', participants));
    properties.add(StringProperty('weather', weather));
  }
}
