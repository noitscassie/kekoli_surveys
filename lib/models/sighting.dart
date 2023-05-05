import 'dart:convert';

import 'package:flutter/foundation.dart';

class Sighting with DiagnosticableTreeMixin {
  final String species;
  final String quantity;
  final String sex;
  final String observationType;
  final String age;
  final String height;
  final String substrate;

  static const quantityTitle = 'Quantity';
  static const heightTitle = 'Height';
  static const substrateTitle = 'Substrate';
  static const sexTitle = 'Sex';
  static const observationTitle = 'Observation';
  static const ageTitle = 'Age';
  static const speciesTitle = 'Species';

  static const unknown = 'Unknown';

  Sighting(
      {required this.quantity,
      required this.sex,
      required this.observationType,
      required this.age,
      required this.height,
      required this.substrate,
      required this.species});

  Sighting.fromMap(Map<String, dynamic> map)
      : quantity = map[quantityTitle] ?? unknown,
        sex = map[sexTitle] ?? unknown,
        observationType = map[observationTitle] ?? unknown,
        age = map[ageTitle] ?? unknown,
        height = map[heightTitle] ?? unknown,
        substrate = map[substrateTitle] ?? unknown,
        species = map[speciesTitle] ?? unknown;

  String toJson() => json.encode(attributes);

  Map<String, String> get attributes => {
        quantityTitle: quantity,
        heightTitle: height,
        substrateTitle: substrate,
        sexTitle: sex,
        observationTitle: observationType,
        ageTitle: age,
        speciesTitle: species,
      };

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    // list all the properties of your class here.
    // See the documentation of debugFillProperties for more information.
    properties.add(StringProperty('name', species));
    properties.add(StringProperty('quantity', quantity));
    properties.add(StringProperty('sex', sex));
    properties.add(StringProperty('observationType', observationType));
    properties.add(StringProperty('age', age));
    properties.add(StringProperty('height', height));
    properties.add(StringProperty('substrate', substrate));
  }
}
