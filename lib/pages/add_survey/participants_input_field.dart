import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/widgets/form_item.dart';

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
      child: Padding(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...List.from(
                value.mapIndexed((index, participant) => participant == null
                    ? const SizedBox.shrink()
                    : Padding(
                        key: Key(index.toString()),
                        padding: EdgeInsets.only(top: index == 0 ? 0 : 16),
                        child: TextFormField(
                          initialValue: participant,
                          textCapitalization: TextCapitalization.words,
                          decoration: InputDecoration(
                              labelText: 'Participant',
                              suffixIcon: value.whereNotNull().length > 1
                                  ? IconButton(
                                      icon: const Icon(Icons.cancel),
                                      onPressed: () => removeParticipant(index),
                                    )
                                  : null),
                          onChanged: (String value) =>
                              updateParticipant(index, value),
                        ),
                      ))),
            if (value.last == null || value.last!.isNotEmpty)
              Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: GestureDetector(
                      child: const Row(
                        children: [
                          Icon(Icons.add),
                          Text('Add new participant')
                        ],
                      ),
                      onTap: () {
                        onChange([...value, '']);
                        onAddNewParticipant();
                      }))
          ],
        ),
      ),
    );
  }
}
