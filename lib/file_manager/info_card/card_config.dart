class CardConfiguration {
  final bool allowEditFile;
  final bool allowCloneFile;
  final bool allowDeleteFile;
  final bool allowExport;

  const CardConfiguration(
      {this.allowCloneFile = true,
      this.allowDeleteFile = true,
      this.allowEditFile = true,
      this.allowExport = true});
}
