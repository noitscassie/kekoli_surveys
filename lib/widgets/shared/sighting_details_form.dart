import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/pages/add_sighting_details/age_input_field.dart';
import 'package:kekoldi_surveys/pages/add_sighting_details/comments_input_field.dart';
import 'package:kekoldi_surveys/pages/add_sighting_details/height_input_field.dart';
import 'package:kekoldi_surveys/pages/add_sighting_details/observation_type_input_field.dart';
import 'package:kekoldi_surveys/pages/add_sighting_details/quantity_input_field.dart';
import 'package:kekoldi_surveys/pages/add_sighting_details/sex_input_field.dart';
import 'package:kekoldi_surveys/pages/add_sighting_details/substrate_input_field.dart';
import 'package:kekoldi_surveys/widgets/page_scaffold.dart';

class SightingDetailsForm extends StatelessWidget {
  final String species;
  final Widget fabLabel;
  final VoidCallback onFabPress;
  final bool isFabValid;

  final String initialQuantity;
  final Function(String newQuantity) onQuantityChange;

  final String initialSex;
  final Function(String newSex) onSexChange;

  final String initialObservationType;
  final Function(String newObservationType) onObservationTypeChange;

  final String initialAge;
  final Function(String newAge) onAgeChange;

  final String initialHeight;
  final Function(String newHeight) onHeightChange;

  final String initialSubstrate;
  final Function(String newSubstrate) onSubstrateChange;

  final String initialComments;
  final Function(String newComments) onCommentsChange;

  const SightingDetailsForm({
    super.key,
    required this.species,
    required this.fabLabel,
    required this.onFabPress,
    required this.isFabValid,
    required this.initialQuantity,
    required this.onQuantityChange,
    required this.initialSex,
    required this.onSexChange,
    required this.initialObservationType,
    required this.onObservationTypeChange,
    required this.initialAge,
    required this.onAgeChange,
    required this.initialHeight,
    required this.onHeightChange,
    required this.initialSubstrate,
    required this.onSubstrateChange,
    required this.initialComments,
    required this.onCommentsChange,
  });

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
        title: species,
        fabLabel: Row(
          children: [
            Text('Add $species'),
            const Icon(Icons.add),
          ],
        ),
        isFabValid: isFabValid,
        onFabPress: onFabPress,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 100),
          child: ListView(
            children: [
              QuantityInputField(
                initialValue: initialQuantity,
                onChange: onQuantityChange,
              ),
              HeightInputField(
                  currentHeight: initialHeight, onChange: onHeightChange),
              SubstrateInputField(
                  currentSubstrate: initialSubstrate,
                  onChange: onSubstrateChange),
              SexInputField(onChange: onSexChange, currentSex: initialSex),
              AgeInputField(onChange: onAgeChange, currentAge: initialAge),
              ObservationTypeInputField(
                  onChange: onObservationTypeChange,
                  currentObservationType: initialObservationType),
              CommentsInputField(
                onChange: onCommentsChange,
                initialComments: initialComments,
              )
            ],
          ),
        ));
  }
}
