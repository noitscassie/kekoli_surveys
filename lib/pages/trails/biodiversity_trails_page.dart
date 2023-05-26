import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/db/db.dart';
import 'package:kekoldi_surveys/widgets/page_scaffold.dart';
import 'package:kekoldi_surveys/widgets/removable_text_field_list.dart';

class BiodiversityTrailsPage extends StatefulWidget {
  const BiodiversityTrailsPage({super.key});

  @override
  State<BiodiversityTrailsPage> createState() => _BiodiversityTrailsPageState();
}

class _BiodiversityTrailsPageState extends State<BiodiversityTrailsPage> {
  final Db _db = Db();
  List<String?> _trails = [];

  void _addTrail() {
    setState(() {
      _trails = [..._trails, ''];
    });
  }

  void _updateTrail(int indexToUpdate, String newValue) {
    setState(() {
      _trails = _trails
          .mapIndexed(
              (index, trail) => index == indexToUpdate ? newValue : trail)
          .toList();
    });
  }

  void _removeTrail(int indexToRemove) {
    setState(() {
      _trails = _trails
          .mapIndexed((index, trail) => index == indexToRemove ? null : trail)
          .toList();
    });
  }

  Future<void> _saveTrails(BuildContext context) async {
    await _db.updateBiodiversityTrails(_trails.whereNotNull().toList());

    if (context.mounted) {
      const snackBar = SnackBar(
        duration: Duration(seconds: 4),
        content: Text('Saved trails list successfully'),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      Navigator.of(context).pop();
    }
  }

  Future<void> _loadTrails() async {
    final trails = await _db.getBiodiversityTrails();
    setState(() {
      _trails = trails;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadTrails();
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: 'Biodiversity Trails',
      fabLabel: const Row(
        children: [
          Text('Save Trails'),
          Icon(Icons.save_alt),
        ],
      ),
      onFabPress: () => _saveTrails(context),
      child: Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 100),
        child: ListView(
          children: [
            RemovableTextFieldList(
              items: _trails,
              optionLabel: 'Trail',
              newItemText: 'Add new trail',
              onAddItem: _addTrail,
              onUpdateItem: _updateTrail,
              onRemoveItem: _removeTrail,
            )
          ],
        ),
      ),
    );
  }
}
