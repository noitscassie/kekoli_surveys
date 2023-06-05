import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/models/biodiversity_survey.dart';
import 'package:kekoldi_surveys/models/sighting.dart';
import 'package:kekoldi_surveys/pages/add_sighting_details/add_biodiversity_sighting_details_page.dart';
import 'package:kekoldi_surveys/pages/biodiversity_survey/add_biodiversity_tally_modal.dart';
import 'package:kekoldi_surveys/pages/biodiversity_survey/remove_biodiversity_tally_modal.dart';
import 'package:kekoldi_surveys/pages/edit_species/edit_biodiversity_species_page.dart';
import 'package:kekoldi_surveys/widgets/page_scaffold.dart';
import 'package:kekoldi_surveys/widgets/shared/sighting_lists/sightings_list.dart';
import 'package:kekoldi_surveys/widgets/shared/sighting_lists/sightings_stats.dart';
import 'package:kekoldi_surveys/widgets/shared/sighting_options_sheet.dart';

class BiodiversitySurveyScaffold extends StatefulWidget {
  final BiodiversitySurvey survey;
  final String title;
  final Widget fabLabel;
  final VoidCallback onFabPress;
  final List<Widget> actions;
  final Widget? sortSelectorSibling;

  const BiodiversitySurveyScaffold({
    super.key,
    required this.survey,
    required this.title,
    required this.fabLabel,
    required this.onFabPress,
    required this.actions,
    this.sortSelectorSibling,
  });

  @override
  State<BiodiversitySurveyScaffold> createState() =>
      _BiodiversitySurveyScaffoldState();
}

class _BiodiversitySurveyScaffoldState
    extends State<BiodiversitySurveyScaffold> {
  late BiodiversitySurvey _statefulSurvey = widget.survey;

  void _onIncrement(Sighting sighting) => showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => AddBiodiversityTallyModal(
          sighting: sighting,
          survey: widget.survey,
          onChangeSurvey: _updateSurvey,
        ),
      );

  void _onDecrement(List<Sighting> sightings) => showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => RemoveBiodiversityTallyModal(
          survey: widget.survey,
          sightings: sightings,
          onChangeSurvey: _updateSurvey,
        ),
      );

  void _onEdit(List<Sighting> sightings) => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => EditBiodiversitySpeciesPage(
            survey: widget.survey,
            sightings: sightings,
          ),
        ),
      );

  void _showBottomSheet(List<Sighting> sightings) => showModalBottomSheet(
        context: context,
        builder: (BuildContext context) => SightingOptionsSheet(
          onIncrement: () => _onIncrement(sightings.last),
          onDecrement: () => _onDecrement(sightings),
          onEditMostRecent: () => _onEdit([sightings.last]),
          onEditAll: () => _onEdit(sightings),
        ),
      );

  void _navigateToAddSightingDetailsPage(String species) =>
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => AddBiodiversitySightingDetailsPage(
            survey: _statefulSurvey,
            species: species,
          ),
        ),
      );

  void _updateSurvey(BiodiversitySurvey survey) => setState(
        () {
          _statefulSurvey = survey;
        },
      );

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: widget.title,
      fabLabel: widget.fabLabel,
      onFabPress: widget.onFabPress,
      actions: widget.actions,
      backButtonToHomeTab: 0,
      child: SightingsList.editable(
        sightings: _statefulSurvey.sightings,
        header: SightingsStats(
          sightings: _statefulSurvey.sightings,
        ),
        onOptionsTap: _showBottomSheet,
        onIncrement: _onIncrement,
        onDecrement: _onDecrement,
        onAddNew: _navigateToAddSightingDetailsPage,
        sortSelectorSibling: widget.sortSelectorSibling,
      ),
    );
  }
}
