import 'package:flutter/material.dart';

class SelectableListItem extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Function(String value) onSelect;
  final IconData icon;
  final EdgeInsetsGeometry? padding;

  const SelectableListItem({
    super.key,
    required this.title,
    required this.onSelect,
    this.icon = Icons.arrow_forward_outlined,
    this.padding,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onSelect(title),
      child: ListTile(
        contentPadding: padding,
        title: Text(title),
        subtitle: subtitle != null
            ? Text(
                subtitle!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: Theme.of(context).hintColor),
              )
            : null,
        trailing: Icon(icon),
      ),
    );
  }
}
