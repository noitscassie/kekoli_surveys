import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/db/db.dart';
import 'package:kekoldi_surveys/widgets/form_item.dart';

class TrailInputField extends StatefulWidget {
  final String initialTrail;
  final Function(String value) onChange;

  const TrailInputField({
    super.key,
    required this.onChange,
    required this.initialTrail,
  });

  @override
  State<TrailInputField> createState() => _TrailInputFieldState();
}

class _TrailInputFieldState extends State<TrailInputField> {
  final Db _db = Db();
  late final List<String> _trails = _db.getBiodiversityTrails();

  @override
  Widget build(BuildContext context) {
    return FormItem(
      label: 'Select a trail',
      child: DropdownButtonFormField<String>(
        value: widget.initialTrail,
        items: List.from(_trails.sorted().map((String trail) =>
            DropdownMenuItem(value: trail, child: Text(trail)))),
        onChanged: (String? newTrail) {
          if (newTrail != null) {
            widget.onChange(newTrail);
          }
        },
      ),
    );
  }
}
