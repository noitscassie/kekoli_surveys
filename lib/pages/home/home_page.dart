import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/models/survey.dart';
import 'package:kekoldi_surveys/pages/add_survey/add_survey_page.dart';
import 'package:kekoldi_surveys/pages/home/surveys_tab.dart';
import 'package:kekoldi_surveys/pages/home/trails_tab.dart';

class HomePage extends StatefulWidget {
  final Function(Survey survey) onCreateSurvey;
  final List<Survey> surveys;

  const HomePage(
      {super.key, required this.onCreateSurvey, required this.surveys});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int navigationBarIndex = 0;

  List<Widget> get tabs => [
        SurveysTab(
          surveys: widget.surveys,
        ),
        const TrailsTab(),
      ];

  List<Widget> get floatingActionButtons => [
        FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) =>
                    AddSurveyPage(onCreateSurvey: widget.onCreateSurvey)));
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
        backgroundColor: Theme.of(context).colorScheme.surface,
        selectedItemColor: Theme.of(context).colorScheme.onSurfaceVariant,
        unselectedItemColor: Theme.of(context).colorScheme.onSurface,
      ),
      floatingActionButton: floatingActionButtons[navigationBarIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
