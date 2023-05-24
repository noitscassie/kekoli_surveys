import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/models/bird_survey.dart';
import 'package:kekoldi_surveys/models/bird_survey_segment.dart';
import 'package:kekoldi_surveys/pages/choose_species/choose_bird_species_page.dart';
import 'package:kekoldi_surveys/widgets/expandable_list/expandable_list_item.dart';
import 'package:kekoldi_surveys/widgets/page_scaffold.dart';

class OngoingBirdSegmentPage extends StatelessWidget {
  final BirdSurvey survey;
  final BirdSurveySegment segment;

  const OngoingBirdSegmentPage({
    super.key,
    required this.survey,
    required this.segment,
  });

  void _navigateToChooseSpeciesPage(BuildContext context) =>
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) =>
              ChooseBirdSpeciesPage(survey: survey, segment: segment)));

  @override
  Widget build(BuildContext context) {
    print(segment);
    return PageScaffold(
      title: '${survey.type.prettyName} ${segment.name}',
      fabLabel: const Row(
        children: [
          Text('Add New Bird'),
          Icon(Icons.add),
        ],
      ),
      onFabPress: () => _navigateToChooseSpeciesPage(context),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 100),
        child: ListView(
          children: [
            ...segment.sightings.mapIndexed((index, sighting) =>
                ExpandableListItem(title: sighting.species))
          ],
        ),
      ),
    );
  }
}
