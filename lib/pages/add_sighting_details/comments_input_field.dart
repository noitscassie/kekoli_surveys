import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/widgets/form_item.dart';

class CommentsInputField extends StatelessWidget {
  final String initialComments;
  final Function(String quantity) onChange;

  const CommentsInputField(
      {super.key, required this.onChange, required this.initialComments});

  @override
  Widget build(BuildContext context) {
    return FormItem(
      label: 'Comments',
      child: TextFormField(
        initialValue: initialComments,
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.sentences,
        minLines: 4,
        maxLines: 10,
        onChanged: (String value) => onChange(value),
      ),
    );
  }
}
