import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/db/db.dart';
import 'package:kekoldi_surveys/models/bird_survey_trail.dart';
import 'package:kekoldi_surveys/pages/bird_trails/bird_trail_page.dart';
import 'package:kekoldi_surveys/widgets/add_new_item.dart';
import 'package:kekoldi_surveys/widgets/page_scaffold.dart';
import 'package:kekoldi_surveys/widgets/selectable_list_item.dart';

class BirdTrailsPage extends StatefulWidget {
  const BirdTrailsPage({super.key});

  @override
  State<BirdTrailsPage> createState() => _BirdTrailsPageState();
}

class _BirdTrailsPageState extends State<BirdTrailsPage> {
  final Db _db = Db();

  List<BirdSurveyTrail> _trails = [];

  Future<void> _loadTrails() async {
    final trails = await _db.getBirdTrails();
    setState(() {
      _trails = trails;
    });
  }

  Future<void> _onSaveTrail(BirdSurveyTrail newTrail) async {
    final allTrails = [
      ..._trails.map((trail) => trail.id == newTrail.id ? newTrail : trail)
    ];

    setState(() {
      _trails = allTrails;
    });

    await _db.updateBirdTrails(allTrails);

    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _onAddTrail() async {
    final trail = BirdSurveyTrail(
      name: 'New Bird Survey Trail',
      segments: [''],
    );

    final allTrails = [..._trails, trail];

    setState(() {
      _trails = allTrails;
    });

    await _db.updateBirdTrails(allTrails);

    if (context.mounted) {
      _navigateToTrailPage(trail);
    }
  }

  Future<void> _onDeleteTrail(BirdSurveyTrail trailToDelete) async {
    final allTrails =
        _trails.whereNot((trail) => trail.id == trailToDelete.id).toList();

    setState(() {
      _trails = allTrails;
    });

    Navigator.of(context).pop();

    await _db.updateBirdTrails(allTrails);
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
  void initState() {
    super.initState();
    _loadTrails();
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: 'Bird Trails',
      child: Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 100),
        child: ListView(
          children: [
            ..._trails.map(
              (BirdSurveyTrail trail) => SelectableListItem(
                text: trail.name,
                onSelect: (_) => _navigateToTrailPage(trail),
              ),
            ),
            AddNewItem(
              text: 'New bird survey trail',
              onTap: _onAddTrail,
            ),
          ],
        ),
      ),
    );
  }
}
