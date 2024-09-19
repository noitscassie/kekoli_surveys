import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/models/input_field_config.dart';
import 'package:kekoldi_surveys/widgets/page_scaffold.dart';

class BirdSurveyForm extends StatelessWidget {
  final String title;
  final List<InputFieldConfig> fields;
  final bool isFabValid;
  final Widget fabLabel;
  final VoidCallback onFabPress;
  final Map<String, dynamic> attributes;
  final Function(String key, dynamic value) onAttributeChange;

  BirdSurveyForm({
    super.key,
    required this.title,
    required this.fields,
    required this.fabLabel,
    required this.isFabValid,
    required this.onFabPress,
    required this.attributes,
    required this.onAttributeChange,
  });

  final ScrollController _controller = ScrollController();

  void _scrollToBottom() => _controller.animateTo(
        _controller.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.fastOutSlowIn,
      );

  void _onFieldChange(int index, String key, dynamic value) {
    onAttributeChange(key, value);

    if (index + 1 == fields.length) {
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold.withScrollableChildren(
      title: title,
      fabLabel: fabLabel,
      isFabValid: isFabValid,
      onFabPress: onFabPress,
      scrollController: _controller,
      children: [
        ...fields.mapIndexed(
          (int index, InputFieldConfig field) => field.inputField(
            value: attributes[field.label],
            onChange: (dynamic value) =>
                _onFieldChange(index, field.label, value),
          ),
        ),
      ],
    );
  }
}
