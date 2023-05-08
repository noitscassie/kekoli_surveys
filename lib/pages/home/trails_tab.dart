import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/constants/trails.dart';
import 'package:kekoldi_surveys/pages/add_survey/add_survey_page.dart';
import 'package:kekoldi_surveys/widgets/selectable_list_item.dart';

class TrailsTab extends StatelessWidget {
  const TrailsTab({super.key});

  void onSelectTrail(BuildContext context, String trail) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => AddSurveyPage(initialTrail: trail)));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: List.from(trails.map((String trail) =>
                  SelectableListItem(
                      text: trail,
                      onSelect: (String newTrail) =>
                          onSelectTrail(context, newTrail)))),
            ),
          ),
        ],
      ),
    );
  }
}
