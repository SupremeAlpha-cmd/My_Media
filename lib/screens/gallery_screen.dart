import 'dart:io';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../theme/pro_media_theme.dart';
import '../services/storage_service.dart';
import 'package:path/path.dart' as p;
import 'video_player_screen.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  int _selectedFilter = 0; // 0: All, 1: Photos, 2: Videos
  List<FileSystemEntity> _files = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFiles();
  }

  Future<void> _loadFiles() async {
    setState(() => _isLoading = true);
    final files = await StorageService.getMediaFiles();
    setState(() {
      _files = files.reversed.toList(); // Newest first
      _isLoading = false;
    });
  }

  List<FileSystemEntity> get _filteredFiles {
    if (_selectedFilter == 0) return _files;
    return _files.where((file) {
      final ext = p.extension(file.path).toLowerCase();
      if (_selectedFilter == 1) return ext == '.jpg';
      if (_selectedFilter == 2) return ext == '.mp4';
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
                Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Media Library',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: ProMediaTheme.surfaceContainer,
                      border: Border.all(color: ProMediaTheme.outline.withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${_files.length} ITEMS',
                      style: const TextStyle(fontFamily: 'monospace', fontSize: 10, color: ProMediaTheme.onSurface),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1C20),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: ProMediaTheme.outline.withOpacity(0.2)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildFilterTab(0, 'All'),
                    _buildFilterTab(1, 'Photos'),
                    _buildFilterTab(2, 'Videos'),
                  ],
                ),
              ),
            ],
          ),
        ),
                Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator(color: ProMediaTheme.primary))
              : _filteredFiles.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Symbols.photo_library, size: 64, color: ProMediaTheme.onSurface.withOpacity(0.1)),
                          const SizedBox(height: 16),
                          Text(
                            'No media captured yet',
                            style: TextStyle(color: ProMediaTheme.onSurface.withOpacity(0.4)),
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 1.0,
                      ),
                      itemCount: _filteredFiles.length,
                      itemBuilder: (context, index) {
                        final file = _filteredFiles[index];
                        final isVideo = p.extension(file.path).toLowerCase() == '.mp4';
                        return _buildGalleryItem(
                          context,
                          file: file,
                          isVideo: isVideo,
                        );
                      },
                    ),
        ),
      ],
    );
  }

  Widget _buildFilterTab(int index, String label) {
    final isSelected = _selectedFilter == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? ProMediaTheme.secondary.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? ProMediaTheme.secondary : ProMediaTheme.onSurface.withOpacity(0.5),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildGalleryItem(BuildContext context, {required FileSystemEntity file, required bool isVideo}) {
    return GestureDetector(
      onTap: () {
        if (isVideo) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => VideoPlayerScreen(file: File(file.path)),
            ),
          );
        } else {
          // Photo preview placeholder
          showDialog(
            context: context,
            builder: (context) => Dialog.fullscreen(
              backgroundColor: Colors.black,
              child: Stack(
                children: [
                  Center(child: Image.file(File(file.path))),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: IconButton(
                      icon: const Icon(Symbols.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: ProMediaTheme.surfaceContainer,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: ProMediaTheme.outline.withOpacity(0.2)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned.fill(
              child: isVideo
                  ? Container(
                      color: Colors.black45,
                      child: const Center(
                        child: Icon(Symbols.movie, color: Colors.white24, size: 48),
                      ),
                    )
                  : Image.file(
                      File(file.path),
                      fit: BoxFit.cover,
                    ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.1),
                      Colors.black.withOpacity(0.6),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  isVideo ? Symbols.videocam : Symbols.photo_library,
                  size: 16,
                  color: isVideo ? ProMediaTheme.primary : ProMediaTheme.onSurface.withOpacity(0.6),
                ),
              ),
            ),
            Positioned(
              bottom: 8,
              left: 8,
              child: Text(
                p.basename(file.path),
                style: const TextStyle(fontSize: 8, color: Colors.white70),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isVideo)
              const Center(
                child: Icon(Symbols.play_circle, color: ProMediaTheme.primary, size: 48, fill: 1),
              ),
          ],
        ),
      ),
    );
  }
}
