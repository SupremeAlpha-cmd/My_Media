import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import '../theme/pro_media_theme.dart';
import '../providers/app_state.dart';
import '../services/vmix_service.dart';
import 'hub_screen.dart';
import 'camera_screen.dart';
import 'comms_screen.dart';
import 'gallery_screen.dart';
import 'settings_screen.dart';

class NavigationShell extends StatefulWidget {
  const NavigationShell({super.key});

  @override
  State<NavigationShell> createState() => _NavigationShellState();
}

class _NavigationShellState extends State<NavigationShell> {
  int _selectedIndex = 0;
  late VmixService _vmixService;

  @override
  void initState() {
    super.initState();
    final appState = Provider.of<AppState>(context, listen: false);
    _vmixService = VmixService(appState);
    _vmixService.connect(appState.vmixIp);
  }

  @override
  void dispose() {
    _vmixService.disconnect();
    super.dispose();
  }

  // Screens are now built directly in the IndexedStack


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MY MEDIA'),
        actions: [
          IconButton(
            icon: const Icon(Symbols.settings),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
        leading: IconButton(
          icon: const Icon(Symbols.menu),
          onPressed: () {},
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HubScreen(onNavigate: _onItemTapped),
          const CameraScreen(),
          const CommsScreen(),
          const GalleryScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: ProMediaTheme.outline, width: 0.5),
          ),
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Symbols.grid_view),
              activeIcon: Icon(Symbols.grid_view, fill: 1),
              label: 'Hub',
            ),
            BottomNavigationBarItem(
              icon: Icon(Symbols.videocam),
              activeIcon: Icon(Symbols.videocam, fill: 1),
              label: 'Camera',
            ),
            BottomNavigationBarItem(
              icon: Icon(Symbols.record_voice_over),
              activeIcon: Icon(Symbols.record_voice_over, fill: 1),
              label: 'Comms',
            ),
            BottomNavigationBarItem(
              icon: Icon(Symbols.photo_library),
              activeIcon: Icon(Symbols.photo_library, fill: 1),
              label: 'Gallery',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
