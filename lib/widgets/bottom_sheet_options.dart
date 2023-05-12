import 'package:flutter/material.dart';

class BottomSheetOption {
  final String text;
  final VoidCallback onPress;
  final IconData? leadingIcon;
  final IconData? trailingIcon;

  BottomSheetOption(
      {required this.text,
      required this.onPress,
      this.leadingIcon,
      this.trailingIcon});
}

class BottomSheetOptions extends StatelessWidget {
  final List<BottomSheetOption> options;

  const BottomSheetOptions({super.key, required this.options});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.from(options.map((BottomSheetOption option) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text(option.text),
                onTap: option.onPress,
                leading: option.leadingIcon == null
                    ? null
                    : Icon(
                        option.leadingIcon,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                trailing: option.trailingIcon == null
                    ? null
                    : Icon(
                        option.trailingIcon,
                        color: Theme.of(context).colorScheme.primary,
                      ),
              ),
            ))),
      ),
    );
  }
}
