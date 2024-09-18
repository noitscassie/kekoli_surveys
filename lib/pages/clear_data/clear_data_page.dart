import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/db/db.dart';
import 'package:kekoldi_surveys/pages/home/home_page.dart';
import 'package:kekoldi_surveys/widgets/page_scaffold.dart';
import 'package:kekoldi_surveys/widgets/text_header.dart';

class ClearDataPage extends StatefulWidget {
  const ClearDataPage({super.key});

  @override
  State<ClearDataPage> createState() => _ClearDataPageState();
}

class _ClearDataPageState extends State<ClearDataPage> {
  static const targetText = 'greenclimbingtoad';
  String text = '';
  final Db _db = Db();

  void _clearData() {
    _db.reset();

    const snackBar = SnackBar(
      duration: Duration(seconds: 2),
      content: Text('Data cleared'),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (BuildContext context) => const HomePage(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold.withScrollableChildren(
      title: 'Clear All Data',
      header: const TextHeader(
          text:
              'Type the phrase \'$targetText\' to confirm that you wish to clear all survey data.\nBefore you do this, you may want to export all this data so you have a copy opf it, which you can do from the \'Export All Data\' option on the Settings page.'),
      fabLabel: const Row(
        children: [
          Text('Clear Data'),
          Icon(Icons.delete),
        ],
      ),
      isFabValid: text == targetText,
      onFabPress: _clearData,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: TextFormField(
              autofocus: true,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                border: const UnderlineInputBorder(),
                labelText: 'Type phrase',
                labelStyle: Theme.of(context).textTheme.bodySmall,
              ),
              onChanged: (String value) {
                setState(() {
                  text = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
