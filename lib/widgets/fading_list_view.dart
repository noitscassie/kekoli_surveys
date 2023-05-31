import 'package:flutter/material.dart';

class FadingListView extends StatelessWidget {
  final ScrollController? scrollController;
  final List<Widget> children;

  const FadingListView({
    super.key,
    this.scrollController,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.only(bottom: 100),
          controller: scrollController,
          children: [
            ...children,
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Theme.of(context).colorScheme.background.withOpacity(1),
                    Theme.of(context).colorScheme.background.withOpacity(0.4),
                  ],
                ),
              ),
              height: 50,
            ),
          ],
        )
      ],
    );
  }
}
