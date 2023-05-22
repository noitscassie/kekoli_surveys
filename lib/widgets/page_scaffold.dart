import 'package:flutter/material.dart';

class PageScaffold extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? fabLabel;
  final VoidCallback? onFabPress;
  final bool isFabValid;
  final List<Widget> actions;
  final Widget? bottomNavigationBar;

  const PageScaffold(
      {super.key,
      required this.title,
      this.fabLabel,
      this.onFabPress,
      this.isFabValid = true,
      this.actions = const [],
      required this.child,
      this.bottomNavigationBar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: actions,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: child,
      ),
      bottomNavigationBar: bottomNavigationBar,
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
