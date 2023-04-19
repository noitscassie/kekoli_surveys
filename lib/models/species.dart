import 'package:flutter/foundation.dart';

class Species with DiagnosticableTreeMixin {
  final String name;
  final String scientificName;

  String get searchableName => name.toLowerCase();
  String get searchableInitials =>
      searchableName.split(' ').map((String word) => word.split('')[0]).join();

  Species({required this.name, required this.scientificName});

  bool matchesSearchTerm(String searchTerm) =>
      searchableName.contains(searchTerm) ||
      searchableInitials.contains(searchTerm);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    // list all the properties of your class here.
    // See the documentation of debugFillProperties for more information.
    properties.add(StringProperty('name', name));
    properties.add(StringProperty('scientificName', scientificName));
  }
}
