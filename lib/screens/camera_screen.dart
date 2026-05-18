import 'dart:async';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../camera_import.dart';
import 'package:provider/provider.dart';
import '../theme/pro_media_theme.dart';
import '../providers/app_state.dart';
import '../services/storage_service.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  RTMPCameraController? _controller;
  bool _isRecording = false;
  bool _isStreaming = false;
  Timer? _recordTimer;
  int _recordSeconds = 0;

  String _formatDuration(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '00:$m:$s';
  }
  String _rtmpUrl = 'rtmp://192.168.1.5/live/stream';

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) return;

    _controller = RTMPCameraController(cameras[0], ResolutionPreset.high);
    try {
      await _controller!.initialize();
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint('Camera error: $e');
    }
  }

  Future<void> _takeSnapshot() async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    try {
      final image = await _controller!.takePicture();
      await StorageService.saveFile(image.path);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Snapshot Saved'), duration: Duration(seconds: 1)),
        );
      }
    } catch (e) {
      debugPrint('Snapshot error: $e');
    }
  }

  Future<void> _toggleRecording() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    try {
      if (_isRecording) {
        _recordTimer?.cancel();
        final video = await _controller!.stopVideoRecording();
        await StorageService.saveFile(video.path, isVideo: true);
        setState(() => _isRecording = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Video Saved'), duration: Duration(seconds: 1)),
          );
        }
      } else {
        await _controller!.startVideoRecording();
        setState(() {
          _isRecording = true;
          _recordSeconds = 0;
        });
        _recordTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
          if (mounted) setState(() => _recordSeconds++);
        });
      }
    } catch (e) {
      debugPrint('Recording error: $e');
    }
  }

  Future<void> _toggleStreaming() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    try {
      if (_isStreaming) {
        await _controller!.stopVideoStreaming();
        setState(() => _isStreaming = false);
      } else {
        // Use the IP from AppState or default
        final appState = context.read<AppState>();
        final url = 'rtmp://${appState.vmixIp}/live/stream';
        await _controller!.startVideoStreaming(url);
        setState(() => _isStreaming = true);
      }
    } catch (e) {
      debugPrint('Streaming error: $e');
    }
  }

  @override
  void dispose() {
    _recordTimer?.cancel();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: ProMediaTheme.primary)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
                    Positioned.fill(
            child: AspectRatio(
              aspectRatio: _controller!.value.aspectRatio,
              child: CameraPreview(_controller!),
            ),
          ),
                    Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.6),
                    Colors.transparent,
                    Colors.transparent,
                    Colors.black.withOpacity(0.6),
                  ],
                  stops: const [0.0, 0.2, 0.8, 1.0],
                ),
              ),
            ),
          ),
                    Positioned(
            top: 64,
            left: 0,
            right: 0,
            child: Consumer<AppState>(
              builder: (context, appState, child) {
                if (appState.tallyState == TallyState.none) return const SizedBox.shrink();
                
                final isProgram = appState.tallyState == TallyState.program;
                final color = isProgram ? const Color(0xFF93000A) : const Color(0xFFaf8d11);
                final glowColor = isProgram ? ProMediaTheme.primary : ProMediaTheme.secondary;
                final label = isProgram ? 'ON AIR' : 'PREVIEW';

                return Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.8),
                      border: Border.all(color: glowColor),
                      borderRadius: BorderRadius.circular(2),
                      boxShadow: [
                        BoxShadow(
                          color: glowColor.withOpacity(0.4),
                          blurRadius: 15,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          label,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
                    Positioned(
            top: 20,
            left: 16,
            right: 16,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: ProMediaTheme.surfaceContainer.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: ProMediaTheme.outline.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Container(width: 8, height: 8, decoration: const BoxDecoration(color: ProMediaTheme.secondary, shape: BoxShape.circle)),
                      const SizedBox(width: 8),
                      Consumer<AppState>(
                        builder: (context, appState, child) => Text(
                          'STUDIO: ${appState.vmixIp}',
                          style: const TextStyle(fontFamily: 'monospace', fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
                    Positioned(
            right: 16,
            top: 120,
            child: Column(
              children: [
                _buildStatBox('FPS', '60.00'),
                const SizedBox(height: 16),
                _buildStatBox('BITRATE', '8.5 Mbps'),
                const SizedBox(height: 16),
                                GestureDetector(
                  onTap: _toggleStreaming,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _isStreaming ? ProMediaTheme.primary.withOpacity(0.2) : Colors.black45,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: _isStreaming ? ProMediaTheme.primary : Colors.white10),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Symbols.podcasts,
                          size: 20,
                          color: _isStreaming ? ProMediaTheme.primary : Colors.white38,
                          fill: _isStreaming ? 1 : 0,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _isStreaming ? 'STOP' : 'STREAM',
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                            color: _isStreaming ? ProMediaTheme.primary : Colors.white38,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
                    Positioned(
            left: 16,
            top: 0,
            bottom: 0,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Symbols.add, size: 14, color: Colors.white70),
                  const SizedBox(height: 8),
                  Container(
                    width: 48,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: ProMediaTheme.outline.withOpacity(0.3)),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 4,
                          height: 160,
                          decoration: BoxDecoration(
                            color: Colors.white12,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                                                Positioned(
                          bottom: 40,
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Icon(Symbols.remove, size: 14, color: Colors.white70),
                  const SizedBox(height: 8),
                  RotatedBox(
                    quarterTurns: 3,
                    child: Text(
                      'ZOOM',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: Colors.white38,
                            fontSize: 10,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
                    Positioned(
            bottom: 110,
            left: 0,
            right: 0,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                                    _buildControlCircle(
                    icon: Symbols.photo_camera,
                    label: 'SNAPSHOT',
                    onTap: _takeSnapshot,
                  ),
                  const SizedBox(width: 32),
                                    _buildRecordButton(),
                  const SizedBox(width: 32),
                                    _buildControlCircle(
                    icon: Symbols.settings_input_component,
                    label: 'STUDIO LINK',
                    iconColor: ProMediaTheme.secondary,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatBox(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 8, color: Colors.white38)),
          Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
        ],
      ),
    );
  }

  Widget _buildControlCircle({required IconData icon, required String label, Color? iconColor, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.black54,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white24),
            ),
            child: Icon(icon, color: iconColor ?? Colors.white, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 10, letterSpacing: 1, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordButton() {
    return Column(
      children: [
        GestureDetector(
          onTap: _toggleRecording,
          child: Container(
            width: 80,
            height: 80,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
            ),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: _isRecording ? BoxShape.rectangle : BoxShape.circle,
                borderRadius: _isRecording ? BorderRadius.circular(8) : null,
              ),
              margin: EdgeInsets.all(_isRecording ? 18 : 0),
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (_isRecording)
          Text(
            'REC ${_formatDuration(_recordSeconds)}',
            style: const TextStyle(color: ProMediaTheme.primary, fontWeight: FontWeight.bold, fontSize: 12),
          )
        else
          const SizedBox(height: 14),
      ],
    );
  }
}
