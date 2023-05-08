import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class Sighting with DiagnosticableTreeMixin {
  final String id;
  final String species;
  final String quantity;
  final String sex;
  final String observationType;
  final String age;
  final String height;
  final String substrate;

  static const unknown = 'Unknown';

  Sighting(
      {required this.quantity,
      required this.sex,
      required this.observationType,
      required this.age,
      required this.height,
      required this.substrate,
      required this.species})
      : id = const Uuid().v4();

  Sighting.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        quantity = map['quantity'] ?? unknown,
        sex = map['height'] ?? unknown,
        observationType = map['substrate'] ?? unknown,
        age = map['sex'] ?? unknown,
        height = map['observation'] ?? unknown,
        substrate = map['age'] ?? unknown,
        species = map['species'] ?? unknown;

  String toJson() => json.encode(attributes);

  Map<String, String> get attributes => {
        'id': id,
        'quantity': quantity,
        'height': height,
        'substrate': substrate,
        'sex': sex,
        'observationType': observationType,
        'age': age,
        'species': species,
      };

  Map<String, String> get displayAttributes => {
        'Quantity': quantity,
        'Height': height,
        'Substrate': substrate,
        'Sex': sex,
        'Observation': observationType,
        'Age': age,
      };

  Sighting duplicate() => Sighting(quantity: quantity, sex: sex, observationType: observationType, age: age, height: height, substrate: substrate, species: species);

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
    properties.add(StringProperty('id', id));
  }
}
