import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/models/survey.dart';
import 'package:kekoldi_surveys/widgets/page_scaffold.dart';

class AddWeatherPage extends StatefulWidget {
  final Function(String weather) onAddWeather;
  final Survey survey;

  const AddWeatherPage(
      {super.key, required this.survey, required this.onAddWeather});

  @override
  State<AddWeatherPage> createState() => _AddWeatherPageState();
}

class _AddWeatherPageState extends State<AddWeatherPage> {
  String weather = '';

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: 'Add Weather',
      fabLabel: Row(
        children: const [Text('Finish Survey'), Icon(Icons.check)],
      ),
      isFabValid: weather.isNotEmpty,
      onFabPress: () => widget.onAddWeather(weather),
      child: Column(children: [
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextFormField(
                autofocus: true,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  border: const UnderlineInputBorder(),
                  labelText: 'Weather',
                  labelStyle: Theme.of(context).textTheme.bodySmall,
                ),
                onChanged: (String value) {
                  setState(() {
                    weather = value;
                  });
                },
              ),
            ))
      ]),
    );
  }
}
