import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/models/input_field_config.dart';
import 'package:kekoldi_surveys/widgets/page_scaffold.dart';

class AddWeatherPage extends StatefulWidget {
  final Function(
    String description,
    String endTemperature,
    String rainfall,
  ) onAddWeather;

  final String? description;
  final String? endTemperature;
  final String? rainfall;

  const AddWeatherPage({
    super.key,
    required this.onAddWeather,
    this.description,
    this.endTemperature,
    this.rainfall,
  });

  @override
  State<AddWeatherPage> createState() => _AddWeatherPageState();
}

class _AddWeatherPageState extends State<AddWeatherPage> {
  late final _descriptionField = InputFieldConfig.text(
    label: 'Description',
    required: true,
    defaultValue: widget.description ?? '',
  );

  late final _endTemperatureField = InputFieldConfig.number(
    label: 'End Temperature (℃)',
    required: false,
    defaultValue: widget.endTemperature ?? '',
  );

  late final _rainfallField = InputFieldConfig.number(
    label: 'Rainfall (cm)',
    required: false,
    defaultValue: widget.rainfall ?? '0',
  );

  late final List<InputFieldConfig> _fields = [
    _descriptionField,
    _endTemperatureField,
    _rainfallField,
  ];

  late final Map<String, String> _data = {
    for (var config in _fields) config.label: config.defaultValue
  };

  void _onFieldChange(String key, dynamic value) => setState(
        () => _data[key] = value,
      );

  bool get _isFabValid => _fields.all(
        (field) =>
            field.required ? _data[field.label]?.isNotEmpty == true : true,
      );

  @override
  Widget build(BuildContext context) {
    return PageScaffold.withScrollableChildren(
      title: 'Weather Information',
      fabLabel: const Row(
        children: [
          Text('Save Weather'),
          Icon(Icons.sunny),
        ],
      ),
      isFabValid: _isFabValid,
      onFabPress: () => widget.onAddWeather(
        _data[_descriptionField.label]!,
        _data[_endTemperatureField.label]!,
        _data[_rainfallField.label]!,
      ),
      children: [
        ..._fields.map(
          (field) => field.inputField(
            onChange: (dynamic value) => _onFieldChange(field.label, value),
          ),
        ),
      ],
    );
  }
}
