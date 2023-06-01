import 'package:flutter/material.dart';

class FadingWidget extends StatelessWidget {
  final Widget child;
  final bool top;
  final bool bottom;
  final bool padTop;

  const FadingWidget({
    super.key,
    required this.child,
    required this.top,
    required this.bottom,
    required this.padTop,
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
        child,
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
                      Theme.of(context).colorScheme.background.withOpacity(0.2),
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
                      Theme.of(context).colorScheme.background.withOpacity(0.2),
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
