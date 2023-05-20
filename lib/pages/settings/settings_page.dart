import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/pages/select_export_data/select_export_data_page.dart';
import 'package:kekoldi_surveys/pages/survey_format/survey_format_page.dart';
import 'package:kekoldi_surveys/pages/trails/trails_page.dart';
import 'package:kekoldi_surveys/widgets/page_scaffold.dart';
import 'package:kekoldi_surveys/widgets/selectable_list_item.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  void _navigateToDataExportFormat(BuildContext context) =>
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => const SelectExportDataPage()));

  void _navigateToSurveyFormat(BuildContext context) =>
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => const SurveyFormatPage()));

  void _navigateToTrails(BuildContext context) => Navigator.of(context).push(
      MaterialPageRoute(builder: (BuildContext context) => const TrailsPage()));

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: 'Settings',
      child: ListView(
        children: [
          SelectableListItem(
              text: 'Data Export Format',
              onSelect: (String _) => _navigateToDataExportFormat(context)),
          SelectableListItem(
              text: 'Survey Format',
              onSelect: (String _) => _navigateToSurveyFormat(context)),
          SelectableListItem(
              text: 'Trails',
              onSelect: (String _) => _navigateToTrails(context)),
        ],
      ),
    );
  }
}
