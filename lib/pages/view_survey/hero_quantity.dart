import 'package:flutter/material.dart';

class HeroQuantity extends StatelessWidget {
  final String quantity;

  const HeroQuantity({super.key, required this.quantity});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        radius: 25,
        child: Text(
          quantity,
          style: Theme.of(context).textTheme.headlineSmall,
        ));
  }
}
