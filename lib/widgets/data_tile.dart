import 'package:flutter/material.dart';

class DataTile extends StatelessWidget {
  final String data;
  final String label;

  const DataTile({super.key, required this.data, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          data,
          style: Theme.of(context)
              .textTheme
              .headlineMedium
              ?.copyWith(color: Colors.black),
        ),
        Text(label, style: Theme.of(context).textTheme.bodySmall)
      ],
    );
  }
}
