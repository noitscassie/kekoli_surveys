import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/models/survey.dart';
import 'package:kekoldi_surveys/pages/add_survey_page.dart';
import 'package:kekoldi_surveys/pages/surveys_tab.dart';
import 'package:kekoldi_surveys/pages/trails_tab.dart';

class HomePage extends StatefulWidget {
  final Function(Survey survey) onCreateSurvey;

  const HomePage({super.key, required this.onCreateSurvey});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int navigationBarIndex = 0;

  late List<Widget> tabs = [
    SurveysTab(onCreateSurvey: widget.onCreateSurvey),
    const TrailsTab(),
  ];

  late List<Widget> floatingActionButtons = [
    FloatingActionButton.extended(
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => const AddSurveyPage()));
      },
      label: Row(
        children: const [Text('Create New Survey'), Icon(Icons.add)],
      ),
    ),
    FloatingActionButton.extended(
      onPressed: () {},
      label: Row(
        children: const [Text('Add New Trail'), Icon(Icons.add)],
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('Surveys'),
      ),
      body: tabs[navigationBarIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationBarIndex,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.pending_actions), label: 'Surveys'),
          BottomNavigationBarItem(
              icon: Icon(Icons.pending_actions), label: 'Trails')
        ],
        onTap: (int newIndex) => setState(() => navigationBarIndex = newIndex),
      ),
      floatingActionButton: floatingActionButtons[navigationBarIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
