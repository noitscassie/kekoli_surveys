import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/widgets/form_item.dart';
import 'package:kekoldi_surveys/widgets/removable_text_field_list.dart';

class ParticipantsInputField extends StatelessWidget {
  final List<String?> value;
  final Function(List<String?> value) onChange;
  final VoidCallback onAddNewParticipant;

  const ParticipantsInputField(
      {super.key,
      required this.onChange,
      required this.value,
      required this.onAddNewParticipant});

  void updateParticipant(int index, String updatedParticipant) => onChange(
      List<String?>.from(value.mapIndexed((mapIndex, originalParticipant) =>
          mapIndex == index ? updatedParticipant : originalParticipant)));

  void removeParticipant(int indexToRemove) =>
      onChange(List<String?>.from(value.mapIndexed((index, participant) =>
          index == indexToRemove ? null : participant)));

  @override
  Widget build(BuildContext context) {
    return FormItem(
      label: 'Add participants',
      child: RemovableTextFieldList(
        items: value,
        optionLabel: 'Participant',
        newItemText: 'Add new participant',
        onAddItem: () {
          onChange([...value, '']);
          onAddNewParticipant();
        },
        onUpdateItem: updateParticipant,
        onRemoveItem: removeParticipant,
      ),
    );
  }
}
