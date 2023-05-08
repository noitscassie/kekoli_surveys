import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/pages/home/home_page.dart';

void main() {
  runApp(const KekoldiSurveys());
}

class KekoldiSurveys extends StatelessWidget {
  const KekoldiSurveys({super.key});

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
        ),
      ).copyWith(
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.lightGreen)
              .copyWith(
                  surface: Colors.lightGreen[100],
                  onSurface: Colors.black,
                  onSurfaceVariant: Colors.lightGreen.shade800,
                  onError: Colors.grey.shade500)),
      home: const HomePage(),
    );
  }
}
