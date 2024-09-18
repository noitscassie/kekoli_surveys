import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/models/bird_survey_trail.dart';
import 'package:kekoldi_surveys/models/input_field_config.dart';
import 'package:kekoldi_surveys/widgets/dialogs/danger_cta.dart';
import 'package:kekoldi_surveys/widgets/dialogs/dialog_scaffold.dart';
import 'package:kekoldi_surveys/widgets/fading_list_view.dart';
import 'package:kekoldi_surveys/widgets/page_scaffold.dart';

class BirdTrailPage extends StatefulWidget {
  final BirdSurveyTrail trail;
  final Function(BirdSurveyTrail trail) onSave;
  final VoidCallback onDelete;

  const BirdTrailPage({
    super.key,
    required this.trail,
    required this.onSave,
    required this.onDelete,
  });

  @override
  State<BirdTrailPage> createState() => _BirdTrailPageState();
}

class _BirdTrailPageState extends State<BirdTrailPage> {
  late String _name = widget.trail.name;
  late List<String?> _segments = widget.trail.segments;

  void _updateName(String name) => setState(() {
        _name = name;
      });

  void _updateSegments(List<String?> segments) => setState(() {
        _segments = segments;
      });

  void _onFabPress() {
    widget.trail.name = _name;
    widget.trail.segments = _segments.whereNotNull().toList();

    widget.onSave(widget.trail);
  }

  void _onDeletePress() => showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => DialogScaffold(
          title: 'Delete $_name?',
          primaryCta: DangerCta(
            text: 'Delete',
            onTap: () {
              widget.onDelete();
              Navigator.of(context).pop();
            },
          ),
          children: [
            Text(
              'Are you sure you want to delete Bird Trail $_name? You cannot undo this.',
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: 'Bird Trail ${widget.trail.name}',
      fabLabel: const Row(
        children: [
          Text('Save Trail'),
          Icon(Icons.save_alt),
        ],
      ),
      onFabPress: _onFabPress,
      child: Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 100),
        child: FadingListView(
          children: [
            InputFieldConfig.text(
              label: 'Trail Name',
              defaultValue: _name,
            ).inputField(
              onChange: (dynamic name) => _updateName(name),
            ),
            InputFieldConfig.multifieldText(
              label: 'Sections',
              defaultValue: _segments,
              newItemText: 'Section',
            ).inputField(
              onChange: (dynamic segments) => _updateSegments(segments),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                            Theme.of(context).colorScheme.error)),
                    onPressed: _onDeletePress,
                    child: Text(
                      'Delete Trail',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.surface),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
