import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/pages/home/home_page.dart';
import 'package:kekoldi_surveys/widgets/fading_list_view.dart';

class PageScaffold extends StatelessWidget {
  final String title;
  final Widget? child;
  final List<Widget> children;
  final Widget? header;
  final ScrollController? scrollController;
  final Widget? fabLabel;
  final VoidCallback? onFabPress;
  final bool isFabValid;
  final List<Widget> actions;
  final Widget? bottomNavigationBar;
  final bool topFade;
  final bool bottomFade;
  final bool? padTop;
  final int? backButtonToHomeTab;

  const PageScaffold({
    super.key,
    required this.title,
    this.fabLabel,
    this.onFabPress,
    this.isFabValid = true,
    this.actions = const [],
    required this.child,
    this.bottomNavigationBar,
    this.backButtonToHomeTab,
  })  : children = const [],
        scrollController = null,
        header = null;

  const PageScaffold.withScrollableChildren({
    super.key,
    required this.title,
    this.fabLabel,
    this.onFabPress,
    this.isFabValid = true,
    this.actions = const [],
    this.bottomNavigationBar,
    required this.children,
    this.scrollController,
    this.header,
  }) : child = null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: actions,
        leading: backButtonToHomeTab == null
            ? null
            : IconButton(
                icon: Icon(Platform.isAndroid
                    ? Icons.arrow_back
                    : Icons.arrow_back_ios),
                onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (BuildContext context) => HomePage(
                        initialTabIndex: backButtonToHomeTab!,
                      ),
                    ),
                    (route) => false),
              ),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
        ),
        child: child ??
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                if (header != null) header!,
                Expanded(
                  child: FadingListView(
                    scrollController: scrollController,
                    children: children,
                  ),
                ),
              ],
            ),
      ),
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: fabLabel == null
          ? null
          : FloatingActionButton.extended(
              onPressed: isFabValid ? onFabPress : null,
              label: fabLabel!,
              backgroundColor: isFabValid
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onError,
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
