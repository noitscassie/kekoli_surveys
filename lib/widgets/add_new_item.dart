import 'package:flutter/material.dart';

class AddNewItem extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const AddNewItem({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Icon(Icons.add),
            ),
            Text(
              text,
              style: Theme.of(context).textTheme.bodyLarge,
            )
          ],
        ),
      ),
    );
  }
}
