import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/widgets/fading_widget.dart';

class FadingListView extends StatelessWidget {
  final ScrollController? scrollController;
  final List<Widget> children;
  final bool top;
  final bool bottom;
  final bool padTop;

  const FadingListView({
    super.key,
    this.scrollController,
    required this.children,
    this.top = true,
    this.bottom = true,
    this.padTop = true,
  });

  @override
  Widget build(BuildContext context) {
    return FadingWidget(
      top: top,
      bottom: bottom,
      padTop: padTop,
      child: ListView(
        padding: EdgeInsets.only(top: padTop ? 20 : 0, bottom: 100),
        controller: scrollController,
        children: [
          ...children,
        ],
      ),
    );
  }
}
