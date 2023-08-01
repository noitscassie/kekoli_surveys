import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileUtil {
  Future<String> writeFileToDocuments(
      {required String csv, required String filename}) async {
    final directory = Platform.isAndroid
        ? Directory("/storage/emulated/0/Download")
        : await getApplicationDocumentsDirectory();

    final filepath = '${directory.path}/$filename.csv';

    final file = File(filepath);

    file.createSync(recursive: true);
    await file.writeAsString(csv);

    return file.path;
  }
}
