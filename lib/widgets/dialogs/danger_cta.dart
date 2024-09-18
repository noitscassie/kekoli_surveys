import 'package:flutter/material.dart';

class DangerCta extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const DangerCta({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
          backgroundColor:
              WidgetStateProperty.all(Theme.of(context).colorScheme.error)),
      onPressed: onTap,
      child: Text(
        text,
        style: TextStyle(color: Theme.of(context).colorScheme.surface),
      ),
    );
  }
}
