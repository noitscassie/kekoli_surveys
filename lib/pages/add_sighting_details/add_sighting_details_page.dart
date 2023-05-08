import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/constants/heights.dart';
import 'package:kekoldi_surveys/constants/substrates.dart';
import 'package:kekoldi_surveys/models/sighting.dart';
import 'package:kekoldi_surveys/models/survey.dart';
import 'package:kekoldi_surveys/pages/add_sighting_details/age_input_field.dart';
import 'package:kekoldi_surveys/pages/add_sighting_details/confirm_sighting_details_dialog.dart';
import 'package:kekoldi_surveys/pages/add_sighting_details/height_input_field.dart';
import 'package:kekoldi_surveys/pages/add_sighting_details/observation_type_input_field.dart';
import 'package:kekoldi_surveys/pages/add_sighting_details/quantity_input_field.dart';
import 'package:kekoldi_surveys/pages/add_sighting_details/sex_input_field.dart';
import 'package:kekoldi_surveys/pages/add_sighting_details/substrate_input_field.dart';
import 'package:kekoldi_surveys/widgets/page_scaffold.dart';

class AddSightingDetailsPage extends StatefulWidget {
  final Survey survey;
  final String species;

  const AddSightingDetailsPage(
      {super.key, required this.survey, required this.species});

  @override
  State<AddSightingDetailsPage> createState() => _AddSightingDetailsPageState();
}

class _AddSightingDetailsPageState extends State<AddSightingDetailsPage> {
  String? selectedQuantity;
  String? selectedSex;
  String? selectedObservationType;
  String? selectedAge;
  String selectedHeight = heights.first;
  String selectedSubstrate = substrates.sorted().first;

  bool get valid =>
      selectedQuantity != null &&
      selectedSex != null &&
      selectedObservationType != null &&
      selectedAge != null;

  void showConfirmationDialog() => showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => ConfirmSightingDetailsDialog(
              survey: widget.survey,
              sighting: Sighting(
                  species: widget.species,
                  quantity: selectedQuantity!,
                  sex: selectedSex!,
                  observationType: selectedObservationType!,
                  age: selectedAge!,
                  height: selectedHeight,
                  substrate: selectedSubstrate),
            ));

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
        title: widget.species,
        fabLabel: Row(
          children: [
            Text('Add ${widget.species}'),
            const Icon(Icons.add),
          ],
        ),
        isFabValid: valid,
        onFabPress: showConfirmationDialog,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 100),
          child: ListView(
            children: [
              QuantityInputField(
                onChange: (String? quantity) {
                  setState(() {
                    selectedQuantity = quantity;
                  });
                },
              ),
              HeightInputField(
                  currentHeight: selectedHeight,
                  onChange: (String newHeight) {
                    setState(() {
                      selectedHeight = newHeight;
                    });
                  }),
              SubstrateInputField(
                  currentSubstrate: selectedSubstrate,
                  onChange: (String newSubstrate) {
                    setState(() {
                      selectedSubstrate = newSubstrate;
                    });
                  }),
              SexInputField(
                  onChange: (String value) {
                    setState(() {
                      selectedSex = value;
                    });
                  },
                  currentSex: selectedSex ?? ''),
              ObservationTypeInputField(
                  onChange: (String value) {
                    setState(() {
                      selectedObservationType = value;
                    });
                  },
                  currentObservationType: selectedObservationType ?? ''),
              AgeInputField(
                  onChange: (String value) {
                    setState(() {
                      selectedAge = value;
                    });
                  },
                  currentAge: selectedAge ?? ''),
            ],
          ),
        ));
  }
}
