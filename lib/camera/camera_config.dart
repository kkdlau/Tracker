class CameraConfiguration {
  int cameraIndex;
  bool enableFlash;
  bool enableAudio;

  CameraConfiguration(
      {this.cameraIndex = 0,
      this.enableFlash = false,
      this.enableAudio = true});
}
