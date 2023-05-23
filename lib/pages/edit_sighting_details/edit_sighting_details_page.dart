import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/models/biodiversity_survey.dart';
import 'package:kekoldi_surveys/models/sighting.dart';
import 'package:kekoldi_surveys/pages/ongoing_survey/ongoing_biodiversity_survey_page.dart';
import 'package:kekoldi_surveys/widgets/shared/sighting_details_form.dart';

class EditSightingDetailsPage extends StatefulWidget {
  final BiodiversitySurvey survey;
  final List<Sighting> sightings;

  const EditSightingDetailsPage(
      {super.key, required this.survey, required this.sightings});

  @override
  State<EditSightingDetailsPage> createState() =>
      _EditSightingDetailsPageState();
}

class _EditSightingDetailsPageState extends State<EditSightingDetailsPage> {
  late Map<String, dynamic> attributes = widget.sightings.last.data;

  void onAttributeChange(String key, String value) => setState(() {
        attributes[key] = value;
      });

  Future<void> updateSighting() async {
    for (var sighting in widget.sightings) {
      sighting.update(attributes);
    }

    await widget.survey.updateSightings(widget.sightings);

    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  OngoingBiodiversitySurveyPage(survey: widget.survey)),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SightingDetailsForm(
      species: widget.sightings.last.species,
      fabLabel: const Row(
        children: [
          Text('Save Details'),
          Icon(Icons.save_alt),
        ],
      ),
      onFabPress: updateSighting,
      attributes: attributes,
      onAttributeChange: onAttributeChange,
      configuration: widget.survey.configuration,
    );
  }
}
