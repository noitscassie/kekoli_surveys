import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/constants/bird_survey_trails.dart';
import 'package:kekoldi_surveys/db/db.dart';
import 'package:kekoldi_surveys/models/bird_survey_trail.dart';
import 'package:kekoldi_surveys/pages/bird_trails/bird_trail_page.dart';
import 'package:kekoldi_surveys/widgets/add_new_item.dart';
import 'package:kekoldi_surveys/widgets/dialogs/dialog_scaffold.dart';
import 'package:kekoldi_surveys/widgets/dialogs/primary_cta.dart';
import 'package:kekoldi_surveys/widgets/page_scaffold.dart';
import 'package:kekoldi_surveys/widgets/selectable_list_item.dart';
import 'package:kekoldi_surveys/widgets/text_header.dart';

class BirdTrailsPage extends StatefulWidget {
  const BirdTrailsPage({super.key});

  @override
  State<BirdTrailsPage> createState() => _BirdTrailsPageState();
}

class _BirdTrailsPageState extends State<BirdTrailsPage> {
  final Db _db = Db();

  late List<BirdSurveyTrail> _trails = _db.getBirdTrails();

  void _openResetToDefaultsDialog() => showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => DialogScaffold(
          title: 'Reset to defaults?',
          primaryCta: PrimaryCta(text: 'Reset', onTap: _resetTrailsToDefaults),
          children: const [
            Text(
                'Are you sure you want to reset all the current bird trails to their defaults?')
          ],
        ),
      );

  void _resetTrailsToDefaults() {
    _db.updateBirdTrails(defaultBirdSurveyTrails);

    if (context.mounted) {
      const snackBar = SnackBar(
        duration: Duration(seconds: 2),
        content: Text('Successfully reset bird trails'),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      Navigator.of(context).pop();
      Navigator.of(context).pop();
    }
  }

  void _onSaveTrail(BirdSurveyTrail newTrail) {
    final allTrails = [
      ..._trails.map((trail) => trail.id == newTrail.id ? newTrail : trail)
    ];

    setState(() {
      _trails = allTrails;
    });

    _db.updateBirdTrails(allTrails);

    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }

  void _onAddTrail() {
    final trail = BirdSurveyTrail(
      name: 'New Bird Survey Trail',
      segments: [''],
    );

    final allTrails = [..._trails, trail];

    setState(() {
      _trails = allTrails;
    });

    _db.updateBirdTrails(allTrails);

    if (context.mounted) {
      _navigateToTrailPage(trail);
    }
  }

  void _onDeleteTrail(BirdSurveyTrail trailToDelete) {
    final allTrails =
        _trails.whereNot((trail) => trail.id == trailToDelete.id).toList();

    setState(() {
      _trails = allTrails;
    });

    Navigator.of(context).pop();

    _db.updateBirdTrails(allTrails);
  }

  void _navigateToTrailPage(BirdSurveyTrail trail) =>
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => BirdTrailPage(
            trail: trail,
            onSave: _onSaveTrail,
            onDelete: () => _onDeleteTrail(trail),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return PageScaffold.withScrollableChildren(
      title: 'Bird Trails',
      actions: [
        IconButton(
          onPressed: _openResetToDefaultsDialog,
          icon: const Icon(Icons.refresh),
        ),
      ],
      header: const TextHeader(
        text:
            'Use this page to rename, add, or remove trails for bird surveys.\n'
            'Once you\'re done, hit the save button below, and the updated set of trails will be available when setting up a new bird survey or editing an existing one.',
      ),
      children: [
        ..._trails.map(
          (BirdSurveyTrail trail) => SelectableListItem(
            title: trail.name,
            onSelect: (_) => _navigateToTrailPage(trail),
          ),
        ),
        AddNewItem(
          text: 'New bird survey trail',
          onTap: _onAddTrail,
        ),
      ],
    );
  }
}
