import 'package:camera/camera.dart';
export 'package:camera/camera.dart';

class RTMPCameraController extends CameraController {
  RTMPCameraController(super.description, super.resolutionPreset);
  
  Future<void> startVideoStreaming(String url) async {
    print('Web mock: start streaming to $url');
  }
  
  Future<void> stopVideoStreaming() async {
    print('Web mock: stop streaming');
  }
}
