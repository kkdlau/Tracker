import 'package:Tracker/file_manager_template/info_card/card_config.dart';

class FileManagerConfiguration {
  final bool allowAddFile;
  final CardConfiguration cardConfig;

  const FileManagerConfiguration(
      {this.allowAddFile = true, this.cardConfig = const CardConfiguration()});
}
