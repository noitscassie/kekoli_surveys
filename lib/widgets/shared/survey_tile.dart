import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/widgets/partly_bolded_text.dart';

class SurveyTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<String> leaders;
  final String scribe;
  final List<String> participants;
  final VoidCallback onTap;

  const SurveyTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.leaders,
    required this.scribe,
    required this.participants,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: InkWell(
        onTap: onTap,
        child: Material(
          elevation: 8,
          color: Colors.transparent,
          child: Card(
            color: Theme.of(context).colorScheme.surface,
            shape: const RoundedRectangleBorder(
              side: BorderSide(
                style: BorderStyle.none,
              ),
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.headlineSmall,
                          softWrap: true,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                subtitle,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              Text('Tap for options',
                                  style: Theme.of(context).textTheme.bodySmall),
                            ],
                          ),
                        ),
                        PartlyBoldedText(
                            style: Theme.of(context).textTheme.bodySmall,
                            textParts: [
                              RawText('Led by '),
                              RawText(leaders.join(' and '), bold: true)
                            ]),
                        PartlyBoldedText(
                          style: Theme.of(context).textTheme.bodySmall,
                          textParts: [
                            RawText('Scribed by '),
                            RawText(scribe, bold: true)
                          ],
                        ),
                        PartlyBoldedText(
                            style: Theme.of(context).textTheme.bodySmall,
                            textParts: [
                              RawText('Participated in by '),
                              RawText(participants.join(', '), bold: true),
                            ]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
