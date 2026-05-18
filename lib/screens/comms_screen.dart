import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import '../theme/pro_media_theme.dart';
import '../services/comms_service.dart';
import '../providers/app_state.dart';

class CommsScreen extends StatefulWidget {
  const CommsScreen({super.key});

  @override
  State<CommsScreen> createState() => _CommsScreenState();
}

class _CommsScreenState extends State<CommsScreen> {
  bool _isTalking = false;
  final CommsService _commsService = CommsService();

  @override
  void initState() {
    super.initState();
    _commsService.initialize();
  }

  @override
  void dispose() {
    _commsService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
                Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: ProMediaTheme.surfaceContainer,
            border: Border.all(color: ProMediaTheme.outline.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(color: ProMediaTheme.secondary, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              const Text(
                'LIVE CHANNEL',
                style: TextStyle(color: ProMediaTheme.secondary, fontWeight: FontWeight.bold, fontSize: 10),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Sunday Service',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const Spacer(),
                GestureDetector(
          onTapDown: (_) {
            setState(() => _isTalking = true);
            final targetIp = context.read<AppState>().vmixIp;
            _commsService.startTalking(targetIp);
          },
          onTapUp: (_) {
            setState(() => _isTalking = false);
            _commsService.stopTalking();
          },
          onTapCancel: () {
            setState(() => _isTalking = false);
            _commsService.stopTalking();
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 240,
            height: 240,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _isTalking ? ProMediaTheme.primary : ProMediaTheme.surfaceContainer,
              border: Border.all(
                color: _isTalking ? ProMediaTheme.primary : ProMediaTheme.outline.withOpacity(0.3),
                width: 4,
              ),
              boxShadow: _isTalking
                  ? [
                      BoxShadow(
                        color: ProMediaTheme.primary.withOpacity(0.4),
                        blurRadius: 40,
                        spreadRadius: 10,
                      )
                    ]
                  : [],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Symbols.mic,
                  size: 80,
                  color: _isTalking ? const Color(0xFF690003) : ProMediaTheme.primary,
                  fill: 1,
                ),
                const SizedBox(height: 16),
                Text(
                  _isTalking ? 'TALKING...' : 'PUSH TO TALK',
                  style: TextStyle(
                    color: _isTalking ? const Color(0xFF690003) : ProMediaTheme.onSurface.withOpacity(0.6),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Symbols.volume_up, size: 16, color: Colors.white38),
            SizedBox(width: 8),
            Text(
              'TX: 44.1kHz / 24-bit PCM',
              style: TextStyle(fontFamily: 'monospace', fontSize: 10, color: Colors.white38),
            ),
          ],
        ),
        const Spacer(),
                Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: ProMediaTheme.surfaceContainer,
            border: Border.all(color: ProMediaTheme.outline.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'CONNECTED MEMBERS (3)',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: 10),
                    ),
                    const Icon(Symbols.group, size: 16, color: Colors.white38),
                  ],
                ),
              ),
              const Divider(height: 1, color: Colors.white10),
              _buildMemberTile(
                name: 'FOH Mixer',
                status: 'Active • 0.5ms Latency',
                isActive: true,
              ),
              const Divider(height: 1, color: Colors.white10),
              _buildMemberTile(
                name: 'Lighting',
                status: 'Listening...',
                isActive: false,
              ),
              const Divider(height: 1, color: Colors.white10),
              _buildMemberTile(
                name: 'Director',
                status: 'Listening...',
                isActive: false,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildMemberTile({required String name, required String status, required bool isActive}) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Symbols.person, size: 24, color: Colors.white38),
      ),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      subtitle: Text(status, style: const TextStyle(fontSize: 12, color: Colors.white38)),
      trailing: Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          color: isActive ? ProMediaTheme.secondary : Colors.transparent,
          shape: BoxShape.circle,
          border: isActive ? null : Border.all(color: Colors.white24),
        ),
      ),
    );
  }
}
