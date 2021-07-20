import 'dart:io';

import 'package:path_provider/path_provider.dart';

class Utils {
  /// Returns path of Application Document Directory.
  static Future<String> getDocumentRootPath() async {
    return (await getApplicationDocumentsDirectory()).path;
  }

  /// Returns the full path of [fileAlias].
  ///
  /// [fileAlias] must be a file / folder name where stores inside Application Document Directory.
  static Future<String> getFileUrl(String fileAlias) async {
    final directory = await getApplicationDocumentsDirectory();
    return "${directory.path}/$fileAlias";
  }

  /// Get Directory instance by passing relative [folderPath].
  ///
  /// This function will create the folder if the given folder name is not exist in Application Document Directory.
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
  /// trim off all prefix and keep file alias.
  String get alias {
    if (this.path.contains('/'))
      return this.path.split('/').last.split('.').first;
    else
      return this.path.split('.').first;
  }
}
