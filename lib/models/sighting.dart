import 'package:flutter/foundation.dart';
import 'package:kekoldi_surveys/models/species.dart';

class Sighting with DiagnosticableTreeMixin {
  final Species species;
  final int quantity;
  final String sex;
  final String observationType;
  final String age;
  final String height;
  final String substrate;

  Sighting(
      {required this.quantity,
      required this.sex,
      required this.observationType,
      required this.age,
      required this.height,
      required this.substrate,
      required this.species});

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    // list all the properties of your class here.
    // See the documentation of debugFillProperties for more information.
    properties.add(StringProperty('name', species.name));
    properties.add(IntProperty('quantity', quantity));
    properties.add(StringProperty('sex', sex));
    properties.add(StringProperty('observationType', observationType));
    properties.add(StringProperty('age', age));
    properties.add(StringProperty('height', height));
    properties.add(StringProperty('substrate', substrate));
    properties.add(DiagnosticsProperty<Species>('species', species));
  }
}
