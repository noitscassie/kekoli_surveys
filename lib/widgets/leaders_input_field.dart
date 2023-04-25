import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class LeadersInputField extends StatelessWidget {
  final List<String> value;
  final Function(List<String> value) onChange;

  const LeadersInputField(
      {super.key, required this.onChange, required this.value});

  void addLeader() => onChange(List.from([...value, '']));

  void updateLeader(int index, String updatedLeader) => onChange(List.from(value
      .mapIndexed((mapIndex, originalLeader) =>
          mapIndex == index ? updatedLeader : originalLeader)
      .whereNotNull()));

  void removeLeader(int indexToRemove) => onChange(List.from(value
      .mapIndexed(
          (index, participant) => index == indexToRemove ? null : participant)
      .whereNotNull()));

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
              border: const UnderlineInputBorder(),
              labelText: 'First leader',
              labelStyle: Theme.of(context).textTheme.bodySmall),
          onChanged: (String newValue) => updateLeader(0, newValue),
        ),
        value.length < 2
            ? Padding(
                padding: const EdgeInsets.only(top: 16),
                child: GestureDetector(
                    onTap: addLeader,
                    child: Row(
                      children: const [
                        Icon(Icons.add),
                        Text('Add a second leader')
                      ],
                    )))
            : Padding(
                padding: const EdgeInsets.only(top: 16),
                child: TextFormField(
                  autofocus: true,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                      border: const UnderlineInputBorder(),
                      labelText: 'Second leader',
                      labelStyle: Theme.of(context).textTheme.bodySmall,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.cancel),
                        onPressed: () => removeLeader(1),
                      )),
                  onChanged: (String newValue) => updateLeader(1, newValue),
                ),
              ),
      ],
    );
  }
}
