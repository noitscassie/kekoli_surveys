import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/models/bird_survey.dart';
import 'package:kekoldi_surveys/models/bird_survey_segment.dart';
import 'package:kekoldi_surveys/models/sighting.dart';
import 'package:kekoldi_surveys/pages/add_sighting_details/confirm_bird_sighting_details_dialog.dart';
import 'package:kekoldi_surveys/widgets/shared/sighting_details_form.dart';

class AddBirdSightingDetailsPage extends StatefulWidget {
  final BirdSurvey survey;
  final BirdSurveySegment segment;
  final String species;

  const AddBirdSightingDetailsPage({
    super.key,
    required this.survey,
    required this.segment,
    required this.species,
  });

  @override
  State<AddBirdSightingDetailsPage> createState() =>
      _AddBirdSightingDetailsPageState();
}

class _AddBirdSightingDetailsPageState
    extends State<AddBirdSightingDetailsPage> {
  late Map<String, String> attributes =
      widget.survey.configuration.asAttributes;

  void onAttributeChange(String key, String value) => setState(() {
        attributes[key] = value;
      });

  void showConfirmationDialog() => showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => ConfirmBirdSightingDetailsDialog(
          survey: widget.survey,
          segment: widget.segment,
          sighting: Sighting(
            species: widget.species,
            data: attributes,
          ),
        ),
      );

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
