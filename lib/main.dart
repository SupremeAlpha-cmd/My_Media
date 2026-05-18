import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/pro_media_theme.dart';
import 'screens/splash_screen.dart';
import 'providers/app_state.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
      child: const MyMediaApp(),
    ),
  );
}

class MyMediaApp extends StatelessWidget {
  const MyMediaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Media',
      debugShowCheckedModeBanner: false,
      theme: ProMediaTheme.darkTheme,
      home: const SplashScreen(),
    );
  }
}
