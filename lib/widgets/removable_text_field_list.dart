import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';

class RemovableTextFieldList extends StatelessWidget {
  final List<String?> items;
  final String optionLabel;
  final String newItemText;
  final VoidCallback onAddItem;
  final Function(int index, String text) onUpdateItem;
  final Function(int index) onRemoveItem;
  final EdgeInsetsGeometry? inputPadding;

  const RemovableTextFieldList({
    super.key,
    required this.items,
    required this.optionLabel,
    required this.newItemText,
    required this.onAddItem,
    required this.onUpdateItem,
    required this.onRemoveItem,
    this.inputPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...List.from(
            items.mapIndexed((index, participant) => participant == null
                ? const SizedBox.shrink()
                : Padding(
                    key: Key(index.toString()),
                    padding: EdgeInsets.only(top: index == 0 ? 0 : 16),
                    child: TextFormField(
                      initialValue: participant,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                          labelText: optionLabel,
                          contentPadding: inputPadding,
                          suffixIcon: items.whereNotNull().length > 1
                              ? IconButton(
                                  icon: const Icon(Icons.cancel),
                                  onPressed: () => onRemoveItem(index),
                                )
                              : null),
                      onChanged: (String value) => onUpdateItem(index, value),
                    ),
                  ))),
        if (items.isEmpty || items.whereNotNull().last.isNotEmpty)
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: GestureDetector(
                  onTap: onAddItem,
                  child: Row(
                    children: [const Icon(Icons.add), Text(newItemText)],
                  )))
      ],
    );
  }
}
