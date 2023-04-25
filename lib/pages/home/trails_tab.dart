import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TrailsTab extends StatelessWidget {
  const TrailsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Trails here'),
          ),
        ],
      ),
    );
  }
}
