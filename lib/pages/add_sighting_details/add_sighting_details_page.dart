import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/models/sighting.dart';
import 'package:kekoldi_surveys/models/survey.dart';
import 'package:kekoldi_surveys/models/survey_configuration.dart';
import 'package:kekoldi_surveys/pages/add_sighting_details/confirm_sighting_details_dialog.dart';
import 'package:kekoldi_surveys/widgets/shared/sighting_details_form.dart';

class AddSightingDetailsPage extends StatefulWidget {
  final Survey survey;
  final String species;

  const AddSightingDetailsPage(
      {super.key, required this.survey, required this.species});

  @override
  State<AddSightingDetailsPage> createState() => _AddSightingDetailsPageState();
}

class _AddSightingDetailsPageState extends State<AddSightingDetailsPage> {
  final _config = SurveyConfiguration();
  late Map<String, String> attributes = _config.asAttributes;

  void onAttributeChange(String key, String value) => setState(() {
        attributes[key] = value;
      });

  void showConfirmationDialog() => showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => ConfirmSightingDetailsDialog(
            survey: widget.survey,
            sighting: Sighting(
              species: widget.species,
              data: attributes,
            ),
          ));

  @override
  Widget build(BuildContext context) {
    return SightingDetailsForm(
      species: widget.species,
      fabLabel: Row(
        children: [
          Text('Add ${widget.species}'),
          const Icon(Icons.add),
        ],
      ),
      onFabPress: showConfirmationDialog,
      attributes: attributes,
      onAttributeChange: onAttributeChange,
    );
  }
}
