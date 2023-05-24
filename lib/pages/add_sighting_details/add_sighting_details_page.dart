import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/models/biodiversity_survey.dart';
import 'package:kekoldi_surveys/models/sighting.dart';
import 'package:kekoldi_surveys/pages/add_sighting_details/confirm_biodiversity_sighting_details_dialog.dart';
import 'package:kekoldi_surveys/widgets/shared/sighting_details_form.dart';

class AddSightingDetailsPage extends StatefulWidget {
  final BiodiversitySurvey survey;
  final String species;

  const AddSightingDetailsPage(
      {super.key, required this.survey, required this.species});

  @override
  State<AddSightingDetailsPage> createState() => _AddSightingDetailsPageState();
}

class _AddSightingDetailsPageState extends State<AddSightingDetailsPage> {
  late Map<String, String> attributes =
      widget.survey.configuration.asAttributes;

  void onAttributeChange(String key, String value) => setState(() {
        attributes[key] = value;
      });

  void showConfirmationDialog() => showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) =>
          ConfirmBiodiversitySightingDetailsDialog(
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
      configuration: widget.survey.configuration,
    );
  }
}
