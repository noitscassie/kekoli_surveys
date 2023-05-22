import 'dart:convert';

import 'package:dartx/dartx.dart';
import 'package:flutter/foundation.dart';
import 'package:kekoldi_surveys/models/input_field_config.dart';
import 'package:kekoldi_surveys/models/survey.dart';
import 'package:uuid/uuid.dart';

class Sighting with DiagnosticableTreeMixin {
  final String id;
  String species;
  Map<String, dynamic> data;
  DateTime seenAt;

  static const unknown = 'Unknown';

  Sighting({required this.species, required this.data})
      : id = const Uuid().v4(),
        seenAt = DateTime.now();

  Sighting.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        species = map['species'],
        data = map['data'],
        seenAt = DateTime.parse(map['seenAt']);

  String toJson() => json.encode(attributes);

  Map<String, dynamic> get attributes => {
        'id': id,
        'species': species,
        'seenAt': seenAt.toIso8601String(),
        'data': data,
      };

  String get attributesString => data.values
      .filter((value) => value.isNotEmpty && value != Sighting.unknown)
      .join(', ');

  Map<String, dynamic> orderedData(BiodiversitySurvey survey) => {
        for (var label in survey.configuration.fields
            .map((InputFieldConfig field) => field.label))
          label: data[label]
      };

  Sighting duplicate() => Sighting(
        species: species,
        data: data,
      );

  Sighting update(Map<String, dynamic> updateData) {
    final updatedSpecies = updateData.remove('species');
    species = updatedSpecies ?? species;

    data = {...data, ...updateData};

    return this;
  }

  int abundance() {
    try {
      return int.parse(data['Quantity']);
    } catch (e) {
      return 1;
    }
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
