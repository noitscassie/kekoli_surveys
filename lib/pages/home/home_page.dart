import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/pages/add_survey/add_biodiversity_survey_page.dart';
import 'package:kekoldi_surveys/pages/home/biodiversity_surveys_tab.dart';
import 'package:kekoldi_surveys/pages/home/bird_surveys_tab.dart';
import 'package:kekoldi_surveys/pages/settings/settings_page.dart';
import 'package:kekoldi_surveys/widgets/page_scaffold.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _tabIndex = 0;

  late final List<String> _titles = [
    'Biodiversity Surveys',
    'Bird Surveys',
  ];

  late final List<Widget> _children = [
    BiodiversitySurveysTab(),
    const BirdSurveysTab(),
  ];

  final List<Widget> _fabTitles = [
    const Row(
      children: [
        Text('New Biodiversity Survey'),
        Icon(Icons.add),
      ],
    ),
    const Row(
      children: [
        Text('New Bird Survey'),
        Icon(Icons.add),
      ],
    ),
  ];

  late final List<VoidCallback> _fabActions = [
    _navigateToAddBiodiversitySurveyPage,
    _navigateToAddBiodiversitySurveyPage,
  ];

  void onTabTap(int index) => setState(() {
        _tabIndex = index;
      });

  void _navigateToAddBiodiversitySurveyPage() =>
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) =>
              const AddBiodiversitySurveyPage()));

  void _navigateToSettingsPage() =>
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => const SettingsPage()));

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
        title: _titles[_tabIndex],
        actions: [
          IconButton(
              onPressed: _navigateToSettingsPage,
              icon: const Icon(Icons.settings))
        ],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _tabIndex,
          items: const [
            BottomNavigationBarItem(
              label: 'Biodiversity',
              icon: Icon(Icons.nature_sharp),
            ),
            BottomNavigationBarItem(
              label: 'Birds',
              icon: Icon(Icons.music_note),
            ),
          ],
          onTap: onTabTap,
        ),
        fabLabel: _fabTitles[_tabIndex],
        onFabPress: _navigateToAddBiodiversitySurveyPage,
        child: _children[_tabIndex]);
  }
}
