import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/models/sighting.dart';
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
  final Map<String, String> attributes;
  final Function(Map<String, String> newAttribute) onAttributeChange;

  const SightingDetailsForm({
    super.key,
    required this.species,
    required this.fabLabel,
    required this.onFabPress,
    required this.isFabValid,
    required this.attributes,
    required this.onAttributeChange,
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
                initialValue: attributes['quantity'] ?? Sighting.unknown,
                onChange: (String newQuantity) =>
                    onAttributeChange({'quantity': newQuantity}),
              ),
              HeightInputField(
                  currentHeight: attributes['height'] ?? Sighting.unknown,
                  onChange: (String newHeight) =>
                      onAttributeChange({'height': newHeight})),
              SubstrateInputField(
                  currentSubstrate: attributes['substrate'] ?? Sighting.unknown,
                  onChange: (String newHeight) =>
                      onAttributeChange({'substrate': newHeight})),
              SexInputField(
                  onChange: (String newSex) =>
                      onAttributeChange({'sex': newSex}),
                  currentSex: attributes['sex'] ?? Sighting.unknown),
              AgeInputField(
                  onChange: (String newAge) =>
                      onAttributeChange({'age': newAge}),
                  currentAge: attributes['age'] ?? Sighting.unknown),
              ObservationTypeInputField(
                  onChange: (String newObservationType) => onAttributeChange(
                      {'observationType': newObservationType}),
                  currentObservationType: attributes['observationType'] ?? ''),
              CommentsInputField(
                onChange: (String newComments) =>
                    onAttributeChange({'comments': newComments}),
                initialComments: attributes['comments'] ?? '',
              )
            ],
          ),
        ));
  }
}
