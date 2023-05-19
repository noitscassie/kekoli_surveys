import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/models/survey.dart';
import 'package:kekoldi_surveys/utils/time_utils.dart';
import 'package:kekoldi_surveys/widgets/data_tile.dart';

class SurveyStats extends StatelessWidget {
  final Survey survey;

  const SurveyStats({super.key, required this.survey});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          DataTile(
              data: survey.totalObservations.toString(),
              label: 'Total Observations'),
          DataTile(
              data: survey.uniqueSpecies.toString(), label: 'Unique Species'),
          DataTile(
              data: survey.totalAbundance.toString(), label: 'Total Abundance'),
        ],
      ),
      Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              DataTile(
                  data: TimeFormats.timeHoursAndMinutes(survey.startAt!),
                  label: 'Start Time'),
              DataTile(
                  data: survey.endAt == null
                      ? '--'
                      : TimeFormats.timeHoursAndMinutes(survey.endAt!),
                  label: 'End Time'),
              DataTile(
                  data: TimeFormats.hmFromMinutes(survey.lengthInMinutes()),
                  label: 'Duration'),
            ],
          ))
    ]);
  }
}
