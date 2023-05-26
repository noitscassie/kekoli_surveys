import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/pages/bird_trails/bird_trails_page.dart';
import 'package:kekoldi_surveys/pages/select_export_data/biodiversity_data_export_page.dart';
import 'package:kekoldi_surveys/pages/survey_format/survey_format_page.dart';
import 'package:kekoldi_surveys/pages/trails/biodiversity_trails_page.dart';
import 'package:kekoldi_surveys/widgets/page_scaffold.dart';
import 'package:kekoldi_surveys/widgets/selectable_list_item.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  void _navigateToDataExportFormat(BuildContext context) =>
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => const BiodiversityDataExportPage(),
        ),
      );

  void _navigateToSurveyFormat(BuildContext context) =>
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => const SurveyFormatPage(),
        ),
      );

  void _navigateToBiodiversityTrails(BuildContext context) =>
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => const BiodiversityTrailsPage(),
        ),
      );

  void _navigateToBirdTrails(BuildContext context) =>
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => const BirdTrailsPage(),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: 'Settings',
      child: ListView(
        children: [
          SelectableListItem(
              text: 'Biodiversity Trails',
              onSelect: (String _) => _navigateToBiodiversityTrails(context)),
          SelectableListItem(
              text: 'Biodiversity Data Export Format',
              onSelect: (String _) => _navigateToDataExportFormat(context)),
          SelectableListItem(
              text: 'Biodiversity Survey Format',
              onSelect: (String _) => _navigateToSurveyFormat(context)),
          SelectableListItem(
              text: 'Bird Trails',
              onSelect: (String _) => _navigateToBirdTrails(context)),
        ],
      ),
    );
  }
}
