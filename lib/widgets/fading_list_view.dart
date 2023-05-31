import 'package:flutter/material.dart';

class FadingListView extends StatelessWidget {
  final ScrollController? scrollController;
  final List<Widget> children;
  final bool top;
  final bool bottom;

  const FadingListView({
    super.key,
    this.scrollController,
    required this.children,
    this.top = true,
    this.bottom = true,
  });

  MainAxisAlignment get _mainAxisAlignment => top && bottom
      ? MainAxisAlignment.spaceBetween
      : top
          ? MainAxisAlignment.start
          : MainAxisAlignment.end;

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
          mainAxisAlignment: _mainAxisAlignment,
          children: [
            if (top)
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Theme.of(context).colorScheme.background.withOpacity(0.4),
                      Theme.of(context).colorScheme.background.withOpacity(1),
                    ],
                  ),
                ),
                height: 20,
              ),
            if (bottom)
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
