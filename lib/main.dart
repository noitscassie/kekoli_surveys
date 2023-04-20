import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/models/survey.dart';
import 'package:kekoldi_surveys/pages/home_page.dart';
import 'package:kekoldi_surveys/pages/ongoing_survey_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static InputBorder border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: const BorderSide(width: 0, color: Colors.transparent),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kekoldi Surveys',
      theme: ThemeData(
          primarySwatch: Colors.lightGreen,
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.lightGreen[100],
            border: border,
            focusedBorder: border,
            enabledBorder: border,
            errorBorder: border,
            disabledBorder: border,
            labelStyle: Theme.of(context).textTheme.bodySmall,
          )),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Survey? currentSurvey;

  void onCreateSurvey(Survey survey) {
    Navigator.pop(context);
    setState(() {
      currentSurvey = survey;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (currentSurvey != null) {
      return OngoingSurveyPage(survey: currentSurvey!);
    } else {
      return HomePage(onCreateSurvey: onCreateSurvey);
    }
  }
}
