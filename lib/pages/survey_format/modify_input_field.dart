import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/models/input_field_config.dart';
import 'package:kekoldi_surveys/widgets/removable_text_field_list.dart';

class ModifyInputField extends StatelessWidget {
  final int index;
  final InputFieldConfig field;
  final Function(InputFieldConfig field) onChange;
  final Function(InputFieldConfig field) onDelete;

  const ModifyInputField(
      {super.key,
      required this.field,
      required this.onChange,
      required this.onDelete,
      required this.index});

  static const Map<FieldType, String> fieldNames = {
    FieldType.text: 'Text',
    FieldType.multilineText: 'Multiline Text',
    FieldType.number: 'Number',
    FieldType.radioButtons: 'Radio Buttons',
    FieldType.select: 'Dropdown Options',
  };

  final inputPadding = const EdgeInsets.symmetric(vertical: 16, horizontal: 12);

  String getFieldName(FieldType type) => fieldNames[type] ?? '';

  void onLabelChange(String label) {
    field.label = label;
    onChange(field);
  }

  void onTypeChange(FieldType? type) {
    if (type == null) return;

    field.type = type;
    onChange(field);
  }

  void onDefaultValueChange(String defaultValue) {
    field.defaultValue = defaultValue;
    onChange(field);
  }

  void onAddOption() {
    field.options = [...field.options, ''];
    onChange(field);
  }

  void onUpdateOption(int index, String updatedValue) {
    field.options = List<String?>.from(field.options.mapIndexed(
        (mapIndex, originalValue) =>
            mapIndex == index ? updatedValue : originalValue));
    onChange(field);
  }

  void onRemoveOption(int index) {
    field.options = List<String?>.from(field.options.mapIndexed(
        (mapIndex, originalValue) => mapIndex == index ? null : originalValue));
    onChange(field);
  }

  void onSortOptionsChange(bool? sortOptions) {
    if (sortOptions == null) return;

    field.sortOptions = sortOptions;
    onChange(field);
  }

  void onDeleteFieldPress(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
          content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Delete ${field.label} field?',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                      'Are you sure you want to remove the ${field.label} field from the survey data?'),
                ),
              ]),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'Back',
                )),
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).colorScheme.error)),
                onPressed: () => onDelete(field),
                child: Text(
                  'Delete Field',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.surface),
                )),
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
        title: Text(
          'Field ${index + 1} - ${field.label}',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              decoration: InputDecoration(
                  labelText: 'Name', contentPadding: inputPadding),
              initialValue: field.label,
              onChanged: onLabelChange,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: DropdownButtonFormField<FieldType>(
                decoration: InputDecoration(
                    labelText: 'Field Type', contentPadding: inputPadding),
                value: field.type,
                items: List.from(FieldType.values.map((FieldType type) =>
                    DropdownMenuItem(
                        key: Key(field.type.name),
                        value: type,
                        child: Text(getFieldName(type))))),
                onChanged: onTypeChange),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              decoration: InputDecoration(
                  labelText: 'Default Value', contentPadding: inputPadding),
              initialValue: field.defaultValue,
              onChanged: onDefaultValueChange,
            ),
          ),
          if (field.requiresOptions)
            ExpansionTile(
              title: Text(
                'View options',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RemovableTextFieldList(
                    items: field.options,
                    optionLabel: 'Option',
                    newItemText: 'Add new option',
                    onAddItem: onAddOption,
                    onUpdateItem: onUpdateOption,
                    onRemoveItem: onRemoveOption,
                    inputPadding: inputPadding,
                  ),
                ),
                CheckboxListTile(
                    title: const Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text('Sort options alphabetically?'),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                          'When selected, all options will be sorted alphabetically when inputting data',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(fontStyle: FontStyle.italic)),
                    ),
                    value: field.sortOptions,
                    onChanged: onSortOptionsChange)
              ],
            ),
          ExpansionTile(
            title: Text(
              'View preview',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: field.inputField(onChange: (_) {}),
              ),
            ],
          ),
          if (field.label != 'Quantity')
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Theme.of(context).colorScheme.error)),
                    onPressed: () => onDeleteFieldPress(context),
                    child: Text(
                      'Remove Field',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.surface),
                    ),
                  ),
                ],
              ),
            )
        ]);
  }
}
