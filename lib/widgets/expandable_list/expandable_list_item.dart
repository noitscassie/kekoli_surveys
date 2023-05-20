import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/widgets/expandable_list/nested_list_item.dart';

class ExpandableListItemChild {
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  ExpandableListItemChild(
      {required this.title, this.subtitle, this.trailing, this.onTap});
}

class ExpandableListItem extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<ExpandableListItemChild> children;
  final Widget? trailing;

  const ExpandableListItem(
      {super.key,
      required this.title,
      this.subtitle,
      this.children = const [],
      this.trailing});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 18),
        ),
      ),
      subtitle: subtitle == null
          ? null
          : Text(
              subtitle!,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(fontStyle: FontStyle.italic),
            ),
      childrenPadding: const EdgeInsets.symmetric(horizontal: 20),
      trailing: children.isEmpty ? const SizedBox.shrink() : trailing,
      expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ...children.map(
            (ExpandableListItemChild child) => NestedListItem(childData: child))
      ],
    );
  }
}
