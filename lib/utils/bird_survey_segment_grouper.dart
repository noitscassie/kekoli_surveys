import 'package:dartx/dartx.dart';
import 'package:flutter/foundation.dart';
import 'package:kekoldi_surveys/constants/bird_sighting_distances.dart';
import 'package:kekoldi_surveys/constants/default_bird_sighting_fields.dart';
import 'package:kekoldi_surveys/models/bird_survey_segment.dart';
import 'package:kekoldi_surveys/models/sighting.dart';

class BirdSurveySegmentGrouper {
  static const threeMinutes = Duration(minutes: 3);

  final BirdSurveySegment segment;

  BirdSurveySegmentGrouper(this.segment);

  List<BirdTransectGroup> get groupsForTransect {
    final sightingsBySpecies =
        segment.sightings.groupBy((Sighting sighting) => sighting.species);

    final groups = sightingsBySpecies.entries.map((entry) {
      final sightingsByDistance = entry.value
          .groupBy((Sighting sighting) => sighting.data[distanceField]);

      final lessThan30 =
          sightingsByDistance[BirdSightingDistance.lessThan30.prettyName] ?? [];
      final moreThan30 =
          sightingsByDistance[BirdSightingDistance.moreThan30.prettyName] ?? [];
      final flyOver =
          sightingsByDistance[BirdSightingDistance.flyOver.prettyName] ?? [];

      return BirdTransectGroup(
        species: entry.key,
        lessThan30Count: lessThan30.length,
        moreThan30Count: moreThan30.length,
        flyoverCount: flyOver.length,
      );
    });

    return groups.toList();
  }

  List<BirdPointCountGroup> get groupsForPointCount {
    final sightingsBySpecies =
        segment.sightings.groupBy((Sighting sighting) => sighting.species);

    final groups = sightingsBySpecies.entries.map((entry) {
      final under3MinsSightingsByDistance = entry.value
          .where((Sighting sighting) =>
              sighting.seenAt < segment.startAt! + threeMinutes)
          .groupBy((Sighting sighting) => sighting.data[distanceField]);

      final lessThan30Under3Mins = under3MinsSightingsByDistance[
              BirdSightingDistance.lessThan30.prettyName] ??
          [];
      final moreThan30Under3Mins = under3MinsSightingsByDistance[
              BirdSightingDistance.moreThan30.prettyName] ??
          [];
      final flyOverUnder3Mins = under3MinsSightingsByDistance[
              BirdSightingDistance.flyOver.prettyName] ??
          [];

      final over3MinsSightingsByDistance = entry.value
          .where((Sighting sighting) =>
              sighting.seenAt >= segment.startAt! + threeMinutes)
          .groupBy((Sighting sighting) => sighting.data[distanceField]);

      final lessThan30Over3Mins = over3MinsSightingsByDistance[
              BirdSightingDistance.lessThan30.prettyName] ??
          [];
      final moreThan30Over3Mins = over3MinsSightingsByDistance[
              BirdSightingDistance.moreThan30.prettyName] ??
          [];
      final flyOverOver3Mins = over3MinsSightingsByDistance[
              BirdSightingDistance.flyOver.prettyName] ??
          [];

      return BirdPointCountGroup(
        species: entry.key,
        lessThan30Under3MinsCount: lessThan30Under3Mins.length,
        moreThan30Under3MinsCount: moreThan30Under3Mins.length,
        flyoverUnder3MinsCount: flyOverUnder3Mins.length,
        lessThan30Over3MinsCount: lessThan30Over3Mins.length,
        moreThan30Over3MinsCount: moreThan30Over3Mins.length,
        flyoverOver3MinsCount: flyOverOver3Mins.length,
      );
    });

    return groups.toList();
  }
}

class BirdTransectGroup with DiagnosticableTreeMixin {
  final String species;
  final int lessThan30Count;
  final int moreThan30Count;
  final int flyoverCount;

  BirdTransectGroup({
    required this.species,
    required this.lessThan30Count,
    required this.moreThan30Count,
    required this.flyoverCount,
  });

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('species', species));
    properties.add(IntProperty('lessThan30Count', lessThan30Count));
    properties.add(IntProperty('moreThan30Count', moreThan30Count));
    properties.add(IntProperty('flyoverCount', flyoverCount));
  }
}

class BirdPointCountGroup with DiagnosticableTreeMixin {
  final String species;
  final int lessThan30Under3MinsCount;
  final int moreThan30Under3MinsCount;
  final int flyoverUnder3MinsCount;
  final int lessThan30Over3MinsCount;
  final int moreThan30Over3MinsCount;
  final int flyoverOver3MinsCount;

  BirdPointCountGroup({
    required this.species,
    required this.lessThan30Under3MinsCount,
    required this.moreThan30Under3MinsCount,
    required this.flyoverUnder3MinsCount,
    required this.lessThan30Over3MinsCount,
    required this.moreThan30Over3MinsCount,
    required this.flyoverOver3MinsCount,
  });

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('species', species));
    properties.add(
        IntProperty('lessThan30Under3MinsCount', lessThan30Under3MinsCount));
    properties.add(
        IntProperty('moreThan30Under3MinsCount', moreThan30Under3MinsCount));
    properties
        .add(IntProperty('flyoverUnder3MinsCount', flyoverUnder3MinsCount));
    properties
        .add(IntProperty('lessThan30Over3MinsCount', lessThan30Over3MinsCount));
    properties
        .add(IntProperty('moreThan30Over3MinsCount', moreThan30Over3MinsCount));
    properties.add(IntProperty('flyoverOver3MinsCount', flyoverOver3MinsCount));
  }
}
