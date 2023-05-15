import 'dart:convert';

import 'package:dartx/dartx.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class Sighting with DiagnosticableTreeMixin {
  final String id;
  String species;
  String quantity;
  String sex;
  String observationType;
  String age;
  String height;
  String substrate;
  String comments;

  static const unknown = 'Unknown';

  Sighting(
      {required this.quantity,
      required this.sex,
      required this.observationType,
      required this.age,
      required this.height,
      required this.substrate,
      required this.species,
      this.comments = ''})
      : id = const Uuid().v4();

  Sighting.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        quantity = map['quantity'] ?? unknown,
        sex = map['sex'] ?? unknown,
        observationType = map['observationType'] ?? unknown,
        age = map['age'] ?? unknown,
        height = map['height'] ?? unknown,
        substrate = map['substrate'] ?? unknown,
        species = map['species'] ?? unknown,
        comments = map['comments'] ?? '';

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
        'comments': comments,
      };

  Map<String, String> get displayAttributes => {
        'Quantity': quantity,
        'Height': height,
        'Substrate': substrate,
        'Sex': sex,
        'Observation': observationType,
        'Age': age,
        'Comments': comments,
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
      quantity: quantity,
      sex: sex,
      observationType: observationType,
      age: age,
      height: height,
      substrate: substrate,
      species: species,
      comments: comments);

  void update(Map<String, String> data) {
    species = data['species'] ?? species;
    quantity = data['quantity'] ?? quantity;
    sex = data['sex'] ?? sex;
    observationType = data['observationType'] ?? observationType;
    age = data['age'] ?? age;
    height = data['height'] ?? height;
    substrate = data['substrate'] ?? substrate;
    comments = data['comments'] ?? comments;
  }

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
    properties.add(StringProperty('comments', comments));
  }
}
