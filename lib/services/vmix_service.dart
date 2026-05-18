import 'dart:async';
import 'dart:io';
import '../providers/app_state.dart';

class VmixService {
  Socket? _socket;
  final AppState _appState;
  Timer? _simulationTimer;

  VmixService(this._appState);

  Future<void> connect(String ip) async {
    _appState.setConnectionStatus(true);
    _startSimulation();
  }

  void _startSimulation() {
    _simulationTimer?.cancel();
    _simulationTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      final states = [TallyState.none, TallyState.preview, TallyState.program];
      final newState = states[timer.tick % states.length];
      _appState.setTallyState(newState);
    });
  }

  void _handleData(List<int> data) {
    final response = String.fromCharCodes(data);
    if (response.startsWith('TALLY OK')) {
      // Parse tally state: 0=none, 1=program, 2=preview
      final char = response[9]; 
      if (char == '1') _appState.setTallyState(TallyState.program);
      else if (char == '2') _appState.setTallyState(TallyState.preview);
      else _appState.setTallyState(TallyState.none);
    }
  }

  void disconnect() {
    _socket?.destroy();
    _simulationTimer?.cancel();
    _appState.setConnectionStatus(false);
  }
}
