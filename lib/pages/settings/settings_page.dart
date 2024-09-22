import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/pages/app_details/app_details_page.dart';
import 'package:kekoldi_surveys/pages/bird_trails/bird_trails_page.dart';
import 'package:kekoldi_surveys/pages/clear_data/clear_data_page.dart';
import 'package:kekoldi_surveys/pages/export_all/export_all_page.dart';
import 'package:kekoldi_surveys/pages/select_export_data/biodiversity_select_data_export_format_page.dart';
import 'package:kekoldi_surveys/pages/survey_format/survey_format_page.dart';
import 'package:kekoldi_surveys/pages/trails/biodiversity_trails_page.dart';
import 'package:kekoldi_surveys/widgets/page_scaffold.dart';
import 'package:kekoldi_surveys/widgets/selectable_list_item.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  void _navigateToDataExportFormat(BuildContext context) =>
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) =>
              const BiodiversitySelectDataExportFormatPage(),
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

  void _navigateToExportAllData(BuildContext context) =>
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => const ExportAllPage(),
        ),
      );

  void _navigateToClearAllData(BuildContext context) =>
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => const ClearDataPage(),
        ),
      );

  void _navigateToAppDetails(BuildContext context) =>
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => const AppDetailsPage(),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return PageScaffold.withScrollableChildren(
      title: 'Settings',
      children: [
        SelectableListItem(
            title: 'Biodiversity Trails',
            onSelect: (String _) => _navigateToBiodiversityTrails(context)),
        SelectableListItem(
            title: 'Bird Trails',
            onSelect: (String _) => _navigateToBirdTrails(context)),
        SelectableListItem(
            title: 'Biodiversity Data Export Format',
            onSelect: (String _) => _navigateToDataExportFormat(context)),
        SelectableListItem(
            title: 'Biodiversity Survey Format',
            onSelect: (String _) => _navigateToSurveyFormat(context)),
        SelectableListItem(
            title: 'Export All Data',
            onSelect: (String _) => _navigateToExportAllData(context)),
        SelectableListItem(
            title: 'Clear All Data',
            onSelect: (String _) => _navigateToClearAllData(context)),
        SelectableListItem(
            title: 'App Details',
            onSelect: (String _) => _navigateToAppDetails(context)),
      ],
    );
  }
}
