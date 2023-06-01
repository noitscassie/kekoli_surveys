import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/constants/survey_state.dart';
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
import 'package:kekoldi_surveys/widgets/dialogs/dialog_scaffold.dart';
import 'package:kekoldi_surveys/widgets/dialogs/primary_cta.dart';
import 'package:kekoldi_surveys/widgets/page_scaffold.dart';
import 'package:kekoldi_surveys/widgets/shared/sighting_lists/sightings_list.dart';
import 'package:kekoldi_surveys/widgets/shared/sighting_lists/sightings_stats.dart';

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

  void _onStartSurveyTap() => showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => DialogScaffold(
            title: 'Start Survey?',
            primaryCta: PrimaryCta(
              text: 'Start',
              onTap: _startSurvey,
            ),
            children: [
              Text(
                  'The time is ${TimeFormats.timeHoursAndMinutes(DateTime.now())}. Do you want to start the ${_statefulSurvey.trail} survey?'),
            ],
          ));

  Future<void> _startSurvey() async {
    Navigator.of(context).pop();
    await _statefulSurvey.start();

    setState(() {
      _statefulSurvey = _statefulSurvey;
    });
  }

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
    if (_statefulSurvey.state == SurveyState.unstarted) {
      return PageScaffold(
        title: '${_statefulSurvey.trail} Survey',
        fabLabel: const Row(
          children: [
            Text('Start Survey'),
            Icon(Icons.start),
          ],
        ),
        onFabPress: _onStartSurveyTap,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Hit the button below to start the survey'),
              Padding(
                padding: EdgeInsets.only(top: 24),
                child: Icon(
                  Icons.arrow_downward,
                  size: 40,
                ),
              )
            ],
          ),
        ),
      );
    } else {
      return PageScaffold(
        title:
            '${_statefulSurvey.trail} Survey, ${DateFormats.ddmmyyyy(_statefulSurvey.startAt!)}',
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
        ),
      );
    }
  }
}
