import 'package:flutter/foundation.dart';
import 'package:kekoldi_surveys/models/sighting.dart';

enum SurveyState { unstarted, inProgress, completed }

class Survey with DiagnosticableTreeMixin {
  DateTime? startAt;
  DateTime? endAt;
  String? weather;
  final List<String> leaders;
  final String scribe;
  final List<String> participants;
  final String trail;
  SurveyState state;
  List<Sighting> sightings;

  Survey(
      {required this.trail,
      required this.leaders,
      required this.scribe,
      required this.participants,
      this.startAt,
      this.endAt,
      this.weather,
      this.state = SurveyState.unstarted,
      this.sightings = const []});

  void start() {
    startAt = DateTime.now();
    state = SurveyState.inProgress;
  }

  void end() {
    endAt = DateTime.now();
    state = SurveyState.completed;
  }

  void setWeather(String newWeather) {
    weather = newWeather;
  }

  void addSighting(Sighting sighting) {
    sightings = [sighting, ...sightings];
  }

  void removeSightingMatchingJson(String json) {
    final index =
        sightings.indexWhere((Sighting sighting) => sighting.toJson() == json);

    sightings.removeAt(index);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('startAt', startAt.toString()));
    properties.add(StringProperty('endAt', endAt?.toString()));
    properties.add(IterableProperty('leaders', leaders));
    properties.add(StringProperty('scribe', scribe));
    properties.add(IterableProperty('participants', participants));
    properties.add(StringProperty('weather', weather));
    properties.add(StringProperty('trail', trail));
  }
}
