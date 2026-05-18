import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme/pro_media_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _ipController;

  @override
  void initState() {
    super.initState();
    final appState = Provider.of<AppState>(context, listen: false);
    _ipController = TextEditingController(text: appState.vmixIp);
  }

  @override
  void dispose() {
    _ipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SYSTEM SETTINGS'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('NETWORK CONFIGURATION'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ProMediaTheme.surfaceContainer,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: ProMediaTheme.outline.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'vMix Host IP Address',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white70),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _ipController,
                    decoration: InputDecoration(
                      hintText: '192.168.x.x',
                      fillColor: Colors.black26,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    style: const TextStyle(fontFamily: 'monospace', color: ProMediaTheme.secondary),
                    onChanged: (value) {
                      context.read<AppState>().updateVmixIp(value);
                    },
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Default port is 8099. Ensure TCP API is enabled in vMix settings.',
                    style: TextStyle(fontSize: 10, color: Colors.white38),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            _buildSectionHeader('HARDWARE PREFERENCES'),
            const SizedBox(height: 16),
            _buildSwitchTile('Enable High Frame Rate (60 FPS)', true),
            _buildSwitchTile('Auto-stabilization', false),
            _buildSwitchTile('External Mic Input', true),
            const SizedBox(height: 32),
            Center(
              child: Text(
                'MY MEDIA PRO v4.2.0\nBuild: 2024.05.15',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10, color: Colors.white10),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.bold,
        letterSpacing: 2,
        color: ProMediaTheme.primary,
      ),
    );
  }

  Widget _buildSwitchTile(String title, bool value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: ProMediaTheme.surfaceContainer,
        borderRadius: BorderRadius.circular(4),
      ),
      child: SwitchListTile(
        title: Text(title, style: const TextStyle(fontSize: 14)),
        value: value,
        activeColor: ProMediaTheme.secondary,
        onChanged: (val) {},
      ),
    );
  }
}
