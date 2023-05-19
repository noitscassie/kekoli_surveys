import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileUtil {
  Future<String> writeFileToDocuments(
      {required String csv, required String filename}) async {
    final Directory directory = await getApplicationDocumentsDirectory();

    final directoryPath = directory.path;

    final filepath = '$directoryPath/$filename.csv';

    final file = File(filepath);

    file.createSync(recursive: true);
    await file.writeAsString(csv);

    return file.path;
  }
}
