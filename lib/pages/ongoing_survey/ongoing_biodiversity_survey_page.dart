import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/models/biodiversity_survey.dart';
import 'package:kekoldi_surveys/models/sighting.dart';
import 'package:kekoldi_surveys/pages/add_sighting_details/add_biodiversity_sighting_details_page.dart';
import 'package:kekoldi_surveys/pages/choose_species/choose_biodiversity_species_page.dart';
import 'package:kekoldi_surveys/pages/edit_species/edit_biodiversity_species_page.dart';
import 'package:kekoldi_surveys/pages/ongoing_survey/add_biodiversity_tally_modal.dart';
import 'package:kekoldi_surveys/pages/ongoing_survey/complete_survey_modal.dart';
import 'package:kekoldi_surveys/pages/ongoing_survey/remove_biodiversity_tally_modal.dart';
import 'package:kekoldi_surveys/pages/ongoing_survey/sighting_options_sheet.dart';
import 'package:kekoldi_surveys/utils/time_utils.dart';
import 'package:kekoldi_surveys/widgets/expandable_list/expandable_list_item.dart';
import 'package:kekoldi_surveys/widgets/page_scaffold.dart';
import 'package:kekoldi_surveys/widgets/shared/species_list_count_and_tallies.dart';

class OngoingBiodiversitySurveyPage extends StatefulWidget {
  final BiodiversitySurvey survey;

  const OngoingBiodiversitySurveyPage({super.key, required this.survey});

  @override
  State<OngoingBiodiversitySurveyPage> createState() =>
      _OngoingBiodiversitySurveyPageState();
}

class _OngoingBiodiversitySurveyPageState
    extends State<OngoingBiodiversitySurveyPage> {
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

  void _navigateToChooseSpeciesPage() => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) =>
              ChooseBiodiversitySpeciesPage(survey: _statefulSurvey),
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

  void _onCompleteSurvey() => showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => CompleteSurveyModal(
          survey: widget.survey,
          onChangeSurvey: _updateSurvey,
        ),
      );

  void _updateSurvey(BiodiversitySurvey survey) => setState(
        () {
          _statefulSurvey = survey;
        },
      );

  @override
  Widget build(BuildContext context) {
    return PageScaffold.withScrollableChildren(
      title:
          '${_statefulSurvey.trail} Survey, ${DateFormats.ddmmyyyy(_statefulSurvey.startAt ?? DateTime.now())}',
      fabLabel: const Row(
        children: [
          Text('Add New Sighting'),
          Icon(Icons.add),
        ],
      ),
      onFabPress: _navigateToChooseSpeciesPage,
      actions: [
        IconButton(
          onPressed: _onCompleteSurvey,
          icon: const Icon(Icons.check),
        )
      ],
      children: [
        ...widget.survey.sightings
            .groupBy((sighting) => sighting.species)
            .entries
            .sortedBy((entry) => entry.key)
            .mapIndexed(
              (index, entry) => ExpandableListItem(
                title: entry.key,
                children: [
                  ...entry.value
                      .groupBy((sighting) => sighting.attributesString)
                      .entries
                      .sortedBy((entry) => entry.key)
                      .map(
                        (entry) => ExpandableListItemChild(
                          title: entry.key,
                          subtitle: 'Tap for options',
                          onTap: () => _showBottomSheet(entry.value),
                          trailing: SpeciesListCountAndTallies(
                            count: entry.value.length.toString(),
                            onIncrement: () => _onIncrement(entry.value.last),
                            onDecrement: () => _onDecrement(entry.value),
                          ),
                        ),
                      ),
                  ExpandableListItemChild(
                    title: 'Add new ${entry.key} observation',
                    trailing: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Icon(Icons.add),
                    ),
                    onTap: () => _navigateToAddSightingDetailsPage(entry.key),
                  ),
                ],
              ),
            ),
      ],
    );
  }
}
