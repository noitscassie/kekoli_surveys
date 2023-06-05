import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/models/biodiversity_survey.dart';
import 'package:kekoldi_surveys/pages/biodiversity_survey/biodiversity_survey_scaffold.dart';
import 'package:kekoldi_surveys/pages/biodiversity_survey/complete_survey_modal.dart';
import 'package:kekoldi_surveys/pages/choose_species/choose_biodiversity_species_page.dart';
import 'package:kekoldi_surveys/utils/time_utils.dart';

class OngoingBiodiversitySurveyPage extends StatefulWidget {
  final BiodiversitySurvey survey;

  const OngoingBiodiversitySurveyPage({
    super.key,
    required this.survey,
  });

  @override
  State<OngoingBiodiversitySurveyPage> createState() =>
      _OngoingBiodiversitySurveyPageState();
}

class _OngoingBiodiversitySurveyPageState
    extends State<OngoingBiodiversitySurveyPage> {
  late BiodiversitySurvey _statefulSurvey = widget.survey;

  void _navigateToChooseSpeciesPage() => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => ChooseBiodiversitySpeciesPage(
            survey: _statefulSurvey,
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
    return BiodiversitySurveyScaffold(
      survey: _statefulSurvey,
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
    );
  }
}
