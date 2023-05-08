import 'package:flutter/material.dart';

class SelectableListItem extends StatelessWidget {
  final String text;
  final Function(String value) onSelect;
  final IconData icon;
  final EdgeInsetsGeometry? padding;

  const SelectableListItem(
      {super.key,
      required this.text,
      required this.onSelect,
      this.icon = Icons.arrow_forward_outlined,
      this.padding});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onSelect(text),
      child: ListTile(
        contentPadding: padding,
        title: Text(text),
        trailing: Icon(icon),
      ),
    );
  }
}
