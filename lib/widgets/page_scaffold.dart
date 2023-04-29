import 'package:flutter/material.dart';

class PageScaffold extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? fabLabel;
  final VoidCallback? onFabPress;
  final bool isFabValid;

  const PageScaffold(
      {super.key,
      required this.title,
      this.fabLabel,
      this.onFabPress,
      this.isFabValid = true,
      required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: child,
      ),
      floatingActionButton: fabLabel == null
          ? null
          : FloatingActionButton.extended(
              onPressed: isFabValid ? onFabPress : null,
              label: fabLabel!,
              backgroundColor: isFabValid
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onError),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
