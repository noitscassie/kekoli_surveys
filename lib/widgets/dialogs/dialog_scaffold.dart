import 'package:flutter/material.dart';

class DialogScaffold extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final Widget primaryCta;

  const DialogScaffold({
    super.key,
    required this.title,
    required this.children,
    required this.primaryCta,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            ...children,
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
