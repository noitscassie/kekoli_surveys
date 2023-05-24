import 'package:flutter/material.dart';

class ModifyTallyIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const ModifyTallyIcon({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: CircleAvatar(
          radius: 15,
          child: Icon(
            icon,
            size: 15,
          )),
    );
  }
}
