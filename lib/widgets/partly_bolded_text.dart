import 'package:flutter/material.dart';

class RawText {
  final String text;
  final bool bold;

  RawText(this.text, {this.bold = false});
}

class PartlyBoldedText extends StatelessWidget {
  final TextStyle? style;
  final List<RawText> textParts;

  const PartlyBoldedText({super.key, this.style, required this.textParts});

  @override
  Widget build(BuildContext context) {
    return RichText(
        text: TextSpan(
            children: List.from(textParts.map((textPart) => TextSpan(
                text: textPart.text,
                style: textPart.bold
                    ? style?.copyWith(fontWeight: FontWeight.bold)
                    : style)))));
  }
}
