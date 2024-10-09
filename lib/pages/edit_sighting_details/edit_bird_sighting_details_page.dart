import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/models/bird_survey.dart';
import 'package:kekoldi_surveys/models/bird_survey_segment.dart';
import 'package:kekoldi_surveys/models/sighting.dart';
import 'package:kekoldi_surveys/pages/bird_segment/bird_segment_page.dart';
import 'package:kekoldi_surveys/pages/bird_survey/ongoing_bird_survey_page.dart';
import 'package:kekoldi_surveys/widgets/shared/sighting_details_form.dart';

class EditBirdSightingDetailsPage extends StatefulWidget {
  final BirdSurvey survey;
  final BirdSurveySegment segment;
  final List<Sighting> sightings;

  const EditBirdSightingDetailsPage({
    super.key,
    required this.survey,
    required this.segment,
    required this.sightings,
  });

  @override
  State<EditBirdSightingDetailsPage> createState() =>
      _EditBirdSightingDetailsPageState();
}

class _EditBirdSightingDetailsPageState
    extends State<EditBirdSightingDetailsPage> {
  late Map<String, dynamic> attributes = widget.sightings.last.data;

  void onAttributeChange(String key, String value) => setState(() {
        attributes[key] = value;
      });

  void updateSighting() {
    for (var sighting in widget.sightings) {
      sighting.update(attributes);
    }

    widget.segment.updateSightings(widget.sightings);
    widget.survey.updateSegment(widget.segment);

    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (BuildContext context) => BirdSegmentPage(
              survey: widget.survey,
              segment: widget.segment,
            ),
          ),
          (route) => route.settings.name == OngoingBirdSurveyPage.name);
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
