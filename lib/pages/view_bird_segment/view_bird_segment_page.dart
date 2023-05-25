import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/models/bird_survey.dart';
import 'package:kekoldi_surveys/models/bird_survey_segment.dart';
import 'package:kekoldi_surveys/pages/view_survey/hero_quantity.dart';
import 'package:kekoldi_surveys/widgets/expandable_list/expandable_list_item.dart';
import 'package:kekoldi_surveys/widgets/page_scaffold.dart';

class ViewBirdSegmentPage extends StatelessWidget {
  final BirdSurvey survey;
  final BirdSurveySegment segment;

  const ViewBirdSegmentPage({
    super.key,
    required this.survey,
    required this.segment,
  });

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: '${survey.type.segmentName} ${segment.name} Observations',
      child: Padding(
        padding: const EdgeInsets.only(bottom: 100),
        child: ListView(
          children: [
            ...segment.sightings
                .groupBy((sighting) => sighting.species)
                .entries
                .sortedBy((entry) => entry.key)
                .mapIndexed(
                  (index, entry) => ExpandableListItem(
                    title: entry.key,
                    children: List.from(
                      entry.value
                          .groupBy((sighting) => sighting.attributesString)
                          .entries
                          .sortedBy((entry) => entry.key)
                          .map(
                            (entry) => ExpandableListItemChild(
                              title: entry.key,
                              trailing: HeroQuantity(
                                quantity: entry.value.length.toString(),
                              ),
                            ),
                          ),
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
