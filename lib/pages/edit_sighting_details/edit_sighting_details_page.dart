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
  late String quantity = widget.sighting.quantity;
  late String sex = widget.sighting.sex;
  late String observationType = widget.sighting.observationType;
  late String age = widget.sighting.age;
  late String height = widget.sighting.height;
  late String substrate = widget.sighting.substrate;
  late String comments = widget.sighting.comments;

  void onQuantityChange(String newQuantity) =>
      setState(() => quantity = newQuantity);

  void onSexChange(String newSex) => setState(() => sex = newSex);

  void onObservationTypeChange(String newObservationType) =>
      setState(() => observationType = newObservationType);

  void onAgeChange(String newAge) => setState(() => age = newAge);

  void onHeightChange(String newHeight) => setState(() => height = newHeight);

  void onSubstrateChange(String newSubstrate) =>
      setState(() => substrate = newSubstrate);

  void onCommentsChange(String newComments) =>
      setState(() => comments = newComments);

  Future<void> updateSighting() async {
    widget.sighting.update({
      'quantity': quantity,
      'sex': sex,
      'observationType': observationType,
      'age': age,
      'height': height,
      'substrate': substrate,
      'comments': comments,
    });
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
        initialQuantity: quantity,
        onQuantityChange: onQuantityChange,
        initialSex: sex,
        onSexChange: onSexChange,
        initialObservationType: observationType,
        onObservationTypeChange: onObservationTypeChange,
        initialAge: age,
        onAgeChange: onAgeChange,
        initialHeight: height,
        onHeightChange: onHeightChange,
        initialSubstrate: substrate,
        onSubstrateChange: onSubstrateChange,
        initialComments: comments,
        onCommentsChange: onCommentsChange);
  }
}
