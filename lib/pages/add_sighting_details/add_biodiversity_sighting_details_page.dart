import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/models/biodiversity_survey.dart';
import 'package:kekoldi_surveys/models/sighting.dart';
import 'package:kekoldi_surveys/pages/add_sighting_details/confirm_biodiversity_sighting_details_dialog.dart';
import 'package:kekoldi_surveys/widgets/shared/sighting_details_form.dart';

class AddBiodiversitySightingDetailsPage extends StatefulWidget {
  final BiodiversitySurvey survey;
  final String species;

  const AddBiodiversitySightingDetailsPage(
      {super.key, required this.survey, required this.species});

  @override
  State<AddBiodiversitySightingDetailsPage> createState() =>
      _AddBiodiversitySightingDetailsPageState();
}

class _AddBiodiversitySightingDetailsPageState
    extends State<AddBiodiversitySightingDetailsPage> {
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
      fields: widget.survey.configuration.fields,
    );
  }
}
