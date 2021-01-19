import 'dart:io';

import 'package:path_provider/path_provider.dart';

class Utils {
  static Future<String> getDocumentRootPath() async {
    return (await getApplicationDocumentsDirectory()).path;
  }

  static Future<String> getFileUrl(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    return "${directory.path}/$fileName";
  }

  static Future<Directory> openFolder(String folderPath) async {
    final directory = await getApplicationDocumentsDirectory();

    Directory folder = Directory("${directory.path}/$folderPath");

    if (await folder.exists())
      return folder;
    else {
      return await folder.create();
    }
  }
}

extension on File {
  String get alias {
    if (this.path.contains('/'))
      return this.path.split('/').last.split('.').first;
    else
      return this.path.split('.').first;
  }
}
