import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/widgets/form_item.dart';
import 'package:kekoldi_surveys/widgets/removable_text_field_list.dart';

class MultifieldTextInputField extends StatelessWidget {
  final String label;
  final List<String?> value;
  final Function(List<String?> value) onChange;
  final String newItemText;
  final int? maxItems;

  const MultifieldTextInputField({
    super.key,
    required this.label,
    required this.value,
    required this.onChange,
    required this.newItemText,
    this.maxItems,
  });

  void _addItem() => onChange([...value, '']);

  void _updateItem(int indexToUpdate, String newValue) => onChange(value
      .mapIndexed((index, trail) => index == indexToUpdate ? newValue : trail)
      .toList());

  void _removeItem(int indexToRemove) => onChange(value
      .mapIndexed((index, trail) => index == indexToRemove ? null : trail)
      .toList());

  @override
  Widget build(BuildContext context) {
    return FormItem(
      label: label,
      child: RemovableTextFieldList(
        items: value,
        optionLabel: '', // TODO: pass in a builder function for this
        newItemText: newItemText,
        onAddItem: _addItem,
        onUpdateItem: _updateItem,
        onRemoveItem: _removeItem,
        maxItems: maxItems,
      ),
    );
  }
}
