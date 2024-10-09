import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/models/biodiversity_survey.dart';
import 'package:kekoldi_surveys/models/sighting.dart';
import 'package:kekoldi_surveys/pages/biodiversity_survey/biodiversity_survey_page.dart';
import 'package:kekoldi_surveys/widgets/shared/sighting_details_form.dart';

class EditBiodiversitySightingDetailsPage extends StatefulWidget {
  final BiodiversitySurvey survey;
  final List<Sighting> sightings;

  const EditBiodiversitySightingDetailsPage(
      {super.key, required this.survey, required this.sightings});

  @override
  State<EditBiodiversitySightingDetailsPage> createState() =>
      _EditBiodiversitySightingDetailsPageState();
}

class _EditBiodiversitySightingDetailsPageState
    extends State<EditBiodiversitySightingDetailsPage> {
  late Map<String, dynamic> attributes = widget.sightings.last.data;

  void onAttributeChange(String key, String value) => setState(() {
        attributes[key] = value;
      });

  void updateSighting() {
    for (var sighting in widget.sightings) {
      sighting.update(attributes);
    }

    widget.survey.updateSightings(widget.sightings);

    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (BuildContext context) => BiodiversitySurveyPage(
            survey: widget.survey,
          ),
        ),
        (route) => route.settings.name == '/',
      );
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
      fields: widget.survey.configuration.fields,
    );
  }
}
