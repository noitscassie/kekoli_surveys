import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kekoldi_surveys/widgets/page_scaffold.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppDetailsPage extends StatelessWidget {
  const AppDetailsPage({super.key});

  Widget _listItem(BuildContext context, String title, String? subtitle) => ListTile(
      title: Text(title),
      subtitle: Text(subtitle == '' || subtitle == null ?  'N/A' : subtitle, style: Theme.of(context).textTheme.bodyMedium),
  );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: PackageInfo.fromPlatform(),
      builder: (BuildContext context, AsyncSnapshot<PackageInfo> snapshot) {
        if (snapshot.hasData) {
          final packageInfo = snapshot.data;

          return PageScaffold.withScrollableChildren(
            title: 'App Details',
            children: [
              _listItem(context, 'App Name', packageInfo?.appName),
              _listItem(context, 'App Version', packageInfo?.version),
              _listItem(context, 'Build Number', packageInfo?.buildNumber),
              _listItem(context, 'Build Signature', packageInfo?.buildSignature),
              _listItem(context, 'OS', Platform.operatingSystem),
              _listItem(context, 'OS Version', Platform.operatingSystemVersion),
            ],
          );
        } else {
          return const PageScaffold(title: 'App Details', child: CircularProgressIndicator());
        }
    }
    );
  }
}
