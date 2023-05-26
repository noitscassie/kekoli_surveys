import 'package:dartx/dartx.dart';

enum BirdSightingDistance {
  lessThan30(prettyName: 'Less than 30m'),
  moreThan30(prettyName: 'More than 30m'),
  flyOver(prettyName: 'Flyover');

  const BirdSightingDistance({required this.prettyName});

  final String prettyName;

  static byPrettyName(String prettyName) =>
      BirdSightingDistance.values.firstOrNullWhere(
          (BirdSightingDistance type) => type.prettyName == prettyName);
}
