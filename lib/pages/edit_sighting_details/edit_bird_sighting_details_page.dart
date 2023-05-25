import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/constants/default_bird_sighting_fields.dart';
import 'package:kekoldi_surveys/models/bird_survey.dart';
import 'package:kekoldi_surveys/models/bird_survey_segment.dart';
import 'package:kekoldi_surveys/models/sighting.dart';
import 'package:kekoldi_surveys/pages/ongoing_bird_segment/ongoing_bird_segment_page.dart';
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

  Future<void> updateSighting() async {
    for (var sighting in widget.sightings) {
      sighting.update(attributes);
    }

    widget.segment.updateSightings(widget.sightings);
    await widget.survey.updateSegment(widget.segment);

    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (BuildContext context) => OngoingBirdSegmentPage(
                    survey: widget.survey,
                    segment: widget.segment,
                  )),
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
      fields: defaultBirdSightingFields,
    );
  }
}
