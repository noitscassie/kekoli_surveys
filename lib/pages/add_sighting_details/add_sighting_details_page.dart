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
  Map<String, String> attributes = {
    'quantity': '1',
    'sex': Sighting.unknown,
    'observationType': '',
    'age': Sighting.unknown,
    'height': Sighting.unknown,
    'substrate': Sighting.unknown,
    'comments': '',
  };

  void onAttributeChange(Map<String, String> newAttributes) => setState(() {
        attributes = {...attributes, ...newAttributes};
      });

  bool get valid => attributes['observationType']?.isNotEmpty == true;

  void showConfirmationDialog() => showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => ConfirmSightingDetailsDialog(
            survey: widget.survey,
            sighting: Sighting(
              species: widget.species,
              data: {
                'quantity': attributes['quantity'] ?? Sighting.unknown,
                'sex': attributes['sex'] ?? Sighting.unknown,
                'observationType':
                    attributes['observationType'] ?? Sighting.unknown,
                'age': attributes['age'] ?? Sighting.unknown,
                'height': attributes['height'] ?? Sighting.unknown,
                'substrate': attributes['substrate'] ?? Sighting.unknown,
                'comments': attributes['comments'] ?? ''
              },
            ),
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
      attributes: attributes,
      onAttributeChange: onAttributeChange,
    );
  }
}
