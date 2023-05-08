import 'package:dartx/dartx.dart';

String formatStringListAsBullets(List<String> items) =>
    items.map((item) => '- $item').join(('\n'));

String sightingAttributesString(Map<String, dynamic> attributes) {
  final quantity = attributes['Quantity'];
  final location = [
    attributes['Height'],
    attributes['Substrate'],
  ].whereNotNull().join(' ');
  final sex = attributes['Sex'];
  final observation = attributes['Observation'];
  final age = attributes['Age'];

  return List<String>.from(
          [quantity, location, sex, age, observation].whereNotNull())
      .where((String part) => part.isNotEmpty)
      .join(', ');
}
