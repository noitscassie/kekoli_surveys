import 'package:flutter/material.dart';

class RadioButtonOption<T> {
  final String label;
  final String? subtitle;
  final T value;

  RadioButtonOption({required this.value, required this.label, this.subtitle});
}

class RadioButtons<T> extends StatelessWidget {
  final T? selectedOption;
  final List<RadioButtonOption<T>> options;
  final Function(T value) onChange;

  const RadioButtons(
      {super.key,
      required this.options,
      required this.onChange,
      required this.selectedOption});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.from(options.map((option) => ListTile(
            onTap: () => onChange(option.value),
            title: Text(option.label),
            subtitle: option.subtitle == null
                ? null
                : Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      option.subtitle!,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(fontStyle: FontStyle.italic),
                    ),
                  ),
            contentPadding: EdgeInsets.zero,
            leading: Radio<T?>(
              value: option.value,
              groupValue: selectedOption,
              onChanged: (T? value) {
                if (value == null) return;

                onChange(value);
              },
              activeColor: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ))),
    );
  }
}
