import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/constants/columns.dart';
import 'package:kekoldi_surveys/widgets/page_scaffold.dart';

class SelectExportDataPage extends StatefulWidget {
  const SelectExportDataPage({super.key});

  @override
  State<SelectExportDataPage> createState() => _SelectExportDataPageState();
}

class _SelectExportDataPageState extends State<SelectExportDataPage> {
  final List<String> _items = columns;
  List<String> get dataOptions => [
        '',
        'species',
        // ...widget.survey.sightings.first.data.keys.distinct().toList()
      ];

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color oddItemColor = colorScheme.primary.withOpacity(0.5);
    final Color evenItemColor = colorScheme.primary.withOpacity(0.1);

    return PageScaffold(
        title: 'Select Data Format',
        child: Center(
          child: ReorderableListView(
            children: <Widget>[
              for (int index = 0; index < _items.length; index += 1)
                ListTile(
                  key: Key('data_export_format_tile_${_items[index]}'),
                  tileColor: index.isOdd ? oddItemColor : evenItemColor,
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(_items[index]),
                      ),
                      DropdownButtonFormField<String>(
                        padding: const EdgeInsets.only(bottom: 8),
                        value: '',
                        items: dataOptions.map((String dataOption) {
                          // final
                          return DropdownMenuItem<String>(
                              value: dataOption,
                              child: Text(dataOption.isEmpty
                                  ? '(Leave blank)'
                                  : dataOption));
                        }).toList(),
                        onChanged: (value) {},
                      )
                    ],
                  ),
                ),
            ],
            onReorder: (int oldIndex, int newIndex) {
              setState(() {
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                final item = _items.removeAt(oldIndex);
                _items.insert(newIndex, item);
              });
            },
          ),
        ));
  }
}
