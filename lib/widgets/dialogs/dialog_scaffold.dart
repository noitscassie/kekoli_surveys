import 'package:flutter/material.dart';

class DialogScaffold extends StatelessWidget {
  final String title;
  final String content;
  final Widget primaryCta;

  const DialogScaffold({
    super.key,
    required this.title,
    required this.content,
    required this.primaryCta,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(content),
            ),
          ]),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Back',
            )),
        primaryCta,
      ],
    );
  }
}
