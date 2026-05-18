import 'dart:io';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import '../theme/pro_media_theme.dart';
import '../providers/app_state.dart';
import '../services/storage_service.dart';

class HubScreen extends StatelessWidget {
  final Function(int) onNavigate;
  const HubScreen({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final isConnected = appState.tallyState != TallyState.none;
    final statusText = isConnected ? 'STUDIO LINK ACTIVE' : 'SYSTEM OFFLINE';
    final statusColor = isConnected ? ProMediaTheme.primary : Colors.grey;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
                    Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ProMediaTheme.surfaceContainer,
              border: Border.all(color: ProMediaTheme.outline.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: statusColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SYSTEM STATUS',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: ProMediaTheme.onSurface.withOpacity(0.5),
                            fontSize: 10,
                          ),
                    ),
                    Text(
                      statusText,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isConnected ? Colors.white : Colors.white54,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  isConnected ? 'LATENCY: 14MS' : 'LATENCY: --',
                  style: TextStyle(
                    color: isConnected ? ProMediaTheme.primary : Colors.grey,
                    fontFamily: 'monospace',
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
                    GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.8,
            children: [
              _buildFeatureCard(
                context,
                title: 'Pro Camera',
                subtitle: 'Zero-latency broadcast feed.',
                icon: Symbols.videocam,
                isLive: true,
                color: ProMediaTheme.primary,
                onTap: () => onNavigate(1),
              ),
              _buildFeatureCard(
                context,
                title: 'Local Comms',
                subtitle: 'Secure radio bridge.',
                icon: Symbols.radio,
                isLive: false,
                color: ProMediaTheme.secondary,
                onTap: () => onNavigate(2),
              ),
            ],
          ),
          const SizedBox(height: 16),
          FutureBuilder<List<FileSystemEntity>>(
            future: StorageService.getMediaFiles(),
            builder: (context, snapshot) {
              final count = snapshot.data?.length ?? 0;
              String sizeStr = '0 MB';
              
              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                 int totalBytes = 0;
                 for (var file in snapshot.data!) {
                   if (file is File) totalBytes += file.lengthSync();
                 }
                 if (totalBytes > 1024 * 1024 * 1024) {
                   sizeStr = '${(totalBytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
                 } else {
                   sizeStr = '${(totalBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
                 }
              }

              return _buildFullWidthCard(
                context,
                title: 'Media Gallery',
                subtitle: 'Central high-speed repository for RAW footage.',
                icon: Symbols.photo_library,
                onTap: () => onNavigate(3),
                stats: [
                  {'label': 'TOTAL ASSETS', 'value': '$count'},
                  {'label': 'STORAGE', 'value': sizeStr},
                ],
              );
            }
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isLive,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ProMediaTheme.surfaceContainer,
        border: Border.all(color: ProMediaTheme.outline.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 32),
              if (isLive)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: ProMediaTheme.primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: const Text(
                    'LIVE',
                    style: TextStyle(
                      color: Color(0xFF690003),
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
            ],
          ),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: ProMediaTheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 36),
            ),
            child: const Text('OPEN'),
          ),
        ],
      ),
    );
  }

  Widget _buildFullWidthCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Map<String, String>> stats,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ProMediaTheme.surfaceContainer,
        border: Border.all(color: ProMediaTheme.outline.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: ProMediaTheme.primary, size: 32),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              color: ProMediaTheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: stats.map((stat) {
              return Padding(
                padding: const EdgeInsets.only(right: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stat['label']!,
                      style: TextStyle(
                        fontSize: 10,
                        letterSpacing: 1,
                        color: ProMediaTheme.onSurface.withOpacity(0.4),
                      ),
                    ),
                    Text(
                      stat['value']!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 36),
            ),
            child: const Text('OPEN LIBRARY'),
          ),
        ],
      ),
    );
  }
}
