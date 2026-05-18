import 'dart:io';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class CommsService {
  final _audioRecorder = AudioRecorder();
  final _audioPlayer = AudioPlayer();
  String? _currentPath;

  Future<void> startTalking() async {
    if (await _audioRecorder.hasPermission()) {
      final dir = await getTemporaryDirectory();
      _currentPath = p.join(dir.path, 'comms_temp.m4a');
      
      const config = RecordConfig();
      await _audioRecorder.start(config, path: _currentPath!);
    }
  }

  Future<void> stopTalking() async {
    final path = await _audioRecorder.stop();
    if (path != null) {
      // In a real MVP, you'd send this bytes over a socket here.
      // For testing, we'll just log it.
      print('Audio captured for transmission: $path');
    }
  }

  Future<void> playIncomingAudio(String path) async {
    await _audioPlayer.play(DeviceFileSource(path));
  }

  void dispose() {
    _audioRecorder.dispose();
    _audioPlayer.dispose();
  }
}
