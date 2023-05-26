import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class CsvColumn with DiagnosticableTreeMixin {
  final String id;
  String header;
  String? field;

  CsvColumn({
    required this.header,
    this.field,
  }) : id = const Uuid().v4();

  CsvColumn.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        header = json['header'],
        field = json['field'];

  String toJson() => jsonEncode(attributes);

  Map<String, dynamic> get attributes => {
        'id': id,
        'header': header,
        'field': field,
      };
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('id', id));
    properties.add(StringProperty('header', header));
    properties.add(StringProperty('field', field));
  }
}
