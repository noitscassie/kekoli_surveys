import 'package:flutter/foundation.dart';
import 'package:kekoldi_surveys/models/species.dart';

class Sighting with DiagnosticableTreeMixin {
  final Species species;

  Sighting({required this.species});

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    // list all the properties of your class here.
    // See the documentation of debugFillProperties for more information.
    properties.add(StringProperty('name', species.name));
    properties.add(StringProperty('scientificName', species.scientificName));
  }
}
