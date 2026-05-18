import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../theme/pro_media_theme.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PRO-MEDIA GUIDE'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'Quick Reference',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: ProMediaTheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          _buildHelpItem(
            icon: Symbols.settings_input_component,
            title: 'Connecting to the Studio',
            content: '1. Tap the Settings icon in the top right.\n2. Enter the Director\'s IP address (e.g., vMix or OBS IP).\n3. When connected, the Top Banner on the Hub will say "STUDIO LINK ACTIVE" in red.',
          ),
          const SizedBox(height: 12),
          _buildHelpItem(
            icon: Symbols.videocam,
            title: 'Pro Camera Operation',
            content: '• Tap "STUDIO LINK" to send the live RTMP stream over Wi-Fi.\n• Tap the red Record button to simultaneously record a local 4K backup to the Media Gallery.\n• A Red Tally light means you are LIVE on the broadcast.',
          ),
          const SizedBox(height: 12),
          _buildHelpItem(
            icon: Symbols.radio,
            title: 'Local Intercom (Comms)',
            content: '• Use the Comms tab to talk directly to the Director.\n• Hold the massive microphone button to transmit.\n• If you connect a Bluetooth earpiece, the app will automatically route incoming audio to your ear.',
          ),
          const SizedBox(height: 12),
          _buildHelpItem(
            icon: Symbols.photo_library,
            title: 'Media Gallery',
            content: '• All your local recordings are saved here.\n• The storage limit depends on your device\'s local storage.\n• Videos are saved in high-bitrate MP4 format for post-production editing.',
          ),
          const SizedBox(height: 12),
          _buildHelpItem(
            icon: Symbols.wifi_tethering_error,
            title: 'Troubleshooting Drops',
            content: 'If the video stream drops or gets choppy:\n1. Move closer to the Wi-Fi access point.\n2. Ensure no one is downloading large files on the church network.\n3. Tap "STUDIO LINK" off and on again to restart the stream.',
          ),
        ],
      ),
    );
  }

  Widget _buildHelpItem({required IconData icon, required String title, required String content}) {
    return Container(
      decoration: BoxDecoration(
        color: ProMediaTheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ProMediaTheme.outline.withOpacity(0.3)),
      ),
      child: ExpansionTile(
        leading: Icon(icon, color: ProMediaTheme.secondary),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        collapsedIconColor: Colors.white54,
        iconColor: ProMediaTheme.primary,
        childrenPadding: const EdgeInsets.all(16.0).copyWith(top: 0),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              content,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                height: 1.5,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
