import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/models/sighting.dart';
import 'package:kekoldi_surveys/models/survey.dart';
import 'package:kekoldi_surveys/pages/ongoing_survey/ongoing_survey_page.dart';
import 'package:kekoldi_surveys/widgets/shared/sighting_details_form.dart';

class EditSightingDetailsPage extends StatefulWidget {
  final Survey survey;
  final Sighting sighting;

  const EditSightingDetailsPage(
      {super.key, required this.survey, required this.sighting});

  @override
  State<EditSightingDetailsPage> createState() =>
      _EditSightingDetailsPageState();
}

class _EditSightingDetailsPageState extends State<EditSightingDetailsPage> {
  late Map<String, String> attributes = {
    'quantity': widget.sighting.data['quantity'] ?? Sighting.unknown,
    'sex': widget.sighting.data['sex'] ?? Sighting.unknown,
    'observationType':
        widget.sighting.data['observationType'] ?? Sighting.unknown,
    'age': widget.sighting.data['age'] ?? Sighting.unknown,
    'height': widget.sighting.data['height'] ?? Sighting.unknown,
    'substrate': widget.sighting.data['substrate'] ?? Sighting.unknown,
    'comments': widget.sighting.data['comments'] ?? '',
  };

  void onAttributeChange(Map<String, String> newAttributes) => setState(() {
        attributes = {...attributes, ...newAttributes};
      });

  Future<void> updateSighting() async {
    widget.sighting.update(attributes);
    await widget.survey.updateSighting(widget.sighting);

    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  OngoingSurveyPage(survey: widget.survey)),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SightingDetailsForm(
      species: widget.sighting.species,
      fabLabel: const Row(
        children: [
          Text('Save Details'),
          Icon(Icons.save_alt),
        ],
      ),
      onFabPress: updateSighting,
      isFabValid: true,
      attributes: attributes,
      onAttributeChange: onAttributeChange,
    );
  }
}
