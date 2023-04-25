import 'package:flutter/foundation.dart';

enum SurveyState { unstarted, inProgress, completed }

class Survey with DiagnosticableTreeMixin {
  DateTime? startAt;
  DateTime? endAt;
  final String? weather;
  final List<String> leaders;
  final String scribe;
  final List<String> participants;
  final String trail;
  SurveyState state;

  Survey(
      {required this.trail,
      required this.leaders,
      required this.scribe,
      required this.participants,
      this.startAt,
      this.endAt,
      this.weather,
      this.state = SurveyState.unstarted});

  void start() {
    startAt = DateTime.now();
    state = SurveyState.inProgress;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    // list all the properties of your class here.
    // See the documentation of debugFillProperties for more information.
    properties.add(StringProperty('startAt', startAt.toString()));
    properties.add(StringProperty('endAt', endAt?.toString()));
    properties.add(IterableProperty('leaders', leaders));
    properties.add(StringProperty('scribe', scribe));
    properties.add(IterableProperty('participants', participants));
    properties.add(StringProperty('weather', weather));
    properties.add(StringProperty('trail', trail));
  }
}
