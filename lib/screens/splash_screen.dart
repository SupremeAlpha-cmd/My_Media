import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../theme/pro_media_theme.dart';
import 'navigation_shell.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _loadingAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _loadingAnimation = Tween<double>(begin: -1.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const NavigationShell()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.2,
            colors: [
              Color(0xFF1E2024),
              Color(0xFF0C0E12),
            ],
          ),
        ),
        child: Column(
          children: [
            const Spacer(),
                        Image.asset(
              'assets/images/logo.jpg',
              width: 160,
              height: 160,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 48),
                        Text(
              'MY MEDIA',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(width: 32, height: 1, color: ProMediaTheme.outline.withOpacity(0.3)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    'PRO-TOOL INTERFACE',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: ProMediaTheme.onSurface.withOpacity(0.5),
                          letterSpacing: 4,
                        ),
                  ),
                ),
                Container(width: 32, height: 1, color: ProMediaTheme.outline.withOpacity(0.3)),
              ],
            ),
            const Spacer(),
                        Padding(
              padding: const EdgeInsets.only(bottom: 48),
              child: Column(
                children: [
                                    Container(
                    width: 192,
                    height: 2,
                    decoration: BoxDecoration(
                      color: const Color(0xFF333539),
                      borderRadius: BorderRadius.circular(1),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: AnimatedBuilder(
                      animation: _loadingAnimation,
                      builder: (context, child) {
                        return FractionalTranslation(
                          translation: Offset(_loadingAnimation.value, 0),
                          child: Container(
                            width: 64,
                            decoration: BoxDecoration(
                              color: ProMediaTheme.primary,
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'PRO-MEDIA TOOLBOX',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: ProMediaTheme.onSurface.withOpacity(0.4),
                          fontSize: 10,
                          letterSpacing: 1,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'VER 4.2.0',
                        style: TextStyle(fontSize: 10, color: Colors.white30),
                      ),
                      const SizedBox(width: 8),
                      Container(width: 4, height: 4, decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white24)),
                      const SizedBox(width: 8),
                      const Text(
                        'SYSTEM READY',
                        style: TextStyle(fontSize: 10, color: Colors.white30),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
