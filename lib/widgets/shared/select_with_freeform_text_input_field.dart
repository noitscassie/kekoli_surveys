import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/widgets/form_item.dart';

class SelectWithFreeformTextInputField extends StatefulWidget {
  static const other = 'Other';

  final String label;
  final String value;
  final List<String> options;
  final Function(String value) onChange;

  const SelectWithFreeformTextInputField({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.onChange,
  });

  @override
  State<SelectWithFreeformTextInputField> createState() =>
      _SelectWithFreeformTextInputFieldState();
}

class _SelectWithFreeformTextInputFieldState
    extends State<SelectWithFreeformTextInputField> {
  late bool _renderTextInputField =
      widget.value == SelectWithFreeformTextInputField.other;

  void _onSelect(String? newValue) {
    if (newValue == null) return;

    if (newValue == SelectWithFreeformTextInputField.other) {
      setState(() {
        _renderTextInputField = true;
      });
      widget.onChange('');
    } else {
      setState(() {
        _renderTextInputField = false;
      });
      widget.onChange(newValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormItem(
      label: widget.label,
      child: Column(
        children: [
          DropdownButtonFormField<String>(
            value: widget.options.contains(widget.value)
                ? widget.value
                : SelectWithFreeformTextInputField.other,
            items: widget.options
                .map(
                  (String option) => DropdownMenuItem(
                    value: option,
                    child: Text(option),
                  ),
                )
                .toList(),
            onChanged: _onSelect,
          ),
          if (_renderTextInputField)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: TextFormField(
                initialValue: '',
                decoration:
                    InputDecoration(label: Text('Custom ${widget.label}')),
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.sentences,
                onChanged: widget.onChange,
              ),
            ),
        ],
      ),
    );
  }
}
