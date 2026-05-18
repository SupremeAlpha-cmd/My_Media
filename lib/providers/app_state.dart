import 'package:flutter/material.dart';

enum TallyState { none, preview, program }

class AppState extends ChangeNotifier {
  TallyState _tallyState = TallyState.none;
  bool _isConnected = false;
  String _vmixIp = '192.168.1.5';
  double _fps = 60.0;
  double _bitrate = 8.5;

  TallyState get tallyState => _tallyState;
  bool get isConnected => _isConnected;
  String get vmixIp => _vmixIp;
  double get fps => _fps;
  double get bitrate => _bitrate;

  void setTallyState(TallyState state) {
    _tallyState = state;
    notifyListeners();
  }

  void setConnectionStatus(bool connected) {
    _isConnected = connected;
    notifyListeners();
  }

  void updateVmixIp(String ip) {
    _vmixIp = ip;
    notifyListeners();
  }
}
