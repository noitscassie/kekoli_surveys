import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/models/sighting.dart';
import 'package:kekoldi_surveys/models/survey.dart';
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
  String quantity = '1';
  String sex = Sighting.unknown;
  String? observationType;
  String age = Sighting.unknown;
  String height = Sighting.unknown;
  String substrate = Sighting.unknown;
  String comments = '';

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

  bool get valid => observationType != null;

  void showConfirmationDialog() => showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => ConfirmSightingDetailsDialog(
            survey: widget.survey,
            sighting: Sighting(
                species: widget.species,
                quantity: quantity,
                sex: sex,
                observationType: observationType!,
                age: age,
                height: height,
                substrate: substrate,
                comments: comments),
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
        isFabValid: valid,
        initialQuantity: quantity,
        onQuantityChange: onQuantityChange,
        initialSex: sex,
        onSexChange: onSexChange,
        initialObservationType: observationType ?? '',
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
