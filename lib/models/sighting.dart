import 'dart:convert';

import 'package:dartx/dartx.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class Sighting with DiagnosticableTreeMixin {
  final String id;
  String species;
  Map<String, String> data;
  DateTime? seenAt;

  static const unknown = 'Unknown';

  Sighting({required this.species, required this.data})
      : id = const Uuid().v4(),
        seenAt = DateTime.now();

  Sighting.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        species = map['species'],
        data = {
          'quantity': map['quantity'] ?? unknown,
          'sex': map['sex'] ?? unknown,
          'age': map['age'] ?? unknown,
          'observationType': map['observationType'] ?? unknown,
          'height': map['height'] ?? unknown,
          'substrate': map['substrate'] ?? unknown,
          'comments': map['substrate'] ?? '',
        },
        seenAt = map['seenAt'] == '' ? null : DateTime.parse(map['seenAt']);

  String toJson() => json.encode(attributes);

  Map<String, String> get attributes => {
        'id': id,
        'quantity': data['quantity'] ?? unknown,
        'height': data['height'] ?? unknown,
        'substrate': data['substrate'] ?? unknown,
        'sex': data['sex'] ?? unknown,
        'observationType': data['observationType'] ?? unknown,
        'age': data['age'] ?? unknown,
        'species': species,
        'comments': data['comments'] ?? '',
        'seenAt': seenAt?.toIso8601String() ?? '',
      };

  Map<String, String> get displayAttributes => {
        'Quantity': data['quantity'] ?? unknown,
        'Height': data['height'] ?? unknown,
        'Substrate': data['substrate'] ?? unknown,
        'Sex': data['sex'] ?? unknown,
        'Observation': data['observationType'] ?? unknown,
        'Age': data['age'] ?? unknown,
        'Comments': data['comments'] ?? '',
      };

  String get attributesString {
    final presentAttributes =
        attributes.filter((entry) => entry.value != Sighting.unknown);
    final quantity = presentAttributes['Quantity'];
    final height = presentAttributes['Height'];
    final substrate = presentAttributes['Substrate'];
    final sex = presentAttributes['Sex'];
    final observation = presentAttributes['Observation'];
    final age = presentAttributes['Age'];

    return [quantity, height, substrate, sex, age, observation]
        .whereNotNull()
        .where((String part) => part.isNotEmpty)
        .join(', ');
  }

  Sighting duplicate() => Sighting(
        species: species,
        data: {
          'quantity': data['quantity'] ?? unknown,
          'sex': data['sex'] ?? unknown,
          'observationType': data['observationType'] ?? unknown,
          'age': data['age'] ?? unknown,
          'height': data['height'] ?? unknown,
          'substrate': data['substrate'] ?? unknown,
          'comments': data['comments'] ?? '',
        },
      );

  void update(Map<String, String> updateData) {
    final updatedSpecies = updateData['species'];
    species = updatedSpecies ?? species;

    data = {...data, ...updateData};
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    // list all the properties of your class here.
    // See the documentation of debugFillProperties for more information.
    properties.add(StringProperty('name', species));
    properties.add(StringProperty('quantity', data['quantity']));
    properties.add(StringProperty('sex', data['sex']));
    properties.add(StringProperty('observationType', data['observationType']));
    properties.add(StringProperty('age', data['age']));
    properties.add(StringProperty('height', data['height']));
    properties.add(StringProperty('substrate', data['substrate']));
    properties.add(StringProperty('id', id));
    properties.add(StringProperty('comments', data['comments']));
    properties.add(DiagnosticsProperty<DateTime?>('seenAt', seenAt));
  }
}
