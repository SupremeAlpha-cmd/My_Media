import 'dart:io';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:record/record.dart';
import 'package:flutter/foundation.dart';

class CommsService {
  final _audioRecorder = AudioRecorder();
  RawDatagramSocket? _socket;
  final _channel = const MethodChannel('com.example.my_media/audio');
  StreamSubscription? _recordSub;

  Future<void> initialize() async {
    if (kIsWeb) return; // UDP not supported on web
    
    try {
      _socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 5000);
      _socket?.listen((RawSocketEvent event) {
        if (event == RawSocketEvent.read) {
          Datagram? datagram = _socket?.receive();
          if (datagram != null && !kIsWeb) {
             _channel.invokeMethod('playBytes', {'bytes': datagram.data});
          }
        }
      });
    } catch (e) {
      debugPrint('Error binding UDP socket: $e');
    }
  }

  Future<void> startTalking(String targetIp) async {
    if (await _audioRecorder.hasPermission()) {
      const config = RecordConfig(
        encoder: AudioEncoder.pcm16bits,
        sampleRate: 44100,
        numChannels: 1,
      );
      
      final stream = await _audioRecorder.startStream(config);
      _recordSub = stream.listen((data) {
        if (!kIsWeb && _socket != null) {
          try {
            final address = InternetAddress(targetIp);
            _socket?.send(data, address, 5000);
            
            // Loopback for local testing if target is localhost
            if (targetIp == '127.0.0.1') {
              _channel.invokeMethod('playBytes', {'bytes': data});
            }
          } catch (e) {
            // Ignore send errors
          }
        }
      });
    }
  }

  Future<void> stopTalking() async {
    await _recordSub?.cancel();
    _recordSub = null;
    await _audioRecorder.stop();
  }

  void dispose() {
    _socket?.close();
    _audioRecorder.dispose();
  }
}
