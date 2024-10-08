import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/pages/home/home_page.dart';
import 'package:localstorage/localstorage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initLocalStorage();

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
      debugShowCheckedModeBanner: false,
      title: 'Kèköldi Surveys',
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
                onError: Colors.grey.shade500),
        textTheme: Theme.of(context).textTheme.copyWith(
            bodyLarge: TextStyle(
                color: Colors.black.withOpacity(0.87),
                fontWeight: FontWeight.normal,
                fontSize: 18),
            labelSmall: TextStyle(
                color: Colors.black.withOpacity(0.95),
                fontWeight: FontWeight.normal,
                fontStyle: FontStyle.italic,
                fontSize: 10)),
      ),
      home: const HomePage(),
    );
  }
}
