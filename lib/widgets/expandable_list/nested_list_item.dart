import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/widgets/expandable_list/expandable_list_item.dart';

class NestedListItem extends StatelessWidget {
  final ExpandableListItemChild childData;

  const NestedListItem({super.key, required this.childData});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: childData.onTap,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Text(
                      childData.title,
                    ),
                  ),
                  if (childData.subtitle != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        childData.subtitle!,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(fontStyle: FontStyle.italic),
                      ),
                    ),
                ],
              ),
            ),
            if (childData.trailing != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: childData.trailing!,
              )
          ]),
    );
  }
}
